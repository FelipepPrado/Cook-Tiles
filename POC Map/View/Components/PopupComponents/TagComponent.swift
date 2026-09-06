//
//  TagComponent.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import SwiftUI

struct TagComponent: View {
    let tag: RecipeTag
    var body: some View {
        Text(tag.displayName)
            .foregroundStyle(.green500)
            .font(.hammersmith(fontStyle: .caption))
            .bold()
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 57)
                    .stroke(Color.green500, lineWidth: 2)
            )
    }
}

//#Preview {
//    TagComponent()
//}
