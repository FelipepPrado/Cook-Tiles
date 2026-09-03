//
//  UnavailableRecipeComponent.swift
//  POC Map
//
//  Created by Maria Fernanda Braga Queiroz on 03/09/26.
//

import SwiftUI

struct UnavailableRecipeComponent: View {
    var body: some View {
        ZStack(){
            RoundedRectangle(cornerRadius: 10)
                .fill(.brown100)
                .stroke(.brown100, lineWidth: 3)
                .frame(width: 120, height: 145)
            
            Image("unavailableSymbol")
                .frame(width: 42.5, height: 72.5)
        }
    }
}

#Preview {
    UnavailableRecipeComponent()
}
