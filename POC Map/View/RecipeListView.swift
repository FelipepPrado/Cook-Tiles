import SwiftUI
import SwiftData

struct RecipeListView: View {
    
    @Query(sort: \Recipe.id, order: .forward) private var recipes: [Recipe]
    
    @Environment(ViewRouter.self) var viewRouter
    @Environment(MapViewModel.self) private var mapViewModel
    @Environment(Player.self) private var player
    
    @State private var viewModel = RecipeListViewModel()
    
    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 3)
    ]
    
    var body: some View {
        ScrollView {
            ForEach(RecipeCategory.allCases, id: \.displayName) { category in
                Text(category.displayName)
                    .font(.hammersmith(fontStyle: .title2))
                    .padding(.bottom, 10)
                    .padding(.leading, 16)
                    .foregroundStyle(Color(.brown200))
                    .frame(maxWidth: .infinity, alignment: .leading)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(recipes.filter { $0.category == category }, id: \.self) { recipe in
           
                        if recipe.status == .unlocked {
                            Button(action:{
                                viewRouter.recipeView(recipe: recipe)
                            },label: {
                                RecipeComponent(recipe: recipe, currentStatus: .unlocked)
                            })
                        }else if recipe.status == .locked {
                            Button(action:{
                                viewRouter.recipeView(recipe: recipe)
                            },label: {
                                RecipeComponent(recipe: recipe, currentStatus: .locked)
                            })
                        }else if recipe.status == .unavailable {
                            RecipeComponent(recipe: recipe, currentStatus: .unavailable)
                        }
                        
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.cream500))
    }
}

#Preview {
    RecipeListView()
}
