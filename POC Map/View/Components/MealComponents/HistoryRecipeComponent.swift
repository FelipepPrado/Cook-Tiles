
import SwiftUI


struct HistoryRecipeComponent: View {
    let meal: Meal
    
    var body: some View {
        ZStack{
            HStack{
                Image("Star Banner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
                
                Spacer()
                
                Image("Star Banner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
                    .scaleEffect(x: -1, y: 1)
            }
            .frame(width: 200)
            .padding(.top, 165)
            .padding(.bottom, 50)
            .accessibilityHidden(true)
            
            VStack(spacing: 70){
                if let uiImage = UIImage(data: meal.image){
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 115, height: 115)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                else{
                    Image("arrozFrito")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 115, height: 115)
                }
                
                HStack(alignment: .center, spacing: 5){
                    ForEach(meal.recipes){ recipe in
                        Image("diamondRecipe")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 25, maxHeight: 25)
                            .foregroundStyle(Color(recipe.category.rawValue))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 15)
            .frame(maxWidth: 161, maxHeight: 251)
            .background(.cream200)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                .inset(by: 1.5)
                .stroke(.cream800, lineWidth: 3)
            )

            StarsRatingComponent(stars: meal.stars)
                .frame(width: 172, height: 40)
                .padding(.top, 95)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Refeicao com \(meal.recipes.count) receita\(meal.recipes.count > 1 ? "s" : ""), \(meal.stars) de 5 estrelas")
        .accessibilityHint("Toque duas vezes para ver detalhes")

    }
}
#Preview {
    HistoryRecipeComponent(
        meal: Meal(
            image: Data(),
            stars: 3,
            recipes: [],
            score: 0,
            comment: "",
            date: Date.now
        )
    )
}
