# Guia de Implementacao VoiceOver - POC Map

Este documento lista todas as alteracoes de acessibilidade (VoiceOver) recomendadas,
organizadas por arquivo. Cada alteracao mostra o codigo ANTES e DEPOIS.

Nenhum arquivo foi modificado. Use este guia como referencia para implementacao.

---

## 1. StatusCoinComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/MapComponents/StatusCoinComponent.swift`

**O que falta:** O componente de moedas nao tem label de acessibilidade. O VoiceOver le os elementos individuais (texto + imagem) separadamente sem contexto.

**ANTES (linha 33-51):**
```swift
var body: some View {
    HStack(spacing: 3) {
        Text(formattedCoin)
            .font(Font.custom("Hammersmith One", size: 19, relativeTo: .headline))
            .foregroundColor(.cream300)
            .lineLimit(1)

        Image("statusCoin")
            .frame(width: 29, height: 24)

    }
    .frame(minWidth: 42)
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(
        HexagonShape()
            .fill(.brown900)
    )
}
```

**DEPOIS:**
```swift
var body: some View {
    HStack(spacing: 3) {
        Text(formattedCoin)
            .font(Font.custom("Hammersmith One", size: 19, relativeTo: .headline))
            .foregroundColor(.cream300)
            .lineLimit(1)

        Image("statusCoin")
            .frame(width: 29, height: 24)

    }
    .frame(minWidth: 42)
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(
        HexagonShape()
            .fill(.brown900)
    )
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("\(coin) moedas")
}
```

**Modificadores adicionados:**
- `.accessibilityElement(children: .ignore)` — agrupa o HStack como um unico elemento
- `.accessibilityLabel("\(coin) moedas")` — le "100 moedas" em vez de ler texto e imagem separados

---

## 2. TabBarComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/MapComponents/TabBarComponent.swift`

**O que falta:** Os botoes laterais ("Historico" e "Receitas") nao tem labels. O VoiceOver tenta ler a imagem de fundo que nao tem texto alternativo.

**ANTES (linhas 11-19) - botao Historico:**
```swift
Button {
    viewRouter.historyView()
} label: {
    sideButton(
        image: "tabBarButtonLeft",
        title: "Historico",
        scale: scale
    )
}
```

**DEPOIS:**
```swift
Button {
    viewRouter.historyView()
} label: {
    sideButton(
        image: "tabBarButtonLeft",
        title: "Historico",
        scale: scale
    )
}
.accessibilityLabel("Historico")
.accessibilityHint("Abre o historico de refeicoes")
```

**ANTES (linhas 34-42) - botao Receitas:**
```swift
Button {
    viewRouter.recipeListView()
} label: {
    sideButton(
        image: "tabBarButtonRight",
        title: "Receitas",
        scale: scale
    )
}
```

**DEPOIS:**
```swift
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
```

**ANTES (linha 21-32) - botao central:**
```swift
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
.accessibilityLabel("Nova Refeicao")
```

**DEPOIS:**
```swift
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
.accessibilityLabel("Nova Refeicao")
.accessibilityHint("Cadastrar uma nova refeicao")
```

---

## 3. DiamondComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/DiamondComponent.swift`

**O que falta:** O diamante mostra a imagem da receita ou "?" quando bloqueada, mas nao comunica nada ao VoiceOver.

**ANTES (linhas 21-44):**
```swift
var body: some View {
    DiamondShape()
        .fill(Color(recipe.category.rawValue))
        .overlay {
            if hasStroke {
                DiamondShape()
                    .stroke(strokeColor, lineWidth: strokeWidth)
            }
        }
        .overlay {
            if recipe.status == .unlocked{
                Image("\(recipe.name + " icon")")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.5)
            }
            else{
                Text("?")
                    .font(.custom("HammersmithOne-Regular", size: 72))
                    .foregroundStyle(.cream500)
            }
        }
        .aspectRatio(1, contentMode: .fit)
}
```

**DEPOIS:**
```swift
var body: some View {
    DiamondShape()
        .fill(Color(recipe.category.rawValue))
        .overlay {
            if hasStroke {
                DiamondShape()
                    .stroke(strokeColor, lineWidth: strokeWidth)
            }
        }
        .overlay {
            if recipe.status == .unlocked{
                Image("\(recipe.name + " icon")")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.5)
            }
            else{
                Text("?")
                    .font(.custom("HammersmithOne-Regular", size: 72))
                    .foregroundStyle(.cream500)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(recipe.status == .unlocked
            ? "Icone da receita \(recipe.name)"
            : "Receita bloqueada")
}
```

