import Observation
import AVFoundation
internal import SpriteKit


@Observable
final class RecipeListViewModel{

    func buyRecipe(recipe: Recipe, mapViewModel: MapViewModel, player: Player) {
        if player.coin >= recipe.price{
            mapViewModel.unlockRecipe(recipe)
            player.coin -= recipe.price
        }
    }

}
