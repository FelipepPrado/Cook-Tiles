
import Observation
import AVFoundation
internal import SpriteKit


@Observable
final class RecipeViewModel{
    let recipe: Recipe

    
    init(recipe: Recipe) {
        self.recipe = recipe

    }


}
