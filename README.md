# Master Plan & Peta Jalan Bertahap PKBM Digital Dar El Iman
**Direktori Proyek:** D:\lms-darel-iman  
**Institusi Pemilik:** Yayasan Dar El Iman Padang  
**Dasar Acuan:** *Rancangan Fitur PKBM Digital 2027–2032* & *Technical Implementation Plan*

---

## 1. Latar Belakang & Arahan Pimpinan

Berdasarkan arahan langsung pimpinan:
> * nay coba breakdown. modul apa yg dikerjakan dulu. bagi pengerjaan modul menjadi bertahap. buat masing-masing tahap file MD nya jadi nanti generatenya per md sj. minimal ada login sama input data trus bisa mulai pembelajaran*

Dokumen cetak biru sistem yang sebelumnya menyatu dalam satu file besar (3.300+ baris) kini telah **dipecah menjadi 5 file spesifikasi teknis modular**. 

### Filosofi Fast-to-Classroom (Langsung Siap KBM)
Alih-alih menahan proses sampai seluruh modul pendaftaran publik (PPDB) dan keuangan (SPP) selesai dibuat, roadmap bertahap ini membalik prioritas agar **proses belajar mengajar (KBM) dapat langsung berjalan secepat mungkin**:
1. **Tahap 1**: Sistem fondasi aktif, Admin login, konfigurasi lembaga (Dar El Iman & jenjang Paket A/B/C), input data guru & santri secara langsung/massal, rombel terbentuk, akun aktif.
2. **Tahap 2**: Kurikulum, jadwal, ruang kelas LMS, materi ajar, tugas, dan Halaqah Tahfizh aktif. **Santri dan Guru langsung bisa mulai belajar!**
3. **Tahap 3**: Ujian daring (CBT), proctoring, penilaian rubrik, dan penerbitan e-Rapor resmi ber-QR.
4. **Tahap 4**: Pendaftaran mandiri (PPDB publik & diaspora), otomasi tagihan SPP/beasiswa, serta ekspor format Dapodik Kemendikbudristek.
5. **Tahap 5**: Ekspansi kemitraan luar negeri/pesantren, penjaminan mutu BAN-PDM & BSC, serta asisten cerdas Tutor AI.

---

## 2. Struktur Direktori D:\lms-darel-iman

`	ext
D:\lms-darel-iman\
│
├── README.md                                     <-- (Dokumen ini) Master peta jalan & indeks
├── Tahap_01_Fondasi_Auth_dan_Master_Data.md      <-- TAHAP 1: Login & Input Data Santri/Tutor
├── Tahap_02_Kurikulum_LMS_dan_Tahfizh.md         <-- TAHAP 2: Pembelajaran KBM & Halaqah Tahfizh
├── Tahap_03_Asesmen_CBT_dan_Rapor.md             <-- TAHAP 3: Ujian Online CBT & E-Rapor
├── Tahap_04_PPDB_Keuangan_dan_Dapodik.md         <-- TAHAP 4: PPDB Publik, SPP & Dapodik
├── Tahap_05_Kemitraan_Mutu_dan_Fitur_Lanjutan.md <-- TAHAP 5: Mitra, Mutu BAN-PDM & Tutor AI
│
└── referensi/                                    <-- Arsip dokumen cetak biru asli
    ├── Rancangan_Fitur_PKBM_Digital_Dar_El_Iman.md
    └── PKBM_Digital_Implementation_Plan.md
```

---

## 3. Matriks Komparasi Antar-Tahap

| Tahap | Dokumen Spesifikasi | Target Operasional Utama | Status | Peran yang Terlibat Langsung |
|---|---|---|---|---|
| **Tahap 1** | Tahap_01_Fondasi_Auth_dan_Master_Data.md | Login, setup lembaga, input santri & tutor, pembagian rombel | ✅ **SELESAI** | Super Admin, Operator Admin, Tutor, Santri |
| **Tahap 2** | Tahap_02_Kurikulum_LMS_dan_Tahfizh.md | **KBM BERJALAN**: Materi, tugas, presensi, setoran hafalan Al-Qur'an | ✅ **SELESAI** | Tutor, Santri, Wali Kelas, Orang Tua |
| **Tahap 3** | Tahap_03_Asesmen_CBT_dan_Rapor.md | Ujian CBT anti-curang, evaluasi nilai, pencetakan E-Rapor PDF | ✅ **SELESAI** | Tutor, Proktor Ujian, Santri, Tim Kurikulum |
| **Tahap 4** | Tahap_04_PPDB_Keuangan_dan_Dapodik.md | Pendaftaran santri baru publik, bayar SPP online, ekspor Dapodik | ✅ **SELESAI** | Calon Santri, Bagian Keuangan, Operator Dapodik |
| **Tahap 5** | Tahap_05_Kemitraan_Mutu_dan_Fitur_Lanjutan.md | Mitra luar negeri/pesantren, akreditasi BAN-PDM, BSC, Tutor AI | ✅ **SELESAI** | Direktur, Dewan Pembina, Tim Penjamin Mutu, Mitra |

---

## 4. Cara Penggunaan File untuk Generate Kode

Setiap file markdown (Tahap_01_... s/d Tahap_05_...) telah dirancang berformat **Prompt-Ready / Implementation-Ready**. 

Di dalam setiap file terdapat komponen lengkap:
1. **Identitas & Sasaran Tahap** (Target operasional konkrit).
2. **Dekomposisi Modul & Fitur Spesifik**.
3. **Skema Basis Data MySQL 8.0 (DDL Lengkap)** dengan tipe data, relasi foreign key, dan indeks.
4. **Daftar Endpoint REST API** (Method, Path, Request/Response Payload, Hak Akses RBAC).
5. **Kebutuhan Antarmuka Frontend (UI/UX Pages)**.
6. **Alur Kerja Operasional Pengguna (User Stories)**.
7. **Kriteria Kesiapan / Selesai (Definition of Done)**.
8. **PROMPT SIAP COPY-PASTE** di bagian akhir setiap file untuk langsung diinstruksikan kepada AI Assistant saat mulai meng-generate kode.

> **Rekomendasi Eksekusi**: Kerjakan secara berurutan mulai dari **Tahap 1**, lalu verifikasi *Definition of Done*, kemudian lanjutkan ke **Tahap 2**. Setelah Tahap 2 selesai, sistem sudah siap dipakai untuk kegiatan belajar santri secara nyata!
