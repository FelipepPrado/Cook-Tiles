import AVFoundation
internal import Combine
import UIKit

@MainActor
final class CameraModel: ObservableObject {
    enum Flash: String, CaseIterable, Identifiable {
        case off, on, auto
        var id: Self { self }
        var title: String {
            switch self { case .off: "Desligado"; case .on: "Ligado"; case .auto: "Automático" }
        }
        var icon: String {
            switch self { case .off: "bolt.slash.fill"; case .on: "bolt.fill"; case .auto: "bolt.badge.a.fill" }
        }
        var captureMode: AVCaptureDevice.FlashMode {
            switch self { case .off: .off; case .on: .on; case .auto: .auto }
        }
        
        mutating func toggle() {
            switch self{
            case .off: self = CameraModel.Flash.on
            case .on: self = CameraModel.Flash.auto
            case .auto: self = CameraModel.Flash.off
            }
        }
    }
    
    @Published private(set) var state = CameraManagerPhoto.State()
    @Published private(set) var photoData: Data?
    @Published private(set) var photoImage: UIImage?
    @Published private(set) var accessDenied = false
    @Published private(set) var isStarting = false
    @Published private var captureRequested = false
    @Published var flash: Flash = .off
    @Published var errorMessage: String?
    @Published private(set) var displayedZoom: Double = 1
    
    private var zoomTarget: Double?
    
    var rotationAngle: CGFloat = 90
    private var isVisible = false
    private var isActive = false
    private var authorizationTask: Task<Void, Never>?
    private var generation = 0
    
    private(set) lazy var camera = CameraManagerPhoto { [weak self] event in
        self?.receive(event)
    }
    var session: AVCaptureSession { camera.session }
    var canTakePhoto: Bool {
        state.isRunning && !state.isCapturing && !captureRequested && photoData == nil && isActive
    }
    var zoomPresets: [Double] {
        let candidates = [
            state.minimumZoom,
            1.0,
            2.0,
            3.0,
            5.0
        ]
        
        var result: [Double] = []
        
        for factor in candidates.sorted() {
            guard
                factor >= state.minimumZoom,
                factor <= state.maximumZoom
            else {
                continue
            }
            
            if !result.contains(where: { abs($0 - factor) < 0.01 }) {
                result.append(factor)
            }
        }
        
        return result
    }
    
    func appear(isActive: Bool) {
        isVisible = true
        setActive(isActive)
    }
    
    func disappear() {
        isVisible = false
        stop()
    }
    
    func setActive(_ active: Bool) {
        isActive = active
        if active && isVisible && photoData == nil { start() } else { stop() }
    }
    
    func start() {
        guard isVisible, isActive, photoData == nil, authorizationTask == nil else { return }
        generation += 1
        let token = generation
        isStarting = true
        authorizationTask = Task { [weak self] in
            let allowed: Bool
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: allowed = true
            case .notDetermined: allowed = await AVCaptureDevice.requestAccess(for: .video)
            default: allowed = false
            }
            guard let self, !Task.isCancelled, token == self.generation else { return }
            self.authorizationTask = nil
            self.accessDenied = !allowed
            if allowed && self.isVisible && self.isActive && self.photoData == nil {
                self.camera.start()
            } else {
                self.isStarting = false
            }
        }
    }
    
    private func stop() {
        generation += 1
        authorizationTask?.cancel()
        authorizationTask = nil
        isStarting = false
        camera.stop()
    }
    
    func takePhoto() {
        guard canTakePhoto else { return }
        captureRequested = true // Bloqueia um segundo toque antes da resposta da fila.
        camera.takePhoto(flash: flash.captureMode, rotationAngle: rotationAngle)
    }
    
    func retake() {
        photoData = nil
        photoImage = nil
        start()
    }
    
    func switchCamera() {
        guard canTakePhoto else { return }
        camera.switchCamera()
    }
    
    func setZoom(
        _ value: Double,
        animated: Bool = true
    ) {
        guard canTakePhoto else {
            return
        }
        
        let target = min(
            max(value, state.minimumZoom),
            state.maximumZoom
        )
        
        zoomTarget = animated ? target : nil
        displayedZoom = target
        
        camera.setZoom(target, animated: animated)
    }
    
    func focus(at point: CGPoint) {
        guard canTakePhoto else { return }
        camera.focus(at: point)
    }
    
    private func receive(_ event: CameraManagerPhoto.Event) {
        switch event {
        case .state(let newState):
            let changedCamera = state.isFront != newState.isFront
            
            state = newState
            isStarting = false
            
            if !newState.isCapturing {
                captureRequested = false
            }
            
            if changedCamera || !newState.isRunning || newState.isCapturing {
                zoomTarget = nil
            }
            
            if let target = zoomTarget {
                // Mantém o destino na interface durante a transição.
                displayedZoom = target
                
                if abs(newState.zoom - target) < 0.01 {
                    zoomTarget = nil
                }
            } else {
                // Sem destino pendente, acompanha o zoom real.
                displayedZoom = newState.zoom
            }
        case .photo(let data):
            captureRequested = false
            guard isVisible else { return }
            guard let image = UIImage(data: data) else {
                errorMessage = "Não foi possível abrir a foto capturada."
                return
            }
            photoData = data
            photoImage = image
            camera.stop()
        case .failure(let message):
            captureRequested = false
            isStarting = false
            errorMessage = message
        }
    }
}
