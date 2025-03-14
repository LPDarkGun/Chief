import SwiftUI

struct HomeView: View {
    @StateObject var recipeManager = RecipeManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Mr.Chief")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    SectionHeader(title: "New Recipes", actionTitle: "Explore more")
                    
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
                .padding(.vertical)
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(StackNavigationViewStyle())
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

struct SearchView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Text("Find Recipes")
                .foregroundColor(.white)
        }
    }
}

struct CartView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Text("Shopping List")
                .foregroundColor(.white)
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Text("Saved Recipes")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    HomeView()
}