---

## 4. RecipeComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/RecipeListComponents/RecipeComponent.swift`

**O que falta:** Cada card de receita na grid nao informa ao VoiceOver o nome da receita, seu estado (bloqueada/desbloqueada/indisponivel) nem a acao disponivel.

**ANTES - case .unlocked (linhas 12-32):**
```swift
case .unlocked:
    ZStack{
        RoundedRectangle(cornerRadius: 10)
            .fill(.cream200)
            .stroke(.cream800, lineWidth: 3)
            .frame(maxWidth: 110, minHeight: 145)

        VStack(spacing: 10){
            DiamondComponent(recipe: recipe)
                .frame(width: 74, height: 74)

            Text(recipe.name)
                .font(.hammersmith())
                .foregroundColor(.brown200)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(15)
    }
```

**DEPOIS:**
```swift
case .unlocked:
    ZStack{
        RoundedRectangle(cornerRadius: 10)
            .fill(.cream200)
            .stroke(.cream800, lineWidth: 3)
            .frame(maxWidth: 110, minHeight: 145)

        VStack(spacing: 10){
            DiamondComponent(recipe: recipe)
                .frame(width: 74, height: 74)

            Text(recipe.name)
                .font(.hammersmith())
                .foregroundColor(.brown200)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(15)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("\(recipe.name), desbloqueada")
    .accessibilityHint("Toque duas vezes para ver detalhes")
```

**ANTES - case .locked (linhas 34-55):**
```swift
case .locked:
    ZStack(){
        RoundedRectangle(cornerRadius: 10)
            .fill(.cream600)
            .stroke(.cream800, lineWidth: 3)
            .frame(width: 110, height: 145)

        VStack(spacing: 10){
            Image("padlockSymbol")
                .frame(width: 74, height: 74)
                .cornerRadius(10)

            HStack(spacing: 2){
                Text("Ver Mais")
                    .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
            }
            .frame(width: 90, height: 30)
            .background(.green500)
            .cornerRadius(30)
            .foregroundStyle(.white)
        }
    }
```

**DEPOIS:**
```swift
case .locked:
    ZStack(){
        RoundedRectangle(cornerRadius: 10)
            .fill(.cream600)
            .stroke(.cream800, lineWidth: 3)
            .frame(width: 110, height: 145)

        VStack(spacing: 10){
            Image("padlockSymbol")
                .frame(width: 74, height: 74)
                .cornerRadius(10)

            HStack(spacing: 2){
                Text("Ver Mais")
                    .font(Font.custom("Hammersmith One", size: 17, relativeTo: .callout))
            }
            .frame(width: 90, height: 30)
            .background(.green500)
            .cornerRadius(30)
            .foregroundStyle(.white)
        }
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Receita bloqueada")
    .accessibilityHint("Toque duas vezes para ver mais informacoes")
```

**ANTES - case .unavailable (linhas 57-66):**
```swift
case .unavailable:
    ZStack(){
        RoundedRectangle(cornerRadius: 10)
            .fill(.brown100)
            .stroke(.brown100, lineWidth: 3)
            .frame(width: 110, height: 145)

        Image("unavailableSymbol")
            .frame(width: 42.5, height: 72.5)
    }
```

**DEPOIS:**
```swift
case .unavailable:
    ZStack(){
        RoundedRectangle(cornerRadius: 10)
            .fill(.brown100)
            .stroke(.brown100, lineWidth: 3)
            .frame(width: 110, height: 145)

        Image("unavailableSymbol")
            .frame(width: 42.5, height: 72.5)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Receita indisponivel")
```

---

## 5. IngredientComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/RecipeComponents/IngredientComponent.swift`

**O que falta:** O ingrediente nao comunica seu nome, quantidade, unidade e se esta marcado ou nao.

**ANTES - case .normal (linhas 18-46):**
```swift
case .normal:
    VStack(alignment: .center) {
        Text("\(igredient.quantity) \(igredient.unit)")
            ...
        Text(igredient.name)
            ...
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
```

