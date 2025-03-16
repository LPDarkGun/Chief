import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    // Pass in the search results (matched recipes) from your RecipeListView
    var matchedRecipes: [(recipe: Recipe, matchCount: Int)]? = nil

    @State private var favorited = false
    @State private var selectedSection: RecipeSection = .ingredients
    @State private var servings: Int = 2
    @State private var showShareSheet = false

    enum RecipeSection: String, CaseIterable {
        case ingredients = "Ingredients"
        case instructions = "Instructions"
        case nutrition = "Nutrition"
    }

    @Namespace private var namespace

    // Compute similar recipes from search results (excluding the current recipe)
    var similarRecipes: [(recipe: Recipe, matchCount: Int)] {
        if let matched = matchedRecipes {
            return matched.filter { $0.recipe.Id != recipe.Id }
        }
        return []
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image with gradient overlay
                ZStack(alignment: .bottomLeading) {
                    if let uiImage = UIImage(named: recipe.Image_Name) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
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
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                            Image(systemName: "fork.knife")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    // Hero content
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recipe.Title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            HStack(spacing: 12) {
                                Label("25 min", systemImage: "clock")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text("•")
                                    .foregroundColor(.gray)
                                
                                Label("Medium", systemImage: "flame")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Action buttons
                        HStack(spacing: 16) {
                            Button(action: {
                                favorited.toggle()
                            }) {
                                HStack {
                                    Image(systemName: favorited ? "heart.fill" : "heart")
                                    Text(favorited ? "Saved" : "Save")
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(favorited ? Color.orange : Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                            
                            Button(action: {
                                showShareSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share")
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                .frame(height: 300)
                
                // Main content card with elevated style
                ZStack {
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
                    
                    VStack(spacing: 0) {
                        // Servings adjuster
                        HStack {
                            Text("Servings")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    if servings > 1 { servings -= 1 }
                                }) {
                                    Image(systemName: "minus")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.gray.opacity(0.3))
                                        .clipShape(Circle())
                                }
                                
                                Text("\(servings)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .frame(width: 30)
                                
                                Button(action: {
                                    if servings < 10 { servings += 1 }
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.orange)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        
                        // Section tabs
                        HStack(spacing: 0) {
                            ForEach(RecipeSection.allCases, id: \.self) { section in
                                Button(action: {
                                    withAnimation { selectedSection = section }
                                }) {
                                    VStack(spacing: 8) {
                                        Text(section.rawValue)
                                            .foregroundColor(selectedSection == section ? .white : .gray)
                                            .fontWeight(selectedSection == section ? .bold : .regular)
                                        
                                        if selectedSection == section {
                                            Rectangle()
                                                .fill(Color.orange)
                                                .frame(height: 3)
                                                .matchedGeometryEffect(id: "underline", in: namespace)
                                        } else {
                                            Rectangle()
                                                .fill(Color.clear)
                                                .frame(height: 3)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.horizontal)
                        
                        // Content based on selected section
                        VStack {
                            switch selectedSection {
                            case .ingredients:
                                ingredientsView
                            case .instructions:
                                instructionsView
                            case .nutrition:
                                nutritionView
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, -40)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: ["\(recipe.Title) - A delicious recipe"])
        }
    }
    
    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(recipe.Cleaned_Ingredients, id: \.self) { ingredient in
                HStack(alignment: .center, spacing: 12) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 6, height: 6)
                    Text(ingredient)
                        .foregroundColor(.white.opacity(0.9))
                        .font(.system(size: 16))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    private var instructionsView: some View {
        VStack(alignment: .leading, spacing: 24) {
            let instructions = recipe.Instructions.split(separator: "\n")
            ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                HStack(alignment: .top, spacing: 16) {
                    Text("\(index + 1)")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(Color.orange)
                        .cornerRadius(14)
                    Text(String(instruction))
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(6)
                }
            }
        }
    }
    
    private var nutritionView: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                nutritionCard(title: "Calories", value: "320", unit: "kcal")
                nutritionCard(title: "Protein", value: "18", unit: "g")
            }
            HStack(spacing: 16) {
                nutritionCard(title: "Carbs", value: "45", unit: "g")
                nutritionCard(title: "Fat", value: "12", unit: "g")
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("Daily Values")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 8)
                nutritionBarRow(title: "Vitamin A", percentage: 25)
                nutritionBarRow(title: "Vitamin C", percentage: 60)
                nutritionBarRow(title: "Calcium", percentage: 15)
                nutritionBarRow(title: "Iron", percentage: 40)
            }
            .padding(.top, 10)
        }
    }
    
    private func nutritionCard(title: String, value: String, unit: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text(unit)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private func nutritionBarRow(title: String, percentage: Int) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text("\(percentage)%")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 40, alignment: .trailing)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    Capsule()
                        .fill(Color.orange)
                        .frame(width: geometry.size.width * CGFloat(percentage) / 100, height: 6)
                }
            }
            .frame(width: 100, height: 6)
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems,
                                 applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct SectionHeaderView: View {
    var title: String
    var actionTitle: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Button(action: {
                // Action for "See all"
            }) {
                Text(actionTitle)
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
        }
        .padding(.horizontal)
    }
}
