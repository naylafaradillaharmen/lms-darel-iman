<div align="center">

# 🕌 PKBM Digital Dar El Iman
### Sistem Manajemen Pembelajaran (LMS), KBM Virtual & Halaqah Tahfizh Terpadu
**Yayasan Dar El Iman Padang — Menjangkau Pendidikan Kesetaraan & Diaspora Santri Global**

[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=flat&logo=docker)](https://www.docker.com/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat&logo=mysql)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-Proprietary-emerald?style=flat)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success?style=flat)]()

[Fitur Utama](#-fitur-utama) • [18 Akun Demo](#-katalog-18-peran-pengguna-demo) • [Cara Menjalankan](#-cara-menjalankan-aplikasi) • [Struktur Proyek](#-struktur-arsitektur-proyek) • [Deploy Docker & Easypanel](#-deployment-docker--easypanel)

---

</div>

## 📌 Tentang Proyek

**PKBM Digital Dar El Iman** adalah platform pembelajaran daring komprehensif yang dirancang untuk mendukung operasional Pusat Kegiatan Belajar Masyarakat (PKBM) modern. Sistem ini memadukan **pendidikan kesetaraan formal (Paket A, B, dan C)** dengan **pendidikan diniyah salafiyah terpadu (Halaqah Tahfizh Al-Qur'an)**.

Sistem dirancang ramah bagi santri mukim di pesantren maupun **santri diaspora** di berbagai zona waktu (WIB, WITA, WIT, dan mancanegara) dengan tata kelola berbasis peran (*Role-Based Access Control / RBAC*) yang ketat dan terstruktur.

---

## Fitur Utama Sistem

- 🔐 **Autentikasi & Keamanan Ketat:**
  - Token JWT berbasis sesi terenkripsi dengan validasi ketat (pencegahan bypass kata sandi).
  - Modal pop-out status login interaktif (notifikasi visual keberhasilan vs. rincian penyebab kegagalan).
  - Fitur **Ubah Kata Sandi** mandiri dengan meteran kekuatan kombinasi karakter real-time.
- 🎯 **18 Peran Terintegrasi (RBAC):** Navigasi antarmuka dan wewenang menu menyesuaikan secara dinamis untuk 18 peran di 5 tingkatan manajemen.
- 📖 **LMS & KBM Virtual:** Modul materi pembelajaran bertingkat, video ajar interaktif, pengumpulan tugas santri, dan evaluasi capaian belajar.
- 🕋 **Halaqah Tahfizh Terpadu:** Pemantauan setoran hafalan Al-Qur'an (Ziyadah & Muraja'ah), catatan makharijul huruf, tajwid, fashahah, serta target juz per santri.
- 📝 **Asesmen & CBT Anti-Curang:** Pelaksanaan ujian online berbasis waktu, bank soal terstruktur, deteksi perpindahan tab, pengacakan soal, dan penilaian otomatis.
- 📊 **e-Rapor Digital:** Penerbitan rapor digital resmi ber-QR Code verifikasi keaslian dokumen.
- 🌍 **Pemantauan Santri Diaspora:** Pengelompokan santri berdasarkan zona waktu internasional untuk penjadwalan kelas sinkronus/asinkronus yang adaptif.
- 💳 **Keuangan & SPP Terpadu:** Pencatatan tagihan SPP, riwayat pembayaran, serta ledger transparansi dana beasiswa bagi donatur.
- 🏛️ **Sinkronisasi Dapodik & Penjaminan Mutu:** Validasi data peserta didik sesuai standar Kemendikbudristek dan audit mutu BAN-PDM.

---

## 🎯 Katalog 18 Peran Pengguna (Demo)

Sistem telah dilengkapi dengan 18 akun siap pakai untuk menguji seluruh modul:

| No | Kategori | Peran | Username | Password | Wewenang Utama |
|:---:|:---|:---|:---|:---|:---|
| 1 | **Pimpinan** | Super Admin | `admin` | `admin123` | Akses penuh seluruh sistem, audit log, kelola user & role |
| 2 | **Pimpinan** | Dewan Pembina | `pembina` | `pembina123` | *Executive Read-Only*: Pantau KPI, statistik diaspora & audit keuangan |
| 3 | **Pimpinan** | Direktur PKBM | `direktur` | `direktur123` | Pengesahan kelulusan, persetujuan kurikulum & legalitas |
| 4 | **Manajerial** | Manajer Akademik | `mgr.akademik` | `akademik123` | Beban ajar pendidik, kalender pendidikan, silabus Paket A/B/C |
| 5 | **Manajerial** | Manajer Kesiswaan & Diaspora | `mgr.kesiswaan` | `kesiswaan123` | Pengelompokan santri lintas zona waktu & monitoring konseling |
| 6 | **Manajerial** | Manajer Keuangan & Legal | `mgr.keuangan` | `keuangan123` | Rekonsiliasi SPP, ledger beasiswa, kepatuhan perizinan |
| 7 | **Manajerial** | Manajer Teknologi (IT) | `mgr.it` | `it123` | Manajemen server, performa API, backup data & log keamanan |
| 8 | **Operasional** | Tutor Pendidik | `tutor.ahmad` | `tutor123` | Kelola modul ajar, penugasan, presensi & input nilai KBM |
| 9 | **Operasional** | Wali Kelas | `wali.kelas` | `wali123` | Pendampingan santri, monitoring halaqah, komunikasi wali santri |
| 10 | **Operasional** | Proktor Ujian | `proktor` | `proktor123` | Rilis token ujian CBT, pemantauan live status peserta ujian |
| 11 | **Operasional** | Operator Dapodik | `operator` | `operator123` | Sinkronisasi data NISN/NPSN ke server Kemendikbudristek |
| 12 | **Operasional** | Staf Layanan / Helpdesk | `helpdesk` | `helpdesk123` | Tiket kendala teknis santri diaspora & reset kredensial |
| 13 | **Operasional** | Tim Penjaminan Mutu | `tim.mutu` | `mutu123` | Audit kesesuaian instrumen akreditasi BAN-PDM & survei mutu |
| 14 | **Pengguna** | Santri / Siswa | `santri.fatih` | `santri123` | Akses materi, pengumpulan tugas, setoran tahfizh, ujian CBT |
| 15 | **Pengguna** | Orang Tua / Wali Santri | `wali.santri` | `ortu123` | Pantau capaian tahfizh anak, kartu SPP, absensi & jadwal |
| 16 | **Eksternal** | Mitra Pesantren | `mitra.pesantren` | `mitra123` | Pemantauan santri binaan mitra, kurikulum salafiyah |
| 17 | **Eksternal** | Donatur Beasiswa | `donatur` | `donatur123` | Laporan transparansi penyaluran beasiswa tahfizh |
| 18 | **Eksternal** | Tamu (Calon Santri PPDB) | `tamu` | `tamu123` | Akses formulir pendaftaran santri baru & informasi program |

---

## 🚀 Cara Menjalankan Aplikasi

### Metode 1: Satu Klik di Windows (Paling Cepat)
Jika Anda menggunakan komputer Windows:
1. Pastikan compiler **Go (v1.22+)** sudah terpasang.
2. Cukup klik ganda (double-click) file:
   ```cmd
   start_pkbm.bat
   ```
3. Script otomatis mengompilasi backend Go, menjalankan server di port `8080`, dan membuka antarmuka di peramban web pada alamat `http://localhost:8080`.

---

### Metode 2: Menggunakan Docker Compose (Multi-Platform)
Jalankan seluruh stack (Database MySQL 8.0, Go Backend, dan Nginx Frontend) secara terisolasi:

```bash
# Clone repositori
git clone https://github.com/naylafaradillaharmen/lms-darel-iman.git
cd lms-darel-iman

# Jalankan semua container
docker compose up -d --build
```
Aplikasi langsung dapat diakses di:
* **Frontend:** `http://localhost` (Port 80)
* **Backend API:** `http://localhost:8080/api/v1`
* **MySQL Database:** `localhost:3306`

---

### Metode 3: Menjalankan Secara Manual
Jika ingin menjalankan backend secara terpisah untuk keperluan pengembangan:

```bash
# 1. Jalankan Backend
cd backend
go run ./cmd/api

# 2. Buka Frontend
# Buka file frontend/index.html langsung di browser Anda atau gunakan Live Server.
```

---

## 🚢 Deployment (Docker & Easypanel)

Repositori ini sudah dioptimalkan untuk langsung dihubungkan ke platform server management seperti **Easypanel**, **Railway**, atau VPS Linux:

1. **Reverse Proxy Nginx Terintegrasi:** `frontend/nginx.conf` otomatis meneruskan request `/api/` ke container backend tanpa kendala CORS dan telah mengaktifkan kompresi Gzip.
2. **Auto-Seed Database:** MySQL akan otomatis menjalankan skema dan seed data awal dari direktori `database/`.
3. **Penyambungan ke Easypanel:**
   * Di dasbor Easypanel, buat App baru dengan Source **GitHub** (`naylafaradillaharmen/lms-darel-iman`).
   * Pilih Build Type: **Docker Compose**.
   * Arahkan domain ke service `frontend` port `80` dengan Auto SSL aktif.

---

## 📂 Struktur Arsitektur Proyek

```text
lms-darel-iman/
├── backend/                  # RESTful API Service (Golang)
│   ├── cmd/api/main.go       # Entry point server & route registry
│   ├── internal/
│   │   ├── handlers/         # Controller HTTP (Auth, LMS, Tahfizh, CBT, dll.)
│   │   ├── middleware/       # JWT Authentication & RBAC Authorization
│   │   └── models/           # Data struct models
│   ├── Dockerfile            # Multi-stage Docker build untuk Go binary
│   └── go.mod
│
├── frontend/                 # Single Page Application (SPA)
│   ├── index.html            # Antarmuka responsif dengan 18 role view
│   ├── nginx.conf            # Konfigurasi reverse proxy & static cache
│   └── Dockerfile            # Container Nginx Alpine
│
├── database/                 # Skema & Data Awal Basis Data (MySQL 8.0)
│   ├── schema.sql            # Master DDL
│   ├── seed.sql              # Data awal pengguna & peran
│   └── tahap*.sql            # Modul lanjutan
│
├── referensi/                # Dokumen Arsitektur & Cetak Biru PKBM 2027–2032
├── docker-compose.yml        # Orkestrasi container production
├── start_pkbm.bat            # Script runner 1-klik untuk Windows
└── README.md
```

---

## 🔒 Hak Cipta & Kepemilikan

Dikembangkan untuk operasional **PKBM Digital Yayasan Dar El Iman Padang**.  
Seluruh hak cipta dan kepemilikan intelektual dilindungi.
