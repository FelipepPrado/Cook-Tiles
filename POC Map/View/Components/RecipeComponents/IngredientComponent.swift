//
//  IngredientComponent.swift
//  POC Map
//
//  Created by Ana Soares on 04/09/26.
//

import SwiftUI

struct IngredientComponent: View {
    let igredient: Igredient
    
    var body: some View {
        ZStack {
            Losango()
                .fill(Color.cream200)
                .frame(width: 125, height: 125)
            
            ZStack {
                
                VStack{
                    
                    Text("\(igredient.quantity.formatted(.number.precision(.fractionLength(0)))) \(igredient.unit)")
                        .font(.callout
                            .bold())
                        .foregroundColor(.brown200)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    Text(igredient.name)
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.brown200)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        
                }
                .frame(width: 90, height: 80)
            }

            Losango()
                .stroke(Color.cream800, lineWidth: 4)
                .frame(width: 125, height: 125)
        }
    }
}

#Preview {
    IngredientComponent(igredient: Igredient(name: "alho", quantity: 100, unit: "gramas", status: false))
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
