
import Observation
import AVFoundation
internal import SpriteKit


@Observable
final class RecipeViewModel{
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe

    }
    
    func buyRecipe(recipe: Recipe, mapViewModel: MapViewModel, player: Player) {
        if recipe.status == .locked, player.coin >= recipe.price {
            mapViewModel.unlockRecipe(recipe)
            player.coin -= recipe.price
        }
    }
    

    func toogleStatus(at index: Int) {

        recipe.igredients[index].status.toggle()
    }
    
}
