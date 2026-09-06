import SwiftUI
import SwiftData

@main
struct POC_MapApp: App {

    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for:
                    Recipe.self,
                    Player.self,
                    Meal.self
            )

            let context = container.mainContext
 
            DataLoader.loadRecipesIfNeeded(context: context)
            DataLoader.loadPlayerIfNeeded(context: context)

        } catch {
            fatalError("Erro no ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MapView()
        }
        .modelContainer(container)
        .environment(ViewRouter())
    }
}
