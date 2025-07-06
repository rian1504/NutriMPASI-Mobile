# NutriMPASI Mobile

<p align="center">
  <img src="assets/images/logo/nutrimpasi.png" alt="NutriMPASI Logo" width="200"/>
</p>

NutriMPASI adalah aplikasi mobile berbasis Flutter yang dirancang untuk mendukung orang tua dalam memberikan makanan pendamping ASI yang bergizi untuk bayi mereka. Aplikasi ini menawarkan rekomendasi makanan personal berdasarkan profil bayi, informasi nutrisi, perencanaan makanan dengan panduan ahli, serta fitur komunitas dan konsultasi terintegrasi.

## ✨ Fitur Utama

### 🔐 Autentikasi & Keamanan

- **Login & Registrasi**: Sistem autentikasi yang aman dengan validasi email
- **Reset Password**: Fitur reset password melalui deep linking dan email
- **Secure Storage**: Penyimpanan token dan data sensitif dengan enkripsi
- **Auto-login**: Sistem remember login untuk kemudahan pengguna

### 👶 Manajemen Profil Bayi

- **Multi-Profile**: Buat dan kelola beberapa profil bayi
- **Detail Lengkap**: Usia, tinggi, berat, tanggal lahir, jenis kelamin, dan informasi alergi
- **Rekomendasi Personal**: Saran makanan yang disesuaikan berdasarkan profil bayi

### 🍽️ Eksplorasi & Rekomendasi Makanan

- **Database Resep Lengkap**: Koleksi resep dari sumber terpercaya (WHO, KEMENKES)
- **Kategorisasi**: Makanan berdasarkan usia (6-8 bulan, 9-11 bulan, 12+ bulan)
- **Filter Canggih**: Pencarian berdasarkan bahan, nutrisi, dan kesesuaian usia
- **Detail Nutrisi**: Informasi lengkap kalori, protein, karbohidrat, dan vitamin
- **Langkah Memasak**: Panduan step-by-step dengan gambar
- **Sistem Favorit**: Simpan resep favorit untuk akses cepat

### 🤖 AI-Powered Features

- **Rekomendasi Cerdas**: Menggunakan Google Generative AI untuk saran makanan personal
- **Kalkulator Nutrisi**: AI membantu menghitung nutrisi berdasarkan informasi usulan makanan pengguna

### 📋 Riwayat & Pelacakan

- **Food Record**: Catat makanan yang telah diberikan kepada bayi
- **Cooking History**: Pantau resep yang telah dimasak

### 🗓️ Penjadwalan & Pengingat

- **Schedule Management**: Buat dan kelola jadwal makan harian
- **Push Notifications**: Pengingat otomatis untuk waktu makan

### 💬 Forum Komunitas

- **Discussion Threads**: Berbagi pengalaman dan tips dengan orang tua lain
- **Like & Comment System**: Interaksi sosial dalam komunitas
- **Content Moderation**: Sistem pelaporan untuk menjaga kualitas konten

### 👩‍⚕️ Konsultasi Ahli

- **Nutritionist Profiles**: Akses ke profil ahli gizi bersertifikat
- **Expert Consultation**: Konsultasi langsung dengan ahli nutrisi
- **Professional Advice**: Saran medis dan nutrisi dari tenaga profesional

### 🔔 Sistem Notifikasi

- **Firebase Cloud Messaging**: Notifikasi real-time
- **Notification History**: Riwayat semua notifikasi

### 🔗 Deep Linking & Navigation

- **App Links**: Buka aplikasi langsung dari link eksternal
- **Password Reset Links**: Reset password melalui email dengan deep link

### 🎨 User Experience

- **Material Design 3**: Antarmuka modern dan intuitif
- **Curved Navigation**: Navigasi bottom yang menarik
- **Responsive Design**: Optimal di berbagai ukuran layar
- **Custom Fonts**: Typography Poppins untuk konsistensi visual

## 📱 Screenshots

<p align="center">
  <img src="https://i.imgur.com/zgrPcum.png" width="200" alt="Layar Beranda"/>
  <img src="https://i.imgur.com/KETmwX1.png" width="200" alt="Daftar Makanan"/>
  <img src="https://i.imgur.com/y9tGNI9.png" width="200" alt="Detail Makanan"/>
</p>

## 🚀 Memulai

### Prasyarat

- Flutter SDK (^3.7.2)
- Dart SDK (^3.7.2)
- Android Studio / VS Code
- Firebase Project (untuk notifications)
- Google AI API Key (untuk Gemini AI)
- Laravel Backend (opsional untuk development lokal)

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

3. Setup Firebase:

   - Buat project Firebase baru
   - Tambahkan aplikasi Android ke project
   - Download `google-services.json` dan letakkan di `android/app/`
   - Setup Firebase Cloud Messaging

4. Buat file `.env` di direktori root (sudah disediakan template examplenya) dengan konten berikut:

   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

5. Menjalankan aplikasi:
   ```bash
   flutter run
   ```

### Menjalankan dengan Backend Lokal

Untuk menjalankan aplikasi dengan backend Laravel secara lokal:

1. Clone repository backend Laravel:

   ```bash
   git clone https://github.com/rian1504/NutriMPASI-Web.git
   cd NutriMPASI-Web
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
     String baseUrl = 'http://192.168.x.x:8000/';
     ```

## 🔧 Struktur Proyek

