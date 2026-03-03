import Foundation
import SwiftData

@Model
final class Coffee {
    var name: String
    var category: String // Espresso, Milk Based, Manual Brew
    var price: Double
    var details: String // GANTI DARI 'description' MENJADI 'details'
    var roastLevel: Int // 1-5
    var image: String // Nama icon atau nama file gambar
    var isFavorite: Bool = false
    
    init(name: String, category: String, price: Double, details: String, roastLevel: Int, image: String) {
        self.name = name
        self.category = category
        self.price = price
        self.details = details
        self.roastLevel = roastLevel
        self.image = image
    }
}
