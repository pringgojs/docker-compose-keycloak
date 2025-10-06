# Keycloak Custom Theme & Authenticator

## Prasyarat

- Node.js & npm (https://nodejs.org/)
- Docker & Docker Compose

## Instalasi & Build Tailwind CSS

1. **Clone repository ini**

2. **Masuk ke folder project**

3. **Inisialisasi npm (jika belum ada `package.json`)**

   ```powershell
   npm init -y
   ```

4. **Install Tailwind CSS**

   ```powershell
   npm install -D tailwindcss
   ```

5. **Build CSS Tailwind**
   Jalankan perintah berikut di PowerShell dari `/keycloak` project:
   ```powershell
   npx tailwindcss -i ./themes/anomic/login/resources/css/input.css -o ./themes/anomic/login/resources/css/tailwind.css --minify
   ```
   File hasil build akan berada di `keycloak/themes/anomic/resources/css/tailwind.css`.

## Menjalankan Keycloak dengan Docker

1. **Build Docker image**

   ```powershell
   docker compose build
   ```

2. **Jalankan container**
   ```powershell
   docker compose up
   ```

## Struktur Penting

- `keycloak/themes/modern/` : Folder custom theme
- `keycloak/simashebat-authenticator-1.0.1.jar` : Custom authenticator
- `keycloak/themes/modern/resources/css/input.css` : Sumber utama Tailwind
- `keycloak/themes/modern/resources/css/tailwind.css` : Hasil build Tailwind

---

Jika ada error saat build Tailwind, pastikan Node.js dan npm sudah terinstall dan jalankan `npm install` sebelum build.

## Panduan Instalasi Theme Modern di Keycloak

1. Pastikan proses build Docker sudah selesai dan container Keycloak sudah berjalan.
2. Theme custom akan otomatis ter-copy ke dalam image Keycloak melalui Dockerfile:
   - Lokasi di dalam container: `/opt/keycloak/themes/modern`
3. Untuk menggunakan theme ini:
   - Login ke Keycloak Admin Console.
   - Masuk ke menu **Realm Settings** > **Themes**.
   - Pada bagian **Login Theme**, pilih `modern`.
   - Klik **Save**.
4. Logout dan akses halaman login Keycloak, tampilan akan menggunakan theme modern custom.

Jika theme tidak muncul di daftar, pastikan build Docker sudah sukses dan tidak ada error pada struktur folder theme.
