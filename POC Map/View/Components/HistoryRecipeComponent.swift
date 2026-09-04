
import SwiftUI

//struct HistoryRecipeComponent: View {
//    let meal: Meal
//    
//    var body: some View {
//        ZStack(){
//            HStack(spacing: -30){
//                Image("Star Banner")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40, height: 40)
//                    .foregroundColor(.green)
//                
//                Spacer()
//                Image("Star Banner")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40, height: 40)
//                    .foregroundColor(.green)
//                    .scaleEffect(x: -1, y: 1)
//            }
//            .frame(maxWidth: 200)
//            .padding(.top, 165)
//            .padding(.bottom, 50)
//            
//            RoundedRectangle(cornerRadius: 10)
//                .fill(.cream200)
//                .stroke(.cream800, lineWidth: 3)
//                .frame(width: 161, height: 251)
//            
//            VStack(spacing: 16){
//                if let uiImage = UIImage(data: meal.image){
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 115, height: 115)
//                }
//                else{
//                    Image("arrozFrito")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 115, height: 115)
//                }
//                
//                StarsRatingComponent(stars: meal.stars)
//                    .frame(width: 172, height: 40)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 20)
//            .padding(.bottom, 57)
//
//        }
//        .border(.black, width: 5)
//    }
//}


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
            
            VStack(spacing: 70){
                if let uiImage = UIImage(data: meal.image){
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 115, height: 115)
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
