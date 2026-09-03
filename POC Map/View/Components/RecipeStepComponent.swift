//
//  RecipeStepsComponent.swift
//  POC Map
//
//  Created by Ana Soares on 03/09/26.
//

import SwiftUI

struct RecipeStepComponent: View {
    let step: RecipeStep
    let totalSteps: Int
    let detectedGesture: StepsEnum
    let holdProgress: Double
    let isFirstStep: Bool
    let isLastStep: Bool
    var body: some View {
        VStack(spacing: 12) {
            // Barra de progresso
            ProgressView(value: Double(step.order), total: Double(totalSteps))
                .tint(.white)
            
            // Etapa atual
            Text("Etapa \(step.order) de \(totalSteps)")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
            
            // Título da etapa
//            Text(step.)
//                .font(.title2)
//                .bold()
//                .foregroundStyle(.white)
            
            // Descrição
            Text(step.instruction)
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Divider()
                .background(.white.opacity(0.3))
            
            // Indicadores de gesto
            HStack(spacing: 30) {
                // Voltar (pedra)
                VStack(spacing: 4) {
                    Text("🪨")
                        .font(.system(size: 30))
                        .opacity(isFirstStep ? 0.3 : 1.0)
                    Text("Voltar")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(isFirstStep ? 0.3 : 0.7))
                    
                    // Barra de progresso do hold
                    if detectedGesture == .voltar && !isFirstStep {
                        ProgressView(value: holdProgress)
                            .tint(.orange)
                            .frame(width: 50)
                    }
                }
                
                // Gesto detectado no momento
                VStack(spacing: 4) {
                    Text(detectedGesture.rawValue)
                        .font(.system(size: 24))
                    Text("Detectado")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                }
                
                // Avançar (tesoura)
                VStack(spacing: 4) {
                    Text("✂️")
                        .font(.system(size: 30))
                        .opacity(isLastStep ? 0.3 : 1.0)
                    Text("Avançar")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(isLastStep ? 0.3 : 0.7))
                    
                    // Barra de progresso do hold
                    if detectedGesture == .passar && !isLastStep {
                        ProgressView(value: holdProgress)
                            .tint(.green)
                            .frame(width: 50)
                    }
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    RecipeStepComponent()
//}
