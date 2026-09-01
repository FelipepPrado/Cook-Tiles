import SwiftUI
internal import SpriteKit
import SwiftData

struct MapView: View {
    
    @Query(sort: \Recipe.id, order: .forward) private var recipeModel: [Recipe]
    
    @State private var viewModel = MapViewModel()
    var body: some View {
        
        SpriteView(scene: viewModel.mapScene)
            .ignoresSafeArea()
        
            .onAppear {
                viewModel.initMap(recipes: recipeModel)
            }
        
            .sheet(item: $viewModel.selectedRecipe) { recipe in
                RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe, mapViewModel: viewModel))
            }
    }
}


#Preview {
    
    MapView()
        .modelContainer(
            for: Recipe.self,
            inMemory: true
        )
}
