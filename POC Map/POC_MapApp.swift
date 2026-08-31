import SwiftUI
import SwiftData

@main
struct POC_MapApp: App {
    //Usar Json para fazer machamada uma unica vez com o @AppStorage
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Recipe.self)
        } catch {
            fatalError("Erro no ModelContainer: \(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            MapView()
                .onAppear {
                    let context = container.mainContext
                    DataLoader.loadRecipesIfNeeded(context: context)
                 }
        }
        .modelContainer(for: [Recipe.self])
    }
}
