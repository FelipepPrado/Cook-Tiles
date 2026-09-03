import Observation

@Observable
final class AddRecipetoMealViewModel {
    let viewModel: NewMealViewModel
    let recipes: [Recipe]
    
    init(viewModel: NewMealViewModel, recipes: [Recipe]) {
        self.viewModel = viewModel
        self.recipes = recipes
    }
    
    func addRecipe(_ recipe: Recipe){
        viewModel.newMeal.recipes.append(recipe)
    }
}
