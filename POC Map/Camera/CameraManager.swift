import AVFoundation
import SwiftUI
import Observation
import CoreImage

import Vision
import CoreML

@Observable
class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let session = AVCaptureSession()
    var currentFrame: CGImage?
    
    var isRunning: Bool = false
    
    var handAnalyzer = HandAnalyzer()
    
    let handPoseRequest = VNDetectHumanHandPoseRequest()
    
    private let context = CIContext()
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        
        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        ) else {
            return
        }
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(captureDeviceInput) {
                session.addInput(captureDeviceInput)
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            
            videoOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String:
                    kCVPixelFormatType_32BGRA
            ]
            
            let queue = DispatchQueue(
                label: "com.handPoseCat.camera.queue"
            )
            
            videoOutput.setSampleBufferDelegate(
                self,
                queue: queue
            )
            
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
            }
            
            // Rotaciona o vídeo para portrait (vertical)
            if let connection = videoOutput.connection(with: .video) {
                if connection.isVideoRotationAngleSupported(90) {
                    connection.videoRotationAngle = 90
                }
            }
            
            Task.detached {
                await self.session.startRunning()
            }
            self.isRunning = true
            
        } catch {
            print("Camera não detectada")
        }
    }
    
    // func do tipo Delegate: Ele é chamado pelo próprio Mac
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ){
        guard isRunning else { return }
        
        // guarda "fotos", ou seja, a cada tempo ele pega frame da câmera e guarda
        guard let pixelBuffer =
                CMSampleBufferGetImageBuffer(sampleBuffer)
        else {
            return
        }
        
        
        let ciImage = CIImage(
            cvPixelBuffer: pixelBuffer
        )
        
        guard let cgImage = context.createCGImage(
            ciImage,
            from: ciImage.extent
        ) else {
            return
        }
        
        DispatchQueue.main.async {
            self.currentFrame = cgImage
        }
        
        //Manda para o handAnalyzer o buffer para fazer a analise de todas as imagens
        handAnalyzer.processFrame(pixelBuffer)
    }
}
