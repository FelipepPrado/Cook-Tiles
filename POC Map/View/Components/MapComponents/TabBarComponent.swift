import SwiftUI

struct TabBarComponent: View {
    @Environment(ViewRouter.self) var viewRouter
    
    var body: some View {
        ZStack{
            HStack(alignment: .top, spacing: -10){
                Button(action:
                        {
                    viewRouter.historyView()
                }, label: {
                    ZStack{
                        Image("tabBarButtonLeft")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 132, height: 73)
                        
                        Text("Histórico")
                            .font(.hammersmith())
                            .padding(.top, 36)
                            .foregroundStyle(Color.cream300)
                    }
                    
                }).buttonStyle(.plain)
                
                Button(action:
                        {
                    viewRouter.newMealView()
                }, label: {
                    ZStack{
                        Image("tabBarButtonCenter")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                    }
                }).buttonStyle(.plain)
                
                Button(action:
                        {
                    viewRouter.recipeListView()
                }, label: {
                    ZStack{
                        Image("tabBarButtonRight")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 132, height: 73)
                        
                        Text("Receitas")
                            .font(.hammersmith())
                            .padding(.top, 36)
                            .foregroundStyle(Color.cream300)
                    }
                }).buttonStyle(.plain)
            }
        }
        
    }
}

#Preview {
    TabBarComponent()
        .environment(ViewRouter())
}
