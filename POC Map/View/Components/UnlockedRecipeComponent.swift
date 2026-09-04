import SwiftUI

struct UnlockedRecipeComponent: View {
    let recipe: Recipe
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(.cream200)
                .stroke(.cream800, lineWidth: 3)
                .padding(3)
                .frame(width: 120, height: 145)
            
            VStack(spacing: 10){
                Image("diamondRecipe")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 74, height: 74)
                    .padding(.bottom, 11)
                    .padding(.horizontal, 23)
                    .foregroundStyle(Color(recipe.category.rawValue))
                
                Text(recipe.name)
                    .font(.body)
                    .foregroundColor(.brown200)
                    .padding(.bottom, 8)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(15)
        }
    }
}

#Preview {
    UnlockedRecipeComponent(recipe: Recipe(name: "Risoto de Cogumelos", status: .unlocked, reward: 0, time: 0, level: .easy, steps: [], ingredients: [], tags: [], category: .sobremesa, id: 0, price: 0, overlayImage: "", portions: ""))
}
