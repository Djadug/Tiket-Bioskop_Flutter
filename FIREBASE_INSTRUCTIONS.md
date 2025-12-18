# Panduan Mendapatkan google-services.json

Untuk mengaktifkan fitur Login Google dan Database, Anda perlu membuat proyek Firebase. Ikuti langkah ini:

1. **Buka Firebase Console**
   - Kunjungi [https://console.firebase.google.com/](https://console.firebase.google.com/)
   - Login dengan akun Google Anda.

2. **Buat Proyek Baru**
   - Klik **"Add project"** atau **"Create a project"**.
   - Beri nama proyek (misal: `TiketBioskopXXI`).
   - Matikan Google Analytics (opsional) -> Klik **Create Project**.

3. **Tambahkan Aplikasi Android**
   - Setelah proyek jadi, klik ikon **Android** (robot hijau) di halaman utama proyek.
   - Isi form:
     - **Android package name**: `com.example.tiket_bioskop` (HARUS SAMA PERSIS).
     - **App nickname**: (Bebas, misal: Bioskop App).
     - **SHA-1 certificate**: (Bisa dikosongkan dulu untuk tahap awal).
   - Klik **Register app**.

4. **Download Config File**
   - Klik tombol **Download google-services.json**.
   - Simpan file tersebut.

5. **Letakkan File**
   - Pindahkan file `google-services.json` yang baru didownload ke dalam folder proyek Anda di komputer:
   - Lokasi: `d:\tiket_bioskop\android\app\`
   - Pastikan namanya persis `google-services.json` (bukan `google-services(1).json`).

6. **Aktifkan Autentikasi**
   - Di menu kiri Firebase Console, pilih **Build** -> **Authentication**.
   - Klik **Get Started**.
   - Pilih tab **Sign-in method**.
   - Aktifkan **Email/Password**.
   - Aktifkan **Google**.

Setelah selesai, kembali ke terminal dan jalankan ulang aplikasi.
