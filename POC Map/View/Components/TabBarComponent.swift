import SwiftUI

struct TabBarComponent: View {
    @Environment(ViewRouter.self) var viewRouter
    
    var body: some View {
        HStack(spacing: -10){
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
                        .font(Font.custom("Hammersmith One", size: 16, relativeTo: .callout))
                        .offset(x: 0, y: 13)
                        .foregroundStyle(Color.white)
                }
                .padding(.bottom, 26)
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
                        .frame(width: 132, height: 81)
                    
                    Text("Receitas")
                        .font(Font.custom("Hammersmith One", size: 16, relativeTo: .callout))
                        .offset(x: 3, y: 18)
                        .foregroundStyle(Color.white)
                }
                .padding(.bottom, 33)
            }).buttonStyle(.plain)
        }
    }
}

#Preview {
    TabBarComponent()
}