```
lib/
├── blocs/                  # State management dengan BLoC pattern
│   ├── authentication/       # Autentikasi dan session management
│   ├── baby/                 # Manajemen profil bayi
│   ├── food/                 # Manajemen data makanan
│   ├── notification/         # Sistem notifikasi
│   ├── schedule/             # Penjadwalan makan
│   ├── thread/               # Forum dan diskusi
│   └── ...                   # BLoC lainnya
├── constants/              # Konstanta aplikasi
│   ├── colors.dart           # Palette warna
│   ├── icons.dart            # Kustom icons
│   ├── url.dart              # Endpoint API
│   ├── notification.dart     # Konfigurasi notifikasi
│   └── deep_link.dart        # Deep linking handler
├── controllers/            # Business logic controllers
├── models/                 # Data models dan entities
├── screens/                # UI screens
│   ├── auth/                 # Login, register, forgot password
│   ├── baby/                 # Profil dan manajemen bayi
│   ├── features/             # Fitur utama (schedule, etc.)
│   ├── food/                 # Eksplorasi dan detail makanan
│   ├── forum/                # Forum komunitas
│   ├── setting/              # Pengaturan aplikasi
│   └── ...                   # Screens lainnya
├── utils/                 # Utility functions
│   ├── flushbar.dart         # Toast notifications
│   └── ...                   # Utils lainnya
├── widgets/               # Utility functions
│   ├── custom_app_bar.dart   # Widget appbar kustom
│   └── ...                   # Widgets lainnya
├── main.dart              # Entry point aplikasi
└── firebase_options.dart  # Konfigurasi Firebase
```

## 🛠️ Teknologi & Dependencies

### Core Framework

- **[Flutter](https://flutter.dev/)** - Cross-platform UI framework
- **[Dart](https://dart.dev/)** - Programming language

### State Management

- **[Flutter Bloc](https://pub.dev/packages/flutter_bloc)** - Predictable state management

### UI/UX

- **[Curved Navigation Bar](https://pub.dev/packages/curved_navigation_bar)** - Custom bottom navigation
- **[Material Symbols Icons](https://pub.dev/packages/material_symbols_icons)** - Modern icon set
- **[Phosphor Flutter](https://pub.dev/packages/phosphor_flutter)** - Additional icon library
- **[Flutter SVG](https://pub.dev/packages/flutter_svg)** - SVG rendering

### Networking & API

- **[Dio](https://pub.dev/packages/dio)** - Powerful HTTP client
- **[Google Generative AI](https://pub.dev/packages/google_generative_ai)** - Gemini AI integration

### Firebase Services

- **[Firebase Core](https://pub.dev/packages/firebase_core)** - Firebase initialization
- **[Firebase Messaging](https://pub.dev/packages/firebase_messaging)** - Push notifications

### Local Storage & Security

- **[Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)** - Encrypted local storage
- **[Flutter DotEnv](https://pub.dev/packages/flutter_dotenv)** - Environment variables

### Utilities

- **[Image Picker](https://pub.dev/packages/image_picker)** - Camera and gallery access
- **[URL Launcher](https://pub.dev/packages/url_launcher)** - External URL handling
- **[App Links](https://pub.dev/packages/app_links)** - Deep linking support
- **[Package Info Plus](https://pub.dev/packages/package_info_plus)** - App information
- **[TimeAgo](https://pub.dev/packages/timeago)** - Human-readable time formatting
- **[Intl](https://pub.dev/packages/intl)** - Internationalization
- **[Another Flushbar](https://pub.dev/packages/another_flushbar)** - Custom notifications
- **[Bottom Picker](https://pub.dev/packages/bottom_picker)** - Date/time picker
- **[Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)** - Local notifications

## 💎 Gaya Kode

Proyek ini mengikuti [Flutter style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) dan menggunakan [flutter_lints](https://pub.dev/packages/flutter_lints) untuk menjaga kualitas kode.

### Konvensi Penamaan

- **Files**: snake_case (contoh: `baby_profile_screen.dart`)
- **Classes**: PascalCase (contoh: `BabyProfileScreen`)
- **Variables & Functions**: camelCase (contoh: `babyProfile`)
- **Constants**: UPPER_SNAKE_CASE (contoh: `API_BASE_URL`)

## 🤝 Kontribusi

Kontribusi sangat diterima! Ikuti langkah-langkah berikut:

1. Fork Project
2. Buat Feature Branch (`git checkout -b fitur/FiturKeren`)
3. Commit Changes (`git commit -m 'Menambahkan FiturKeren'`)
4. Push to Branch (`git push origin fitur/FiturKeren`)
5. Open Pull Request

### Guidelines Kontribusi

- Pastikan kode mengikuti style guide
- Tambahkan tests untuk fitur baru
- Update dokumentasi jika diperlukan
- Gunakan commit message yang descriptive

## 📬 Kontak & Support

- **Project Link**: [https://github.com/rian1504/NutriMPASI-Mobile](https://github.com/rian1504/NutriMPASI-Mobile)
- **Issues**: [GitHub Issues](https://github.com/rian1504/NutriMPASI-Mobile/issues)
- **Discussions**: [GitHub Discussions](https://github.com/rian1504/NutriMPASI-Mobile/discussions)

## 🙏 Ucapan Terima Kasih

- [Tim Flutter](https://flutter.dev/) - Framework yang luar biasa
- [World Health Organization (WHO)](https://www.who.int/) - Panduan nutrisi global
- [Kementerian Kesehatan RI (KEMENKES)](https://www.kemkes.go.id/) - Standar nutrisi nasional
- [Firebase Team](https://firebase.google.com/) - Backend infrastructure
- [Google AI](https://ai.google/) - Gemini AI capabilities
- [Politeknik Negeri Batam](https://polibatam.ac.id/) - Support dan inspirasi

---

<p align="center">
  Made with ❤️ for Indonesian babies and parents
</p>