**DEPOIS:**
```swift
case .normal:
    VStack(alignment: .center) {
        Text("\(igredient.quantity) \(igredient.unit)")
            ...
        Text(igredient.name)
            ...
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
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("\(igredient.name), \(igredient.quantity) \(igredient.unit)")
    .accessibilityValue("Nao selecionado")
    .accessibilityHint("Toque duas vezes para marcar")
```

**ANTES - case .green (linhas 47-76):**
```swift
case .green:
    VStack(alignment: .center) {
        Text("\(igredient.quantity) \(igredient.unit)")
            ...
        Text(igredient.name)
            ...
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
```

**DEPOIS:**
```swift
case .green:
    VStack(alignment: .center) {
        Text("\(igredient.quantity) \(igredient.unit)")
            ...
        Text(igredient.name)
            ...
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
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("\(igredient.name), \(igredient.quantity) \(igredient.unit)")
    .accessibilityValue("Selecionado")
    .accessibilityHint("Toque duas vezes para desmarcar")
```

---

## 6. StepsScreenComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/RecipeComponents/StepsScreenComponent.swift`

**O que falta:** O numero da etapa e a instrucao sao lidos separadamente sem contexto.

**ANTES (linhas 7-39):**
```swift
var body: some View {
    ZStack{
        Rectangle()
            .fill(.cream200)
            .frame(maxWidth: 360, minHeight: 83)
            .cornerRadius(10)

        HStack(alignment: .center, spacing: 15){
            VStack{
                Text("\(step.order)a")
                    .font(Font.largeTitle.bold())
                    .foregroundStyle(.green500)

                Text("Etapa")
                    .font(Font.body.bold())
                    .foregroundStyle(.brown200)
            }
            .padding(20)

            Text("\(step.instruction)")
                .font(Font.headline)
                .foregroundStyle(.brown200)
                .padding(.vertical, 15)

            Spacer()
        }
        .padding(.horizontal, 15)
    }
}
```

**DEPOIS:**
```swift
var body: some View {
    ZStack{
        Rectangle()
            .fill(.cream200)
            .frame(maxWidth: 360, minHeight: 83)
            .cornerRadius(10)

        HStack(alignment: .center, spacing: 15){
            VStack{
                Text("\(step.order)a")
                    .font(Font.largeTitle.bold())
                    .foregroundStyle(.green500)

                Text("Etapa")
                    .font(Font.body.bold())
                    .foregroundStyle(.brown200)
            }
            .padding(20)

            Text("\(step.instruction)")
                .font(Font.headline)
                .foregroundStyle(.brown200)
                .padding(.vertical, 15)

            Spacer()
        }
        .padding(.horizontal, 15)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Etapa \(step.order): \(step.instruction)")
}
```

---

## 7. StarsRatingComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/MealComponents/StarsRatingComponent.swift`

**O que falta:** As estrelas sao lidas individualmente como "star.fill" pelo VoiceOver, sem significado.

**ANTES (linhas 7-24):**
```swift
var body: some View {
    HStack{
        HStack(spacing: 8){
            ForEach(1...stars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
            }
        }
    }
    .frame(maxWidth: 172, maxHeight: 40)
    .padding(.horizontal, 18.4)
    .padding(.top, 8.6)
    .padding(.bottom, 14.6)
    .background(.green500)
}
```

**DEPOIS:**
```swift
var body: some View {
    HStack{
        HStack(spacing: 8){
            ForEach(1...stars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
            }
        }
    }
    .frame(maxWidth: 172, maxHeight: 40)
    .padding(.horizontal, 18.4)
    .padding(.top, 8.6)
    .padding(.bottom, 14.6)
    .background(.green500)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Avaliacao: \(stars) de 5 estrelas")
}
```

---

## 8. StarRatingInputComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/MealComponents/StarRatingInputComponent.swift`

**O que falta:** As imagens decorativas (Star Banner) nao estao ocultas. Os botoes de estrela nao indicam qual numero representam nem se estao selecionados. No modo somente leitura, nao ha label.

