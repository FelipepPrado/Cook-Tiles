import SwiftUI
import SpriteKit
import SwiftData

struct MapView: View {

    @Query(sort: \Recipe.id, order: .forward) private var recipeModel: [Recipe]
    
    @State private var selectedRecipe: Recipe?

    @State private var mapScene = MapScene(
        size: CGSize(width: 800, height: 800)
    )


    var body: some View {

        SpriteView(scene: mapScene)
            .ignoresSafeArea()

            .onAppear {

                mapScene.recipes = recipeModel
                mapScene.scaleMode = .aspectFill

                mapScene.onRecipeTapped = { recipe in
                    if recipe.status == .unlocked || recipe.status == .locked{
                        selectedRecipe = recipe
                    }
                }

                mapScene.reloadMap()
            }

            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe) {
                        mapScene.refreshTileStates()
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
