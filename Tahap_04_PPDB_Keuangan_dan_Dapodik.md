# Spesifikasi Teknis Tahap 4: PPDB Online, Keuangan SPP & Ekspor Dapodik
**Proyek:** PKBM Digital Dar El Iman  
**Fase:** Tahap 4 (OTOMASI ADMINISTRASI, KEUANGAN & REGULASI NASIONAL)  
**Tujuan Utama:** Membuka portal pendaftaran santri baru publik (PPDB nasional & diaspora), mengelola otomasi tagihan SPP dan pembayaran, serta menyediakan fitur ekspor data terstandar Dapodik Kemendikbudristek.

---

## 1. Sasaran Operasional & Batasan Tahap

Setelah tahap ini selesai dibangun:
- [x] Calon santri baru (dalam negeri maupun diaspora luar negeri) dapat mendaftar mandiri lewat portal publik PPDB.
- [x] Calon santri dapat mengunggah dokumen prasyarat (KK, Akta Kelahiran, KTP Orang Tua, Ijazah Jenjang Sebelumnya).
- [x] Panitia PPDB dapat memverifikasi berkas, melakukan tes penempatan (*placement test*), dan mengubah status pendaftaran (Diterima / Cadangan / Ditolak).
- [x] Calon santri yang dinyatakan DITERIMA otomatis dimutasi menjadi Data Induk Santri (`students`) dan langsung dibuatkan akun pengguna (`users`).
- [x] Modul keuangan menerbitkan tagihan SPP bulanan otomatis dengan tarif sesuai jenjang (Paket A, B, atau C).
- [x] Orang tua/santri dapat melihat tagihan, konfirmasi pembayaran via transfer manual (upload bukti transfer) atau *payment gateway*.
- [x] Sistem mendukung beasiswa potongan biaya dari donatur dan kode afiliasi.
- [x] Operator lembaga dapat mengekspor data santri, tutor, dan rombel ke dalam format spreadsheet/CSV terstandar Dapodik Kemendikbudristek untuk sinkronisasi tanpa ketik ulang manual.

---

## 2. Modul yang Dikerjakan

| Modul | Deskripsi Fungsional | Role Terkait |
|---|---|---|
| **M21: Portal Publik PPDB Online** | Formulir registrasi santri baru, pemilihan jenjang Paket A/B/C, pemilihan santri diaspora & zona waktu, nomor pendaftaran unik. | Calon Santri / Orang Tua |
| **M22: Verifikasi & Dokumen PPDB** | Unggah berkas digital pendukung, verifikasi oleh staf panitia PPDB, catatan revisi berkas. | Staf PPDB, Calon Santri |
| **M23: Placement Test & Kelulusan** | Ujian penempatan dasar (Tahfizh & Pengetahuan Umum), pengumuman hasil kelulusan, dan konversi calon santri menjadi santri resmi. | Tim Penguji, Staf PPDB |
| **M24: Tagihan SPP & Tarif Lembaga** | Master tarif SPP per jenjang, penjadwalan tagihan bulanan otomatis, penomoran invoice resmi yayasan. | Manajer Keuangan |
| **M25: Transaksi Pembayaran & Rekonsiliasi** | Pembayaran SPP (upload bukti bayar / gateway), verifikasi berjenjang (*maker-checker*), status lunas/tertunggak. | Bendahara, Orang Tua |
| **M26: Manajemen Beasiswa & Afiliasi** | Data program beasiswa (donatur), alokasi kuota beasiswa potongan SPP, kode referral afiliasi komunitas. | Bagian Keuangan, Donatur |
| **M27: Ekspor Standar Dapodik** | Validasi kelengkapan atribut NIK/NISN/Ibu Kandung, generator file ekspor format Dapodik Kemendikbudristek. | Operator Dapodik |

---

## 3. Skema Basis Data MySQL 8.0 (DDL)

