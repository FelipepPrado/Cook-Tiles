import SwiftUI

struct UnlockedRecipeComponent: View {
    let recipe: Recipe

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(.cream200)
                .stroke(.cream800, lineWidth: 3)
                .padding(3)
                .frame(maxWidth: 120, minHeight: 145)
            
            VStack(spacing: 10){
                Image("diamondRecipe")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 74, height: 74)
//                    .padding(.bottom, 10)
                    .foregroundStyle(Color("\(recipe.category.rawValue)"))

                
                Text(recipe.name)
                    .font(.hammersmith())
                    .foregroundColor(.brown200)
//                    .padding(.bottom, 8)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(15)
        }
    }
}

#Preview {

    @Previewable var recipe: Recipe = Recipe(
        name: "Receita",
        status: .locked,
        reward: 1,
        time: 1,
        level: .easy,
        steps: [],
        igredients: [],
        tags: [],
        category: .sobremesa,
        id: 1,
        price: 50,
        overlayImage: "nuvem",
        portions: "duas",
        recipeDescription: " "
        )

    UnlockedRecipeComponent(recipe: recipe)

}
