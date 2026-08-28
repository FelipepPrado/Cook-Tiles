import SwiftData
import SwiftUI
//import SwiftUI

@Model
class Meal {
    var image: Data
    var stars: Int
    var recipes: [Recipe]
    var score: Int = 0
    
    init(image: Data, stars: Int, recipes: [Recipe]) {
        self.image = image
        self.stars = stars
        self.recipes = recipes
    }
    
    func calculetteScore() -> Int{
        for recipe in recipes{
            score += recipe.reward
        }
        
        return score
    }
}
