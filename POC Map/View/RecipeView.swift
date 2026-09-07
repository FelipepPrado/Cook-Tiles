import SwiftUI

struct RecipeView: View {
    
    var viewModel: RecipeViewModel
    
    @Environment(ViewRouter.self) var viewRouter
    @Environment(MapViewModel.self) private var mapViewModel
    @Environment(Player.self) private var player
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 0) {
                headerSection
                
                if viewModel.recipe.status == .unlocked {
                    Text("Ingredientes")
                        .bold()
                        .foregroundStyle(Color.brown700)
                        .font(.hammersmith(fontStyle: .title2))
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    IngredientFlowLayout(horizontalSpacing: 10, verticalSpacing: 10) {
                        ForEach(viewModel.recipe.igredients, id: \.self) { igredient in
                            if igredient.status == false {
                                Button(action: {
                                    viewModel.toogleStatus(igredient: igredient)
                                }, label: {
                                    IngredientComponent(igredient: igredient, currentStatus: .normal)
                                })
                            } else if igredient.status == true {
                                
                                Button(action: {
                                    viewModel.toogleStatus(igredient: igredient)
                                }, label: {
                                    IngredientComponent(igredient: igredient, currentStatus: .green)
                                })
                            }
                            
                        }
                    }
                    .frame(maxWidth: 360)
                    .padding(.bottom, 20)
                    
                    Text("Preparo")
                        .bold()
                        .foregroundStyle(Color.brown700)
                        .font(.hammersmith(fontStyle: .title2))
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    ForEach(viewModel.recipe.steps, id: \.self) { step in
                        StepsScreenComponent(step: step)
                            .padding(.bottom, 15)
                    }
                    
                    
                }else if viewModel.recipe.status == .locked {
                    DescriptionComponent(recipe: viewModel.recipe, currentStatus: .recipeViewLocked)
                        .padding(.bottom, 10)
                    
                    
                }
                
            }
            .background {
                VStack(spacing: 0) {
                    Color("\(viewModel.recipe.category.rawValue)")
                        .frame(height: 200)
                    Color.cream500
                }
            }
            
        }
        .safeAreaInset(edge: .bottom) {
            
            VStack {
                if viewModel.recipe.status == .unlocked {
                    Button(action: {
                        viewRouter.stepsView(recipe: viewModel.recipe)
                    }, label: {
                        FillButtonComponent(recipe: viewModel.recipe, currentStatus: .seeMore)
                    })
                } else if viewModel.recipe.status == .locked {
                    Button(action: {
                        viewModel.buyRecipe(recipe: viewModel.recipe, mapViewModel: mapViewModel, player: player)
                    }, label: {
                        FillButtonComponent(recipe: viewModel.recipe, currentStatus: .buy)
                    })
                }
            }
            .padding(.bottom, 20)
            .background(Color.clear)
        }
        .background {
            VStack(spacing: 0) {
                Color("\(viewModel.recipe.category.rawValue)")
                Color.cream500
            }
        }
        .ignoresSafeArea(edges: .all)
        .navigationTitle(viewModel.recipe.name)
    }
    
    // MARK: - Sub-views
    
    @ViewBuilder
    private var headerSection: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 200)
            .padding(.bottom, 20)
        
        HStack {
            VStack(alignment: .center) {
                Text("Preparo")
                    .bold()
                    .foregroundStyle(Color.brown100)
                    .font(.hammersmith(fontStyle: .caption))
                Text("\(viewModel.recipe.time) min")
                    .foregroundStyle(Color.brown700)
                    .bold()
                    .font(.hammersmith())
            }
            .padding(.leading, 25)
            
            Spacer()
            
            VStack(alignment: .center) {
                Text("Porções")
                    .bold()
                    .foregroundStyle(Color.brown100)
                    .font(.hammersmith(fontStyle: .caption))
                
                Text(viewModel.recipe.portions)
                    .foregroundStyle(Color.brown700)
                    .bold()
                    .font(.hammersmith())
            }
            .padding(.trailing, 20)
        }
        .padding(.bottom, 15)
        
        VStack(spacing: 0) {
            Text(viewModel.recipe.name)
                .foregroundStyle(Color.brown700)
                .bold()
                .font(Font.custom("JainiPurva-Regular", size: 44, relativeTo: .largeTitle))
                .frame(maxWidth: 360)
                .multilineTextAlignment(.center)
            
            Rectangle()
                .fill(.brown100)
                .frame(width: 360, height: 2)
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
        .frame(maxWidth: 360)
        .padding(.top, 10)
        .padding(.bottom, 15)
        
    }
    
    
}
