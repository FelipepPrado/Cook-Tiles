import SwiftUI
import SwiftData

struct RecipeListView: View {
    
    @Query(sort: \Recipe.id, order: .forward) private var recipes: [Recipe]
    
    @Environment(ViewRouter.self) var viewRouter
    @Environment(MapViewModel.self) private var mapViewModel
    @Environment(Player.self) private var player
    
    @State private var viewModel = RecipeListViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            ForEach(RecipeCategory.allCases, id: \.displayName) { category in
                Text(category.displayName)
                    .font(.hammersmith(fontStyle: .title2))
                    .padding(.bottom, 10)
                    .padding(.leading, 10)
                    .foregroundStyle(Color(.brown200))
                    .frame(maxWidth: .infinity, alignment: .leading)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(recipes.filter { $0.category == category }, id: \.self) { recipe in
           
                        if recipe.status == .unlocked {
                            Button(action:{
                                viewRouter.recipeView(recipe: recipe)
                            },label: {
                                UnlockedRecipeComponent(recipe: recipe)
                            })
                        }else if recipe.status == .locked {
                            Button(action:{
                                viewModel.buyRecipe(recipe: recipe, mapViewModel: mapViewModel, player: player)
                            },label: {
                                LockedRecipeComponent(recipe: recipe)
                            })
                        }else if recipe.status == .unavailable {
                            UnavailableRecipeComponent()
                        }
                        
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color(.cream500))
    }
}

#Preview {
    RecipeListView()
}
