import Foundation

struct Recipe: Identifiable, Codable {
    var Id: Int
    var Title: String
    var Ingredients: [String]
    var Instructions: String
    var Image_Name: String
    var Cleaned_Ingredients: [String]

    var id: Int { return Id }
    
    // Custom initializer for manual instantiation
    init(Id: Int, Title: String, Ingredients: [String], Instructions: String, Image_Name: String, Cleaned_Ingredients: [String]) {
        self.Id = Id
        self.Title = Title
        self.Ingredients = Ingredients
        self.Instructions = Instructions
        self.Image_Name = Image_Name
        self.Cleaned_Ingredients = Cleaned_Ingredients
    }
    
    // Custom decoding initializer for JSON decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Id = try container.decode(Int.self, forKey: .Id)
        Title = try container.decodeIfPresent(String.self, forKey: .Title)?.cleanedString() ?? "Untitled Recipe"
        
        let ingredientsString = try container.decodeIfPresent(String.self, forKey: .Ingredients) ?? "[]"
        Ingredients = Recipe.parseJsonArrayString(ingredientsString)

        Instructions = try container.decodeIfPresent(String.self, forKey: .Instructions)?.cleanedString() ?? "No instructions provided."
        
        Image_Name = try container.decodeIfPresent(String.self, forKey: .Image_Name) ?? ""
        
        let cleanedIngredientsString = try container.decodeIfPresent(String.self, forKey: .Cleaned_Ingredients) ?? "[]"
        Cleaned_Ingredients = Recipe.parseJsonArrayString(cleanedIngredientsString)
    }
    
    // Helper method to clean and properly format an array string from JSON
    private static func parseJsonArrayString(_ jsonString: String) -> [String] {
        let trimmed = jsonString.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        let items = trimmed.split(separator: ",")
        
        return items.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
              .replacingOccurrences(of: "\\/", with: "/") // Fix escaped slashes
              .replacingOccurrences(of: "\u{00b0}", with: "°") // Fix degree symbol
              .trimmingCharacters(in: CharacterSet(charactersIn: "'\"")) // Trim quotes
        }
    }
}

// String Extension to clean unwanted escape sequences
extension String {
    func cleanedString() -> String {
        return self
            .replacingOccurrences(of: "\\n", with: "\n")  // Fix new lines
            .replacingOccurrences(of: "\\/", with: "/")  // Fix escaped slashes
            .replacingOccurrences(of: "\u{00b0}", with: "°") // Fix degree symbol
            .replacingOccurrences(of: "\"Lasagne\"", with: "Lasagne") // Remove unnecessary quotes
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
