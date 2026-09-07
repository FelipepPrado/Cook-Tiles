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
            
                    ForEach(recipes
                                .filter { $0.category == category }
                                .sorted { $0.level.sortWeight < $1.level.sortWeight },
                            id: \.self) { recipe in
                        
                        if recipe.status == .unlocked {
                            Button(action: {
                                viewRouter.recipeView(recipe: recipe)
                            }, label: {
                                RecipeComponent(recipe: recipe, currentStatus: .unlocked)
                            })
                            .buttonStyle(.plain)
                            
                        } else if recipe.status == .locked {
                            Button(action: {
                                viewRouter.recipeView(recipe: recipe)
                            }, label: {
                                RecipeComponent(recipe: recipe, currentStatus: .locked)
                            })
                            .buttonStyle(.plain)
                            
                        } else if recipe.status == .unavailable {
                            RecipeComponent(recipe: recipe, currentStatus: .unavailable)
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.cream500))
        
        .navigationTitle("Receitas")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Receitas")
                    .fontWeight(.bold)
                    .foregroundStyle(.brown200)
                    .blendMode(.plusDarker)
            }
        }
    }
}

#Preview {
    RecipeListView()
}
