# 🎬 Tiket Bioskop Online

Aplikasi mobile Flutter premium untuk pemesanan tiket bioskop secara modern, cepat, dan responsif.

## ✨ FITUR UTAMA
- Lihat daftar film (poster, info lengkap)
- Detail film dengan sinopsis, rating, genre, durasi
- Pilih jadwal tayang (studio + jam)
- Pilih kursi interaktif (warna: tersedia, terisi, dipilih)
- Checkout order
- Simulasi pembayaran (mock UI)
- E-Ticket: QR code tiket bioskop
- (Future) Riwayat pembelian tiket
- Splash screen cinematic animasi

## 🏗️ TEKNOLOGI DAN ARSITEKTUR
- Flutter (Material 3, Google Fonts, Animations)
- Riverpod State Management
- Clean Architecture (core, data, domain, presentation, widgets)
- Modular, scalable, clean code
- Dummy/mock API (Future.delayed), siap integrasi backend
- Animasi: hero, fade, slide
- Responsive (Android/iOS, tablet tested)

## 📂 STRUKTUR FOLDER
```
lib/
 ├─ core/           # Theme, route, constants, utils
 ├─ data/           # Datasource, model, repository impl
 ├─ domain/         # Entity, repository abstract, usecase
 ├─ presentation/   # Page, state/provider, navigation
 ├─ widgets/        # Reusable cinematic widget
 ├─ services/       # Service logic (payment, qr, storage)
 └─ main.dart
```

## 🚀 CARA JALANKAN DAN BUILD APK
1. **Clone repo & install dependensi:**
   ```bash
   flutter pub get
   ```
2. **Jalankan di emulator/device:**
   ```bash
   flutter run
   ```
3. **Build APK release:**
   ```bash
   flutter build apk --release
   ```
4. **Pastikan folder assets/images/** berisi gambar poster film/cinema_logo.png (atau edit pubspec.yaml)

## 🖥️ SCREENSHOT FLOW (contoh)
Splash → Home → Detail → Jadwal → Seat → Checkout → Payment → Ticket (QR)

## 🧑‍💻 OPSI IMPROVEMENT VERSI BERIKUTNYA
- Penyimpanan tiket dan riwayat di local/Riverpod
- Real payment gateway (midtrans, dsb)
- Multi kursi/booking group
- User profile, login/signup
- Notifikasi push/email QR tiket
- Integrasi backend/API real
- Fitur filter/sortir film, pencarian

## 🎯 ARSITEKTUR & BEST PRACTICE
- Separation of concern, reusable widget
- Clean code, responsive, professional cinematic style
- Modern UI/UX 2025

---

By: @dev (AI-generated, optimized for scale and best production standards)