**ANTES (linhas 8-55):**
```swift
var body: some View {
    ZStack{
        HStack{
            Image("Star Banner")
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 64)
                .foregroundColor(.green)

            Spacer()

            Image("Star Banner")
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 64)
                .foregroundColor(.green)
                .scaleEffect(x: -1, y: 1)
        }
        .padding(.top, 25)
        HStack (alignment: .center, spacing: 15) {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                if isInput{
                    Button {
                        rating = number
                    } label: {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(number <= rating ? .white : .green700)
                            .animation(.linear, value: rating)
                    }
                }
                else{
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(number <= rating ? .white : .green700)
                        .animation(.linear, value: rating)
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
        .padding(.horizontal, 45)
        .background(.green500)
        .padding(.horizontal, 28)
    }
}
```

**DEPOIS:**
```swift
var body: some View {
    ZStack{
        HStack{
            Image("Star Banner")
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 64)
                .foregroundColor(.green)

            Spacer()

            Image("Star Banner")
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 64)
                .foregroundColor(.green)
                .scaleEffect(x: -1, y: 1)
        }
        .padding(.top, 25)
        .accessibilityHidden(true)
        HStack (alignment: .center, spacing: 15) {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                if isInput{
                    Button {
                        rating = number
                    } label: {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(number <= rating ? .white : .green700)
                            .animation(.linear, value: rating)
                    }
                    .accessibilityLabel("\(number) estrela\(number > 1 ? "s" : "")")
                    .accessibilityValue(number <= rating ? "Selecionada" : "Nao selecionada")
                    .accessibilityHint("Toque duas vezes para avaliar com \(number) estrela\(number > 1 ? "s" : "")")
                }
                else{
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(number <= rating ? .white : .green700)
                        .animation(.linear, value: rating)
                        .accessibilityHidden(true)
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
        .padding(.horizontal, 45)
        .background(.green500)
        .padding(.horizontal, 28)
        .accessibilityElement(children: isInput ? .contain : .ignore)
        .accessibilityLabel(isInput ? "Avaliacao" : "Avaliacao: \(rating) de \(maximumRating) estrelas")
    }
}
```

---

## 9. HistoryRecipeComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/MealComponents/HistoryRecipeComponent.swift`

**O que falta:** Imagens decorativas de banner nao estao ocultas. O card inteiro nao tem label descritivo. O VoiceOver le elementos internos sem contexto.

**ANTES (linhas 8-71):**
```swift
var body: some View {
    ZStack{
        HStack{
            Image("Star Banner")
                ...
            Spacer()
            Image("Star Banner")
                ...
        }
        .frame(width: 200)
        .padding(.top, 165)
        .padding(.bottom, 50)

        VStack(spacing: 70){
            if let uiImage = UIImage(data: meal.image){
                Image(uiImage: uiImage)
                    ...
            }
            else{
                Image("arrozFrito")
                    ...
            }

            HStack(alignment: .center, spacing: 5){
                ForEach(meal.recipes){ recipe in
                    Image("diamondRecipe")
                        ...
                }
            }
        }
        ...

        StarsRatingComponent(stars: meal.stars)
            ...
    }
}
```

**DEPOIS:** Adicionar ao final do ZStack principal (apos a chave de fechamento, antes de `}`):
```swift
var body: some View {
    ZStack{
        HStack{
            Image("Star Banner")
                ...
            Spacer()
            Image("Star Banner")
                ...
        }
        .frame(width: 200)
        .padding(.top, 165)
        .padding(.bottom, 50)
        .accessibilityHidden(true)

        VStack(spacing: 70){
            ...
        }
        ...

        StarsRatingComponent(stars: meal.stars)
            ...
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Refeicao com \(meal.recipes.count) receita\(meal.recipes.count > 1 ? "s" : ""), \(meal.stars) de 5 estrelas")
    .accessibilityHint("Toque duas vezes para ver detalhes")
}
```

---

## 10. RecipeStepComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/StepComponent/RecipeStepComponent.swift`

**O que falta:** As instrucoes de gesto, barra de progresso e etapa atual nao sao comunicadas ao VoiceOver.

**Adicionar ao final do VStack principal (linha 103), antes de `.frame(maxHeight: .infinity)`:**

```swift
// ANTES:
    }
}
.frame(maxHeight: .infinity)

// DEPOIS:
    }
}
.frame(maxHeight: .infinity)
.accessibilityElement(children: .ignore)
.accessibilityLabel("Etapa \(step.order) de \(totalSteps): \(step.instruction)")
.accessibilityValue("Progresso: etapa \(step.order) de \(totalSteps)")
.accessibilityHint(
    isLastStep
        ? "Ultima etapa. Faca gesto de pedra para voltar."
        : isFirstStep
            ? "Primeira etapa. Faca gesto de tesoura para avancar."
            : "Faca gesto de tesoura para avancar ou pedra para voltar."
)
```

