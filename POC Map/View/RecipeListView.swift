import SwiftUI
import SwiftData

struct RecipeListView: View {

    @Query(sort: \Recipe.id, order: .forward) private var recipes: [Recipe]
    
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
                    .font(.title2)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(recipes.filter { $0.category == category }, id: \.self) { recipe in
                        //                        HStack(spacing: 10) {
                        //                            Text(recipe.name)
                        //                                .font(.headline)
                        //
                        //                            Button("Comprar") {
                        //                                viewModel.buyRecipe(recipe: recipe, mapViewModel: mapViewModel, player: player)
                        //                            }
                        //                        }
                        if recipe.status == .unlocked {
                            Button(action:{
                                //
                            },label: {
                                UnlockedRecipeComponent(recipe: recipe)
                            })
                    }
                }
            }
        }
    }
}
}

#Preview {
    RecipeListView()
}
