# NutriMPASI Mobile

<p align="center">
  <img src="assets/images/logo/nutrimpasi.png" alt="NutriMPASI Logo" width="200"/>
</p>

NutriMPASI adalah aplikasi mobile berbasis Flutter yang dirancang untuk mendukung orang tua dalam memberikan makanan pendamping ASI yang bergizi untuk bayi mereka. Aplikasi ini menawarkan rekomendasi makanan personal berdasarkan profil bayi, informasi nutrisi, dan perencanaan makanan dengan panduan ahli.

## ✨ Fitur Utama

- **Manajemen Profil Bayi**: Buat dan kelola beberapa profil bayi dengan detail seperti usia, tinggi, berat, dan alergi
- **Rekomendasi Makanan Personal**: Dapatkan saran makanan yang disesuaikan berdasarkan usia dan kebutuhan nutrisi bayi
- **Eksplorasi Resep**: Jelajahi koleksi lengkap resep makanan bayi dari sumber terpercaya seperti WHO dan KEMENKES
- **Sistem Usulan Makanan**: Tambahkan resep makanan dan saran Anda ke komunitas
- **Riwayat Memasak**: Pantau makanan yang telah Anda siapkan untuk bayi
- **Konsultasi Ahli**: Terhubung dengan ahli gizi untuk mendapatkan saran profesional
- **Penjadwalan Makan**: Rencanakan dan atur jadwal makan bayi dengan pengingat
- **Pencarian & Filter**: Temukan resep dengan mudah berdasarkan bahan, kesesuaian usia, dan lainnya

## 📱 Screenshots

<p align="center">
  <!-- Tambahkan screenshot aplikasi di sini -->
  <img src="https://i.imgur.com/zgrPcum.png" width="200" alt="Layar Beranda"/>
  <img src="https://i.imgur.com/KETmwX1.png" width="200" alt="Daftar Makanan"/>
  <img src="https://i.imgur.com/y9tGNI9.png" width="200" alt="Detail Makanan"/>
</p>

## 🚀 Memulai

### Prasyarat

- Flutter SDK (^3.7.2)
- Dart SDK (^3.7.2)
- Android Studio / VS Code
- Laravel (untuk backend) - opsional jika ingin menjalankan secara lokal

### Instalasi

1. Clone repository ini:

   ```bash
   git clone https://github.com/rian1504/NutriMPASI-Mobile.git
   cd NutriMPASI-Mobile
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Buat file `.env` di direktori root dengan konten berikut:

   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. Menjalankan aplikasi:
   ```bash
   flutter run
   ```

### Menjalankan dengan Backend Lokal

Untuk menjalankan aplikasi dengan backend Laravel secara lokal:

1. Clone repository backend Laravel:

   ```bash
   git clone https://github.com/rian1504/NutriMPASI-Web.git
   cd NutriMPASI-Backend
   ```

2. Setup Laravel:

   ```bash
   composer install
   cp .env.example .env
   php artisan key:generate
   php artisan migrate --seed
   ```

3. Jalankan server Laravel:

   - Jika menggunakan emulator Android:
     ```bash
     php artisan serve
     ```
   - Jika menggunakan perangkat Android fisik:
     ```bash
     php artisan serve --host=0.0.0.0 --port=8000
     ```

4. Ubah pengaturan URL di `lib/constants/url.dart` pada flutter:
   - Untuk emulator Android, buka file `url.dart` dan gunakan:
     ```dart
     String baseUrl = 'http://10.0.2.2:8000/';
     ```
   - Untuk perangkat Android fisik, gunakan IP komputer Anda:
     ```dart
     String baseUrl = 'http://192.168.1.xxx:8000/';
     ```

## 🔧 Struktur Proyek

```
lib/
├── blocs/                  # Manajemen state dengan BLoC
├── constants/              # Konstanta aplikasi (warna, URL, dll)
├── controllers/            # Controller logika bisnis
├── models/                 # Model data
├── screens/                # Layar UI
│   ├── auth/               # Layar autentikasi
│   ├── baby/               # Layar profil bayi
│   ├── features/           # Layar fitur
│   ├── food/               # Layar terkait makanan
│   └── ...                 # Layar lainnya
├── main.dart               # Entry point
└── ...
```

## 🛠️ Dibangun Dengan

- [Flutter](https://flutter.dev/) - Framework UI
- [Flutter Bloc](https://pub.dev/packages/flutter_bloc) - Manajemen state
- [Curved Navigation Bar](https://pub.dev/packages/curved_navigation_bar) - Navigasi kustom
- [Material Symbols Icons](https://pub.dev/packages/material_symbols_icons) - Paket ikon
- [Google Generative AI](https://pub.dev/packages/google_generative_ai) - Fitur AI
- [Dio](https://pub.dev/packages/dio) - HTTP client
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) - Penyimpanan data aman

## 💎 Gaya Kode

Proyek ini mengikuti [Flutter style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) dan menggunakan [flutter_lints](https://pub.dev/packages/flutter_lints) untuk kualitas kode.

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan ajukan Pull Request.

1. Fork Proyek
2. Buat Branch Fitur (`git checkout -b feature/FiturKeren`)
3. Commit Perubahan (`git commit -m 'Menambahkan FiturKeren'`)
4. Push ke Branch (`git push origin feature/FiturKeren`)
5. Buka Pull Request

## 📄 Lisensi

Proyek ini dilisensikan di bawah Lisensi MIT - lihat file LICENSE untuk detail.

## 📬 Kontak

Link Proyek: [https://github.com/rian1504/NutriMPASI-Mobile](https://github.com/rian1504/NutriMPASI-Mobile)

## 🙏 Ucapan Terima Kasih

- [Tim Flutter](https://flutter.dev/)
- [World Health Organization (WHO)](https://www.who.int/)
- [Kementerian Kesehatan RI (KEMENKES)](https://www.kemkes.go.id/)
