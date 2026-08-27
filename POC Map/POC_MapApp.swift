import SwiftUI
import SwiftData

@main
struct POC_MapApp: App {
    //Usar Json para fazer machamada uma unica vez com o @AppStorage
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Recipe.self])
    }
}
