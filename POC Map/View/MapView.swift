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
                            .ignoresSafeArea()
                            .onTapGesture {
                                viewModel.selectedRecipe = nil
                            }
                            .transition(.opacity)
                        
                        RecipeDetailView(viewModel: RecipeDetailViewModel(
                            recipe: recipe, mapViewModel: viewModel, player: player
                        ))
                        .padding(.bottom, 35)
                    }
                    .zIndex(1)
                }
                ZStack{
                    SpriteView(scene: viewModel.mapScene)
                        .ignoresSafeArea()
                    
                }
                .overlay(alignment: .topLeading) {
                    StatusCoinComponent(coin: player.coin)
                        .padding()
                        .zIndex(2)
                }
                .onAppear {
                    viewModel.initMap(recipes: recipeModel)
                    
                }
                .navigationDestination(for: NameViews.self){
                    destination in
                    ViewManagar.viewForDestination(destination)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    TabBarComponent()
                }
//                .toolbar{
//                    ToolbarItem(placement: .topBarLeading){
//                        VStack{
//                            Text("\(player.coin)")
//                        }
//                    }
//                }
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
