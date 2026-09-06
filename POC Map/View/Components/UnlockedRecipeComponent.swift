import SwiftUI

struct RecipeComponent: View {
    
    let recipe: Recipe
    let currentStatus: recipeComponent

    var body: some View {
        
        switch currentStatus {
        case .unlocked:
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
            
        case .locked:
            ZStack(){
                RoundedRectangle(cornerRadius: 10)
                    .fill(.cream600)
                    .stroke(.cream800, lineWidth: 3)
                    .frame(width: 120, height: 140)
                VStack(spacing: 10){
                    Image("padlockSymbol")
                        .frame(width: 74, height: 74)
                        .cornerRadius(10)
                    HStack(spacing: 2){
                        Text("\(recipe.price)")
                            .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
                        Image("recipeCoin")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 17)
                    }
                    .frame(width: 90, height: 30)
                    .background(.green500)
                    .cornerRadius(30)
                    .foregroundStyle(.white)
                }
            }
            
        case .unavailable:
            ZStack(){
                RoundedRectangle(cornerRadius: 10)
                    .fill(.brown100)
                    .stroke(.brown100, lineWidth: 3)
                    .frame(width: 120, height: 145)
                
                Image("unavailableSymbol")
                    .frame(width: 42.5, height: 72.5)
            }
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
    var currentStatus: recipeComponent = .unlocked

    RecipeComponent(recipe: recipe, currentStatus: currentStatus)

}

enum recipeComponent: CaseIterable {
    case unlocked, locked, unavailable
}
