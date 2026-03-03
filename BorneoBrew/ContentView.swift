import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedCategory = "All"
    let categories = ["All", "Espresso", "Milk Based", "Manual Brew"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Section
                    VStack(alignment: .leading) {
                        Text("Selamat pagi, Derry")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Mau ngopi apa hari ini?")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    }
                    .padding(.horizontal)
                    
                    // Category Selection
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryButton(title: category, isSelected: selectedCategory == category) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Featured Card (Hero Section)
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
                    
                    // Coffee Grid (Placeholder untuk sekarang)
                    Text("Pilihan Untukmu")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Di dalam LazyVGrid di ContentView.swift
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        // Kita buat contoh untuk 4 item kopi
                        let coffeeList = ["Espresso", "Latte", "Cappuccino", "Macchiato"]
                        
                        ForEach(coffeeList, id: \.self) { coffeeName in
                            // Navigasi saat kartu diklik
                            NavigationLink(destination: CoffeeDetailView(coffeeName: coffeeName)) {
                                CoffeeCard(name: coffeeName)
                            }
                            .buttonStyle(PlainButtonStyle()) // Agar warna teks tidak berubah menjadi biru link
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("BorneoBrew")
            .background(Color(.systemGroupedBackground))
        }
    }
}

// Komponen Kecil agar Kode Rapi
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
                .background(isSelected ? .brown : .white)
                .foregroundColor(isSelected ? .white : .brown)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.05), radius: 5)
        }
    }
}

struct CoffeeCard: View {
    let name: String // Tambahkan parameter ini
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color.coffeeLight.opacity(0.2))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.largeTitle)
                        .foregroundColor(.coffeeDark)
                )
                .cornerRadius(20)
            
            Text(name) // Tampilkan nama yang sesuai
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Rp35.000")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.white)
        .cornerRadius(25)
        .transition(.move(edge: .bottom)) // Animasi muncul dari bawah
    }
}
