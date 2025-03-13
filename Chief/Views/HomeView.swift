import SwiftUI

struct HomeView: View {
    var body: some View {
        // Load all recipes from your JSON
        let allRecipes = DataLoader.loadRecipes()
        
        // Pick the first recipe (or fall back to a placeholder if none found)
        let featuredRecipe = allRecipes.first ?? Recipe(
            Id: 0,
            Title: "No Recipe Found",
            Ingredients: [],
            Instructions: "No instructions available.",
            Image_Name: "miso-butter-roast-chicken-acorn-squash-panzanella",
            Cleaned_Ingredients: []
        )
        
        // Get 3 featured recipes for the carousel
        let featuredRecipes = Array(allRecipes.prefix(3))
        
        return NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Section
                    ZStack(alignment: .bottomLeading) {
                        // Background Image
                        ZStack {
                            Rectangle()
                                .fill(Color(UIColor.systemBackground).opacity(0.3))
                                .frame(height: 300)
                            
                            Image(systemName: "photo.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        }
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0)]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        
                        // Hero Text
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Discover Delicious Recipes")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Find the perfect meal for any occasion")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.bottom, 8)
                            
                            NavigationLink(destination: RecipeDetailView(recipe: featuredRecipe)) {
                                Text("Featured Recipe: \(featuredRecipe.Title)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    
                    // Categories Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Popular Categories")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(["Breakfast", "Lunch", "Dinner", "Dessert", "Vegetarian"], id: \.self) { category in
                                    VStack {
                                        Circle()
                                            .fill(Color.blue.opacity(0.2))
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Image(systemName: categoryIcon(for: category))
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.blue)
                                            )
                                        
                                        Text(category)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Featured Recipes Section
                        Text("Featured Recipes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(featuredRecipes) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        VStack(alignment: .leading) {
                                            // Recipe thumbnail
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(10)
                                                .overlay(
                                                    Image(systemName: "fork.knife")
                                                        .font(.system(size: 40))
                                                        .foregroundColor(.gray)
                                                )
                                            
                                            Text(recipe.Title)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                                .lineLimit(2)
                                                .frame(width: 150, alignment: .leading)
                                            
                                            Text("\(recipe.Cleaned_Ingredients.count) ingredients!")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
    }
    
    // Helper function to determine icon for each category
    private func categoryIcon(for category: String) -> String {
        switch category {
        case "Breakfast":
            return "sunrise"
        case "Lunch":
            return "sun.max"
        case "Dinner":
            return "moon.stars"
        case "Dessert":
            return "birthday.cake"
        case "Vegetarian":
            return "leaf"
        default:
            return "fork.knife"
        }
    }
}
