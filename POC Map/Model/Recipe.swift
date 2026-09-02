import Foundation
import SwiftUI
import SwiftData

@Model
final class Recipe{
    var name: String
    var status: RecipeStatus
    var reward: Int
    var time: Int
    var level: RecipeLevel
    var steps: [RecipeStep]
    var ingredients: [Igredient]
    var tags: [RecipeTag]
    var category: RecipeCategory
    var id: Int
    var price: Int
    var overlayImage: String
    var portions: String

    init(
        name: String,
        status: RecipeStatus,
        reward: Int,
        time: Int,
        level: RecipeLevel,
        steps: [RecipeStep],
        ingredients: [Igredient],
        tags: [RecipeTag],
        category: RecipeCategory,
        id: Int,
        price: Int,
        overlayImage: String,
        portions: String
    ) {
        self.name = name
        self.status = status
        self.reward = reward
        self.time = time
        self.level = level
        self.steps = steps
        self.ingredients = ingredients
        self.tags = tags
        self.category = category
        self.id = id
        self.price = price
        self.overlayImage = overlayImage
        self.portions = portions
    }
    
}

enum RecipeStatus: String, Codable{
    case locked
    case unlocked
    case unavailable
    
    var displayName: String {
        switch self{
        case .locked:
            "Fechado"
        case .unlocked:
            "Aberto"
        case .unavailable:
            "Indisponível"
        }
    }
}

struct RecipeStep: Codable{
    let order: Int
    let instruction: String
    let process: String
}

enum RecipeLevel: String, Codable {
    case easy
    case medium
    case hard
    
    var displayName: String {
        switch self{
        case .easy:
            "Fácil"
        case .medium:
            "Médio"
        case .hard:
            "Difícil"
        }
    }
}

enum RecipeTag: String, Codable {
    case vegetarian
    case vegan
    case healthy
    case spicy
}

enum RecipeCategory: String, Codable {
    case sobremesa 
    case pratoPrincipal
    case entrada
    case guarnicao
    
    var displayName: String{
        switch self{
            case .entrada:
            "Entrada"
            case .guarnicao:
            "Guarnição"
        case .pratoPrincipal:
            "Prato Principal"
        case .sobremesa:
            "Sobremesa"
        }
    }
}

