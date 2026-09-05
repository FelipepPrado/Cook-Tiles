import SwiftUI

struct RecipeView: View {
    var viewModel: RecipeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                
                Text("Ingredientes")
                    .bold()
                    .foregroundStyle(Color.brown700)
                    .font(.title2)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                ingredientsGrid
            }
        }
        .background {
            VStack(spacing: 0) {
                Color("\(viewModel.recipe.category.rawValue)")
                    .frame(height: 200)
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
                    .font(.callout)
                Text("\(viewModel.recipe.time) min")
                    .foregroundStyle(Color.brown700)
                    .bold()
                    .font(.body)
            }
            .padding(.leading, 25)
            
            Spacer()
            
            VStack(alignment: .center) {
                Text("Porções")
                    .bold()
                    .foregroundStyle(Color.brown100)
                    .font(.callout)
                
                Text(viewModel.recipe.portions)
                    .foregroundStyle(Color.brown700)
                    .bold()
                    .font(.body)
            }
            .padding(.trailing, 20)
        }
        .padding(.bottom, 15)
        
        VStack(spacing: 3) {
            Text(viewModel.recipe.name)
                .foregroundStyle(Color.brown700)
                .bold()
                .font(.largeTitle)
                .frame(maxWidth: 360)
                .multilineTextAlignment(.center)
            
            Rectangle()
                .fill(.brown100)
                .frame(width: 360, height: 2)
        }
        .padding(.bottom, 10)
        
        HStack(spacing: 10) {
            ForEach(viewModel.recipe.tags, id: \.rawValue) { tag in
                TagComponent(tag: tag)
            }
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private var ingredientsGrid: some View {
        VStack(spacing: -60) {
            let linhas = viewModel.organizarEmLinhas(ingredientes: viewModel.recipe.igredients)
            
            ForEach(0..<linhas.count, id: \.self) { indexDaLinha in
                HStack(spacing: 0) {
                    ForEach(0..<linhas[indexDaLinha].count, id: \.self) { indexDoIngrediente in
                        
                        if let igredient = linhas[indexDaLinha][indexDoIngrediente] {

                            IngredientComponent(igredient: igredient)
                                .padding(2)
                        } else {
 
                            Color.clear
                                .frame(width: 125, height: 125)
                                .padding(2)
                        }
                    }
                }
                .zIndex(Double(linhas.count - indexDaLinha))
            }
        }
        .padding(.top, 10)
    }

}
