import SwiftUI
import PhotosUI
import SwiftData

struct NewMealView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ViewRouter.self) var viewRouter
    
    @Query(sort: \Recipe.id, order: .forward) private var recipeModel: [Recipe]
    @Query private var players: [Player]
    
    
    var player: Player {
        players.first ?? Player(coin: 100, banner: "Phoenix")
    }
    
    @State private var viewModel = NewMealViewModel()
    
    var body: some View {
        ZStack{
            Color(.cream500).ignoresSafeArea()
            ScrollView{
                VStack(spacing: 30){
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
                                    .padding(90)
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
                    
                    VStack(spacing: 20){
                        Text("Receitas do Prato")
                            .font(Font.custom("Hammersmith One", size: 24, relativeTo: .title2))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.brown200)
                        
                        //Trocar essa lógica talvez
                        VStack(alignment: .center, spacing: 20){
                            HStack(spacing: 20){
                                ForEach(RecipeCategory.allCases) { category in
                                    if category != .sobremesa{
                                        Button(action: {
                                            viewModel.recipeCategory = category
                                        }, label:{
                                            if viewModel.recipesDic[category] == nil{
                                                VStack(alignment: .center, spacing: 9){
                                                    Image("diamondInput")
                                                        .resizable()
                                                        .scaledToFill()
                                                    
                                                    Text(category.displayName)
                                                        .font(Font.custom("Hammersmith One", size: 12, relativeTo: .caption))
                                                        .foregroundStyle(.brown200)
                                                }
                                                //
                                            }
                                            else{
                                                VStack(alignment: .center){
                                                    Image("diamondRecipe")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .foregroundStyle(Color(category.rawValue))
                                                    Spacer()
                                                    Text(viewModel.recipesDic[category]?.name ?? "Sem nome")
                                                        .font(Font.custom("Hammersmith One", size: 12, relativeTo: .caption))
                                                        .foregroundStyle(.brown200)
                                                        .frame(maxWidth: 100)
                                                }
                                            }
                                        })
                                        .frame(maxWidth: 88, maxHeight: 112)
                                    }
                                }
                            }
                            
                            Button(action: {
                                viewModel.recipeCategory = .sobremesa
                            }, label:{
                                if viewModel.recipesDic[.sobremesa] == nil{
                                    VStack(alignment: .center, spacing: 9){
                                        Image("diamondInput")
                                            .resizable()
                                            .scaledToFill()
                                        
                                        Text(RecipeCategory.sobremesa.displayName)
                                            .font(Font.custom("Hammersmith One", size: 12, relativeTo: .caption))
                                            .foregroundStyle(.brown200)
                                    }
                                }
                                else{
                                    VStack(alignment: .center, spacing: 9){
                                        Image("diamondRecipe")
                                            .resizable()
                                            .scaledToFill()
                                            .foregroundStyle(.sobremesa)
                                        
                                        Text(viewModel.recipesDic[.sobremesa]?.name ?? "Sem nome")
                                            .font(Font.custom("Hammersmith One", size: 12, relativeTo: .caption))
                                            .foregroundStyle(.brown200)
                                            .frame(minHeight: 20)
                                    }
                                }
                            })
                            .frame(maxWidth: 88, maxHeight: 112)
                        }
                    }
                }
                
                //Fazer a lógica de comentário depois
            }
            .padding(.horizontal, 32)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(role: .confirm){
                        viewModel.addMeal(context: modelContext, player)
                        viewRouter.removeLast()
                    }
                    .tint(.green500)
                    .disabled(viewModel.newMeal.image == Data() || viewModel.recipesDic.isEmpty)
                }
            }
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
