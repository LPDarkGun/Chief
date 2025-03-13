import Foundation




class DataLoader {
    static func loadRecipes() -> [Recipe] {
        guard let url = Bundle.main.url(forResource: "Recipes", withExtension: "json") else {
            print("Recipes.json not found")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let recipes = try decoder.decode([Recipe].self, from: data)
            return recipes
        } catch {
            print("Error decoding Recipes.json: \(error)")
            return []
        }
    }
    
    static func debugBundleResources() {
        let bundle = Bundle.main
        if let resourcePath = bundle.resourcePath {
            let fileManager = FileManager.default
            do {
                let resources = try fileManager.contentsOfDirectory(atPath: resourcePath)
                print("Resources in bundle: \(resources)")
            } catch {
                print("Failed to list resources: \(error)")
            }
        } else {
            print("Resource path not found")
        }
    }
    
    static func loadIngredients() -> [Ingredient] {
        guard let url = Bundle.main.url(forResource: "ing", withExtension: "json") else {
            print("ing.json not found")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let ingredients = try decoder.decode([Ingredient].self, from: data)
            return ingredients
        } catch {
            print("Error decoding ing.json: \(error)")
            return []
        }
    }
}


