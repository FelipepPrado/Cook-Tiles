import SwiftUI

struct RecipeDetailView: View {
    let viewModel: RecipeDetailViewModel
    @Environment(ViewRouter.self) var viewRouter
    @Environment(\.dismiss) private var dismiss
  
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center) {
                
                HStack {
                    VStack(alignment: .center) {
                        Text("Preparo")
                            .bold()
                            .foregroundStyle(Color.brown100)
                            .font(.hammersmith(fontStyle: .caption))
                        if viewModel.recipe.status == .unlocked {
                            Text("\(viewModel.recipe.time) min")
                                .foregroundStyle(Color.brown700)
                                .bold()
                                .font(.hammersmith())
                        }else if viewModel.recipe.status == .locked {
                            Text("???")
                                .foregroundStyle(Color.brown700)
                                .bold()
                                .font(.hammersmith())
                        }
                        
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(viewModel.recipe.status == .unlocked
                        ? "Tempo de preparo: \(viewModel.recipe.time) minutos"
                        : "Tempo de preparo: informacao bloqueada")

                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("Porções")
                            .bold()
                            .foregroundStyle(Color.brown100)
                            .font(.hammersmith(fontStyle: .caption))
                        
                        if viewModel.recipe.status == .unlocked {
                            Text(viewModel.recipe.portions)
                                .foregroundStyle(Color.brown700)
                                .bold()
                                .font(.hammersmith())
                        }
                        else if viewModel.recipe.status == .locked {
                            Text("???")
                                .foregroundStyle(Color.brown700)
                                .bold()
                                .font(.hammersmith())
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(viewModel.recipe.status == .unlocked
                        ? "Porcoes: \(viewModel.recipe.portions)"
                        : "Porcoes: informacao bloqueada")

                }
                .padding(.bottom, 2)
                
                VStack(spacing:-3){
                    
                    Text(viewModel.recipe.name)
                        .foregroundStyle(Color.brown700)
                        .font(Font.custom("JainiPurva-Regular", size: 48, relativeTo: .largeTitle))
                        .frame(maxWidth: 290)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .modifier(LockedRecipeTitleModifier(isLocked: viewModel.recipe.status != .unlocked))

                    Rectangle()
                            .fill(Color.brown100)
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                            .accessibilityHidden(true)

                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                

                VStack(alignment: .center, spacing: 10) {
                    ForEach(Array(viewModel.recipe.tags.indices).chunked(into: 3), id: \.self) { rowTags in
                        HStack(spacing: 10) {
                            ForEach(rowTags, id: \.self) { index in
                                TagComponent(tag: viewModel.recipe.tags[index], isHidden: viewModel.recipe.status != .unlocked && index >= 2)
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
                
                if viewModel.recipe.status == .locked {
                    DescriptionComponent(recipe: viewModel.recipe, currentStatus: .detailViewLocked)
                        .padding(.bottom, 8)
                } else if viewModel.recipe.status == .unlocked{
                    DescriptionComponent(recipe: viewModel.recipe, currentStatus: .detailViewUnlocked)
                        .padding(.bottom, 8)
                }
                
                
                
                if viewModel.recipe.status == .locked {
                    Button {
                        viewModel.buyRecipe()
                    } label: {
                        BrownButtonComponent(recipe: viewModel.recipe, currentButton: .smallFill, canAfford: viewModel.player.coin >= viewModel.recipe.price)
                    }
                    .accessibilityLabel("Adquirir receita por \(viewModel.recipe.price) moedas")

                } else if viewModel.recipe.status == .unlocked{

                    Button {
                        viewRouter.recipeView(recipe: viewModel.recipe)
                        viewModel.close()

                    } label: {
                        BrownButtonComponent(recipe: viewModel.recipe, currentButton: .smallFill, canAfford: viewModel.player.coin >= viewModel.recipe.price)
                            .padding(.bottom, 5)
                    
                    }
                    .accessibilityLabel("Ver mais sobre \(viewModel.recipe.name)")
                    
                    Button {
                        viewRouter.stepsView(recipe: viewModel.recipe)
                        viewModel.close()
                    } label: {
                        BrownButtonComponent(recipe: viewModel.recipe, currentButton: .smallStroke, canAfford: viewModel.player.coin >= viewModel.recipe.price)
                    }
                    .accessibilityLabel("Iniciar receita \(viewModel.recipe.name)")

                }
            }
            .frame(maxWidth: 290, maxHeight: 520)
        }
        .frame(maxWidth: 310, minHeight: 590)
        .background {
            Image("popupBackground")
                .resizable()
                .scaledToFill()
                .accessibilityHidden(true)
        }

        .overlay(alignment: .top) {
            DiamondComponent(recipe: viewModel.recipe, hasStroke: true, strokeWidth: 10)
                .frame(width: 120, height: 120)
                .offset(y: -40)
        }
        
    }
    

}

/// Recreates fragmented lettering without requiring a separate Metal shader file.
struct LockedRecipeTitleModifier: ViewModifier {
    let isLocked: Bool

    func body(content: Content) -> some View {
        if isLocked {
            content
                .mask {
                    Canvas { context, size in
                        context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.white))

                        // Stable randomness prevents the cutouts from jumping on redraw.
                        var seed: UInt64 = 7391
                        func nextRandom() -> CGFloat {
                            seed = seed &* 6364136223846793005 &+ 1442695040888963407
                            return CGFloat(seed >> 32) / CGFloat(UInt32.max)
                        }
                        var cutouts: Path = Path()
                        var occupied: [(center: CGPoint, radius: CGFloat)] = []
                        let targetCount = Int(ceil(size.width * size.height / 360))
                        // Keep centers apart while allowing edges to meet for denser cutouts.
                        for _ in 0..<(targetCount * 60) {
                            if occupied.count >= targetCount { break }
                            let isLarge = nextRandom() < 0.45
                            let width = isLarge ? 24 + nextRandom() * 22 : 8 + nextRandom() * 18
                            let height = isLarge ? 17 + nextRandom() * 17 : 6 + nextRandom() * 15
                            let radius = hypot(width, height) / 2
                            let center = CGPoint(x: nextRandom() * size.width,
                                                 y: nextRandom() * size.height)
                            guard occupied.allSatisfy({
                                hypot(center.x - $0.center.x, center.y - $0.center.y) >= max(12, (radius + $0.radius) * 0.5)
                            }) else { continue }

                            let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
                            var shape: Path
                            switch Int(nextRandom() * 3) {
                            case 0:
                                shape = Path(ellipseIn: rect)
                            case 1:
                                shape = Path(roundedRect: rect, cornerRadius: min(width, height) * 0.25)
                            default:
                                // An asymmetric curved patch, mixed with ovals and rounded slits.
                                shape = Path { path in
                                    path.move(to: CGPoint(x: rect.minX, y: 0))
                                    path.addCurve(to: CGPoint(x: width * 0.15, y: rect.minY),
                                                  control1: CGPoint(x: rect.minX, y: rect.minY),
                                                  control2: CGPoint(x: 0, y: -height * 0.2))
                                    path.addCurve(to: CGPoint(x: rect.maxX, y: height * 0.2),
                                                  control1: CGPoint(x: rect.maxX, y: rect.minY),
                                                  control2: CGPoint(x: width * 0.25, y: 0))
                                    path.addCurve(to: CGPoint(x: rect.minX, y: 0),
                                                  control1: CGPoint(x: rect.maxX, y: rect.maxY),
                                                  control2: CGPoint(x: -width * 0.4, y: rect.maxY))
                                    path.closeSubpath()
                                }
                            }
                            let rotation = CGAffineTransform(rotationAngle: nextRandom() * .pi * 2)
                            let translation = CGAffineTransform(translationX: center.x, y: center.y)
                            cutouts.addPath(shape, transform: rotation.concatenating(translation))
                            occupied.append((center, radius))
                        }

                        // Blur only the holes in the alpha mask; the original text stays sharp.
                        context.blendMode = .destinationOut
                        context.drawLayer { holes in
                            holes.blendMode = .normal
                            holes.addFilter(.blur(radius: 1.2))
                            holes.fill(cutouts, with: .color(.white))
                        }
                    }
                    .allowsHitTesting(false)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Receita bloqueada")
        } else {
            content
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

//#Preview {
//    RecipeDetailView()
//}
