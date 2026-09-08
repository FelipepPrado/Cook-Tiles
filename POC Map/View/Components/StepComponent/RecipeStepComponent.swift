import SwiftUI

struct RecipeStepComponent: View {
    let recipe: Recipe
    let step: RecipeStep
    let totalSteps: Int
    let detectedGesture: StepsEnum
    let holdProgress: Double
    let isFirstStep: Bool
    let isLastStep: Bool
    let isCompleted: Bool
    let onFinish: () -> Void
    let onRegister: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack(spacing: 30) {
                    VStack(alignment: .center, spacing: 2) {
                        Image("anterior")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 75)
                            .padding(.bottom, 10)
                        
                        Text("Passo\nAnterior")
                            .font(.hammersmith())
                            .foregroundStyle(.cream50)
                            .multilineTextAlignment(.center)
                        
                        if detectedGesture == .voltar && (isCompleted || !isFirstStep) {
                            ProgressView(value: holdProgress)
                                .tint(.orange)
                                .frame(width: 50)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 2) {
                        Image("seguinte")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 75)
                            .padding(.bottom, 10)
                        
                        Text("Passo\nSeguinte")
                            .font(.hammersmith())
                            .foregroundStyle(.cream50)
                            .multilineTextAlignment(.center)
                        
                        if detectedGesture == .passar && !isCompleted {
                            ProgressView(value: holdProgress)
                                .tint(.green)
                                .frame(width: 50)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                VStack(spacing: 36) {
                    if isCompleted {
                        Text("Receita Completa!")
                            .font(.hammersmith(fontStyle: .title))
                            .foregroundStyle(.brown200)
                            .multilineTextAlignment(.center)
//                            .padding(.bottom, 20)
                        
                        VStack(spacing: 16) {
                            Button(action: onFinish) {
                                BrownButtonComponent(
                                    title: "Finalizar",
                                    recipe: recipe,
                                    currentButton: .smallFill
                                )
                            }
                            
                            Button(action: onRegister) {
                                BrownButtonComponent(
                                    title: "Registrar Receita",
                                    recipe: recipe,
                                    currentButton: .smallStroke
                                )
                            }
                        }
                        .padding(.bottom, 20)
                        .buttonStyle(.plain)
                    } else {
                        Text(step.instruction)
                            .font(.body)
                            .foregroundStyle(.brown200)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 0) {
                            Text("Etapa \(step.order)")
                                .font(.hammersmith())
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
                            
                            ProgressView(
                                value: Double(step.order),
                                total: Double(totalSteps + 1)
                            )
                            .padding()
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .frame(height: 30)
                            .tint(.green500)
                            .background(Color.cream50)
                            .cornerRadius(25)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .padding(20)
                .background(.cream500)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(alignment: .top) {
                    DiamondComponent(
                        recipe: recipe,
                        hasStroke: true,
                        strokeWidth: 10
                    )
                    .frame(width: 120, height: 120)
                    .offset(y: -60)
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(maxHeight: .infinity)
    }
}
