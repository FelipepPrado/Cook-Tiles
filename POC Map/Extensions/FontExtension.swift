//
//  FontExtension.swift
//  POC Map
//
//  Created by Gabriel Sousa de Queiroz Lima on 06/09/26.
//

import SwiftUI

extension Font{
    static func hammersmith(fontStyle: Font.TextStyle = .body) -> Font{
        Font.custom("HammersmithOne-Regular", size: fontStyle.size, relativeTo: fontStyle)
    }
    
    static func jaini() -> Font{
        Font.custom("JainiPurva-Regular", size: 48, relativeTo: .largeTitle)
    }
}

extension Font.TextStyle {
    var size: CGFloat {
        switch
        self {
        case .largeTitle: return 34
        case .title: return 30
        case .title2: return 22
        case .title3: return 20
        case .headline: return 18
        case .body: return 16
        case .callout: return 15
        case .subheadline: return 14
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 8
        }
    }
    
}
