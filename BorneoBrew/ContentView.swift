import SwiftUI
import SwiftData

struct ContentView: View {
    // 1. Mengambil data kopi dan item keranjang secara real-time
    @Query(sort: \Coffee.name) var coffees: [Coffee]
    @Query var cartItems: [CartItem] // Untuk menghitung badge di ikon keranjang
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedCategory = "All"
    let categories = ["All", "Espresso", "Milk Based", "Manual Brew"]
    
    // 2. Logika untuk menyaring kopi berdasarkan kategori yang dipilih
    var filteredCoffees: [Coffee] {
        if selectedCategory == "All" {
            return coffees
        } else {
            return coffees.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // --- Header Section ---
                    VStack(alignment: .leading) {
                        Text("Selamat pagi, Derry")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Mau ngopi apa hari ini?")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    }
                    .padding(.horizontal)
                    
                    // --- Category Selection ---
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryButton(title: category, isSelected: selectedCategory == category) {
                                    withAnimation(.spring()) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // --- Hero Promo Section ---
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(colors: [.brown, .black.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 180)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Promo Khatulistiwa")
                                .font(.caption).bold()
                                .padding(6)
                                .background(.white.opacity(0.2))
                                .clipShape(Capsule())
                            
                            Text("Diskon 20% untuk Manual Brew pagi ini.")
                                .font(.headline)
                        }
                        .padding(25)
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    
                    // --- Coffee Grid Section ---
                    Text("Pilihan Untukmu")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if coffees.isEmpty {
                        ContentUnavailableView(
                            "Belum ada menu",
                            systemImage: "cup.and.saucer",
                            description: Text("Gunakan tombol + untuk menambah menu kopi baru.")
                        )
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(filteredCoffees) { coffeeItem in
                                NavigationLink(destination: CoffeeDetailView(coffee: coffeeItem)) {
                                    CoffeeCard(coffee: coffeeItem)
                                }
                                .buttonStyle(PlainButtonStyle())
                                // Fitur Hapus dengan tekan lama (Context Menu)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            modelContext.delete(coffeeItem)
                                            try? modelContext.save()
                                        }
                                    } label: {
                                        Label("Hapus Menu", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("BorneoBrew")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                // Toolbar Item Kanan: Tombol Keranjang & Tambah Data
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 15) {
                        // Navigasi ke Halaman Keranjang
                        NavigationLink(destination: CartView()) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "cart")
                                    .font(.title3)
                                
                                // Badge jumlah item di keranjang
                                if !cartItems.isEmpty {
                                    Text("\(cartItems.count)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 16, height: 16)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 8, y: -8)
                                }
                            }
                        }
                        
                        // Tombol Tambah Data Dummy
                        Button(action: {
                            withAnimation(.spring()) {
                                addSampleData()
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.title3)
                                .bold()
                        }
                    }
                }
            }
        }
    }
    
    private func addSampleData() {
        let samples = [
            Coffee(name: "Espresso", category: "Espresso", price: 25000, details: "Ekstrak kopi murni yang kuat dan kental khas Pontianak.", roastLevel: 4, image: "cup"),
            Coffee(name: "Latte Borneo", category: "Milk Based", price: 35000, details: "Espresso dengan susu lembut dan sentuhan gula aren lokal.", roastLevel: 2, image: "cup"),
            Coffee(name: "Kopi Tubruk", category: "Manual Brew", price: 18000, details: "Kopi hitam klasik dengan aroma yang sangat tajam.", roastLevel: 5, image: "cup")
        ]
        
        for item in samples {
            modelContext.insert(item)
        }
        
        do {
            try modelContext.save()
            print("Data berhasil disimpan!")
        } catch {
            print("Gagal menyimpan: \(error.localizedDescription)")
        }
    }
}

// MARK: - Komponen Pendukung Tetap Sama
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.brown : Color.white)
                .foregroundColor(isSelected ? .white : .brown)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.05), radius: 5)
        }
    }
}

struct CoffeeCard: View {
    let coffee: Coffee
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.brown.opacity(0.1))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.largeTitle)
                            .foregroundColor(.brown)
                    )
                    .cornerRadius(20)
                
                if coffee.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .padding(10)
                        .background(.white.opacity(0.8))
                        .clipShape(Circle())
                        .padding(8)
                }
            }
            
            Text(coffee.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Rp \(coffee.price, specifier: "%.0f")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.03), radius: 10)
    }
}
