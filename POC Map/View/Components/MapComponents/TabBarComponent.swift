import SwiftUI

struct TabBarComponent: View {
    @Environment(ViewRouter.self) var viewRouter

    var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width / 344

            HStack(alignment: .top, spacing: -10 * scale) {
                Button {
                    viewRouter.historyView()
                } label: {
                    sideButton(
                        image: "tabBarButtonLeft",
                        title: "Histórico",
                        scale: scale
                    )
                }
                .accessibilityLabel("Historico")
                .accessibilityHint("Abre o historico de refeicoes")

                Button {
                    viewRouter.newMealView()
                } label: {
                    Image("tabBarButtonCenter")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * scale,
                            height: 100 * scale
                        )
                }
                .accessibilityLabel("Nova Refeição")
                .accessibilityHint("Cadastrar uma nova refeicao")

                Button {
                    viewRouter.recipeListView()
                } label: {
                    sideButton(
                        image: "tabBarButtonRight",
                        title: "Receitas",
                        scale: scale
                    )
                }
                .accessibilityLabel("Receitas")
                .accessibilityHint("Abre a lista de receitas")

            }
            .buttonStyle(.plain)
        }
        .aspectRatio(344.0 / 100.0, contentMode: .fit)
        .frame(maxWidth: 430)
    }

    private func sideButton(
        image: String,
        title: String,
        scale: CGFloat
    ) -> some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(
                width: 132 * scale,
                height: 73 * scale
            )
            .overlay {
                Text(title)
                    .font(.hammersmith())
                    .foregroundStyle(Color.cream300)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, 8 * scale)
                    .padding(.top, 36 * scale)
            }
    }
}

#Preview {
    VStack(spacing: 32) {
        TabBarComponent()
            .frame(width: 280)

        TabBarComponent()
            .frame(width: 344)
    }
    .padding()
    .environment(ViewRouter())
}