---

## 11. MapView.swift

**Arquivo:** `POC Map/POC Map/View/MapView.swift`

**O que falta:** O overlay escuro do popup e o SpriteView do mapa nao tem labels.

**Adicionar na overlay escura do popup (linha 26-29):**
```swift
// ANTES:
Color.black.opacity(0.4)
    .ignoresSafeArea()
    .onTapGesture {
        viewModel.selectedRecipe = nil
    }
    .transition(.opacity)

// DEPOIS:
Color.black.opacity(0.4)
    .ignoresSafeArea()
    .onTapGesture {
        viewModel.selectedRecipe = nil
    }
    .transition(.opacity)
    .accessibilityLabel("Fechar popup")
    .accessibilityHint("Toque duas vezes para fechar os detalhes da receita")
```

**Adicionar no SpriteView (linha 40):**
```swift
// ANTES:
SpriteView(scene: viewModel.mapScene, options: [.allowsTransparency])
    .ignoresSafeArea()

// DEPOIS:
SpriteView(scene: viewModel.mapScene, options: [.allowsTransparency])
    .ignoresSafeArea()
    .accessibilityLabel("Mapa de receitas")
    .accessibilityHint("Navegue pelo mapa para encontrar receitas")
```

---

## 12. RecipeListView.swift

**Arquivo:** `POC Map/POC Map/View/RecipeListView.swift`

**O que falta:** Os botoes de receita na grid nao descrevem o nome e estado da receita para o VoiceOver.

**Adicionar nos botoes de receita (linhas 35-48):**
```swift
// ANTES (unlocked):
Button(action: {
    viewRouter.recipeView(recipe: recipe)
}, label: {
    RecipeComponent(recipe: recipe, currentStatus: .unlocked)
})
.buttonStyle(.plain)

// DEPOIS:
Button(action: {
    viewRouter.recipeView(recipe: recipe)
}, label: {
    RecipeComponent(recipe: recipe, currentStatus: .unlocked)
})
.buttonStyle(.plain)
.accessibilityLabel("\(recipe.name), desbloqueada")
.accessibilityHint("Toque duas vezes para abrir a receita")

// ANTES (locked):
Button(action: {
    viewRouter.recipeView(recipe: recipe)
}, label: {
    RecipeComponent(recipe: recipe, currentStatus: .locked)
})
.buttonStyle(.plain)

// DEPOIS:
Button(action: {
    viewRouter.recipeView(recipe: recipe)
}, label: {
    RecipeComponent(recipe: recipe, currentStatus: .locked)
})
.buttonStyle(.plain)
.accessibilityLabel("Receita bloqueada")
.accessibilityHint("Toque duas vezes para ver mais informacoes")
```

---

## 13. RecipeView.swift

**Arquivo:** `POC Map/POC Map/View/RecipeView.swift`

**O que falta:** Informacoes de tempo/porcoes, nome da receita, botoes de acao e ingredientes nao tem labels adequados.

**Adicionar no headerSection - Tempo (linhas 135-144):**
```swift
// ANTES:
VStack(alignment: .center) {
    Text("Preparo")
        ...
    Text("\(viewModel.recipe.time) min")
        ...
}
.padding(.leading, 25)

// DEPOIS:
VStack(alignment: .center) {
    Text("Preparo")
        ...
    Text("\(viewModel.recipe.time) min")
        ...
}
.padding(.leading, 25)
.accessibilityElement(children: .ignore)
.accessibilityLabel("Tempo de preparo: \(viewModel.recipe.time) minutos")
```

**Adicionar no headerSection - Porcoes (linhas 149-160):**
```swift
// ANTES:
VStack(alignment: .center) {
    Text("Porcoes")
        ...
    Text(viewModel.recipe.portions)
        ...
}
.padding(.trailing, 20)

// DEPOIS:
VStack(alignment: .center) {
    Text("Porcoes")
        ...
    Text(viewModel.recipe.portions)
        ...
}
.padding(.trailing, 20)
.accessibilityElement(children: .ignore)
.accessibilityLabel("Porcoes: \(viewModel.recipe.portions)")
```

