import SwiftUI

struct SizeSelector: View {
    @Binding var selectedSize: String
    let sizes = ["S", "M", "L"]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(sizes, id: \.self) { size in
                Button(action: { selectedSize = size }) {
                    Text(size)
                        .font(.headline)
                        .frame(width: 60, height: 60)
                        .background(selectedSize == size ? Color.coffeeDark : Color.white)
                        .foregroundColor(selectedSize == size ? .white : .coffeeDark)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.coffeeDark, lineWidth: 1))
                }
                .animation(.spring(), value: selectedSize)
            }
        }
    }
}
