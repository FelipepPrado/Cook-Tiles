import SwiftData
import SwiftUI

@Model
class Meal {
    var image: Data
    var stars: Int
    var recipes: [Recipe]
    var score: Int
    var comment: String
    var date: Date
    
    init(image: Data, stars: Int, recipes: [Recipe], score: Int, comment: String, date: Date) {
        self.image = image
        self.stars = stars
        self.recipes = recipes
        self.score = score
        self.comment = comment
        self.date = date
    }
    
    func calculetteScore() -> Int{
        for recipe in recipes{
            score += recipe.reward
        }
        
        return score
    }
}
