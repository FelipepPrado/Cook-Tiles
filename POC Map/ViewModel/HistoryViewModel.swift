import Observation
import SwiftUI

@Observable
final class HistoryViewModel{
    var groupedMeals: [(date: Date, meals: [Meal])] = []
    var selectedMeal: Meal?
    
    init(groupedMeals: [(date: Date, meals: [Meal])] = [], selectedMeal: Meal? = nil) {
        self.groupedMeals = groupedMeals
        self.selectedMeal = selectedMeal
    }
    
    func addGroupedMeal(_ meals: [Meal]) {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: meals) { meal in
            calendar.startOfDay(for: meal.date)
        }
        
        groupedMeals = grouped
        .map { date, meals in
            (
                date: date,
                meals: meals.sorted {
                    $0.date < $1.date
                }
            )
        }
        .sorted {
            $0.date > $1.date
        }
    }
}
