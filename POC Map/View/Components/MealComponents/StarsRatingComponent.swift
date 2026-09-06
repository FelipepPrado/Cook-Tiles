import SwiftUI

struct StarsRatingComponent: View {
    
    let stars: Int
    
    var body: some View {
        
        HStack{
            HStack(spacing: 8){
                ForEach(1...stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: 172, maxHeight: 40)
        .padding(.horizontal, 18.4)
        .padding(.top, 8.6)
        .padding(.bottom, 14.6)
        .background(.green500)
    }
}

#Preview {
    StarsRatingComponent(stars: 5)
}
