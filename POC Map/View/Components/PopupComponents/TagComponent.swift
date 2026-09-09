//
//  TagComponent.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import SwiftUI

struct TagComponent: View {
    let tag: RecipeTag
    var isHidden: Bool = false
    var body: some View {
        Text(isHidden ? "???" : tag.displayName)
            .foregroundStyle(isHidden ? Color.brown100 : Color.green500)
            .font(.hammersmith(fontStyle: .caption))
            .bold()
            .accessibilityLabel(isHidden ? "Tag bloqueada" : tag.displayName)
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 57)
                    .stroke(isHidden ? Color.brown100 : Color.green500, lineWidth: 2)
            )
    }
}

//#Preview {
//    TagComponent()
//}
