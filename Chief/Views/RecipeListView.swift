import SwiftUI

struct RecipeListView: View {
    var selectedIngredients: [String]
    @State private var recipes: [Recipe] = []
    
    var body: some View {
        List(filteredRecipes) { recipe in
            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                Text(recipe.Title)
            }
        }
        .navigationTitle("Recipes")
        .onAppear {
            recipes = DataLoader.loadRecipes()
        }
    }
    
    var filteredRecipes: [Recipe] {
        if selectedIngredients.isEmpty {
            return recipes
        } else {
            return recipes.filter { recipe in
                // Check if any ingredient in Cleaned_Ingredients matches the selected ingredients
                for ingredient in recipe.Cleaned_Ingredients {
                    if selectedIngredients.contains(where: { ingredient.lowercased().contains($0.lowercased()) }) {
                        return true
                    }
                }
                return false
            }
        }
    }

}
