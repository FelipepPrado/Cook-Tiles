//
//  StrokeButtonComponent.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import SwiftUI

struct StrokeButtonComponent: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding(10)
            .font(.hammersmith())
            .frame(width: 280, height: 48)
            .background(Color.cream500)
            .cornerRadius(10)
            .foregroundStyle(Color.brown200)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.brown200, lineWidth: 3)
            )
    }
}

#Preview {
    @Previewable @State var text: String = "Hello, World!"
    StrokeButtonComponent(text: text)
}
