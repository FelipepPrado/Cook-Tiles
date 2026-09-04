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
            
            ZStack{
                if let recipe = viewModel.selectedRecipe, viewModel.showPopup {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea() // Cobre a tela toda, incluindo a TabBar
                            .onTapGesture {
                                viewModel.selectedRecipe = nil
                            }
                            .transition(.opacity)
                        
                        RecipeDetailView(viewModel: RecipeDetailViewModel(
                            recipe: recipe, mapViewModel: viewModel, player: player
                        ))
                        .padding(.bottom, 50)
                    }
                    .zIndex(1) // Força o popup a renderizar por cima da Camada Base
                }
                ZStack{
                    SpriteView(scene: viewModel.mapScene)
                        .ignoresSafeArea()
                    
                }
                
                .onAppear {
                    viewModel.initMap(recipes: recipeModel)
                    
                }
//                .overlay {
//                    if let recipe = viewModel.selectedRecipe{
//                        
//                        if viewModel.showPopup {
//                            ZStack {
//                                
//                                Color.black.opacity(0.4)
//                                    .ignoresSafeArea()
//                                    .onTapGesture {
//                                        
//                                        viewModel.selectedRecipe = nil
//                                        
//                                    }
//                                    .transition(.opacity)
//                                
//                                RecipeDetailView(viewModel: RecipeDetailViewModel(
//                                    recipe: recipe, mapViewModel: viewModel, player: player
//                                ))
//                                
//                            }
//                        }
//                    }
//                }
                .navigationDestination(for: NameViews.self){
                    destination in
                    ViewManagar.viewForDestination(destination)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    TabBarComponent()
                }
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        VStack{
                            Text("\(player.coin)")
                        }
                    }
                }
            }
        }
        .environment(viewModel)
        .environment(player)
    }
    
}


#Preview {
    MapView()
        .modelContainer(
            for: [
                Recipe.self,
                Player.self
            ],
            inMemory: true
        )
        .environment(ViewRouter())
}
