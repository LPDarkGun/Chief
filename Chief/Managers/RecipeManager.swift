import Foundation

class RecipeManager: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    init() {
        loadRecipes()
    }
    
    func loadRecipes() {
        if let url = Bundle.main.url(forResource: "Recipes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
                
                DispatchQueue.main.async {
                    self.recipes = Array(decodedRecipes.suffix(5)) // ✅ Only keep the last 5 recipes
                    print("✅ Loaded \(self.recipes.count) latest recipes") // Debugging log
                }
            } catch {
                print("❌ Error loading recipes: \(error)")
            }
        } else {
            print("❌ Recipes.json not found")
        }
    }
}