**Adicionar no retangulo divisorio (linhas 173-175):**
```swift
// ANTES:
Rectangle()
    .fill(.brown100)
    .frame(width: 360, height: 2)

// DEPOIS:
Rectangle()
    .fill(.brown100)
    .frame(width: 360, height: 2)
    .accessibilityHidden(true)
```

**Adicionar nos botoes de acao (linhas 86-96):**
```swift
// ANTES (botao iniciar receita, status unlocked):
Button(action: {
    viewRouter.stepsView(recipe: viewModel.recipe)
}, label: {
    BrownButtonComponent(recipe: viewModel.recipe, currentButton: .largeFill, ...)
})

// DEPOIS:
Button(action: {
    viewRouter.stepsView(recipe: viewModel.recipe)
}, label: {
    BrownButtonComponent(recipe: viewModel.recipe, currentButton: .largeFill, ...)
})
.accessibilityLabel("Iniciar receita \(viewModel.recipe.name)")

// ANTES (botao adquirir, status locked):
Button(action: {
    viewModel.buyRecipe(...)
}, label: {
    BrownButtonComponent(recipe: viewModel.recipe, currentButton: .largeFill, ...)
})

// DEPOIS:
Button(action: {
    viewModel.buyRecipe(...)
}, label: {
    BrownButtonComponent(recipe: viewModel.recipe, currentButton: .largeFill, ...)
})
.accessibilityLabel("Adquirir receita por \(viewModel.recipe.price) moedas")
.accessibilityHint(player.coin >= viewModel.recipe.price
    ? "Voce tem moedas suficientes"
    : "Voce nao tem moedas suficientes")
```

---

## 14. RecipeDetailView.swift

**Arquivo:** `POC Map/POC Map/View/RecipeDetailView.swift`

**O que falta:** Informacoes de preparo/porcoes com "???", botoes de acao e imagem de fundo do popup.

**Adicionar nos VStacks de Preparo e Porcoes (linhas 14-53):**
```swift
// Preparo VStack - DEPOIS:
VStack(alignment: .center) {
    Text("Preparo")
        ...
    if viewModel.recipe.status == .unlocked {
        Text("\(viewModel.recipe.time) min")
            ...
    } else if viewModel.recipe.status == .locked {
        Text("???")
            ...
    }
}
.accessibilityElement(children: .ignore)
.accessibilityLabel(viewModel.recipe.status == .unlocked
    ? "Tempo de preparo: \(viewModel.recipe.time) minutos"
    : "Tempo de preparo: informacao bloqueada")

// Porcoes VStack - DEPOIS:
VStack(alignment: .center) {
    Text("Porcoes")
        ...
    if viewModel.recipe.status == .unlocked {
        Text(viewModel.recipe.portions)
            ...
    } else if viewModel.recipe.status == .locked {
        Text("???")
            ...
    }
}
.accessibilityElement(children: .ignore)
.accessibilityLabel(viewModel.recipe.status == .unlocked
    ? "Porcoes: \(viewModel.recipe.portions)"
    : "Porcoes: informacao bloqueada")
```

**Adicionar no retangulo divisorio (linhas 68-71):**
```swift
Rectangle()
    .fill(Color.brown100)
    .frame(height: 2)
    .frame(maxWidth: .infinity)
    .accessibilityHidden(true)
```

**Adicionar na imagem de fundo do popup (linhas 130-133):**
```swift
Image("popupBackground")
    .resizable()
    .scaledToFill()
    .accessibilityHidden(true)
```

**Adicionar nos botoes (linhas 99-123):**
```swift
// Botao adquirir (locked):
Button {
    viewModel.buyRecipe()
} label: {
    BrownButtonComponent(...)
}
.accessibilityLabel("Adquirir receita por \(viewModel.recipe.price) moedas")

// Botao ver mais (unlocked):
Button {
    viewRouter.recipeView(recipe: viewModel.recipe)
    viewModel.close()
} label: {
    BrownButtonComponent(...)
}
.accessibilityLabel("Ver mais sobre \(viewModel.recipe.name)")

// Botao iniciar receita (unlocked):
Button {
    viewRouter.stepsView(recipe: viewModel.recipe)
    viewModel.close()
} label: {
    BrownButtonComponent(...)
}
.accessibilityLabel("Iniciar receita \(viewModel.recipe.name)")
```

