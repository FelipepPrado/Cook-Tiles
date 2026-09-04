//
//  HistoryRecipeComponent.swift
//  POC Map
//
//  Created by Maria Fernanda Braga Queiroz on 03/09/26.
//

import SwiftUI

struct HistoryRecipeComponent: View {
    let meal: Meal
    
    var body: some View {
        ZStack(){
            HStack(spacing: -30){
                Image("Star Banner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 39)
                    .foregroundColor(.green)
                
                
                Image("Star Banner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 39)
                    .foregroundColor(.green)
                    .scaleEffect(x: -1, y: 1)
            }
            .padding(.top, 161)
            .padding(.bottom, 50)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.cream200)
                .stroke(.cream800, lineWidth: 3)
                .frame(width: 161, height: 251)
            
            VStack(spacing: 16){
                if let uiImage = UIImage(data: meal.image){
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 115, height: 115)
                }
                else{
                    Image("arrozFrito")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 115, height: 115)
                }
                
                StarsRatingComponent(stars: meal.stars)
                    .frame(width: 172, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 57)
        }
    }
}

#Preview {
    HistoryRecipeComponent(
        meal: Meal(
            image: Data(),
            stars: 3,
            recipes: [],
            score: 0,
            comment: ""
        )
    )
}
