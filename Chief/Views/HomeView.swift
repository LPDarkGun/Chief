import SwiftUI

struct HomeView: View {
    @StateObject var recipeManager = RecipeManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    ZStack(alignment: .bottomLeading) {
                        // Hero Background with Gradient Overlay
                        ZStack(alignment: .center) {
                            Image("hero-background")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipped()
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.black.opacity(0.8),
                                            Color.black.opacity(0.3)
                                        ]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                            
                           
                        }
                        
                        // Hero Content
                        VStack(alignment: .leading, spacing: 20) {
                            // App brand and tagline
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mr.Chief")
                                    .font(.system(size: 42, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                
                                
                                Text("Elevate your culinary journey")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                            }
                            
      
                            FeaturedRecipeCard(recipes: recipeManager.recipes)


                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                    .frame(height: 300)
                    
                    // Category Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryPill(icon: "flame.fill", text: "Trending", isActive: true)
                            CategoryPill(icon: "clock", text: "Quick & Easy")
                            CategoryPill(icon: "leaf", text: "Vegetarian")
                            CategoryPill(icon: "heart.fill", text: "Healthy")
                            CategoryPill(icon: "star.fill", text: "Popular")
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(recipeManager.recipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCard(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    SectionHeader(title: "New Recipes", actionTitle: "Explore more")
                        .padding(.top, 8)
                    
                    Spacer(minLength: 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(recipeManager.recipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCard(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 80)
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FeaturedRecipeCard: View {
    @Environment(\.selectedTab) private var selectedTab // Access selectedTab
    var recipes: [Recipe] // Pass all recipes

    var body: some View {
        // Find recipe with ID 2172, fallback if not found
        let featuredRecipe = recipes.first(where: { $0.Id == 2172 }) ?? Recipe(
            Id: 2172,
            Title: "Default Recipe",
            Ingredients: ["No Ingredients Found"],
            Instructions: "No instructions available.",
            Image_Name: "veggie-sushi-hand-roll",
            Cleaned_Ingredients: []
        )

        ZStack(alignment: .bottomLeading) {
            // Card Background
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.white.opacity(0.05), radius: 10, x: 0, y: 4)

            // Card Content
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("FEATURED")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.orange)

                    Text(featuredRecipe.Title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 8) {
                        Label("20 min", systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text("•")
                            .foregroundColor(.gray)

                        Label("Easy", systemImage: "star.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // Switch to AddIngredientView
                    Button(action: {
                        selectedTab.wrappedValue = .addIngredient
                    }) {
                        Text("Cook Now")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding(.vertical, 4)

                Spacer()

                // Right side: Image
                if let uiImage = UIImage(named: featuredRecipe.Image_Name) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.4),
                                            Color.clear
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white.opacity(0.6))
                        )
                }
            }
            .padding(20)
        }
        .frame(height: 160)
    }
}


struct CategoryPill: View {
    var icon: String
    var text: String
    var isActive: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
            
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(isActive ? Color.orange : Color.gray.opacity(0.15))
                .overlay(
                    Capsule()
                        .stroke(
                            isActive ?
                                Color.orange.opacity(0.1) :
                                Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .foregroundColor(isActive ? .white : .gray)
    }
}

struct RecipeCard: View {
    var recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let uiImage = UIImage(named: recipe.Image_Name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 250)
                    .clipped()
            } else {
                ZStack {
                    Color.white
                    Image(systemName: "fork.knife")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black.opacity(0.6))
                }
                .frame(width: 200, height: 250)
                .cornerRadius(16)
            }

            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(width: 200, height: 250)
            .cornerRadius(16)

            VStack(alignment: .leading, spacing: 6) {
                Text("NEW")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                
                Spacer()
                
                Text(recipe.Title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                    .lineLimit(2)
            }
            .padding()
        }
        .frame(width: 200, height: 250)
        .cornerRadius(16)
    }
}

struct SectionHeader: View {
    var title: String
    var actionTitle: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {}) {
                Text(actionTitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}



#Preview {
    HomeView()
}
