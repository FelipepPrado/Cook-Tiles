//
//  FillButtonComponent.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import SwiftUI

struct FillButtonComponent: View {
    let text: String
    var body: some View {
        
        Text(text)
            .font(Font.callout.bold())
            .padding(10)
            .frame(width: 280, height: 48)
            .background(Color.brown200)
            .cornerRadius(10)
            .foregroundStyle(Color.cream500)
    }
}

//
//#Preview {
//    FillButtonComponent()
//}
