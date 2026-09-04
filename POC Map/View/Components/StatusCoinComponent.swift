//
//  StatusCoinComponent.swift
//  POC Map
//
//  Created by Maria Fernanda Braga Queiroz on 04/09/26.
//

import SwiftUI

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let corte = rect.height * 0.4
        
        path.move(to: CGPoint(x: corte, y: 0))
        path.addLine(to: CGPoint(x: rect.width - corte, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width - corte, y: rect.height))
        path.addLine(to: CGPoint(x: corte, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        path.closeSubpath()
        return path
    }
}

struct ResourceBadge: View {
    let coin: Int
    var body: some View {
        HStack(spacing: 12) {
            Text("\(coin)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.cream300)
            
            Image("statusCoin")

        }
        .padding(.horizontal, 24)
        .padding(.top, 11)
        .padding(.bottom, 10)
        .background(
            HexagonShape()
                .fill(.brown900)
        )
    }
}

#Preview {
    ResourceBadge(coin: 100)
}
