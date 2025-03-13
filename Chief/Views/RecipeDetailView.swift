import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(recipe.Title)
                    .font(.largeTitle)
                    .padding(.top)
                
                // Display image or a default image if none provided
                if !recipe.Image_Name.isEmpty {
                    Image(recipe.Image_Name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Text("Ingredients")
                    .font(.headline)
                
                ForEach(recipe.Cleaned_Ingredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                }
                
                Text("Instructions")
                    .font(.headline)
                    .padding(.top)
                
                Text(recipe.Instructions)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle(recipe.Title)
    }
}
