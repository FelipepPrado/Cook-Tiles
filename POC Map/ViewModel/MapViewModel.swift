import Observation
import AVFoundation
internal import SpriteKit

@Observable
final class MapViewModel{
    var selectedRecipe: Recipe?
    var mapScene = MapScene(
        size: CGSize(width: 1378, height: 850)
    )
    
    init(selectedRecipe: Recipe? = nil, mapScene: MapScene = MapScene(
        size: CGSize(width: 1378, height: 850)
    )) {
        self.selectedRecipe = selectedRecipe
        self.mapScene = mapScene
    }
    
    func initMap(recipes: [Recipe]){
        mapScene.recipes = recipes
        mapScene.scaleMode = .aspectFill

        mapScene.onRecipeTapped = { recipe in
            if recipe.status == .unlocked || recipe.status == .locked{
                self.selectedRecipe = recipe
            }
        }
        mapScene.reloadMap()
    }
    
    func unlockRecipe(_ recipe: Recipe){
        recipe.status = .unlocked
        mapScene.refreshTileStates()
    }
    
    func lockRecipe(_ recipe: Recipe){
        recipe.status = .locked
        mapScene.refreshTileStates()
    }
}
