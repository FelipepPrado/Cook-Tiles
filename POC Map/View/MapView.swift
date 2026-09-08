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
                        .accessibilityLabel("Mapa de receitas")
                        .accessibilityHint("Navegue pelo mapa para encontrar receitas")
                        .background(
                            Image("Home Map")
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                        )
                    
                }
                .overlay(alignment: .topLeading) {
                    StatusCoinComponent(coin: player.coin)
                        .padding()
                        .zIndex(2)
                }
                .onAppear {
                    viewModel.mapScene.coinBalance = player.coin
                    viewModel.initMap(recipes: recipeModel)

                    if !hasCompletedOnboarding && viewRouter.sheet == nil {
                        viewRouter.initialSheet()
                    }
                }
                .onChange(of: player.coin, initial: true) { _, balance in
                    viewModel.mapScene.coinBalance = balance
                }
                .navigationDestination(for: NameViews.self){
                    destination in
                    ViewManagar.viewForDestination(destination)
                }
                .sheet(
                    isPresented: Binding(
                        get: { viewRouter.sheet != nil },
                        set: { isPresented in
                            if !isPresented {
                                viewRouter.dismissSheet()
                            }
                        }
                    )
                ) {
                    OnBoardingSheetView()
                        .interactiveDismissDisabled()
                        .presentationDragIndicator(.hidden)
                        .presentationBackground(Color.cream500)
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
