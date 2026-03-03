import SwiftUI
import SwiftData

struct CartView: View {
    @Query var cartItems: [CartItem]
    @Environment(\.modelContext) private var modelContext
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var body: some View {
        VStack {
            if cartItems.isEmpty {
                ContentUnavailableView("Keranjang Kosong", systemImage: "cart.badge.minus", description: Text("Ayo pilih kopi favoritmu dulu!"))
            } else {
                List {
                    ForEach(cartItems) { item in
                        HStack(spacing: 15) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.title)
                                .foregroundColor(.coffeeDark)
                                .frame(width: 50, height: 50)
                                .background(Color.coffeeLight.opacity(0.1))
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("Size: \(item.size)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("Rp \(item.price, specifier: "%.0f")")
                                .fontWeight(.semibold)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                // Total Section
                VStack(spacing: 15) {
                    HStack {
                        Text("Total Pembayaran")
                            .font(.headline)
                        Spacer()
                        Text("Rp \(totalPrice, specifier: "%.0f")")
                            .font(.title3).bold()
                            .foregroundColor(.coffeeDark)
                    }
                    .padding(.horizontal)
                    
                    Button(action: { /* Logic Checkout */ }) {
                        Text("Checkout Sekarang")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.coffeeDark)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top)
                .background(.white)
                .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
            }
        }
        .navigationTitle("Keranjang")
    }
    
    func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cartItems[index])
        }
    }
}
