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
            Text(recipe.name)
                .font(Font.callout.bold())
                .multilineTextAlignment(.leading)
                .frame(width: 280, height: 258)
                .background(Color.cream600)
                .foregroundStyle(Color.brown700)
            
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
            .frame(width: 280, height: 280)
            .background(Color.cream600)
        }
    }
}

//#Preview {
//    DescriptionComponent()
//}
