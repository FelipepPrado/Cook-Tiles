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
