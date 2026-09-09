import AVFoundation
import Foundation

final class CameraManagerPhoto: NSObject, @unchecked Sendable {

    struct State: Sendable {
        var isRunning = false
        var isCapturing = false
        var isFront = false
        var canSwitchCamera = false
        var hasUltraWide = false
        var supportsFlash = false

        var zoom: Double = 1
        var minimumZoom: Double = 1
        var maximumZoom: Double = 5
    }

    enum Event: Sendable {
        case state(State)
        case photo(Data)
        case failure(String)
    }

    let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(
        label: "photo.camera.session",
        qos: .userInitiated
    )

    private let output = AVCapturePhotoOutput()

    private var input: AVCaptureDeviceInput?
    private var configured = false
    private var wantsToRun = false

    private var state = State()
    private var photoData: Data?
    private var photoError: String?

    private var observers: [NSObjectProtocol] = []
    private var zoomObservation: NSKeyValueObservation?

    // Converte o zoom interno da câmera para o valor da interface.
    // Exemplo: zoom interno 2 pode corresponder a 1× na interface.
    private var zoomMultiplier: Double = 1

    // Velocidade da transição dos botões.
    private let zoomRampRate: Float = 10

    private let onEvent: @MainActor @Sendable (Event) -> Void

    init(
        onEvent: @escaping @MainActor @Sendable (Event) -> Void
    ) {
        self.onEvent = onEvent
        super.init()

        observeSession()
    }

    deinit {
        zoomObservation?.invalidate()

        observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }

        let session = session

