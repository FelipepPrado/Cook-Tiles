import SwiftUI
import Observation

enum NameViews: Hashable{
    case CameraView
    case HistoryView
    case MapView
    case NewMealView
    case RecipeListView
    case RecipeView
    case StepsView
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
    
    func cameraView(){
        path.append(NameViews.CameraView)
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
    
    func recipeView(){
        path.append(NameViews.RecipeView)
    }
    
    func stepsView(){
        path.append(NameViews.StepsView)
    }
}


enum ViewManagar {
    @ViewBuilder
    static func viewForDestination(_ destination: NameViews) -> some View {
        switch destination {
        case .CameraView:
            CameraView()
        case .HistoryView:
            HistoryView()
        case .MapView:
            MapView()
        case .NewMealView:
            NewMealView()
        case .RecipeListView:
            RecipeListView()
        case .RecipeView:
            RecipeView()
        case .StepsView:
            StepsView()
        }
    }
}
