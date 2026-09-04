//
//  FillButtonComponent.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import SwiftUI

struct FillButtonComponent: View {
    let recipe: Recipe
    let text: String
    var body: some View {
        if recipe.status == .unlocked {
            Text("Ver Mais")
                .font(Font.callout.bold())
                .padding(10)
                .frame(width: 280, height: 48)
                .background(Color.brown200)
                .cornerRadius(10)
                .foregroundStyle(Color.cream500)
        }else if recipe.status == .locked{
            HStack(spacing: 3) {
                Text("Adquirir \(recipe.price)")
                    .font(Font.callout.bold())
                
                Image("recipeCoin")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(Color.cream500)
                    .frame(width: 20, height: 16)
                
            }
            .padding(10)
            .frame(width: 280, height: 48)
            .background(Color.brown200)
            .cornerRadius(10)
            .foregroundStyle(Color.cream500)
        }
    }
}

//
//#Preview {
//    FillButtonComponent()
//}
