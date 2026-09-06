//
//  FillButtonComponent.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import SwiftUI

struct FillButtonComponent: View {
    
    let recipe: Recipe
    let currentStatus: FillButton
    
    var body: some View {
        
        switch currentStatus {
            
        case .buy:
            
            HStack(spacing: 3) {
                Text("Adquirir: \(recipe.price)")
                    .font(.hammersmith(fontStyle: .title3))
                
                Image("recipeCoin")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(Color.white)
                    .frame(width: 20, height: 16)
                
            }
            .padding(10)
            .frame(width: 280, height: 48)
            .background(Color.green500)
            .cornerRadius(10)
            .foregroundStyle(Color.white)
            
        case .seeMore:
            Text("Ver Mais")
                .font(.hammersmith())
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

enum FillButton: CaseIterable {
    case buy
    case seeMore
}
