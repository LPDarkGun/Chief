import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    @State private var favorited = false
    @State private var selectedSection: RecipeSection = .ingredients
    @State private var servings: Int = 2
    @State private var showShareSheet = false
    
    enum RecipeSection: String, CaseIterable {
        case ingredients = "Ingredients"
        case instructions = "Instructions"
        case nutrition = "Nutrition"
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "1A1A1A"), Color(hex: "0A0A0A")],
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Main content
            ScrollView {
                VStack(spacing: 0) {
                    // Hero image with interactive elements
                    ZStack(alignment: .bottomLeading) {
                        if !recipe.Image_Name.isEmpty {
                            Image(recipe.Image_Name)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 320)
                                .overlay(
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.clear, .black.opacity(0.7)],
                                                startPoint: .center,
                                                endPoint: .bottom
                                            )
                                        )
                                )
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "644AB5"), Color(hex: "301E5F")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(height: 320)
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "fork.knife")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60)
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Text("Gourmet Recipe")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        
                        // Floating action buttons
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                favorited.toggle()
                            }) {
                                Image(systemName: favorited ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(favorited ? .red : .white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.4))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                showShareSheet = true
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.4))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 90)
                        
                        // Recipe title and quick info
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recipe.Title)
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 1)
                            
                            HStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.orange)
                                    Text("25 min")
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                
                                HStack {
                                    Image(systemName: "flame")
                                        .foregroundColor(.orange)
                                    Text("Medium")
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Recipe card
                    VStack(spacing: 0) {
                        // Servings adjuster
                        HStack {
                            Text("Servings")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    if servings > 1 {
                                        servings -= 1
                                    }
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
                                    if servings < 10 {
                                        servings += 1
                                    }
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
                        .background(Color(hex: "222222"))
                        
                        // Section picker
                        HStack(spacing: 0) {
                            ForEach(RecipeSection.allCases, id: \.self) { section in
                                Button(action: {
                                    withAnimation {
                                        selectedSection = section
                                    }
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
                        .background(Color(hex: "222222"))
                        
                        // Section content
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
                        .background(Color(hex: "222222"))
                        .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                    }
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.2), radius: 16, x: 0, y: 5)
                    .padding(.horizontal, 16)
                    .padding(.top, -20)
                    
                    // Related recipes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You might also like")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.top, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(1...3, id: \.self) { _ in
                                    relatedRecipeCard
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(recipe.Title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
    }
    
    @Namespace private var namespace
    
    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(recipe.Cleaned_Ingredients, id: \.self) { ingredient in
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 6, height: 6)
                        .foregroundColor(.orange)
                    
                    Text(ingredient)
                        .foregroundColor(.white.opacity(0.9))
                        .font(.system(size: 16))
                        .lineLimit(nil)
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
                        .foregroundColor(.orange)
                        .frame(width: 24, height: 24)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(12)
                    
                    Text(String(instruction))
                        .foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(6)
                }
            }
        }
    }
    
    private var nutritionView: some View {
        VStack(spacing: 20) {
            HStack {
                nutritionCard(title: "Calories", value: "320", unit: "kcal")
                nutritionCard(title: "Protein", value: "18", unit: "g")
            }
            
            HStack {
                nutritionCard(title: "Carbs", value: "45", unit: "g")
                nutritionCard(title: "Fat", value: "12", unit: "g")
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Daily Values")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    nutritionBarRow(title: "Vitamin A", percentage: 25)
                    nutritionBarRow(title: "Vitamin C", percentage: 60)
                    nutritionBarRow(title: "Calcium", percentage: 15)
                    nutritionBarRow(title: "Iron", percentage: 40)
                }
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
        .background(Color(hex: "2A2A2A"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        .frame(width: 160)
    }
}

private var relatedRecipeCard: some View {
    VStack(alignment: .leading, spacing: 8) {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "3A3A3A"))
                .frame(width: 160, height: 120)
            
            Image(systemName: "fork.knife")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .padding(8)
                .foregroundColor(.white.opacity(0.6))
        }
        
        VStack(alignment: .leading, spacing: 4) {
            Text("Similar Recipe")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(1)
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
                
                Text("20 min")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
                
                Text("4.5")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 6)
        .padding(.bottom, 6)
    }
    .background(Color(hex: "2A2A2A"))
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
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: geometry.size.width, height: 6)
                    .cornerRadius(3)
                
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: geometry.size.width * CGFloat(percentage) / 100, height: 6)
                    .cornerRadius(3)
            }
        }
        .frame(width: 100, height: 6)
    }
}


// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
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
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: geometry.size.width, height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: geometry.size.width * CGFloat(percentage) / 100, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(width: 100, height: 6)
        }
    }
    
    private var relatedRecipeCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "3A3A3A"))
                    .frame(width: 160, height: 120)
                
                Image(systemName: "fork.knife")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .padding(8)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Similar Recipe")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.orange)
                        .font(.system(size: 12))
                    
                    Text("20 min")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 12))
                    
                    Text("4.5")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 6)
        }
        .background(Color(hex: "2A2A2A"))
    }
}
