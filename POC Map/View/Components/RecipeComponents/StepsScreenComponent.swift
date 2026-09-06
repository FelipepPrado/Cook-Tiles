import SwiftUI

struct StepsScreenComponent: View {
    
    let step: RecipeStep
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(.cream200)
                .frame(maxWidth: 360, minHeight: 83)
                .cornerRadius(10)
            
            HStack(alignment: .center, spacing: 15){
                VStack{
                    Text("\(step.order)ª")
                        .font(Font.largeTitle.bold())
                        .foregroundStyle(.green500)
                    
                    Text("Etapa")
                        .font(Font.body.bold())
                        .foregroundStyle(.brown200)
                }
                
                .padding(20)
                
                Text("\(step.instruction)")
                    .font(Font.headline)
                    .foregroundStyle(.brown200)
                    .padding(.vertical, 15)
                    
                
                Spacer()
            }
            .padding(.horizontal, 15)
           
        }
    }
}
    
    #Preview {
        StepsScreenComponent(step: RecipeStep(order: 1, instruction: "Finalize com chocolate granulado por cima e leve à geladeira por pelo menos 4 horas.", process: ""))
    }
