import SwiftUI
import SpriteKit
import SwiftData

struct ContentView: View {

    @Query private var recipeModel: [Recipe]
    
    @State private var selectedRecipe: Recipe?

    @State private var scene = MapScene(
        size: CGSize(width: 800, height: 800)
    )

    private var sortedRecipes: [Recipe] {
        recipeModel.sorted {
            $0.category.rawValue < $1.category.rawValue
        }
    }

    var body: some View {

        SpriteView(scene: scene)
            .ignoresSafeArea()

            .onAppear {

                scene.recipes = recipeModel
                scene.scaleMode = .aspectFill

                scene.onRecipeTapped = { recipe in
                    selectedRecipe = recipe
                }

                scene.reloadMap()
            }

            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(
                    recipe: recipe
                )
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
