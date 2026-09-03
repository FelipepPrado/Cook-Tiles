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
        
        
        VStack{
            Spacer()
            VStack{
                HStack(spacing: 30) {
                    VStack(alignment:.center, spacing: 2) {
                        Image("anterior").resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 75)
                            .padding(.bottom, 10)
                        Text("Passo \nAnterior")
                            .font(.caption2.bold())
                            .foregroundStyle(.cream50)
                            .multilineTextAlignment(.center)
                        
                        // Barra de progresso do hold
                        if detectedGesture == .voltar && !isFirstStep {
                            ProgressView(value: holdProgress)
                                .tint(.orange)
                                .frame(width: 50)
                        }
                    }
                    
                    Spacer()

                    VStack(alignment:.center, spacing: 2) {
                        Image("seguinte").resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 75)
                            .padding(.bottom, 10)
                        Text("Passo\nSeguinte")
                            .font(.caption2.bold())
                            .foregroundStyle(.cream50)
                            .multilineTextAlignment(.center)
                        
                        // Barra de progresso do hold
                        if detectedGesture == .passar && !isLastStep {
                            ProgressView(value: holdProgress)
                                .tint(.green)
                                .frame(width: 50)
                        }
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                
                VStack(spacing: 12) {

                    Text(step.instruction)
                        .font(.body)
                        .foregroundStyle(.brown200)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 0){
                        Text("Etapa \(step.order)")
                            .font(.body.bold())
                            .foregroundStyle(.brown200)
                            .frame(width: 100, height: 40)
                            .background(Color.cream50)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 15,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 15
                                )
                            )
                        
                        ProgressView(value: Double(step.order), total: Double(totalSteps))
                            .padding()
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .frame(width: 300, height: 30)
                            .tint(.green500)
                            .background(Color.cream50)
                            .cornerRadius(25)
                    }
                   
                }
                .padding(20)
                .background(.cream500)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

//#Preview {
//    RecipeStepComponent()
//}
