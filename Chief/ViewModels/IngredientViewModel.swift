import Foundation
import Combine

class IngredientViewModel: ObservableObject {
    @Published var allIngredients: [Ingredient] = []
    @Published var searchText: String = ""
    @Published var suggestions: [Ingredient] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadIngredients()
        
        // Update suggestions as the search text changes
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.updateSuggestions(for: text)
            }
            .store(in: &cancellables)
    }
    
    private func loadIngredients() {
        if let url = Bundle.main.url(forResource: "ing", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let ingredients = try decoder.decode([Ingredient].self, from: data)
                DispatchQueue.main.async {
                    self.allIngredients = ingredients
                }
            } catch {
                print("Error loading ingredients: \(error)")
            }
        } else {
            print("ing.json not found")
        }
    }
    
    private func updateSuggestions(for text: String) {
        if text.isEmpty {
            suggestions = []
        } else {
            let lowerText = text.lowercased()
            // Filter and sort by useCount (popularity), then limit to 6 results.
            suggestions = allIngredients.filter { ingredient in
                ingredient.searchValue.lowercased().contains(lowerText) ||
                ingredient.term.lowercased().contains(lowerText)
            }
            .sorted { $0.useCount > $1.useCount }
            .prefix(6)
            .map { $0 }
        }
    }
}
