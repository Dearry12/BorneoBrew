BorneoBrew - iOS Coffee Shop App
BorneoBrew adalah aplikasi katalog dan pemesanan kopi modern yang dibangun menggunakan SwiftUI dan SwiftData. Proyek ini dirancang dengan fokus pada UI/UX yang estetik serta manajemen data lokal yang efisien. Aplikasi ini merupakan bagian dari eksplorasi pengembangan aplikasi iOS menggunakan teknologi terbaru dari Apple.

Fitur Utama
Dashboard Estetik: Navigasi menu kopi berdasarkan kategori (Espresso, Milk Based, Manual Brew) dengan tampilan kartu yang modern.

Detail Produk Interaktif: Informasi lengkap mengenai varian kopi, termasuk deskripsi, tingkat pemanggangan (roast level), dan pemilihan ukuran (S, M, L).

Sistem Favorit: Menandai kopi pilihan yang tersimpan secara permanen menggunakan database SwiftData.

Keranjang Belanja (Cart): Alur pemesanan lengkap mulai dari penambahan item hingga manajemen kuantitas otomatis (sinkronisasi stok).

Context Menu: Fitur manajemen menu yang memudahkan penghapusan item langsung dari dashboard.

Teknologi yang Digunakan
Bahasa: Swift

Framework UI: SwiftUI

Database: SwiftData (Local Persistence)

Architecture: MVVM Pattern

Alat Pengembangan: Xcode 26.2 di MacBook Pro M4 Pro

Struktur Proyek
Plaintext
BorneoBrew/
├── Models/          # SwiftData Models (Coffee, CartItem)
├── Views/           # Main Screens (ContentView, CoffeeDetailView, CartView)
├── Components/      # Reusable SwiftUI Components (SizeSelector, CategoryButton)
└── Utilities/       # Extensions & Helpers (Color+Ext)
Tampilan Aplikasi
Cara Menjalankan
Clone repositori ini:

Bash
git clone https://github.com/Dearry12/BorneoBrew.git
Buka file BorneoBrew.xcodeproj di Xcode.

Pastikan kamu menggunakan macOS 26.3 dan Xcode 26.2 ke atas.

Pilih simulator (contoh: iPhone 18) dan tekan Command + R.

Cara Menambahkan README ke GitHub:
Buat file baru di folder project kamu dengan nama README.md.

Tempelkan teks di atas ke dalam file tersebut.

Buka Terminal dan jalankan perintah berikut:

Bash
git add README.md
git commit -m "Add professional README for BorneoBrew"
git push
