import SwiftUI

struct StarRatingInputComponent: View {
    @Binding var rating: Int
    var maximumRating: Int = 5
    
    var body: some View {
        ZStack{
            HStack{
                Image("Star Banner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 74, height: 64)
                    .foregroundColor(.green)
                
                Spacer()
                
                Image("Star Banner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 74, height: 64)
                    .foregroundColor(.green)
                    .scaleEffect(x: -1, y: 1)
            }
            .padding(.top, 35)
            HStack (alignment: .center, spacing: 15) {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    Button {
                        rating = number
                    } label: {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(number <= rating ? .white : .green700)
                            .animation(.linear, value:  rating)
                    }
                }
            }
            .padding(.top, 14)
            .padding(.bottom, 24)
            .padding(.horizontal, 45)
            .background(.green500)
            .padding(.horizontal, 28)
        }
    }
}

#Preview {
    @Previewable @State var rating: Int = 0
    StarRatingInputComponent(rating: $rating)
}