---

## 15. HistoryView.swift

**Arquivo:** `POC Map/POC Map/View/HistoryView.swift`

**O que falta:** A imagem do estado vazio e os botoes de refeicao no historico nao tem labels.

**Adicionar na imagem de estado vazio (linha 18):**
```swift
// ANTES:
Image("lockedRecipe")
    .resizable()
    .scaledToFit()
    .frame(width: 170, height: 130)

// DEPOIS:
Image("lockedRecipe")
    .resizable()
    .scaledToFit()
    .frame(width: 170, height: 130)
    .accessibilityHidden(true)
```

**Adicionar nos botoes de refeicao (linhas 49-53):**
```swift
// ANTES:
Button(action: {
    viewModel.selectedMeal = meal
}, label:{
    HistoryRecipeComponent(meal: meal)
})

// DEPOIS:
Button(action: {
    viewModel.selectedMeal = meal
}, label:{
    HistoryRecipeComponent(meal: meal)
})
.accessibilityLabel("Refeicao com \(meal.recipes.count) receita\(meal.recipes.count > 1 ? "s" : ""), \(meal.stars) estrelas")
.accessibilityHint("Toque duas vezes para ver detalhes")
```

---

## 16. MealView.swift

**Arquivo:** `POC Map/POC Map/View/MealView.swift`

**O que falta:** A foto da refeicao, os diamantes de receita e o comentario nao tem labels.

**Adicionar na imagem da refeicao (linhas 11-15):**
```swift
// ANTES:
Image(uiImage: UIImage(data: meal.image) ?? UIImage())
    .resizable()
    .scaledToFit()
    .clipShape(RoundedRectangle(cornerRadius: 35))
    .padding(.horizontal, 30)

// DEPOIS:
Image(uiImage: UIImage(data: meal.image) ?? UIImage())
    .resizable()
    .scaledToFit()
    .clipShape(RoundedRectangle(cornerRadius: 35))
    .padding(.horizontal, 30)
    .accessibilityLabel("Foto da refeicao")
```

**Adicionar em cada receita do prato (linhas 28-40):**
```swift
// ANTES:
ForEach(meal.recipes){ recipe in
    VStack(spacing: 9){
        DiamondComponent(recipe: recipe)
            .frame(width: 62, height: 62)

        Text(recipe.name)
            ...
    }
    .frame(alignment: .top)
}

// DEPOIS:
ForEach(meal.recipes){ recipe in
    VStack(spacing: 9){
        DiamondComponent(recipe: recipe)
            .frame(width: 62, height: 62)

        Text(recipe.name)
            ...
    }
    .frame(alignment: .top)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Receita: \(recipe.name)")
}
```

---

## 17. NewMealView.swift

**Arquivo:** `POC Map/POC Map/View/NewMealView.swift`

**O que falta:** O botao de captura de foto, selecao de categoria, campo de comentarios e botao confirmar nao tem labels.

**Adicionar no botao de foto (linhas 25-56):**
```swift
// Adicionar apos o fechamento do Button (apos a label):
.accessibilityLabel(viewModel.imageData != nil
    ? "Foto da refeicao capturada"
    : "Adicionar foto da refeicao")
.accessibilityHint("Toque duas vezes para abrir a camera")
```

**Adicionar nos botoes de categoria (linhas 73-106, cada botao):**
```swift
// Adicionar em cada botao de categoria:
.accessibilityLabel(viewModel.recipesDic[category] != nil
    ? "\(category.displayName): \(viewModel.recipesDic[category]?.name ?? "")"
    : "Selecionar \(category.displayName)")
.accessibilityHint("Toque duas vezes para escolher uma receita de \(category.displayName)")
```

**Adicionar no TextField de comentarios (linhas 149-165):**
```swift
// ANTES:
TextField("",
          text: $viewModel.newMeal.comment,
          prompt: Text("Descreva seus comentarios...")
    .foregroundStyle(.brown200),
          axis: .vertical
)

// DEPOIS:
TextField("",
          text: $viewModel.newMeal.comment,
          prompt: Text("Descreva seus comentarios...")
    .foregroundStyle(.brown200),
          axis: .vertical
)
.accessibilityLabel("Comentarios")
.accessibilityHint("Digite seus comentarios sobre a refeicao")
```

