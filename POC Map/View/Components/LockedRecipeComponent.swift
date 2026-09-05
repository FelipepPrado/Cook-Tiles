//
//  LockedRecipeComponent.swift
//  POC Map
//
//  Created by Maria Fernanda Braga Queiroz on 03/09/26.
//

import SwiftUI

struct LockedRecipeComponent: View {
    
    let recipe: Recipe
    
    var body: some View {
        ZStack(){
            RoundedRectangle(cornerRadius: 10)
                .fill(.cream600)
                .stroke(.cream800, lineWidth: 3)
                .frame(width: 120, height: 140)
            VStack(spacing: 10){
                Image("padlockSymbol")
                    .frame(width: 74, height: 74)
                    .cornerRadius(10)
                HStack(spacing: 2){
                    Text("\(recipe.price)")
                        .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
                    Image("recipeCoin")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 17)
                }
                .frame(width: 90, height: 30)
                .background(.green500)
                .cornerRadius(30)
                .foregroundStyle(.white)
            }
        }
    }
}
                                

#Preview {
    LockedRecipeComponent(
        recipe: Recipe(
            name: "Receita",
            status: .locked,
            reward: 1,
            time: 1,
            level: .easy,
            steps: [],
            igredients: [],
            tags: [],
            category: .sobremesa,
            id: 1,
            price: 50,
            overlayImage: "nuvem",
            portions: "duas",
            recipeDescription: ""
            )
        )
}
