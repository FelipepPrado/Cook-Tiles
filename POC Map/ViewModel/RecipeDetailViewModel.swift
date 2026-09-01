import Observation
import AVFoundation
internal import SpriteKit


@Observable
final class RecipeDetailViewModel{
    let recipe: Recipe
    private let mapViewModel: MapViewModel
    let player: Player
    
    init(recipe: Recipe, mapViewModel: MapViewModel, player: Player) {
        self.recipe = recipe
        self.mapViewModel = mapViewModel
        self.player = player
    }
    
    var recipeName: String { recipe.name }
    var reward: Int { recipe.reward }
    var isLocked: Bool { recipe.status == .locked }
    var isUnlocked: Bool { recipe.status == .unlocked }
    
    func buyRecipe() {
        if player.coin >= recipe.price{
            mapViewModel.unlockRecipe(recipe)
            player.coin -= recipe.price
        }
    }
    
    func lockRecipe() {
        mapViewModel.lockRecipe(recipe)
    }
}
