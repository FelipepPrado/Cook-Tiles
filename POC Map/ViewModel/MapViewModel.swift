import Observation
import AVFoundation
internal import SpriteKit

struct AccessibleTileInfo: Identifiable {
    let id: Int
    let name: String
    let label: String
    let value: String
    let hint: String
    let normalizedPosition: CGPoint
    let isInteractable: Bool
    let recipe: Recipe
}

@Observable
final class MapViewModel{
    var selectedRecipe: Recipe?
    var mapScene = MapScene(
        size: CGSize(width: 1378, height: 850)
    )

    private var mapInitialized: Bool = false


    var showPopup: Bool = true
    
    init(selectedRecipe: Recipe? = nil, mapScene: MapScene = MapScene(
        size: CGSize(width: 1378, height: 850)
    )) {
        self.selectedRecipe = selectedRecipe
        self.mapScene = mapScene
     
        self.showPopup = showPopup
    }
    
    var accessibleTiles: [AccessibleTileInfo] = []
    
    func updateAccessibleTiles() {
        let positions = mapScene.tileScreenPositions()

        accessibleTiles = positions.map { item in
            AccessibleTileInfo(
                id: item.recipeTile.recipe.id,
                name: item.recipeTile.recipe.name,
                label: item.recipeTile.accessibilityLabelText,
                value: item.recipeTile.accessibilityValueText,
                hint: item.recipeTile.accessibilityHintText,
                normalizedPosition: item.screenPoint,
                isInteractable: item.recipeTile.recipe.status == .unlocked
                                || item.recipeTile.recipe.status == .locked,
                recipe: item.recipeTile.recipe
            )
        }
    }
    
    func initMap(recipes: [Recipe]) {
        guard !mapInitialized else { return }
        mapScene.recipes = recipes
        mapScene.scaleMode = .aspectFill

        mapScene.onRecipeTapped = { recipe in
            if recipe.status == .unlocked || recipe.status == .locked {
                self.selectedRecipe = recipe
                self.showPopup = true
            }
        }
        mapScene.reloadMap()
        mapInitialized = true
        updateAccessibleTiles()
        mapScene.onCameraDidMove = { [weak self] in
            self?.updateAccessibleTiles()
        }
    }

    
    func unlockRecipe(_ recipe: Recipe) {
        recipe.status = .unlocked
        mapScene.refreshTileStates()
        updateAccessibleTiles()
    }
    
    func lockRecipe(_ recipe: Recipe) {
        recipe.status = .locked
        mapScene.refreshTileStates()
        updateAccessibleTiles()
    }
}
