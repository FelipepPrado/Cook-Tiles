import SwiftUI

struct RecipeDetailView: View {
    let viewModel: RecipeDetailViewModel
    @Environment(ViewRouter.self) var viewRouter
    @Environment(\.dismiss) private var dismiss
  
    
    var body: some View {
        VStack(alignment: .center) {
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
                .padding(.bottom, 3)
                
                VStack(spacing:3){
                    
                    Text(viewModel.recipe.name)
                        .foregroundStyle(Color.brown700)
                        .font(.largeTitle)
                        .frame(maxWidth: 280)
                        .multilineTextAlignment(.center)
                    
                    Rectangle()
                        .fill(.brown100)
                        .frame(width: 280, height: 2)

                }
                .padding(.bottom, 10)
                

                VStack(alignment: .center, spacing: 10) {
                    ForEach(viewModel.recipe.tags.chunked(into: 2), id: \.self) { rowTags in
                        HStack(spacing: 10) {
                            ForEach(rowTags, id: \.rawValue) { tag in
                                TagComponent(tag: tag)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                
                DescriptionComponent(recipe: viewModel.recipe)
                    .padding(.bottom, 8)
                
                if viewModel.recipe.status == .locked {
                    Button {
                        viewModel.buyRecipe()
                    } label: {
                        FillButtonComponent(recipe: viewModel.recipe, text: "Adquirir \(viewModel.recipe.price) P")
                    }

                } else if viewModel.recipe.status == .unlocked{

                    Button {
                        viewRouter.recipeView(recipe: viewModel.recipe)
                        viewModel.close()

                    } label: {
                        FillButtonComponent(recipe: viewModel.recipe, text: "Ver Mais")
                            .padding(.bottom, 5)
                    
                    }
                    Button {
                        viewRouter.stepsView(recipe: viewModel.recipe)
                        viewModel.close()
                    } label: {
                        StrokeButtonComponent(text: "Iniciar Receita")
                    }

                }
            }
            .frame(maxWidth: 340, maxHeight: 560)
        }
        .frame(maxWidth: 350, minHeight: 650)
        .background(Image("popupBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea() )
        
    }
    

}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

//#Preview {
//    RecipeDetailView()
//}
