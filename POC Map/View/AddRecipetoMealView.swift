import SwiftUI

struct AddRecipetoMealView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: AddRecipetoMealViewModel
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(spacing: 15), GridItem(spacing: 15), GridItem()], spacing: 20) {
                ForEach(viewModel.recipes){ recipe in
                    Button(action: {
                        viewModel.addRecipe(recipe)
                        dismiss()
                    }, label: {
                        UnlockedRecipeComponent()
                    })
                }
            }
        }
        .padding(.vertical)
    }
}

//#Preview {
//    AddRecipetoMealView()
//}
