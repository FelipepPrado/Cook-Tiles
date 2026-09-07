//
//  IngredientComponent.swift
//  POC Map
//
//  Created by Ana Soares on 04/09/26.
//

import SwiftUI

struct IngredientComponent: View {
    
    let igredient: Igredient
    let currentStatus: StatusColor
    
    var body: some View {
        switch currentStatus {
            
        case .normal:
            VStack(alignment: .center) {
                Text("\(igredient.quantity) \(igredient.unit)")
                    .font(.callout
                        .bold())
                    .foregroundColor(.brown200)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)

                
                Text(igredient.name)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.brown200)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)

            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(minHeight: 80)
            .background(.cream200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.cream800, lineWidth: 5)
            )
            
        case .green:
            
            VStack(alignment: .center) {
                Text("\(igredient.quantity) \(igredient.unit)")
                    .font(.callout
                        .bold())
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)

                
                Text(igredient.name)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.brown200)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)

                    
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(minHeight: 80)
            .background(.cream200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.green500, lineWidth: 5)
            )
        }

        
//        ZStack {
//            Losango()
//                .fill(Color.cream200)
//                .frame(width: 125, height: 125)
//            
//            ZStack {
//                
//                VStack{
//                    
//
//                        
//                }
//                .frame(width: 90, height: 80)
//            }
//
//            Losango()
//                .stroke(Color.cream800, lineWidth: 4)
//                .frame(width: 125, height: 125)
//        }
    }
}

#Preview {
    IngredientComponent(igredient: Igredient(name: "alho", quantity: "100", unit: "gramas", status: false), currentStatus: .normal)
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

enum StatusColor: CaseIterable {
    case normal, green
}
