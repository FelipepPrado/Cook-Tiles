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
                            .font(.hammersmith(fontStyle: .caption))
                        if viewModel.recipe.status == .unlocked {
                            Text("\(viewModel.recipe.time) min")
                                .foregroundStyle(Color.brown700)
                                .bold()
                                .font(.hammersmith())
                        }else if viewModel.recipe.status == .locked {
                            Text("???")
                                .foregroundStyle(Color.brown700)
                                .bold()
                                .font(.hammersmith())
                        }
                        
                    }
                    
                        Spacer()
                    
                    VStack(alignment: .center) {
                        Text("Porções")
                            .bold()
                            .foregroundStyle(Color.brown100)
                            .font(.hammersmith(fontStyle: .caption))
                        
                        if viewModel.recipe.status == .unlocked {
                            Text(viewModel.recipe.portions)
                                .foregroundStyle(Color.brown700)
                                .bold()
                                .font(.hammersmith())
                        }
                        else if viewModel.recipe.status == .locked {
                            Text("???")
                                .foregroundStyle(Color.brown700)
                                .bold()
                                .font(.hammersmith())
                        }
                    }
                    
                }
                .padding(.bottom, 2)
                
                VStack(spacing:3){
                    
                    Text(viewModel.recipe.name)
                        .foregroundStyle(Color.brown700)
                        .font(Font.custom("JainiPurva-Regular", size: 48, relativeTo: .largeTitle))
                        .frame(maxWidth: 290)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    
                    Rectangle()
                        .fill(.brown100)
                        .frame(maxWidth: 280, maxHeight: 2)

                }
                .padding(.bottom, 10)
                

                VStack(alignment: .center, spacing: 10) {
                    ForEach(viewModel.recipe.tags.chunked(into: 3), id: \.self) { rowTags in
                        HStack(spacing: 10) {
                            ForEach(rowTags, id: \.rawValue) { tag in
                                TagComponent(tag: tag)
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
                
                if viewModel.recipe.status == .locked {
                    DescriptionComponent(recipe: viewModel.recipe, currentStatus: .detailViewLocked)
                        .padding(.bottom, 8)
                } else if viewModel.recipe.status == .unlocked{
                    DescriptionComponent(recipe: viewModel.recipe, currentStatus: .detailViewUnlocked)
                        .padding(.bottom, 8)
                }
                
                
                
                if viewModel.recipe.status == .locked {
                    Button {
                        viewModel.buyRecipe()
                    } label: {
                        FillButtonComponent(recipe: viewModel.recipe, currentStatus: .buy)
                    }

                } else if viewModel.recipe.status == .unlocked{

                    Button {
                        viewRouter.recipeView(recipe: viewModel.recipe)
                        viewModel.close()

                    } label: {
                        FillButtonComponent(recipe: viewModel.recipe, currentStatus: .seeMore)
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
            .frame(maxWidth: 290, maxHeight: 500)
        }
        .frame(maxWidth: 310, minHeight: 590)
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
