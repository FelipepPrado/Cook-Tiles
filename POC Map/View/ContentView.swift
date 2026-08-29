import SwiftUI
import SpriteKit
import SwiftData

struct ContentView: View {

    @Query(sort: \Recipe.id, order: .forward) private var recipeModel: [Recipe]
    
    @State private var selectedRecipe: Recipe?

    @State private var scene = MapScene(
        size: CGSize(width: 800, height: 800)
    )


    var body: some View {

        SpriteView(scene: scene)
            .ignoresSafeArea()

            .onAppear {

                scene.recipes = recipeModel
                scene.scaleMode = .aspectFill

                scene.onRecipeTapped = { recipe in
                    if recipe.status == .unlocked || recipe.status == .locked{
                        selectedRecipe = recipe
                    }
                }

                scene.reloadMap()
            }

            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe) {
                        scene.refreshTileStates()
                }
            }
    }
}

#Preview {

    ContentView()
        .modelContainer(
            for: Recipe.self,
            inMemory: true
        )
}
