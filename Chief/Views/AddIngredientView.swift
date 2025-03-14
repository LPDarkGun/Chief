import SwiftUI

struct AddIngredientView: View {
    @State private var ingredientInput: String = ""
    @State private var ingredients: [String] = []
    @State private var showRecipes = false
    @StateObject private var viewModel = IngredientViewModel()
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search ingredients...", text: $ingredientInput)
                            .onChange(of: ingredientInput) { newValue in
                                viewModel.searchText = newValue
                                viewModel.search()
                                isSearching = !newValue.isEmpty
                            }
                        
                        if !ingredientInput.isEmpty {
                            Button(action: {
                                ingredientInput = ""
                                viewModel.searchText = ""
                                viewModel.search()
                                isSearching = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color("SearchBarBackground"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    if isSearching {
                        // Search Results
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                ForEach(viewModel.filteredIngredients.prefix(8)) { ingredient in
                                    IngredientCard(ingredient: ingredient, onTap: {
                                        if !ingredients.contains(ingredient.term) {
                                            ingredients.append(ingredient.term)
                                        }
                                        ingredientInput = ""
                                        isSearching = false
                                    })
                                }
                            }
                            .padding()
                        }
                        .transition(.opacity)
                    } else {
                        // Selected Ingredients
                        if ingredients.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "basket")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("No ingredients selected")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        } else {
                            ScrollView {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                    ForEach(ingredients, id: \.self) { ingredient in
                                        SelectedIngredientCard(ingredient: ingredient, onRemove: {
                                            ingredients.removeAll(where: { $0 == ingredient })
                                        })
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        Spacer()
                        
                        // Show Recipes Button
                        Button(action: {
                            showRecipes = true
                        }) {
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("Show Recipes")
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ingredients.isEmpty ? Color.gray : Color("AccentColor"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color("AccentColor").opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(ingredients.isEmpty)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Ingredients")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showRecipes) {
                RecipeListView(selectedIngredients: ingredients)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct IngredientCard: View {
    let ingredient: Ingredient
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading) {
                Text(ingredient.term.capitalized)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Used \(formatNumber(ingredient.useCount)) times")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color("CardBackground"))
            .cornerRadius(12)
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000)
        }
        return "\(number)"
    }
}

struct SelectedIngredientCard: View {
    let ingredient: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Text(ingredient.capitalized)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(12)
    }
}

// View Model for Ingredients
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
            filteredIngredients = allIngredients.filter { $0.searchValue.localizedCaseInsensitiveContains(searchText) }
                .sorted(by: { $0.useCount > $1.useCount })
        }
    }
}

