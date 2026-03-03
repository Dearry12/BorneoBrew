import SwiftUI
import SwiftData

struct CoffeeDetailView: View {
    // Akses ke database SwiftData
    @Environment(\.modelContext) private var modelContext
    
    // Objek kopi yang sedang dilihat
    @Bindable var coffee: Coffee
    
    // State untuk UI
    @State private var selectedSize = "M"
    @State private var showSuccessAlert = false // Feedback saat berhasil tambah ke cart
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // --- Hero Image Section ---
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
                    
                    // Tombol Favorit
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
            
            // --- Content Section ---
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
                Text(coffee.details)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Size")
                    .font(.headline)
                SizeSelector(selectedSize: $selectedSize)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                // --- Logic & Button Tambah ke Keranjang ---
                Button(action: {
                    addToCart()
                }) {
                    HStack {
                        if showSuccessAlert {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Added to Cart!")
                        } else {
                            Text("Add to Cart")
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(showSuccessAlert ? Color.green : Color.coffeeDark)
                    .cornerRadius(20)
                }
                .disabled(showSuccessAlert) // Mencegah klik ganda saat animasi
            }
            .padding(30)
            .background(.white)
            .cornerRadius(40, corners: [.topLeft, .topRight])
            .offset(y: -40)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    // FUNGSI: Menambah data ke database CartItem
    private func addToCart() {
        // 1. Ambil nilai ke variabel lokal (Penting untuk SwiftData Predicate)
        let targetName = coffee.name
        let targetSize = selectedSize
        
        // 2. Cari apakah item yang sama persis sudah ada di keranjang?
        let descriptor = FetchDescriptor<CartItem>(
            predicate: #Predicate<CartItem> { item in
                item.name == targetName && item.size == targetSize
            }
        )
        
        do {
            let existingItems = try modelContext.fetch(descriptor)
            
            if let existingItem = existingItems.first {
                // Jika sudah ada, cukup tambah jumlahnya (Sinkronisasi Stok)
                existingItem.quantity += 1
            } else {
                // Jika belum ada, buat item baru
                let newItem = CartItem(
                    name: coffee.name,
                    price: coffee.price,
                    size: selectedSize,
                    quantity: 1,
                    image: "cup.and.saucer.fill"
                )
                modelContext.insert(newItem)
            }
            
            // 3. Simpan perubahan secara permanen
            try modelContext.save()
            
            // Efek visual sukses
            withAnimation(.spring()) {
                showSuccessAlert = true
            }
            
        } catch {
            print("Gagal memproses keranjang: \(error.localizedDescription)")
        }
    }
}

// --- Helper Extensions ---
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
