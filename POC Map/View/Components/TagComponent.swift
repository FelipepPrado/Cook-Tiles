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
            .font(.callout)
            .bold()
            .padding(.top, 5)
            .padding(.bottom, 5)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 57)
                    .stroke(Color.green500, lineWidth: 2)
            )
    }
}

//#Preview {
//    TagComponent()
//}
