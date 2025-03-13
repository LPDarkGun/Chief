import SwiftUI

struct AddIngredientView: View {
    @State private var ingredientInput: String = ""
    @State private var ingredients: [String] = []
    @State private var showRecipes = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter ingredient", text: $ingredientInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Ingredient") {
                    if !ingredientInput.isEmpty {
                        ingredients.append(ingredientInput)
                        ingredientInput = ""
                    }
                }
                .padding()
                
                List(ingredients, id: \.self) { ing in
                    Text(ing)
                }
                
                Button(action: {
                    showRecipes = true
                }) {
                    Text("Show Recipes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Add Ingredients")
            .navigationDestination(isPresented: $showRecipes) {
                RecipeListView(selectedIngredients: ingredients)
            }
        }
    }
}
