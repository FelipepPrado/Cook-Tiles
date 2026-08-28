import SwiftUI
import SpriteKit

final class RecipeTile {
    let recipe: Recipe
    let tile: SKSpriteNode
    let row: Int
    let col: Int
    
    init(recipe: Recipe, tile: SKSpriteNode, row: Int, col: Int) {
        self.recipe = recipe
        self.tile = tile
        self.row = row
        self.col = col
    }
}
