
import Observation
import AVFoundation
internal import SpriteKit


@Observable
final class RecipeViewModel{
    let recipe: Recipe

    
    init(recipe: Recipe) {
        self.recipe = recipe

    }
    
    func organizarEmLinhas(ingredientes: [Igredient]) -> [[Igredient?]] {
        var linhas: [[Igredient?]] = []
        var indice = 0
        var linhaDeTres = true
        
        while indice < ingredientes.count {
            let limite = linhaDeTres ? 3 : 2
            let fim = min(indice + limite, ingredientes.count)
            
            var linha: [Igredient?] = Array(ingredientes[indice..<fim])
            
            while linha.count < limite {
                linha.append(nil)
            }
            
            linhas.append(linha)
            
            indice += limite
            linhaDeTres.toggle()
        }
        
        return linhas
    }

}
