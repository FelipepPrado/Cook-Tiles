import SwiftUI

struct AddRecipetoMealView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: AddRecipetoMealViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading){
                    Text(viewModel.recipes[0].category.displayName)
                        .font(Font.custom("Hammersmith One", size: 24, relativeTo: .title2))
                        .foregroundColor(.brown700)
                    
                    LazyVGrid(columns: [GridItem(spacing: 9), GridItem(spacing: 9), GridItem()], spacing: 20) {
                        ForEach(viewModel.recipes){ recipe in
                            Button(action: {
                                viewModel.addRecipe(recipe)
                                dismiss()
                            }, label: {
                                UnlockedRecipeComponent(recipe: recipe)
                                    .frame(width: 120 ,height: 145)
                            })
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
            }
        }
        .background(.cream500)
    }
}



//#Preview {
//    AddRecipetoMealView()
//}
