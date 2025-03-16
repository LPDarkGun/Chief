import SwiftUI

struct AddIngredientView: View {
    @State private var ingredientInput: String = ""
    @State private var selectedIngredients: [String] = []
    @State private var showRecipes = false
    @StateObject private var viewModel = IngredientViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main background
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Custom navigation title with gradient
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add Ingredients")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("What's in your kitchen?")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    // Custom search field
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
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
                            .shadow(color: Color.white.opacity(0.05), radius: 8, x: 0, y: 4)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                            
                            TextField("", text: $ingredientInput)
                                .placeholder(when: ingredientInput.isEmpty) {
                                    Text("Search for an ingredient...")
                                        .foregroundColor(.gray)
                                }
                                .foregroundColor(.white)
                                .accentColor(.orange)
                                .padding(.vertical, 12)
                            
                            if !ingredientInput.isEmpty {
                                Button(action: {
                                    ingredientInput = ""
                                    viewModel.searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 12)
                                }
                            }
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 24)
                    .onChange(of: ingredientInput) { _, newValue in
                        viewModel.searchText = newValue
                    }
                    
                    // Display suggestions with styled look
                    if !viewModel.suggestions.isEmpty {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(viewModel.suggestions, id: \.id) { ingredient in
                                    Button(action: {
                                        if !selectedIngredients.contains(ingredient.term) {
                                            selectedIngredients.append(ingredient.term)
                                            
                                            // Add subtle haptic feedback
                                            let impact = UIImpactFeedbackGenerator(style: .light)
                                            impact.impactOccurred()
                                        }
                                        ingredientInput = ""
                                        viewModel.searchText = ""
                                    }) {
                                        HStack {
                                            Text(ingredient.term.capitalized)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 12)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.horizontal, 16)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    if ingredient.id != viewModel.suggestions.last?.id {
                                        Divider()
                                            .background(Color.gray.opacity(0.2))
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        }
                        .frame(height: min(CGFloat(viewModel.suggestions.count * 44) + 16, 250))
                    }
                    
                    // Selected ingredients section
                    VStack(alignment: .leading) {
                        if !selectedIngredients.isEmpty {
                            HStack {
                                Text("SELECTED INGREDIENTS")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button(action: {
                                    selectedIngredients.removeAll()
                                }) {
                                    Text("Clear All")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 12)
                            
                            // Ingredient chips in a flowing layout
                            FlowLayout(spacing: 10) {
                                ForEach(selectedIngredients, id: \.self) { ingredient in
                                    SelectedIngredientChip(
                                        ingredient: ingredient,
                                        onDelete: {
                                            if let index = selectedIngredients.firstIndex(of: ingredient) {
                                                selectedIngredients.remove(at: index)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        } else {
                            // Empty state
                            VStack(spacing: 16) {
                                Image(systemName: "cart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("No ingredients selected")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Text("Search and add ingredients to find matching recipes")
                                    .font(.caption)
                                    .foregroundColor(.gray.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        }
                    }
                    
                    Spacer()
                    
                    // Show Recipes button
                    Button(action: {
                        showRecipes = true
                        print("NET")
                    }) {
                        Text("Show Recipes")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                selectedIngredients.isEmpty ?
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        selectedIngredients.isEmpty ?
                                        Color.gray.opacity(0.2) :
                                        Color.orange.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(
                                color: selectedIngredients.isEmpty ?
                                Color.clear :
                                Color.orange.opacity(0.3),
                                radius: 8, x: 0, y: 4
                            )
                            .foregroundColor(.white)
                    }
                    .disabled(selectedIngredients.isEmpty)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showRecipes) {
                RecipeListView(selectedIngredients: selectedIngredients)
            }
        }
    }
}

// MARK: - Supporting Views

// Flow layout for ingredient chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width {
                // Move to next row
                y += maxHeight + spacing
                x = 0
                maxHeight = 0
            }
            
            maxHeight = max(maxHeight, size.height)
            x += size.width + spacing
        }
        
        height = y + maxHeight
        
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var x = bounds.minX
        var y = bounds.minY
        var maxHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            
            if x + size.width > bounds.width + bounds.minX {
                // Move to next row
                y += maxHeight + spacing
                x = bounds.minX
                maxHeight = 0
            }
            
            view.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )
            
            maxHeight = max(maxHeight, size.height)
            x += size.width + spacing
        }
    }
}

// Selected ingredient chip with delete option
struct SelectedIngredientChip: View {
    var ingredient: String
    var onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(ingredient.capitalized)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.gray.opacity(0.15))
                .overlay(
                    Capsule()
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
        )
        .foregroundColor(.white)
    }
}

// TextField placeholder extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

