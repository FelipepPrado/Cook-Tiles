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
    
    init(newMeal: Meal = Meal(image: Data(), stars: 3, recipes: [], score: 0, comment: "")) {
        self.newMeal = newMeal
    }
    
    func addMeal(context: ModelContext){
        do{
            context.insert(newMeal)
            try context.save()
        } catch{
            print(error)
        }
    }
}
