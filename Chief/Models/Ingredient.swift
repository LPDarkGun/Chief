import Foundation

struct Ingredient: Identifiable, Codable {
    var id: String
    var ingredientId: String
    var searchValue: String
    var term: String
    var useCount: Int
}
