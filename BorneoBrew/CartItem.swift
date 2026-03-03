import Foundation
import SwiftData

@Model
final class CartItem {
    var name: String
    var price: Double
    var size: String // S, M, L
    var quantity: Int
    var image: String
    
    init(name: String, price: Double, size: String, quantity: Int = 1, image: String) {
        self.name = name
        self.price = price
        self.size = size
        self.quantity = quantity
        self.image = image
    }
}
