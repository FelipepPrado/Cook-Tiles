
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
        if player.coin >= recipe.price{
            mapViewModel.unlockRecipe(recipe)
            player.coin -= recipe.price
        }
    }
    
    func toogleStatus(igredient: Igredient){
        
        if let index = recipe.igredients.firstIndex(where: { $0.name == igredient.name }) {
            recipe.igredients[index].status.toggle()
        }
        
    }
    
}
