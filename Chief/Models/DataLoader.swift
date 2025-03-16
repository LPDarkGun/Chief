import Foundation

class DataLoader {
    static var ingredientIndex: [String: [Recipe]] = [:]
    
    private static func buildIngredientIndex(_ recipes: [Recipe]) {
        ingredientIndex = [:] // Reset index before building

        for recipe in recipes {
            for ingredient in recipe.Cleaned_Ingredients {
                let key = normalizeIngredient(ingredient)
                ingredientIndex[key, default: []].append(recipe)
            }
        }

        print("✅ Built ingredient index with \(ingredientIndex.count) unique ingredients")
    }


    
    static func loadRecipes(completion: @escaping ([Recipe]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = Bundle.main.url(forResource: "Recipes", withExtension: "json") else {
                print("❌ Recipes.json not found in bundle!")
                debugBundleResources()
                DispatchQueue.main.async { completion([]) }
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let recipes = parseRecipes(from: data)
                
                // ✅ CALL THIS TO BUILD INGREDIENT INDEX
                buildIngredientIndex(recipes)

                print("✅ Successfully loaded \(recipes.count) recipes")
                DispatchQueue.main.async { completion(recipes) }
            } catch {
                print("❌ Error loading Recipes.json: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }
    }


    /// ✅ **Fast JSON parsing with `JSONSerialization` (faster than JSONDecoder)**
    private static func parseRecipes(from data: Data) -> [Recipe] {
        var recipes: [Recipe] = []

        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for dict in jsonArray {
                    if let recipe = parseRecipe(from: dict) {
                        recipes.append(recipe)
                    }
                }
            }
        } catch {
            print("❌ Error parsing JSON: \(error)")
        }

        return recipes
    }

    /// ✅ **Convert Dictionary to Recipe Object (avoids slow JSONDecoder)**
    private static func parseRecipe(from dict: [String: Any]) -> Recipe? {
        guard let id = dict["Id"] as? Int,
              let title = dict["Title"] as? String,
              let ingredientsRaw = dict["Ingredients"] as? String,  // JSON sometimes stores this as a string
              let instructions = dict["Instructions"] as? String,
              let imageName = dict["Image_Name"] as? String,
              let cleanedIngredientsRaw = dict["Cleaned_Ingredients"] as? String else {
            return nil
        }

        let ingredients = parseJsonArrayString(ingredientsRaw)
        let cleanedIngredients = parseJsonArrayString(cleanedIngredientsRaw)

        return Recipe(
            Id: id,
            Title: title,
            Ingredients: ingredients,
            Instructions: instructions,
            Image_Name: imageName,
            Cleaned_Ingredients: cleanedIngredients
        )
    }

    
    private static func parseJsonArrayString(_ jsonString: String) -> [String] {
        let trimmed = jsonString.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        return trimmed.components(separatedBy: "', '").map {
            let cleaned = $0
                .replacingOccurrences(of: "\\/", with: "/")  // Fix escaped slashes
                .replacingOccurrences(of: "\u{00b0}", with: "°")  // Fix degree symbols
                .trimmingCharacters(in: CharacterSet(charactersIn: "'\""))  // Trim quotes
            
            return normalizeIngredient(cleaned)
        }
    }

    static func normalizeIngredient(_ ingredient: String) -> String {
        return ingredient
            .replacingOccurrences(of: #"(?<!\w)(\d+(\.\d+)?\s*(cup|tbsp|tsp|oz|g|lb|ml|cl|dl|kg|pound|quart|pinch|dash|can|packet|slice|piece|large|medium|small|whole|chopped|diced|sliced|peeled|crushed))"#,
                                  with: "",
                                  options: .regularExpression)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }


    /// ✅ **Debugging function to list all files in the app bundle**
    static func debugBundleResources() {
        let bundle = Bundle.main
        if let resourcePath = bundle.resourcePath {
            let fileManager = FileManager.default
            do {
                let resources = try fileManager.contentsOfDirectory(atPath: resourcePath)
                print("📂 Bundle contains: \(resources)")
            } catch {
                print("❌ Failed to list bundle resources: \(error)")
            }
        } else {
            print("❌ Resource path not found")
        }
    }
}
