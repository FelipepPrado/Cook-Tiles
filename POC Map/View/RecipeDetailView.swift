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
                    if viewModel.recipe.status == .unlocked {
                        Text("\(viewModel.recipe.time) min")
                            .foregroundStyle(Color.brown700)
                            .bold()
                            .font(.body)
                    }else if viewModel.recipe.status == .locked {
                        Text("???")
                            .foregroundStyle(Color.brown700)
                            .bold()
                            .font(.body)
                    }
                    
                }
                .padding(.leading, 25)
                
                    Spacer()
                
                VStack(alignment: .center) {
                    Text("Porções")
                        .bold()
                        .foregroundStyle(Color.brown100)
                        .font(.callout)
                    
                    if viewModel.recipe.status == .unlocked {
                        Text(viewModel.recipe.portions)
                            .foregroundStyle(Color.brown700)
                            .bold()
                            .font(.body)
                    }
                    else if viewModel.recipe.status == .locked {
                        Text("???")
                            .foregroundStyle(Color.brown700)
                            .bold()
                            .font(.body)
                    }
                }
                .padding(.trailing, 20)
                
            }
            .padding(.bottom, 15)
            VStack(spacing:3){
                
                Text(viewModel.recipe.name)
                    .foregroundStyle(Color.brown700)
                    .bold()
                    .font(.largeTitle)
                    .frame(maxWidth: 280)
                    .multilineTextAlignment(.center)
                
                Rectangle()
                    .fill(.brown100)
                    .frame(width: 280, height: 2)

            }
            .padding(.bottom, 10)
            
            HStack(spacing: 10) {
                ForEach (viewModel.recipe.tags, id: \.rawValue){ tag in
                    TagComponent(tag: tag)
                }
            }
            .padding(.bottom, 8)
            
            DescriptionComponent(recipe: viewModel.recipe)
                .padding(.bottom, 8)
            
            if viewModel.recipe.status == .locked {
                Button {
                    viewModel.buyRecipe()
                } label: {
                    FillButtonComponent(recipe: viewModel.recipe, text: "Adquirir \(viewModel.recipe.price) P")
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
                    viewRouter.recipeView(recipe: viewModel.recipe)
                    viewModel.close()
//                    print(viewModel.recipe.category.rawValue)
                } label: {
                    FillButtonComponent(recipe: viewModel.recipe, text: "Ver Mais")
                        .padding(.bottom, 8)
                
                }
                Button {
                    viewRouter.stepsView(recipe: viewModel.recipe)
                    viewModel.close()
                } label: {
                    StrokeButtonComponent(text: "Iniciar Receita")
                }

            }
        }
        .frame(width: 350, height: 630)
        .background(Image("popupBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea() )
        
    }
}



//#Preview {
//    RecipeDetailView()
//}
