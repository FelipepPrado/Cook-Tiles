import SwiftUI

struct UnlockedRecipeComponent: View {
    var body: some View {
        ZStack(){
            RoundedRectangle(cornerRadius: 10)
                .fill(.cream200)
                .stroke(.cream800, lineWidth: 3)
                .frame(width: 120, height: 145)
            
            VStack(spacing: 10){
                Image("diamondRecipe")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 74, height: 74)
                    .padding(.bottom, 10)
                    .foregroundStyle(.entrada)
                
                Text("Receita")
                    .font(.body)
                    .foregroundColor(.brown200)
            }
        }
    }
}

#Preview {
    UnlockedRecipeComponent()
}
