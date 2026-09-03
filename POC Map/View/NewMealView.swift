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
                VStack{
                    
                }
            }
            .padding()
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
