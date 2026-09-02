import Foundation
import Vision
import CoreML

@Observable
class HandAnalyzer {
    private let handler = VNSequenceRequestHandler()
    var detectedPose: StepsEnum = .noValue
    
    //Variavel com o modelo
    private let model: RecipeStepsClassifier2
    
    //Inicializa principalmente como o foco de inicializar o modelo apenas uma vez
    init(detectedPose: StepsEnum = .noValue) {
        self.detectedPose = detectedPose
        do {
            self.model = try RecipeStepsClassifier2(
                configuration: MLModelConfiguration()
            )
        } catch {
            fatalError("Não foi possível carregar o modelo: \(error)")
        }
    }
    
    //Parte onde a câmera devolve frames, já que é em tempo real
    func processFrame(_ pixelBuffer: CVPixelBuffer) {
        //Parte do request, onde eu chamo o Vision para identificar os pontos da mão e analisar
        let handPoseRequest = VNDetectHumanHandPoseRequest { [weak self] request, error in
            guard let self = self else { return }
            //
            guard let observations = request.results as? [VNHumanHandPoseObservation],
                  let firstHand = observations.first else {
                detectedPose = .noValue
                return
            }
            
            self.analyseHand(firstHand)
        }
        
        do {
            // Chamada do modelo para detecar a pose da mão
            try handler.perform([handPoseRequest], on: pixelBuffer, orientation: .up)
            
        } catch {
            print("Erro ao detectar mão: \(error)")
            return
        }
    }
    
    private func analyseHand(_ handPoseRequest: VNHumanHandPoseObservation) {
        do {
            //Pega os pontos da mão
            let keypointsMultiArray = try handPoseRequest.keypointsMultiArray()
            
            //Retorna a resposta do modelo a imagem
            let prediction = try model.prediction(input: RecipeStepsClassifier2Input(poses: keypointsMultiArray))
            let predictionLabel = prediction.label
            
            DispatchQueue.main.async {
                //Se o modelo me der uma confiança alta (geralmente acontece isso), eu guardo a pose
                if handPoseRequest.confidence > 0.80 {
                    self.detectedPose = self.returnStepsEnum(label: predictionLabel)
                }
            }
            
        } catch {
        }
    }
    
    private func returnStepsEnum(label: String) -> StepsEnum{
        switch label {
        case "voltar":
            return .voltar
        case "passar":
            return .passar
        default:
            return .noValue
        }
        
    }
}
