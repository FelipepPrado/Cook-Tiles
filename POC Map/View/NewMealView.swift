import SwiftUI
import PhotosUI
import SwiftData

struct NewMealView: View {
    @Query(sort: \Recipe.id, order: .forward) private var recipeModel: [Recipe]
    @Environment(\.modelContext) private var modelContext
    @Environment(ViewRouter.self) var viewRouter
    
    @State private var viewModel = NewMealViewModel()
    
    var body: some View {
        ZStack{
            Color(.cream500).ignoresSafeArea()
            ScrollView{
                VStack{
                    PhotosPicker(selection: $viewModel.pickerItem, matching: .images, photoLibrary: .shared()) {
                        if viewModel.imageData != nil{
                            Image(uiImage: UIImage(data: viewModel.newMeal.image) ?? UIImage())
                                .resizable()
                                .frame(width: 285, height: 260)
                                .scaledToFill()
                                .tint(.cream800)
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                        }
                        
                        else{
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 60))
                                .padding(100)
                                .tint(.cream800)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 35)
                                        .stroke(
                                            .cream800,
                                            style: StrokeStyle(lineWidth: 5, dash: [31, 31])
                                        )
                                )
                        }
                    }
                    
                    StarRatingInputComponent(rating: $viewModel.newMeal.stars)
                }
                .padding(.top, 16)
                VStack(alignment: .leading, spacing: 20){
                    Text("Receitas do Prato")
                        .font(Font.custom("Hammersmith One", size: 16, relativeTo: .callout))
                        .padding(.top, 26)
                        .border(Color.gray, width: 1)
                    
                    ForEach(RecipeCategory.allCases) { category in
                        if !viewModel.newMeal.recipes.contains(where: { $0.category == category }){
                            Button("Add Receita" ,systemImage: "plus") {
                                viewModel.recipeCategory = category
                            }
                        }
                        else{
                            Text(category.displayName)
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(item: $viewModel.recipeCategory) { category in
            AddRecipetoMealView(
                viewModel: AddRecipetoMealViewModel(
                    viewModel: viewModel,
                    recipes: recipeModel.filter { recipe in
                        recipe.category == category && recipe.status == .unlocked
                    }
                )
            )
        }
        
        .navigationTitle("Cadastrar Refeição")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NewMealView()
        .environment(ViewRouter())
        .modelContainer(
            for: Recipe.self,
            inMemory: true
        )
}
