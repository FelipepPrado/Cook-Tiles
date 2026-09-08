import SwiftUI

struct StarRatingInputComponent: View {
    @Binding var rating: Int
    var maximumRating: Int = 5
    let isInput: Bool
    
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
            .padding(.top, 25)
            .accessibilityHidden(true)
            
            HStack (alignment: .center, spacing: 15) {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    if isInput{
                        Button {
                            rating = number
                        } label: {
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(number <= rating ? .white : .green700)
                                .animation(.linear, value:  rating)
                        }
                        .accessibilityLabel("\(number) estrela\(number > 1 ? "s" : "")")
                        .accessibilityValue(number <= rating ? "Selecionada" : "Nao selecionada")
                        .accessibilityHint("Toque duas vezes para avaliar com \(number) estrela\(number > 1 ? "s" : "")")

                    }
                    
                    else{
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(number <= rating ? .white : .green700)
                            .animation(.linear, value:  rating)
                            .accessibilityHidden(true)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 24)
            .padding(.horizontal, 45)
            .background(.green500)
            .padding(.horizontal, 28)
            .accessibilityElement(children: isInput ? .contain : .ignore)
            .accessibilityLabel(isInput ? "Avaliacao" : "Avaliacao: \(rating) de \(maximumRating) estrelas")

        }
    }
}

#Preview {
    @Previewable @State var rating: Int = 3
    StarRatingInputComponent(rating: $rating, isInput: false)
}
