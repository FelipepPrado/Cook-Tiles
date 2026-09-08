import SwiftUI
internal import SpriteKit
import SwiftData

struct MapView: View {
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false
    
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
                                   .accessibilityLabel("Fechar popup")
                                   .accessibilityHint("Toque duas vezes para fechar os detalhes da receita")

                               
                               RecipeDetailView(viewModel: RecipeDetailViewModel(
                                   recipe: recipe, mapViewModel: viewModel, player: player
                               ))
                               .padding(.bottom, 35)
                           }
                           .zIndex(1)
                       }
                       ZStack{
                           SpriteView(scene: viewModel.mapScene, options: [.allowsTransparency])
                               .ignoresSafeArea()
                               .accessibilityHidden(true)
                               .background(
                                Image("Home Map")
                                    .resizable()
                                    .scaledToFill()
                                    .ignoresSafeArea()
                               )
                           MapAccessibilityOverlay(viewModel: viewModel)
                       }
                       .overlay(alignment: .topLeading) {
                           StatusCoinComponent(coin: player.coin)
                               .padding()
                               .zIndex(2)
                       }
                       .onAppear {
                           viewModel.mapScene.coinBalance = player.coin
                           viewModel.initMap(recipes: recipeModel)
                           
                       }
                       .onChange(of: player.coin, initial: true) { _, balance in
                           viewModel.mapScene.coinBalance = balance
                       }
                       .onChange(of: viewModel.mapScene.recipeTiles.count) {
                           viewModel.updateAccessibleTiles()
                       }
                       .navigationDestination(for: NameViews.self){
                           destination in
                           ViewManagar.viewForDestination(destination)
                       }
                       .safeAreaInset(edge: .bottom, spacing: 0) {
                           TabBarComponent()
                               .padding(.horizontal, 30)
                       }
                       .navigationTitle("Mapa de Receitas")
                       .toolbar(.hidden, for: .navigationBar)
                   }
    
               }
               .environment(viewModel)
               .environment(player)
        
    }
    
}

private struct MapAccessibilityOverlay: View {
    var viewModel: MapViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(viewModel.accessibleTiles) { tileInfo in
                    Color.clear
                        .frame(width: 120, height: 100)
                        .contentShape(Rectangle())
                        .position(
                            x: tileInfo.normalizedPosition.x * geometry.size.width,
                            y: tileInfo.normalizedPosition.y * geometry.size.height
                        )
                        .accessibilityLabel(tileInfo.label)
                        .accessibilityValue(tileInfo.value)
                        .accessibilityHint(tileInfo.hint)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityRemoveTraits(
                            tileInfo.isInteractable ? [] : .isButton
                        )
                        .onTapGesture {
                            if tileInfo.isInteractable {
                                viewModel.selectedRecipe = tileInfo.recipe
                                viewModel.showPopup = true
                            }
                        }
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Mapa de receitas")
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
