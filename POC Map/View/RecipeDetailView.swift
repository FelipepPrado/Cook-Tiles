import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    var onStatusChanged: () -> Void
    
    var body: some View {
        VStack {
            Text(recipe.name)
            if recipe.status == .locked {
                Text("\(recipe.reward)")
                Button {
                    recipe.status = .unlocked
                    onStatusChanged()
                } label: {
                    Text("Comprar Receita")
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundStyle(Color.white)
                }

            } else if recipe.status == .unlocked{
                Button {
                    recipe.status = .locked
                    onStatusChanged()
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
