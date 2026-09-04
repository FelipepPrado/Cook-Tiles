import SwiftUI
internal import Combine

struct StepsView: View {
    
    var viewModel: StepsViewModel
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Group {
            if let frame = viewModel.cameraManager.currentFrame {
                ZStack {
                    // Feed da câmera como fundo
                    Image(frame, scale: 1, orientation: .up, label: Text("Camera Feed"))
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(x: -1, y: 1)
                    
                    // Overlay escuro para legibilidade
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    // Conteúdo da receita
                    VStack(spacing: 16) {
                        Spacer()
                        
                        RecipeStepComponent(
                            step: viewModel.currentStep,
                            totalSteps: viewModel.totalSteps,
                            detectedGesture: viewModel.currentGesture,
                            holdProgress: viewModel.holdProgress,
                            isFirstStep: viewModel.isFirstStep,
                            isLastStep: viewModel.isLastStep
                        )
                        
                        // Feedback de navegação
                        if let message = viewModel.feedbackMessage {
                            Text(message)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        Spacer()
                    }
                }
            } else {
                ProgressView("Ligando câmera...")
            }
        }
        .onReceive(timer) { _ in
            checkGesture()
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.feedbackMessage)
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStepIndex)
    }
    
    private func checkGesture() {
        let detected = viewModel.cameraManager.handAnalyzer.detectedPose
        
        // Só processa tesoura (avançar) e pedra (voltar)
        let isActionGesture = (detected == .passar || detected == .voltar)
        
        // Se está em cooldown, não faz nada
        if viewModel.isInCooldown { return }
        
        if isActionGesture && detected == viewModel.currentGesture {
            // Mesmo gesto sendo mantido — calcula progresso
            if let start = viewModel.gestureHoldStart {
                let elapsed = Date.now.timeIntervalSince(start)
                viewModel.holdProgress = min(elapsed / viewModel.holdDuration, 1.0)
                
                if elapsed >= viewModel.holdDuration {
                    // Gesto mantido tempo suficiente — executa ação
                    executeGestureAction(detected)
                }
            }
        } else if isActionGesture {
            // Novo gesto detectado — começa a contar
            viewModel.currentGesture = detected
            viewModel.gestureHoldStart = Date.now
            viewModel.holdProgress = 0.0
        } else {
            // Gesto não reconhecido ou mão ausente — reseta
            resetGesture()
        }
    }
    
    private func executeGestureAction(_ gesture: StepsEnum) {
        switch gesture {
        case .passar:
            if !viewModel.isLastStep {
                viewModel.nextStep()
                viewModel.feedbackMessage = "Próxima etapa"
            }
        case .voltar:
            if !viewModel.isFirstStep {
                viewModel.previousStep()
                viewModel.feedbackMessage = "Etapa anterior"
            }
        default:
            break
        }
        
        // Reseta e entra em cooldown
        resetGesture()
        viewModel.isInCooldown = true
        
        // Remove feedback e cooldown após um tempo
        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.cooldownDuration) {
            viewModel.isInCooldown = false
            viewModel.feedbackMessage = nil
        }
    }
    
    private func resetGesture() {
        viewModel.currentGesture = .noValue
        viewModel.gestureHoldStart = nil
        viewModel.holdProgress = 0.0
    }
}

//#Preview {
//    StepsView()
//}
