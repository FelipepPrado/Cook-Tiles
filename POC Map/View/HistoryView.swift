import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @Query(sort: \Meal.date, order: .reverse)
    private var meals: [Meal]
    
    @State private var viewModel = HistoryViewModel()
    
    var body: some View {
        ZStack{
            Color.cream500
                .ignoresSafeArea()
            if viewModel.groupedMeals.isEmpty{
                VStack(spacing: 25){
                    Spacer()
                    Image("NoRecipe")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 173, height: 150)
                    Text("Você ainda não cadastrou nenhuma Refeição!")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.brown100)
                    Spacer()
                }
                .frame(maxWidth: 288)
                .frame(maxHeight: .infinity, alignment: .center)
            }
            else{
                ScrollView(.vertical) {
                    VStack{
                        ForEach(viewModel.groupedMeals, id: \.date) { group in
                            VStack(
                                alignment: .leading,
                                spacing: 20
                            ) {
                                Text(formattedDate(group.date))
                                    .font(Font.custom("Hammersmith One", size: 16, relativeTo: .callout))
                                    .bold()
                                    .foregroundStyle(.brown200)
                                
                                ScrollView(
                                    .horizontal,
                                    showsIndicators: false
                                ) {
                                    LazyHStack(spacing: 20) {
                                        ForEach(group.meals) { meal in
                                            Button(action: {
                                                viewModel.selectedMeal = meal
                                            }, label:{
                                                HistoryRecipeComponent(meal: meal)
                                            })
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.leading, 20)
                    }
                }
            }
            
        }
        .onAppear{
            viewModel.addGroupedMeal(meals)
        }
        .sheet(item: $viewModel.selectedMeal){ selectedMeal in
            MealView(meal: selectedMeal)
        }
        .navigationTitle("Histórico de Refeições")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formattedDate(_ date: Date) -> String {
        date.formatted(
            .dateTime
                .weekday(.abbreviated)
                .day(.twoDigits)
                .month(.twoDigits)
                .year()
                .locale(Locale(identifier: "pt_BR"))
        )
    }
}

#Preview {
    let configuration = ModelConfiguration(
        isStoredInMemoryOnly: true
    )
    
    let container = try! ModelContainer(
        for: Meal.self,
        Recipe.self,
        configurations: configuration
    )
    
    let calendar = Calendar.current
    
    container.mainContext.insert(
        Meal(
            image: Data(),
            stars: 5,
            recipes: [],
            score: 100,
            comment: "Muito bom!",
            date: .now
        )
    )
    
    container.mainContext.insert(
        Meal(
            image: Data(),
            stars: 4,
            recipes: [],
            score: 80,
            comment: "Gostei bastante.",
            date: calendar.date(
                byAdding: .hour,
                value: -2,
                to: .now
            )!
        )
    )
    
    container.mainContext.insert(
        Meal(
            image: Data(),
            stars: 3,
            recipes: [],
            score: 60,
            comment: "Ficou razoável.",
            date: calendar.date(
                byAdding: .day,
                value: -1,
                to: .now
            )!
        )
    )
    
    return HistoryView()
        .modelContainer(container)
}
