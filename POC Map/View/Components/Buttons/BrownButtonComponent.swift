//
//  BrownButtonComponent.swift
//  POC Map
//
//  Created by Maria Fernanda Braga Queiroz on 07/09/26.
//

import SwiftUI

enum BrownButtonStyle: CaseIterable {
    case largeFill, smallStroke, smallFill
    
    var frameSize: CGSize {
        switch self {
        case .smallFill, .smallStroke:
            return CGSize(width: 280, height: 48)
        case .largeFill:
            return CGSize(width: 360, height: 55)
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
    var title: String? = nil
    let recipe: Recipe
    let currentButton: BrownButtonStyle
    var canAfford: Bool = true
    
    var body: some View {
        
        switch currentButton {
            
        case .smallFill:
            
            
            if recipe.status == .unlocked {
                HStack(spacing: 8){
                    Text(title ?? "Ver Mais")
                        .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
                        .foregroundColor(.cream500)
                }
                .frame(width: currentButton.frameSize.width, height: currentButton.frameSize.height)
                .background(
                    HexagonButtonShape()
                        .fill(Color.brown200)
                )
                
            } else if recipe.status == .locked {
                
                HStack(spacing: 8){
                    Text("Adquirir: \(recipe.price)")
                        .font(Font.custom("Hammersmith One", size: 17, relativeTo: .headline))
                        .foregroundColor(.cream500)
                    
                    Image("recipeCoin")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 17)
                        .foregroundStyle(.cream500)
                }
                .frame(width: currentButton.frameSize.width, height: currentButton.frameSize.height)
                .background(
                    HexagonButtonShape()
                        .fill(canAfford ? Color.green500 : Color.brown100)
                )
                
            }
            
            
            
        case .smallStroke:
            
            VStack{
                Text(title ?? "Iniciar Receita")
                    .font(Font.custom("Hammersmith One", size: 17, relativeTo: .headline))
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
            
        case .largeFill:
            
            if recipe.status == .unlocked {
                
                VStack{
                    Text("Iniciar Receita")
                        .font(Font.custom("Hammersmith One", size: 17, relativeTo: .headline))
                        .foregroundColor(.cream300)
                }
                .frame(width: currentButton.frameSize.width, height: currentButton.frameSize.height)
                .glassEffect(
                    .clear
                        .tint(Color.brown700.opacity(0.7))
                        .interactive(),
                    in: HexagonButtonShape()
                )
                
            } else if recipe.status == .locked {
                
                HStack(spacing: 8){
                    Text("Adquirir: \(recipe.price)")
                        .font(Font.custom("Hammersmith One", size: 17, relativeTo: .headline))
                        .foregroundColor(.cream500)
                    
                    Image("recipeCoin")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 17)
                        .foregroundStyle(.cream500)
                }
                .frame(width: currentButton.frameSize.width, height: currentButton.frameSize.height)
                .glassEffect(
                    .identity
                        .tint(
                            (canAfford ? Color.green500 : Color.brown100)
                        )
                        .interactive(),
                    in: HexagonButtonShape()
                )
            }
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