```sql
-- 1. TABEL PENERIMAAN PESERTA DIDIK BARU (PPDB)
CREATE TABLE ppdb_periods (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    academic_year_id CHAR(36) NOT NULL REFERENCES academic_years(id) ON DELETE RESTRICT,
    title VARCHAR(150) NOT NULL, -- Contoh: 'PPDB Gelombang 1 TA 2027/2028'
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_open BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ppdb_registrations (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    ppdb_period_id CHAR(36) NOT NULL REFERENCES ppdb_periods(id) ON DELETE RESTRICT,
    registration_number VARCHAR(50) UNIQUE NOT NULL, -- Contoh: 'REG-2027-001'
    target_package VARCHAR(10) NOT NULL CHECK (target_package IN ('PAKET_A', 'PAKET_B', 'PAKET_C')),
    
    -- Biodata Calon Santri
    full_name VARCHAR(255) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('L', 'P')),
    nik VARCHAR(20),
    nisn VARCHAR(20),
    birth_place VARCHAR(100),
    birth_date DATE,
    phone VARCHAR(50),
    email VARCHAR(150),
    
    -- Atribut Diaspora
    is_diaspora BOOLEAN DEFAULT FALSE,
    country VARCHAR(100) DEFAULT 'Indonesia',
    timezone VARCHAR(50) DEFAULT 'Asia/Jakarta',
    
    -- Biodata Orang Tua
    guardian_name VARCHAR(255) NOT NULL,
    guardian_phone VARCHAR(50) NOT NULL,
    guardian_relationship VARCHAR(50) NOT NULL,
    
    status VARCHAR(30) DEFAULT 'SUBMITTED' 
        CHECK (status IN ('SUBMITTED', 'DOCUMENTS_VERIFIED', 'TEST_PASSED', 'ACCEPTED', 'REJECTED')),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ppdb_documents (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    ppdb_registration_id CHAR(36) NOT NULL REFERENCES ppdb_registrations(id) ON DELETE CASCADE,
    document_type VARCHAR(50) NOT NULL, -- 'KK', 'AKTA_LAHIR', 'IJAZAH_SEBELUMNYA', 'KTP_WALI'
    file_url TEXT NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABEL KEUANGAN, SPP & PEMBAYARAN
CREATE TABLE tuition_tariffs (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    academic_year_id CHAR(36) NOT NULL REFERENCES academic_years(id) ON DELETE RESTRICT,
    grade_level_id CHAR(36) NOT NULL REFERENCES grade_levels(id) ON DELETE RESTRICT,
    amount DECIMAL(12,2) NOT NULL, -- Contoh: Rp 350.000 / bulan
    description VARCHAR(200),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE student_invoices (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE RESTRICT,
    invoice_number VARCHAR(50) UNIQUE NOT NULL, -- Contoh: 'INV-2027-01-0045'
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    year INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) DEFAULT 0.00,
    final_amount DECIMAL(12,2) NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'UNPAID' CHECK (status IN ('UNPAID', 'PENDING_VERIFICATION', 'PAID', 'CANCELLED')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payment_transactions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_invoice_id CHAR(36) NOT NULL REFERENCES student_invoices(id) ON DELETE RESTRICT,
    payment_method VARCHAR(50) NOT NULL, -- 'BANK_TRANSFER', 'PAYMENT_GATEWAY', 'CASH'
    amount_paid DECIMAL(12,2) NOT NULL,
    proof_file_url TEXT, -- Bukti struk transfer
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    verified_by_user_id CHAR(36) REFERENCES users(id) ON DELETE SET NULL,
    verified_at DATETIME,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),
    rejection_reason TEXT
);

CREATE TABLE scholarship_grants (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    program_name VARCHAR(150) NOT NULL, -- Contoh: 'Beasiswa Santri Berprestasi Dar El Iman'
    discount_percentage INT DEFAULT 100, -- 100% (bebas penuh) atau 50%
    donor_name VARCHAR(150),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABEL LOG EKSPOR DAPODIK
CREATE TABLE dapodik_export_logs (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    exported_by_user_id CHAR(36) REFERENCES users(id) ON DELETE SET NULL,
    academic_year_id CHAR(36) NOT NULL REFERENCES academic_years(id) ON DELETE RESTRICT,
    export_type VARCHAR(50) NOT NULL, -- 'DATA_SISWA', 'DATA_TUTOR', 'DATA_ROMBEL'
    total_records INT NOT NULL,
    download_url TEXT NOT NULL,
    exported_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indeks Kinerja
CREATE INDEX idx_ppdb_reg_number ON ppdb_registrations(registration_number);
CREATE INDEX idx_student_invoices_status ON student_invoices(student_id, status);
```

---

## 4. Spesifikasi REST API Endpoints

### 4.1 Modul PPDB (`/api/v1/ppdb`)
- `GET /periods/active`: Ambil info gelombang pendaftaran yang sedang buka.
- `POST /register`: Pendaftaran publik calon santri (menghasilkan nomor registrasi unik).
- `POST /:registration_id/documents`: Unggah berkas dokumen (KK/Akta/Ijazah).
- `GET /my-status?registration_number=...`: Pengecekan status seleksi oleh calon santri.
- `GET /admin/registrations`: Panitia melihat seluruh pendaftar (filter status & jenjang).
- `PUT /admin/registrations/:id/verify`: Panitia memverifikasi dokumen.
- `POST /admin/registrations/:id/accept-and-convert`: **Aksi Krusial**: Mengubah calon santri menjadi santri resmi di tabel `students`, auto-generate akun login `users`, dan assign ke rombel awal.

### 4.2 Modul Keuangan SPP (`/api/v1/finance`)
- `POST /invoices/generate-monthly`: Generate massal tagihan SPP awal bulan untuk seluruh santri aktif.
- `GET /invoices/student/:student_id`: Riwayat tagihan dan status lunas santri.
- `POST /invoices/:id/pay`: Konfirmasi pembayaran oleh wali/santri (upload struk bukti transfer).
- `GET /payments/pending`: Panitia keuangan melihat daftar transfer yang butuh verifikasi (*maker-checker*).
- `PUT /payments/:id/verify`: Setujui/tolak konfirmasi pembayaran.
- `POST /scholarships`: Berikan beasiswa potongan SPP untuk santri tertentu.

