//
//  DataLoader.swift
//  POC Map
//
//  Created by Ana Soares on 27/08/26.
//

import Foundation
import SwiftData

import Foundation

struct RecipeDTO: Codable {
    let name: String
    let status: String
    let reward: Int
    let time: Int
    let level: String
    let steps: [RecipeStep]
    let ingredients: [Igredient]
    let tags: [String]
    let category: String

    func toRecipe() -> Recipe {
        return Recipe(
            name: name,
            status: RecipeStatus(rawValue: status) ?? .locked,
            reward: reward,
            time: time,
            level: RecipeLevel(rawValue: level) ?? .easy,
            steps: steps,
            ingredients: ingredients,
            tags: tags.compactMap { RecipeTag(rawValue: $0) },
            category: RecipeCategory(rawValue: category) ?? .pratoPrincipal
        )
    }
}

struct DataLoader {
    
    static func loadRecipesIfNeeded(context: ModelContext) {

        // Verifica se já existem receitas salvas
        let descriptor = FetchDescriptor<Recipe>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        if existingCount > 0 {
            print("Receitas já carregadas (\(existingCount)). Pulando.")
            return
        }

        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Erro: arquivo recipes.json não encontrado")
            return
        }

        do {
            let decoder = JSONDecoder()
            let dtos = try decoder.decode([RecipeDTO].self, from: data)

            for dto in dtos {
                let recipe = dto.toRecipe()
                context.insert(recipe)
            }

            try context.save()
            print("\(dtos.count) receitas carregadas com sucesso")
        } catch {
            print("Erro ao decodificar JSON: \(error)")
        }
    }
    static func deleteAllRecipes(context: ModelContext) {
        do {
            try context.delete(model: Recipe.self)
            try context.save()
            print("Todas as receitas foram removidas.")
        } catch {
            print("Erro ao deletar receitas: \(error)")
        }
    }
}