**Adicionar no botao de confirmar na toolbar (linhas 171-178):**
```swift
// ANTES:
Button(role: .confirm){
    viewModel.addMeal(context: modelContext, player)
    viewRouter.removeLast()
}
.tint(.green500)
.disabled(...)

// DEPOIS:
Button(role: .confirm){
    viewModel.addMeal(context: modelContext, player)
    viewRouter.removeLast()
}
.tint(.green500)
.disabled(...)
.accessibilityLabel("Confirmar refeicao")
.accessibilityHint("Toque duas vezes para salvar a refeicao")
```

---

## 18. StepsView.swift

**Arquivo:** `POC Map/POC Map/View/StepsView.swift`

**O que falta:** O overlay escuro e o feed de camera sao puramente visuais. A mensagem de feedback precisa ser anunciada ao VoiceOver.

**Adicionar no overlay escuro (linha 21):**
```swift
// ANTES:
Color.black.opacity(0.4)
    .edgesIgnoringSafeArea(.all)

// DEPOIS:
Color.black.opacity(0.4)
    .edgesIgnoringSafeArea(.all)
    .accessibilityHidden(true)
```

**Adicionar na mensagem de feedback (linhas 39-46):**
```swift
// ANTES:
Text(message)
    .font(.headline)
    .foregroundStyle(.white)
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(.ultraThinMaterial)
    .clipShape(Capsule())
    .transition(.scale.combined(with: .opacity))

// DEPOIS:
Text(message)
    .font(.headline)
    .foregroundStyle(.white)
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(.ultraThinMaterial)
    .clipShape(Capsule())
    .transition(.scale.combined(with: .opacity))
    .accessibilityLabel(message)
    .accessibilityAddTraits(.updatesFrequently)
```

**Adicionar no ProgressView de carregamento (linha 53):**
```swift
// ANTES:
ProgressView("Ligando camera...")

// DEPOIS:
ProgressView("Ligando camera...")
    .accessibilityLabel("Carregando camera, por favor aguarde")
```

---

## 19. AddRecipetoMealView.swift

**Arquivo:** `POC Map/POC Map/View/AddRecipetoMealView.swift`

**O que falta:** Os botoes de selecao de receita nao descrevem qual receita esta sendo selecionada.

**Adicionar nos botoes de receita (linhas 20-25):**
```swift
// ANTES:
Button(action: {
    viewModel.addRecipe(recipe)
    dismiss()
}, label: {
    RecipeComponent(recipe: recipe, currentStatus: .unlocked)
})

// DEPOIS:
Button(action: {
    viewModel.addRecipe(recipe)
    dismiss()
}, label: {
    RecipeComponent(recipe: recipe, currentStatus: .unlocked)
})
.accessibilityLabel("Selecionar \(recipe.name)")
.accessibilityHint("Toque duas vezes para adicionar esta receita a refeicao")
```

---

## 20. DescriptionComponent.swift

**Arquivo:** `POC Map/POC Map/View/Components/PopupComponents/DescriptionComponent.swift`

**O que falta:** A imagem "NoRecipe" no estado bloqueado e decorativa e deve ser ocultada.

**Adicionar nas imagens "NoRecipe" (linhas 36-39 e 52-55):**
```swift
// ANTES:
Image("NoRecipe")
    .resizable()
    .scaledToFill()
    .frame(width: 90, height:80)

// DEPOIS:
Image("NoRecipe")
    .resizable()
    .scaledToFill()
    .frame(width: 90, height:80)
    .accessibilityHidden(true)
```

---

## Resumo de Modificadores Utilizados

| Modificador | Funcao | Quantidade de usos |
|---|---|---|
| `.accessibilityLabel()` | Texto lido pelo VoiceOver | ~35 |
| `.accessibilityHint()` | Dica de acao para o usuario | ~18 |
| `.accessibilityValue()` | Estado atual do elemento | ~5 |
| `.accessibilityElement(children:)` | Agrupamento de elementos | ~12 |
| `.accessibilityHidden(true)` | Oculta elementos decorativos | ~8 |
| `.accessibilityAddTraits()` | Comportamento especial | ~1 |

**Total de arquivos afetados:** 20
**Total de modificacoes:** ~79 adicoes de modificadores de acessibilidade
