import SwiftUI
internal import SpriteKit
import SwiftData

struct MapView: View {
    
    @Environment(ViewRouter.self) var viewRouter
    @Query(sort: \Recipe.id, order: .forward) private var recipeModel: [Recipe]
    @Query private var players: [Player]
    
    var player: Player {
        players.first ?? Player(coin: 0, banner: "Phoenix")
    }
    
    @State private var viewModel = MapViewModel()
    var body: some View {
        @Bindable var path = viewRouter
        NavigationStack(path: $path.path) {
            SpriteView(scene: viewModel.mapScene)
                .ignoresSafeArea()
            
                .onAppear {
                    viewModel.initMap(recipes: recipeModel)
                }
            
                .sheet(item: $viewModel.selectedRecipe) { recipe in
                    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe, mapViewModel: viewModel, player: player))
                }
                .navigationDestination(for: NameViews.self){
                    destination in
                    ViewManagar.viewForDestination(destination)
                }
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
