import SwiftUI

struct RecipeDetailView: View {
    let viewModel: RecipeDetailViewModel
    @Environment(ViewRouter.self) var viewRouter
    @Environment(\.dismiss) private var dismiss
  
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .center) {
                    Text("Preparo")
                        .bold()
                        .foregroundStyle(Color.brown100)
                        .font(.callout)
                    
                    Text("\(viewModel.recipe.time)")
                        .foregroundStyle(Color.brown700)
                        .bold()
                        .font(.body)
                }
                
                    Spacer()
                
                VStack(alignment: .center) {
                    Text("Porções")
                        .bold()
                        .foregroundStyle(Color.brown100)
                        .font(.callout)
                    
                    Text("\(viewModel.recipe.portions) min")
                        .foregroundStyle(Color.brown700)
                        .bold()
                        .font(.body)
                }
                
            }
            .padding(.bottom, 15)

            Text(viewModel.recipe.name)
                .foregroundStyle(Color.brown700)
                .bold()
                .font(.title)
            
            if viewModel.recipe.status == .locked {
                Text("\(viewModel.recipe.price)")
                Button {
                    viewModel.buyRecipe()
                } label: {
                    Text("Adquirir \(viewModel.recipe.price)p")
                        .padding(10)
                        .background(Color.brown200)
                        .cornerRadius(10)
                        .foregroundStyle(Color.cream500)
                }

            } else if viewModel.recipe.status == .unlocked{
//                Button {
//                    viewModel.lockRecipe()
//                } label: {
//                    Text("Bloquear Receita")
//                        .padding(10)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                        .foregroundStyle(Color.white)
//                }
                Button {
                    viewRouter.recipeView()
                    viewModel.close()
                } label: {
                    Text("Ver Mais")
                        .padding(10)
                        .background(Color.brown200)
                        .cornerRadius(10)
                        .foregroundStyle(Color.cream500)
                       
                
                }
                Button {
                    viewRouter.stepsView()
                    viewModel.close()
                } label: {
                    Text("Iniciar Receita")
                        .padding(10)
                        .background(Color.cream600)
                        .cornerRadius(10)
                        .foregroundStyle(Color.brown200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.brown200, lineWidth: 3)
                        )
                }

            }
        }
        .padding(.bottom, 100)
        .frame(width: 300, height: 600)
        .background(Image("popupBackground") // Replace with your Asset Catalog image name
            .resizable()         // Allows the image to scale down or up
            .scaledToFill()      // Scales the image to completely fill the view
            .ignoresSafeArea() )
        
    }
}



//#Preview {
//    RecipeDetailView()
//}
