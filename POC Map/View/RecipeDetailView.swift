import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Text(recipe.name)
        }
    }
}

//#Preview {
//    RecipeDetailView()
//}
