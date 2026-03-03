import SwiftUI
import SwiftData

struct CoffeeDetailView: View {
    // Kita ganti nama String menjadi objek Coffee agar bisa akses .isFavorite
    @Bindable var coffee: Coffee
    @State private var selectedSize = "M"
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Hero Image Section
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.coffeeLight.opacity(0.3))
                    .frame(height: 400)
                    .overlay(
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 150))
                            .foregroundStyle(Color.coffeeDark)
                    )
                
                // Top Bar (Back & Favorite)
                HStack {
                    // Back Button
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // TOMBOL FAVORIT
                    Button(action: {
                        coffee.isFavorite.toggle()
                    }) {
                        Image(systemName: coffee.isFavorite ? "heart.fill" : "heart")
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .foregroundColor(coffee.isFavorite ? .red : .primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
            }
            
            // Content Section
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(coffee.name)
                            .font(.system(size: 32, weight: .bold))
                        Text("Premium Selection")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("Rp \(coffee.price, specifier: "%.0f")")
                        .font(.title2).bold()
                        .foregroundColor(.coffeeDark)
                }
                
                Text("Description")
                    .font(.headline)
                Text(coffee.details) // Menggunakan data dari model
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Size")
                    .font(.headline)
                SizeSelector(selectedSize: $selectedSize)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Add to Cart Button
                Button(action: { /* Logic Tambah ke Keranjang */ }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.coffeeDark)
                        .cornerRadius(20)
                }
            }
            .padding(30)
            .background(.white)
            .cornerRadius(40, corners: [.topLeft, .topRight])
            .offset(y: -40)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

// Helper tetap sama seperti kodemu sebelumnya
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
