import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(recipe.Title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white) // ✅ White text
                    .padding(.top)
                
                if !recipe.Image_Name.isEmpty {
                    Image(recipe.Image_Name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .padding(.bottom)
                } else {
                    ZStack {
                        Color.white
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.bottom)
                }

                Text("📝 Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white) // ✅ White text
                
                ForEach(recipe.Cleaned_Ingredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                        .foregroundColor(.white) // ✅ White text
                }

                Text("📖 Instructions")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white) // ✅ White text
                    .padding(.top)

                Text(recipe.Instructions)
                    .foregroundColor(.white) // ✅ White text
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // ✅ Black background
        .navigationTitle(recipe.Title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
