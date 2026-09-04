//
//  IngredientComponent.swift
//  POC Map
//
//  Created by Ana Soares on 04/09/26.
//

import SwiftUI

struct IngredientComponent: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    IngredientComponent()
}
struct Losango: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Define os 4 pontos do losango baseados no tamanho do container
        let topo = CGPoint(x: rect.midX, y: rect.minY)
        let direita = CGPoint(x: rect.maxX, y: rect.midY)
        let baixo = CGPoint(x: rect.midX, y: rect.maxY)
        let esquerda = CGPoint(x: rect.minX, y: rect.midY)
        
        // Desenha as linhas conectando os pontos
        path.move(to: topo)
        path.addLine(to: direita)
        path.addLine(to: baixo)
        path.addLine(to: esquerda)
        path.closeSubpath()
        
        return path
    }
}
