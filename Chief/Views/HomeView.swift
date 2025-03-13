import SwiftUI

struct HomeView: View {
    var body: some View {
        let allRecipes = DataLoader.loadRecipes()
        
        let featuredRecipe = allRecipes.randomElement() ?? Recipe(
            Id: 0,
            Title: "No Recipe Found",
            Ingredients: [],
            Instructions: "No instructions available.",
            Image_Name: "miso-butter-roast-chicken-acorn-squash-panzanella",
            Cleaned_Ingredients: []
        )
        
        return NavigationView {
            VStack(alignment: .leading) {
                Text("Welcome to the Recipe App!")
                    .font(.largeTitle)
                    .padding()
                
                Text("Popular Recipe")
                    .font(.title2)
                    .padding(.horizontal)
                

                NavigationLink(destination: RecipeDetailView(recipe: featuredRecipe)) {
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding()
                        VStack(alignment: .leading) {
                            Text(featuredRecipe.Title.isEmpty ? "Featured Recipe" : featuredRecipe.Title)
                                .font(.headline)
                            Text("Tap to see details")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}
