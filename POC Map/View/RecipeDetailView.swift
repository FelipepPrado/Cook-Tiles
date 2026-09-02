import SwiftUI

struct RecipeDetailView: View {
    let viewModel: RecipeDetailViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.recipe.name)
            if viewModel.recipe.status == .locked {
                Text("\(viewModel.recipe.price)")
                Button {
                    viewModel.buyRecipe()
                } label: {
                    Text("Comprar Receita")
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundStyle(Color.white)
                }

            } else if viewModel.recipe.status == .unlocked{
                Button {
                    viewModel.lockRecipe()
                } label: {
                    Text("Bloquear Receita")
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundStyle(Color.white)
                }

            }
        }
    }
}

//#Preview {
//    RecipeDetailView()
//}
