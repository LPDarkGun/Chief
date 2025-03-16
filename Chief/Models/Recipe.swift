import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    var Id: Int
    var Title: String
    var Ingredients: [String]
    var Instructions: String
    var Image_Name: String
    var Cleaned_Ingredients: [String]
    
    var id: Int { return Id }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.Id == rhs.Id
    }
    
    // Custom initializer for manual instantiation
    init(Id: Int, Title: String, Ingredients: [String], Instructions: String, Image_Name: String, Cleaned_Ingredients: [String]) {
        self.Id = Id
        self.Title = Title
        self.Ingredients = Ingredients
        self.Instructions = Instructions
        self.Image_Name = Image_Name
        self.Cleaned_Ingredients = Cleaned_Ingredients.map { Recipe.cleanIngredient($0) }
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
        Cleaned_Ingredients = Recipe.parseJsonArrayString(cleanedIngredientsString).map { Recipe.cleanIngredient($0) }
    }
    
    private static func parseJsonArrayString(_ jsonString: String) -> [String] {
        if jsonString.hasPrefix("[") && jsonString.hasSuffix("]") {
            let trimmed = jsonString.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
            let items = trimmed.components(separatedBy: "', '")
            
            let cleanedArray = items.map {
                $0.replacingOccurrences(of: "\\/", with: "/")
                  .replacingOccurrences(of: "°", with: "°")
                  .replacingOccurrences(of: "'", with: "")
                  .replacingOccurrences(of: "\"", with: "")
                  .replacingOccurrences(of: " ,", with: ",")
                  .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            return cleanedArray
        }
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let decodedArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String] {
                    return decodedArray.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                }
            } catch {
                print("⚠️ JSON Parsing Failed: \(error.localizedDescription)")
            }
        }
        
        return [jsonString.trimmingCharacters(in: .whitespacesAndNewlines)]
    }
    
    static func cleanIngredient(_ ingredient: String) -> String {
        let measurementPattern = "\\b(\\d+[\\/\\d]*|lb|oz|cup|tsp|tbsp|quart|g|kg|ml|cl|dl|pound|can|packet|slice|piece|large|medium|small|whole|stick|bunch|tablespoons?|teaspoons?|ounces?|pounds?)\\b"
        let descriptorPattern = "\\b(chopped|minced|sliced|diced|crushed|divided|peeled|grated|zested|melted|toasted|cooled|rinsed|drained|packed|firmly|loosely|lightly|scant|generous|halved|quartered|thawed if frozen|room temperature|cored)\\b"
        let extraWordsPattern = "\\b(including juice|to taste|if canned|from package|plus additional for|for dusting|for sprinkling|for garnish|from 1 tea bag)\\b"

        var cleaned = ingredient.lowercased()

        // Remove measurements
        cleaned = cleaned.replacingOccurrences(of: measurementPattern, with: "", options: .regularExpression)

        // Remove descriptors but keep necessary ones
        cleaned = cleaned.replacingOccurrences(of: descriptorPattern, with: "", options: .regularExpression)

        // Remove extra words
        cleaned = cleaned.replacingOccurrences(of: extraWordsPattern, with: "", options: .regularExpression)

        // Remove unnecessary slashes and leading spaces
        cleaned = cleaned.replacingOccurrences(of: "^\\s*/\\s*", with: "", options: .regularExpression)

        // Fix misplaced commas
        cleaned = cleaned.replacingOccurrences(of: "\\s*,+", with: "", options: .regularExpression)

        // Trim spaces
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)

        return cleaned
    }


}

extension String {
    func cleanedString() -> String {
        return self
            .replacingOccurrences(of: "\\n", with: "\n")
            .replacingOccurrences(of: "\\/", with: "/")
            .replacingOccurrences(of: "°", with: "°")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
