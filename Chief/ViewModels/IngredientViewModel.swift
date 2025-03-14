import Foundation

class IngredientViewModel: ObservableObject {
    @Published var allIngredients: [Ingredient] = []
    @Published var filteredIngredients: [Ingredient] = []
    @Published var searchText: String = ""
    
    init() {
        loadIngredients()
    }
    
    func loadIngredients() {
        guard let url = Bundle.main.url(forResource: "ing", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let ingredients = try JSONDecoder().decode([Ingredient].self, from: data)
            
            DispatchQueue.main.async {
                self.allIngredients = ingredients
                self.filteredIngredients = ingredients
            }
        } catch {
            print("Error loading ingredients: \(error)")
        }
    }
    
    func search() {
        if searchText.isEmpty {
            filteredIngredients = []
        } else {
            filteredIngredients = allIngredients.filter { $0.term.localizedCaseInsensitiveContains(searchText) }
                .sorted(by: { $0.useCount > $1.useCount })
        }
    }
}
