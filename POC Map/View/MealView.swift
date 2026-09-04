import SwiftUI

struct MealView: View {
    let meal: Meal
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 30){
                    VStack(spacing: 15){
                        Image(uiImage: UIImage(data: meal.image) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 285, height: 260)
                        
                        StarRatingInputComponent(rating: .constant(meal.stars), isInput: false)
                    }
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text("Receitas do Prato")
                            .font(Font.custom("Hammersmith One", size: 22, relativeTo: .title2))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.brown200)
                        
                        HStack(alignment: .center, spacing: 25){
                            ForEach(meal.recipes){ recipe in
                                VStack(alignment: .center, spacing: 9){
                                    Image("diamondRecipe")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundStyle(Color(recipe.category.rawValue))
                                        .frame(width: 62, height: 62)
                                    Text(recipe.name)
                                        .font(Font.custom("Hammersmith One", size: 12, relativeTo: .caption))
                                        .foregroundStyle(.brown200)
                                        .frame(maxWidth: 100)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 36)
        .padding(.top, 60)
        .background(.cream500)
    }
}

#Preview {
    MealView(meal: Meal(
        image: Data(),
        stars: 5,
        recipes: [],
        score: 100,
        comment: "Muito bom!",
        date: .now
    ))
}
