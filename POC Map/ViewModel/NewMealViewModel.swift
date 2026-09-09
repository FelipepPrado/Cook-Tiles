import Observation
import AVFoundation
import SwiftData
import PhotosUI
import SwiftUI

@Observable
final class NewMealViewModel{
    var newMeal: Meal
    var pickerItem: PhotosPickerItem? {
        didSet {
            guard let pickerItem else {return}
            Task {
                imageData = try await
                pickerItem.loadTransferable(type: Data.self)
                newMeal.image = imageData ?? Data() //image é do tipo Data e imageData é do tipo Data?
            }
        }
    }
    var imageData: Data?
    var recipeCategory: RecipeCategory?
    var recipesDic: [RecipeCategory: Recipe] = [:]
    var actualScore: Int {
        var actualScore = 0
        for recipe in recipesDic.values{
            actualScore += recipe.reward
        }
        
        return actualScore
    }
    
    init(newMeal: Meal = Meal(image: Data(), stars: 3, recipes: [], score: 0, comment: "", date: Date.now)) {
        self.newMeal = newMeal
    }
    
    func addMeal(context: ModelContext, _ player: Player){
        do{
            for recipe in recipesDic.values{
                newMeal.recipes.append(recipe)
            }
            newMeal.score = actualScore
            player.coin += actualScore
            newMeal.date = Date.now
            context.insert(newMeal)
            print(player.coin)
            try context.save()
        } catch{
            print(error)
        }
    }
}