        sessionQueue.async {
            if session.isRunning {
                session.stopRunning()
            }
        }
    }

    // MARK: - Ciclo de vida

    func start() {
        sessionQueue.async { [self] in
            wantsToRun = true

            do {
                if !configured {
                    try configure()
                }

                if !session.isRunning {
                    session.startRunning()
                }

                publishState()

                if !session.isRunning && !session.isInterrupted {
                    emit(
                        .failure(
                            "Não foi possível iniciar a câmera. Tente novamente."
                        )
                    )
                }
            } catch {
                emit(.failure(error.localizedDescription))
                publishState()
            }
        }
    }

    func stop() {
        sessionQueue.async { [self] in
            wantsToRun = false

            if session.isRunning {
                session.stopRunning()
            }

            publishState()
        }
    }

    // MARK: - Seleção da câmera

    private func preferredDevice(
        position: AVCaptureDevice.Position
    ) -> AVCaptureDevice? {
        let types: [AVCaptureDevice.DeviceType]

        if position == .back {
            types = [
                .builtInTripleCamera,
                .builtInDualWideCamera,
                .builtInDualCamera,
                .builtInWideAngleCamera
            ]
        } else {
            types = [
                .builtInWideAngleCamera
            ]
        }

        for type in types {
            if let device = AVCaptureDevice.default(
                type,
                for: .video,
                position: position
            ) {
                return device
            }
        }

        return nil
    }

    private func displayMultiplier(
        for device: AVCaptureDevice
    ) -> Double {
        let constituents = device.constituentDevices

        guard
            let wideIndex = constituents.firstIndex(
                where: {
                    $0.deviceType == .builtInWideAngleCamera
                }
            ),
            wideIndex > 0
        else {
            return 1
        }

        let switchFactors =
            device.virtualDeviceSwitchOverVideoZoomFactors

        let factorIndex = wideIndex - 1

        guard switchFactors.indices.contains(factorIndex) else {
            return 1
        }

        let wideFactor = switchFactors[factorIndex].doubleValue

        guard wideFactor > 0 else {
            return 1
        }

        return 1 / wideFactor
    }

    private func applyInitialSettings(
        to device: AVCaptureDevice
    ) throws {
        let multiplier = displayMultiplier(for: device)

        // Começa no enquadramento equivalente à câmera principal: 1×.
        let initialZoom = CGFloat(1 / multiplier)

        try device.lockForConfiguration()
        defer {
            device.unlockForConfiguration()
        }

        device.cancelVideoZoomRamp()

        device.videoZoomFactor = min(
            max(
                initialZoom,
                device.minAvailableVideoZoomFactor
            ),
            device.maxAvailableVideoZoomFactor
        )

        if device.isFocusModeSupported(.continuousAutoFocus) {
            device.focusMode = .continuousAutoFocus
        }

        if device.isExposureModeSupported(.continuousAutoExposure) {
            device.exposureMode = .continuousAutoExposure
        }
    }

    private func configure() throws {
        guard let device = preferredDevice(position: .back)
            ?? preferredDevice(position: .front) else {
            throw CameraFailure(
                "Nenhuma câmera disponível. Teste em um iPhone físico."
            )
        }

        let newInput = try AVCaptureDeviceInput(device: device)

        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }

        session.sessionPreset = .photo

        guard session.canAddInput(newInput) else {
            throw CameraFailure(
                "Não foi possível conectar a câmera."
            )
        }

        session.addInput(newInput)

        guard session.canAddOutput(output) else {
            session.removeInput(newInput)

            throw CameraFailure(
                "Não foi possível configurar a captura de fotos."
            )
        }

        session.addOutput(output)

        do {
            try applyInitialSettings(to: device)
        } catch {
            session.removeOutput(output)
            session.removeInput(newInput)
            throw error
        }

        input = newInput
        output.maxPhotoQualityPrioritization = .quality

        configured = true

        updateDeviceInformation()
        observeZoom(of: device)
    }

    func switchCamera() {
        sessionQueue.async { [self] in
            guard configured, !state.isCapturing else {
                return
            }

            let position: AVCaptureDevice.Position =
                state.isFront ? .back : .front

            do {
                try changeCamera(position: position)
            } catch {
                emit(.failure(error.localizedDescription))
            }

            publishState()
        }
    }

    private func changeCamera(
        position: AVCaptureDevice.Position
    ) throws {
        guard let device = preferredDevice(position: position) else {
            throw CameraFailure(
                "Esta câmera não está disponível no aparelho."
            )
        }

        let newInput = try AVCaptureDeviceInput(device: device)
        let previousInput = input

        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }

        if let previousInput {
            session.removeInput(previousInput)
        }

        guard session.canAddInput(newInput) else {
            if let previousInput,
               session.canAddInput(previousInput) {
                session.addInput(previousInput)
            }

            throw CameraFailure(
                "Não foi possível trocar a câmera."
            )
        }

        session.addInput(newInput)

        do {
            try applyInitialSettings(to: device)
        } catch {
            session.removeInput(newInput)

            if let previousInput,
               session.canAddInput(previousInput) {
                session.addInput(previousInput)
            }

            throw error
        }

        input = newInput

        updateDeviceInformation()
        observeZoom(of: device)
    }

    // MARK: - Zoom

    func setZoom(
        _ requestedZoom: Double,
        animated: Bool = true
    ) {
        sessionQueue.async { [self] in
            guard
                configured,
                session.isRunning,
                !state.isCapturing,
                requestedZoom.isFinite,
                let device = input?.device
            else {
                return
            }

            let limits = zoomLimits(for: device)

            let displayZoom = min(
                max(requestedZoom, limits.minimum),
                limits.maximum
            )

            let hardwareZoom = min(
                max(
                    CGFloat(displayZoom / zoomMultiplier),
                    device.minAvailableVideoZoomFactor
                ),
                device.maxAvailableVideoZoomFactor
            )

            do {
                try device.lockForConfiguration()
                defer {
                    device.unlockForConfiguration()
                }

                device.cancelVideoZoomRamp()

                if animated {
                    device.ramp(
                        toVideoZoomFactor: hardwareZoom,
                        withRate: zoomRampRate
                    )
                } else {
                    // Na pinça, o movimento dos dedos já faz a transição.
                    device.videoZoomFactor = hardwareZoom
                }
            } catch {
                emit(.failure(error.localizedDescription))
            }

            publishState()
        }
    }

    private func zoomLimits(
        for device: AVCaptureDevice
    ) -> (minimum: Double, maximum: Double) {
        let minimum =
            Double(device.minAvailableVideoZoomFactor) *
            zoomMultiplier

        let hardwareMaximum =
            Double(device.maxAvailableVideoZoomFactor) *
            zoomMultiplier

        let maximum = max(
            minimum,
            min(5, hardwareMaximum)
        )

        return (minimum, maximum)
    }

    private func observeZoom(of device: AVCaptureDevice) {
        zoomObservation?.invalidate()

        // Atualiza o número exibido enquanto a transição acontece.
        zoomObservation = device.observe(
            \.videoZoomFactor,
            options: [.new]
        ) { [weak self] observedDevice, _ in
            guard let self else {
                return
            }

            self.sessionQueue.async {
                // Ignora eventos de uma câmera que já foi substituída.
                guard self.input?.device === observedDevice else {
                    return
                }

                self.publishState()
            }
        }
    }

    private func stopZoomMovement() throws {
        guard let device = input?.device else {
            return
        }

        try device.lockForConfiguration()
        defer {
            device.unlockForConfiguration()
        }

        device.cancelVideoZoomRamp()
    }

    // MARK: - Foco

    func focus(at point: CGPoint) {
        sessionQueue.async { [self] in
            guard
                let device = input?.device,
                !state.isCapturing
            else {
                return
            }

            do {
                try device.lockForConfiguration()
                defer {
                    device.unlockForConfiguration()
                }

                if device.isFocusPointOfInterestSupported,
                   device.isFocusModeSupported(.autoFocus) {
                    device.focusPointOfInterest = point
                    device.focusMode = .autoFocus
                }

                if device.isExposurePointOfInterestSupported,
                   device.isExposureModeSupported(
                       .continuousAutoExposure
                   ) {
                    device.exposurePointOfInterest = point
                    device.exposureMode = .continuousAutoExposure
                }
            } catch {
                emit(.failure(error.localizedDescription))
            }
        }
    }

    // MARK: - Foto

    func takePhoto(
        flash: AVCaptureDevice.FlashMode,
        rotationAngle: CGFloat
    ) {
        sessionQueue.async { [self] in
            guard
                configured,
                session.isRunning,
                !session.isInterrupted,
                !state.isCapturing
            else {
                emit(
                    .failure(
                        "A câmera ainda não está pronta para fotografar."
                    )
                )
                return
            }

            do {
                try stopZoomMovement()
            } catch {
                emit(.failure(error.localizedDescription))
                return
            }

            state.isCapturing = true
            photoData = nil
            photoError = nil

            publishState()

            let settings = AVCapturePhotoSettings(
                format: [
                    AVVideoCodecKey: AVVideoCodecType.jpeg
                ]
            )

            settings.photoQualityPrioritization = .balanced

            if input?.device.isFlashAvailable == true,
               output.supportedFlashModes.contains(flash) {
                settings.flashMode = flash
            } else {
                settings.flashMode = .off
            }

            if let connection = output.connection(with: .video) {
                if connection.isVideoRotationAngleSupported(
                    rotationAngle
                ) {
                    connection.videoRotationAngle = rotationAngle
                }

                if connection.isVideoMirroringSupported {
                    connection.automaticallyAdjustsVideoMirroring = false
                    connection.isVideoMirrored = false
                }
            }

            output.capturePhoto(
                with: settings,
                delegate: self
            )
        }
    }

    // MARK: - Estado

    private func updateDeviceInformation() {
        guard let device = input?.device else {
            return
        }

        zoomMultiplier = displayMultiplier(for: device)

        state.isFront = device.position == .front

        state.canSwitchCamera = preferredDevice(
            position: state.isFront ? .back : .front
        ) != nil

        state.hasUltraWide =
            device.deviceType == .builtInUltraWideCamera ||
            device.constituentDevices.contains {
                $0.deviceType == .builtInUltraWideCamera
            }
    }

    private func publishState() {
        state.isRunning =
            session.isRunning && !session.isInterrupted

        if let device = input?.device {
            let limits = zoomLimits(for: device)

            state.zoom =
                Double(device.videoZoomFactor) *
                zoomMultiplier

            state.minimumZoom = limits.minimum
            state.maximumZoom = limits.maximum

            state.supportsFlash =
                device.isFlashAvailable &&
                output.supportedFlashModes.contains(.on)
        }

        emit(.state(state))
    }

    private func emit(_ event: Event) {
        DispatchQueue.main.async { [onEvent] in
            onEvent(event)
        }
    }

    // MARK: - Interrupções

    private func observeSession() {
        let center = NotificationCenter.default

        observers.append(
            center.addObserver(
                forName: AVCaptureSession.wasInterruptedNotification,
                object: session,
                queue: nil
            ) { [weak self] _ in
                guard let self else {
                    return
                }

                self.sessionQueue.async {
                    self.publishState()

                    self.emit(
                        .failure(
                            "Câmera temporariamente indisponível. Aguarde e tente novamente."
                        )
                    )
                }
            }
        )

        observers.append(
            center.addObserver(
                forName: AVCaptureSession.interruptionEndedNotification,
                object: session,
                queue: nil
            ) { [weak self] _ in
                guard let self else {
                    return
                }

                self.sessionQueue.async {
                    if self.wantsToRun && !self.session.isRunning {
                        self.session.startRunning()
                    }

                    self.publishState()
                }
            }
        )

        observers.append(
            center.addObserver(
                forName: AVCaptureSession.runtimeErrorNotification,
                object: session,
                queue: nil
            ) { [weak self] notification in
                guard let self else {
                    return
                }

                let error = notification.userInfo?[
                    AVCaptureSessionErrorKey
                ] as? AVError

                let shouldRestart =
                    error?.code == .mediaServicesWereReset

                let message =
                    error?.localizedDescription ??
                    "Ocorreu um erro na câmera."

                self.sessionQueue.async {
                    self.state.isCapturing = false

                    if shouldRestart && self.wantsToRun {
                        self.session.startRunning()
                    }

                    self.publishState()

                    if !self.session.isRunning {
                        self.emit(.failure(message))
                    }
                }
            }
        )
    }
}

extension CameraManagerPhoto: AVCapturePhotoCaptureDelegate {

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        let data = error == nil
            ? photo.fileDataRepresentation()
            : nil

        let message = error?.localizedDescription

        sessionQueue.async { [self] in
            photoData = data
            photoError = message
        }
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings,
        error: Error?
    ) {
        let message = error?.localizedDescription

        sessionQueue.async { [self] in
            state.isCapturing = false

            if let failure = message ?? photoError {
                emit(.failure(failure))
            } else if let photoData {
                emit(.photo(photoData))
            } else {
                emit(
                    .failure(
                        "Não foi possível processar a foto. Tente novamente."
                    )
                )
            }

            photoData = nil
            photoError = nil

            publishState()
        }
    }
}

private struct CameraFailure: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}
