# Panduan Deploy PKBM Digital Dar El Iman ke Easypanel via GitHub

Dokumen ini menjelaskan langkah-langkah praktis dan teruji untuk melakukan *deployment* aplikasi **LMS PKBM Digital Dar El Iman** ke server VPS Anda menggunakan **Easypanel** yang terhubung langsung dengan repositori **GitHub**.

---

## 🌟 Mengapa Easypanel Sangat Cocok?
Aplikasi ini sudah dilengkapi dengan:
1. **`docker-compose.yml`**: Mengorkestrasi 3 layanan secara otomatis (MySQL 8.0, Go Backend, dan Nginx Frontend).
2. **`frontend/nginx.conf`**: Sudah dikonfigurasi sebagai *Reverse Proxy* untuk meneruskan *traffic* `/api/` langsung ke backend, mendukung Gzip compression, dan mengaktifkan SSL/HTTPS secara transparan tanpa masalah CORS.
3. **Database Auto-Seed**: File SQL skema dan data awal di direktori `database/` akan otomatis dieksekusi saat container MySQL pertama kali dibuat.

---

## Langkah 1: Push Repositori ke GitHub

Jika repositori lokal belum berada di GitHub Anda:

1. Buka [GitHub](https://github.com) dan buat repositori baru (misalnya `pkbm-digital-darel-iman`), pilih **Private** atau **Public**.
2. Jalankan perintah berikut di terminal komputer Anda:
   ```bash
   git remote add origin https://github.com/USERNAME_ANDA/pkbm-digital-darel-iman.git
   git branch -M main
   git push -u origin main
   ```

---

## Langkah 2: Hubungkan GitHub ke Easypanel

1. Masuk ke dasbor **Easypanel** Anda (misalnya `https://easypanel.your-server.com`).
2. Masuk ke menu **Settings** &rarr; **GitHub**.
3. Klik **Connect GitHub** dan ikuti instruksi otorisasi GitHub App agar Easypanel memiliki izin membaca repositori Anda.

---

## Langkah 3: Deploy Menggunakan Metode Docker Compose (Direkomendasikan)

Ini adalah metode termudah karena hanya membutuhkan 1 kali konfigurasi di Easypanel:

1. Di dasbor Easypanel, klik **Projects** &rarr; pilih atau buat project baru (misal: `PKBM-DarElIman`).
2. Klik tombol **+ Service** &rarr; pilih tipe **App**.
3. Pada tab **General**:
   * **Name**: `pkbm-app`
4. Pada tab **Source**:
   * Pilih **GitHub**.
   * Pilih repositori Anda: `USERNAME_ANDA/pkbm-digital-darel-iman`.
   * **Branch**: `main`.
   * **Auto Deploy**: Aktifkan (ON) agar setiap kali Anda `git push`, Easypanel otomatis mem-build ulang.
5. Pada tab **Build**:
   * Ubah **Build Type** menjadi **Docker Compose**.
   * Pastikan path compose file adalah `docker-compose.yml`.
6. Pada tab **Domains**:
   * Tambahkan domain Anda (misal: `lms.darel-iman.or.id` atau subdomain gratis dari Easypanel).
   * Arahkan domain tersebut ke:
     * **Container / Service**: `frontend`
     * **Port**: `80`
   * Centang opsi **Auto SSL (Let's Encrypt)**.
7. Klik tombol **Save** lalu klik **Deploy**.

Easypanel akan otomatis:
* Menjalankan build Go binary pada `backend/Dockerfile`.
* Menyiapkan Nginx web server pada `frontend/Dockerfile`.
* Menjalankan MySQL 8.0 dan menjalankan inisialisasi database dari folder `database/`.
* Menerbitkan sertifikat SSL gratis HTTPS.

---

## Langkah 4 (Alternatif): Deploy Service Terpisah di Easypanel

Jika Anda ingin memisahkan service agar bisa mengontrol resource CPU/RAM masing-masing:

### 1. Buat Service Database (MySQL)
* Klik **+ Service** &rarr; pilih tab **Templates** &rarr; pilih **MySQL**.
* Name: `db`
* Password: `rootpassword` (atau ganti sesuai keinginan)
* Database Name: `pkbm_digital_darel_iman`

### 2. Buat Service Backend (Go API)
* Klik **+ Service** &rarr; pilih **App**.
* Source: GitHub &rarr; Repo Anda &rarr; Branch `main`.
* Build Type: **Dockerfile**.
  * Dockerfile Path: `backend/Dockerfile`
  * Context Path: `backend`
* Port: `8080`
* Environment Variables:
  ```env
  PORT=8080
  DB_USER=root
  DB_PASSWORD=rootpassword
  DB_HOST=db
  DB_PORT=3306
  DB_NAME=pkbm_digital_darel_iman
  JWT_SECRET=dar-el-iman-secret-key-2027-2032
  FRONTEND_URL=*
  ```

### 3. Buat Service Frontend (Nginx SPA)
* Klik **+ Service** &rarr; pilih **App**.
* Source: GitHub &rarr; Repo Anda &rarr; Branch `main`.
* Build Type: **Dockerfile**.
  * Dockerfile Path: `frontend/Dockerfile`
  * Context Path: `frontend`
* Port: `80`
* Domains: Tambahkan domain utama Anda (misal `lms.darel-iman.or.id`).

---

## Langkah 5: Verifikasi Setelah Deploy

1. Buka domain yang telah diarahkan di browser (misalnya `https://lms.darel-iman.or.id`).
2. Halaman login PKBM Digital Dar El Iman akan muncul dengan koneksi aman HTTPS.
3. Klik tombol **`🎯 Katalog 18 Akun Demo Lengkap`** untuk menguji login akun pimpinan, pengajar, santri, atau wali santri.
4. Periksa apakah request network menuju `/api/v1/auth/login` berhasil dengan status `200 OK`.

---

## Catatan Penting & Troubleshooting

* **Perubahan Kata Sandi:** Fitur ubah kata sandi berjalan baik di database MySQL maupun penyimpanan per sesi browser.
* **Auto Deploy:** Ketika Anda melakukan perbaikan kode di lokal dan menjalankan `git push origin main`, Easypanel akan mendeteksi commit baru via Webhook GitHub dan melakukan deploy tanpa downtime (*rolling restart*).
* **Backup Database:** Di Easypanel, Anda dapat mengaktifkan fitur bawaan **Backups** (harian/mingguan ke cloud storage S3/Wasabi/Google Cloud) langsung dari menu layanan database.
