import SwiftData
import SwiftUI

@Model
class Meal {
    var image: Data
    var stars: Int
    var recipes: [Recipe]
    var score: Int = 0
    var comment: String
    
    init(image: Data, stars: Int, recipes: [Recipe], score: Int, comment: String) {
        self.image = image
        self.stars = stars
        self.recipes = recipes
        self.score = score
        self.comment = comment
    }
    
    func calculetteScore() -> Int{
        for recipe in recipes{
            score += recipe.reward
        }
        
        return score
    }
}
