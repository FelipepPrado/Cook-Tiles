//
//  DescriptionComponent.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import SwiftUI

struct DescriptionComponent: View {
    let recipe: Recipe
    
    var body: some View {
        if recipe.status == .unlocked {
            VStack(alignment: .leading){
                Text(recipe.recipeDescription)
                    .font(Font.callout.bold())
                    .multilineTextAlignment(.leading)
                    .padding(.top, 5)
                    .frame(maxWidth: 260, maxHeight: 260, alignment: .topLeading)
                    .foregroundStyle(Color.brown700)
            }
            .frame(minWidth: 280, maxHeight: 280)
            .background(Color.cream600)
            .cornerRadius(10)
            
            
        }else if recipe.status == .locked {
            VStack(alignment: .center, spacing: 10){
                Image("lockedRecipe")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height:80)
                Text("Adquira essa Receita para \nvisualizar mais informações")
                    .multilineTextAlignment(.center)
                    .font(Font.callout.bold())
                    .foregroundStyle(Color.brown100)
            }
            .frame(minWidth: 280, maxHeight: 280)
            .background(Color.cream600)
        }
    }
}

//#Preview {
//    DescriptionComponent()
//}
