import SwiftUI

struct OnBoardingSheetView: View {
    @Environment(ViewRouter.self) private var viewRouter

    var body: some View {
        @Bindable var router = viewRouter

        NavigationStack(path: $router.sheetPath) {
            InitialSheet()
                .navigationDestination(for: NameSheets.self) { destination in
                    ViewManagar.viewForSheet(destination)
                }
        }
        .tint(.brown700)
    }
}
