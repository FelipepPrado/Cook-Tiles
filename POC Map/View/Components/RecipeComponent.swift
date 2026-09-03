//import SwiftUI
//import SwiftData
//
//struct RecipeComponent: View {
//    
//    let recipe: Recipe
//    
//    var body: some View {
//        ZStack(){
//         RoundedRectangle(cornerRadius: 10)
//               .fill(Color(recipe.status.rawValue+"Background"))
//               .stroke(Color(recipe.status.rawValue+"Border"), lineWidth: 3)
//                .frame(width: 120, height: 145)
//          
//            VStack(spacing: 10){
//             switch recipe.status {
//                case .locked:
//                        Image("padlockSymbol")
//                            .frame(width: 74, height: 74)
//                            .cornerRadius(10)
//                    HStack{
//                        Text("\(recipe.price)")
//                            .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
//                        Image("recipeCoin")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 20, height: 17)
//                    }
//                    .frame(width: 90, height: 30)
//                    .background(.green500)
//                    .cornerRadius(30)
//                    .foregroundStyle(.white)
//                    
//                case .unlocked:
//                    Image("diamondRecipe")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 74, height: 74)
//                        .padding(.bottom, 10)
//                        .foregroundStyle(Color(recipe.category.rawValue))
//                    
//                    Text("Receita")
////                        .foregroundStyle(.letter)
//                        .font(.body)
//                        .foregroundColor(.brown200)
//                case .unavailable:
//                    Image("unavailableSymbol")
//                        .frame(width: 42.5, height: 72.5)
//                }
//            }
//        }
//    }
//}
//
////#Preview("Locked") {
////    RecipeComponent(
////        recipe: Recipe(
////            name: "Receita",
////            status: .locked,
////            reward: 1,
////            time: 1,
////            level: .easy,
////            steps: [],
////            ingredients: [],
////            tags: [],
////            category: .sobremesa,
////            id: 1,
////            price: 10,
////            overlayImage: "nuvem"
////        )
////    )
////}
//
////#Preview("Unlocked") {
////    RecipeComponent(
////        recipe: Recipe(
////            name: "Receita",
////            status: .unlocked,
////            reward: 1,
////            time: 1,
////            level: .easy,
////            steps: [],
////            ingredients: [],
////            tags: [],
////            category: .sobremesa,
////            id: 1,
////            price: 10,
////            overlayImage: "batata"
////        )
////    )
////}
////
////#Preview("Unavailable") {
////    RecipeComponent(
////        recipe: Recipe(
////            name: "Receita",
////            status: .unavailable,
////            reward: 1,
////            time: 1,
////            level: .easy,
////            steps: [],
////            ingredients: [],
////            tags: [],
////            category: .sobremesa,
////            id: 1,
////            price: 10,
////            overlayImage: "nuvem"
////        )
////    )
////}
