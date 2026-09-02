import SwiftUI
internal import SpriteKit

final class RecipeTile {
    let recipe: Recipe
    let tile: SKSpriteNode
    let overlay: SKSpriteNode
    let row: Int
    let col: Int
    
    init(recipe: Recipe, tile: SKSpriteNode, overlay: SKSpriteNode, row: Int, col: Int) {
        self.recipe = recipe
        self.tile = tile
        self.overlay = overlay
        self.row = row
        self.col = col
    }
}