### 4.3 Modul Integrasi Dapodik (`/api/v1/dapodik`)
- `GET /validation-check`: Audit kelengkapan data santri (cek apakah ada NIK/NISN/nama ibu kandung yang masih kosong).
- `POST /export-students`: Download file format Excel/CSV siap impor ke aplikasi Dapodik Kemendikbudristek.
- `POST /export-tutors`: Download data PTK/Tutor untuk Dapodik.
- `POST /export-classrooms`: Download data Rombel untuk Dapodik.

---

## 5. Kebutuhan Antarmuka Frontend (UI Screens)

1. **Portal Publik Pendaftaran PPDB (`/ppdb/register`)**:
   - Tampilan bersih profesional dan ramah pengguna umum.
   - Pilihan tab: Jalur Nasional / Jalur Diaspora Internasional.
   - Form bertahap (*multi-step wizard*): Data Pribadi -> Data Orang Tua -> Pilihan Jenjang -> Unggah Dokumen -> Selesai (cetak kartu bukti pendaftaran).
2. **Dashboard Verifikasi PPDB Panitia (`/admin/ppdb`)**:
   - Tabel pemantauan pendaftar, preview berkas dokumen PDF/gambar secara langsung, dan tombol "Luluskan & Terbitkan Akun Santri".
3. **Portal Pembayaran & Tagihan Orang Tua (`/parent/invoices`)**:
   - Status ringkasan: Tagihan Bulan Berjalan, Total Tunggakan (jika ada).
   - Form "Konfirmasi Pembayaran" dengan tombol upload bukti struk bank transfer.
4. **Dashboard Rekonsiliasi Keuangan Admin (`/admin/finance`)**:
   - Antarmuka maker-checker persetujuan transfer pembayaran.
   - Laporan rekapitulasi penerimaan kas SPP bulanan.
5. **Halaman Generator Ekspor Dapodik (`/admin/dapodik`)**:
   - Indikator kesiapan data: "150 dari 152 santri telah lengkap syarat Dapodik (98%)".
   - Tombol satu klik: "Unduh Berkas Ekspor Dapodik Terstandar".

---

## 6. Skenario Pengujian & Kriteria Selesai (Definition of Done)

Tahap 4 dinyatakan **SELESAI & LULUS** jika:
1. Calon santri berhasil mengisi formulir pendaftaran di `/ppdb/register` dan mengunggah berkas Akta Kelahiran.
2. Panitia PPDB memverifikasi berkas dan menekan tombol "Luluskan & Terbitkan Akun"; data calon santri otomatis masuk ke tabel `students`, akun login aktif di tabel `users`, dan santri bisa langsung login ke LMS.
3. Generator tagihan SPP berhasil membuat tagihan bulanan untuk seluruh santri aktif dengan tarif yang sesuai jenjang.
4. Santri mengunggah bukti bayar transfer; bagian keuangan menyetujui verifikasi; status invoice berubah menjadi `PAID`.
5. Modul Dapodik berhasil memvalidasi kelengkapan data dan mengekspor 1 berkas CSV terstandar yang memuat seluruh santri aktif.

---

## 7. PROMPT INSTRUKSI SIAP PAKAI (Copy-Paste ke AI Generator)

Salin blok prompt berikut saat Anda ingin meminta AI membangun kode untuk Tahap 4:

```text
Tolong implementasikan backend dan frontend untuk TAHAP 4 PKBM DIGITAL DAR EL IMAN sesuai dokumen spesifikasi Tahap_04_PPDB_Keuangan_dan_Dapodik.md:

1. Buat migration database MySQL 8.0 untuk skema: ppdb_periods, ppdb_registrations, ppdb_documents, tuition_tariffs, student_invoices, payment_transactions, scholarship_grants, dapodik_export_logs.
2. Bangun REST API backend:
   - Portal PPDB Publik: Form pendaftaran calon santri (nasional & diaspora) + upload berkas digital
   - Verifikasi PPDB & Konversi Otomatis: Calon santri diterima -> auto insert ke students & users
   - Manajemen Keuangan SPP: Generate invoice bulanan massal, pencatatan transaksi bayar, maker-checker verifikasi bukti transfer
   - Beasiswa donatur & potongan biaya
   - Ekspor Dapodik: Validasi kelengkapan atribut Dapodik & download file CSV/Excel terstandar Kemendikbudristek
3. Bangun antarmuka frontend SPA:
   - Formulir pendaftaran publik PPDB multi-step wizard
   - Dashboard Panitia PPDB (verifikasi berkas & aksi kelulusan)
   - Portal Keuangan Orang Tua/Santri (daftar invoice & upload bukti transfer)
   - Panel Rekonsiliasi Kas Keuangan Admin
   - Halaman Ekspor Format Dapodik.

Pastikan proses pendaftaran publik aman dan alur mutasi calon santri menjadi santri resmi berjalan mulus.
```
