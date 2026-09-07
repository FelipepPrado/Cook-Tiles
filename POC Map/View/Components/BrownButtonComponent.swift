//
//  BrownButtonComponent.swift
//  POC Map
//
//  Created by Maria Fernanda Braga Queiroz on 07/09/26.
//

import SwiftUI

enum BrownButtonStyle: CaseIterable {
    case largefill, smallstroke, smallfill
    
    var frameSize: CGSize {
            switch self {
            case .smallfill, .smallstroke:
                return CGSize(width: 289, height: 48)
            case .largefill:
                return CGSize(width: 391, height: 55)
            }
        }
}

struct HexagonButtonShape: Shape {
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        let offset = rect.height * 0.4
        
        path.move(to: CGPoint(x: offset, y: 0))
        path.addLine(to: CGPoint(x: rect.width - offset, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width - offset, y: rect.height))
        path.addLine(to: CGPoint(x: offset, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        path.closeSubpath()
        
        return path
    }
}

struct BrownButtonComponent: View{
    
    let recipe: Recipe
    let currentButton: BrownButtonStyle
    
    var body: some View {
        
        switch currentButton {
            
        case .smallfill:
            HStack(spacing: 8) {
                if recipe.status == .unlocked {
                    Text("Ver Mais")
                        .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
                        .foregroundColor(.cream500)
                } else {
                    Text("Adquirir: \(recipe.price)")
                        .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
                        .foregroundColor(.cream500)
                    
                    Image("recipeCoin")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 17)
                        .foregroundStyle(.cream500)
                }
            }
            .frame(width: currentButton.frameSize.width, height: currentButton.frameSize.height)
            .background(
                HexagonButtonShape()
                    .fill(.brown200)
            )
            
        case .smallstroke:
            VStack{
                Text("Iniciar Receita")
                    .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
                    .foregroundColor(.brown200)
            }
            .frame(width: currentButton.frameSize.width, height: currentButton.frameSize.height)
            .background(
                HexagonButtonShape()
                    .fill(Color.clear)
                    .overlay(
                        HexagonButtonShape()
                            .stroke(.brown200, lineWidth: 3)
                    )
            )
            
        case .largefill:
            VStack{
                Text("Botão")
                    .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
                    .foregroundColor(.cream300)
            }
            .frame(width: currentButton.frameSize.width, height: currentButton.frameSize.height)
            .background(
                HexagonButtonShape()
                    .fill(.brown700.opacity(0.7))
            )
        }
    }
}

//#Preview {
//    VStack(spacing: 20) {
//        BrownButtonComponent(recipe: Recipe(
//            name: "Teste",
//            status: .unlocked,
//            reward: 10,
//            time: 15,
//            level: .easy,
//            steps: [],
//            igredients: [],
//            tags: [],
//            category: .sobremesa,
//            id: 1,
//            price: 10,
//            overlayImage: [],
//            portions: [],
//            recipeDescription: []), currentButton: .smallfill)
//    }
//}
