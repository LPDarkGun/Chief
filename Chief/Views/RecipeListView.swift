import SwiftUI

struct RecipeListView: View {
    var selectedIngredients: [String]
    @State private var recipes: [Recipe] = []
    @State private var visibleCount = 5
    @State private var isLoading = true
    @State private var matchedRecipes: [(recipe: Recipe, matchCount: Int)] = []
    
    var body: some View {
        ZStack {
            // Background color
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Custom navigation title with gradient
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recipes")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("\(matchedRecipes.count) matches found")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // Selected ingredients pills
                if !selectedIngredients.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(selectedIngredients, id: \.self) { ingredient in
                                IngredientPill(text: ingredient)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                    }
                }
                
                if isLoading {
                    Spacer()
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.orange))
                            .scaleEffect(1.5)
                            .padding(.bottom, 16)
                        
                        Text("Finding the perfect recipes for you...")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    Spacer()
                } else if matchedRecipes.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.red.opacity(0.8))
                        
                        Text("No recipes found")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Try different ingredients or add more options")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(visibleRecipes, id: \.recipe.Id) { item in
                                NavigationLink(destination: RecipeDetailView(recipe: item.recipe)) {
                                    RecipeResultCard(recipe: item.recipe, matchCount: item.matchCount)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    if let lastRecipe = visibleRecipes.last, item.recipe.Id == lastRecipe.recipe.Id {
                                        loadMoreRecipes()
                                    }
                                }
                            }
                            
                            if visibleCount < matchedRecipes.count {
                                Button(action: {
                                    loadMoreRecipes()
                                }) {
                                    HStack {
                                        Text("Show More")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                    }
                                    .foregroundColor(.orange)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.15))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                            }
                            
                            // Bottom spacer for better scrolling
                            Color.clear.frame(height: 80)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .onAppear {
            loadRecipes()
        }
        .onChange(of: selectedIngredients) {
            filterRecipes()
        }
    }

    private func loadRecipes() {
        isLoading = true
        DataLoader.loadRecipes { loadedRecipes in
            print("✅ Recipes Loaded: \(loadedRecipes.count)")
            recipes = loadedRecipes
            isLoading = false
            filterRecipes()
        }
    }

    private func filterRecipes() {
        if selectedIngredients.isEmpty {
            print("✅ No ingredients selected. Showing all recipes.")
            matchedRecipes = recipes.map { ($0, 0) }
            return
        }

        print("🔎 Searching for ingredients: \(selectedIngredients)")

        var recipeMatchCount: [(Recipe, Int)] = []

        for recipe in recipes {
            let recipeIngredients = recipe.Cleaned_Ingredients.map { DataLoader.normalizeIngredient($0) }
            let matchCount = selectedIngredients.reduce(0) { count, ingredient in
                count + (recipeIngredients.contains(DataLoader.normalizeIngredient(ingredient)) ? 1 : 0)
            }

            if matchCount > 0 {
                recipeMatchCount.append((recipe, matchCount))
            }
        }

        // Sort by match count highest first
        recipeMatchCount.sort { $0.1 > $1.1 }

        print("🔍 Matched Recipes: \(recipeMatchCount.count)")
        for (index, match) in recipeMatchCount.prefix(5).enumerated() {
            print("🏆 Rank \(index + 1): \(match.0.Title) - Matches: \(match.1)")
        }

        matchedRecipes = recipeMatchCount
    }

    var visibleRecipes: [(recipe: Recipe, matchCount: Int)] {
        let visible = Array(matchedRecipes.prefix(visibleCount)) // ✅ FIXED
        print("🔄 Recalculating visible recipes: \(visible.count) of \(matchedRecipes.count)")
        return visible
    }

    private func loadMoreRecipes() {
        guard visibleCount < matchedRecipes.count else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            visibleCount += 5  // ✅ Increase by 5 for smooth loading
        }
    }
}

// Custom Views

struct IngredientPill: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.orange)
                    .overlay(
                        Capsule()
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(.white)
    }
}

struct RecipeResultCard: View {
    var recipe: Recipe
    var matchCount: Int
    
    var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.05),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.white.opacity(0.03), radius: 8, x: 0, y: 4)
            
            // Card Content
            HStack(spacing: 16) {
                // Recipe Image
                if let uiImage = UIImage(named: recipe.Image_Name) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.3),
                                            Color.clear
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white.opacity(0.6))
                        )
                }
                
                // Recipe Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.Title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        // Match count pills
                        Text("\(matchCount) ingredients matched")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
        .frame(height: 110)
    }
}

