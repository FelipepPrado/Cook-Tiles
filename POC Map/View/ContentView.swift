import SwiftUI
import SpriteKit
import SwiftData

struct ContentView: View {
    @Query private var recipeModel: [Recipe]
    
    private var sortedRecipes: [Recipe] {
        recipeModel.sorted {
            $0.category.rawValue < $1.category.rawValue
        }
    }

    private var scene: SKScene {

        let scene = MapScene(
            size: CGSize(width: 800, height: 800)
        )
        
        scene.recipes = sortedRecipes
        scene.scaleMode = .aspectFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
    .modelContainer(
        for: Recipe.self,
        inMemory: true
    )
}
