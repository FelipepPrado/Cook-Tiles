import SwiftUI

struct RecipeUnlockedComponent: View {
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color("centerComponent"))
                .frame(width: 120, height: 145)
                .cornerRadius(10)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color("edgeComponent"))
                                .stroke(Color("edgeComponent"), lineWidth: 3))
            
            VStack{
                Image("diamondStarter").resizable()
                    .scaledToFill()
                    .frame(width: 74, height: 74)
                    .padding(.bottom, 10)
                Text("Receita")
                    .foregroundStyle(.letter)
                    .font(.body)
            }
        }
    }
}

#Preview {
    RecipeUnlockedComponent()
}
