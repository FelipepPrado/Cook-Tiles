import SwiftUI
import Observation

enum NameViews: Hashable{
    case CameraView(request: CameraRequest)
    case HistoryView
    case MapView
    case NewMealView
    case RecipeListView
    case RecipeView(recipe: Recipe)
    case StepsView(recipe: Recipe)
}

@Observable
class ViewRouter{
    var path = NavigationPath()
    
    func clear(){
        path = .init()
    }
    
    func removeLast(){
        path.removeLast()
    }
    
    func initView(){
        self.clear()
    }
    
    func cameraView(
        onPhoto: @escaping (Data) -> Void
    ) {
        let request = CameraRequest(onPhoto: onPhoto)

        path.append(
            NameViews.CameraView(request: request)
        )
    }
    
    func historyView(){
        path.append(NameViews.HistoryView)
    }
    
    func mapView(){
        path.append(NameViews.MapView)
    }
    
    func newMealView(){
        path.append(NameViews.NewMealView)
    }
    
    func recipeListView(){
        path.append(NameViews.RecipeListView)
    }
    
    func recipeView(recipe: Recipe){
        path.append(NameViews.RecipeView(recipe: recipe))
    }
    
    func stepsView(recipe: Recipe){
        path.append(NameViews.StepsView(recipe: recipe))
    }
}


enum ViewManagar {
    @ViewBuilder
    static func viewForDestination(_ destination: NameViews) -> some View {
        switch destination {
        case .CameraView(let request):
            CameraView(onPhoto: request.onPhoto)
        case .HistoryView:
            HistoryView()
        case .MapView:
            MapView()
        case .NewMealView:
            NewMealView()
        case .RecipeListView:
            RecipeListView()
        case .RecipeView(let recipe):
            RecipeView(viewModel: RecipeViewModel(recipe: recipe))
        case .StepsView(let recipe):
            StepsView(viewModel: StepsViewModel(recipe: recipe))
        }
    }
}
