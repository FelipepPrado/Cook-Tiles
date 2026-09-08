import SwiftUI
internal import SpriteKit

final class RecipeTile {
    let recipe: Recipe
    let tile: SKSpriteNode
    let overlay: SKSpriteNode
    let priceTag: SKNode
    let row: Int
    let col: Int
    
    init(recipe: Recipe, tile: SKSpriteNode, overlay: SKSpriteNode, priceTag: SKNode, row: Int, col: Int) {
        self.recipe = recipe
        self.tile = tile
        self.overlay = overlay
        self.priceTag = priceTag
        self.row = row
        self.col = col
    }
    
    var accessibilityLabelText: String {
        "Receita \(recipe.name), categoria \(recipe.category.displayName)"
    }

    var accessibilityValueText: String {
        switch recipe.status {
        case .unlocked:
            "Desbloqueada, nível \(recipe.level.displayName), \(recipe.time) minutos"
        case .locked:
            "Bloqueada, custa \(recipe.price) moedas"
        case .unavailable:
            "Indisponível"
        }
    }

    var accessibilityHintText: String {
        switch recipe.status {
        case .unlocked:
            "Toque duas vezes para ver os detalhes da receita"
        case .locked:
            "Toque duas vezes para tentar desbloquear esta receita"
        case .unavailable:
            "Receita indisponível, desbloqueie receitas vizinhas primeiro"
        }
    }
}
