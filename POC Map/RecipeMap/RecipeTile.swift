import SwiftUI
import SpriteKit

final class RecipeTile {
    let recipe: Recipe
    let tile: SKSpriteNode
    
    init(recipe: Recipe, tile: SKSpriteNode) {
        self.recipe = recipe
        self.tile = tile
    }
}
