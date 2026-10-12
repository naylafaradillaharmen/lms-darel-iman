# Spesifikasi Teknis Tahap 1: Fondasi Sistem, Autentikasi & Input Master Data
**Proyek:** PKBM Digital Dar El Iman  
**Fase:** Tahap 1 (Wajib Selesai Pertama)  
**Tujuan Utama:** Admin dapat login, mengonfigurasi lembaga, menginput data tutor & santri (manual/massal), serta mengelompokkannya ke dalam rombongan belajar (rombel/kelas). Akun pengguna aktif dan siap login.

---

## 1. Sasaran Operasional & Batasan Tahap

Setelah tahap ini selesai dibangun:
- [x] Super Admin dan Staf Operator dapat login ke dalam sistem secara aman.
- [x] Konfigurasi lembaga (Yayasan Dar El Iman, jenjang Paket A, B, C, serta Tahun Ajaran/Semester aktif) telah tersimpan.
- [x] Data seluruh Tutor (guru/ustadz) berhasil diinput, dan akun login tutor diterbitkan.
- [x] Data seluruh Santri/Siswa (termasuk penanda diaspora dan kontak wali) berhasil diinput manual maupun lewat impor file Excel/CSV.
- [x] Rombongan Belajar (Rombel/Kelas) terbentuk, wali kelas ditunjuk, dan santri telah di-plot ke rombel masing-masing.
- [x] Santri dan Tutor dapat login dengan akun masing-masing dan melihat profil pribadinya.

---

## 2. Modul yang Dikerjakan

| Modul | Deskripsi Fungsional | Role Terkait |
|---|---|---|
| **M01: Akun & Autentikasi** | Login email/username, JWT token (access + refresh), hash password Argon2/Bcrypt, ganti password, logout. | Semua Role |
| **M02: RBAC & Hak Akses** | 4-layer evaluation (Module -> Feature -> Action -> Scope). Pengelolaan pengguna & peran: Super Admin, Operator, Tutor, Siswa. | Super Admin, Operator |
| **M03: Pengaturan Lembaga** | Profil PKBM Dar El Iman, identitas NPSN, status jenjang (Paket A, B, C), manajemen Tahun Ajaran & Semester aktif. | Super Admin, Operator |
| **M04: Master Data Tutor** | Input biodata pendidik (NIP, gelar, spesialisasi mapel/tahfizh, kontak), auto-generate akun pengguna pendidik. | Operator, Tutor |
| **M05: Master Data Santri** | Input data santri (NIS, NISN, NIK, TTL, data wali, penanda diaspora & zona waktu), impor massal Excel/CSV, auto-generate akun. | Operator, Santri |
| **M06: Rombongan Belajar (Rombel)** | Pembuatan kelas per jenjang dan tahun ajaran, penunjukan wali kelas, serta penetapan daftar santri per kelas. | Operator, Tutor |
| **M07: Audit Trail Dasar** | Pencatatan otomatis riwayat penambahan/perubahan akun dan data kesiswaan (siapa, kapan, perubahan data apa). | Super Admin |

---

## 3. Skema Basis Data MySQL 8.0 (DDL)

```sql
-- Ekstensi CHAR(36)
-- 1. TABEL PENGATURAN LEMBAGA & TAHUN AJARAN
CREATE TABLE institutions (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    name VARCHAR(255) NOT NULL DEFAULT 'PKBM Digital Dar El Iman',
    npsn VARCHAR(20) UNIQUE,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(100),
    website VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE academic_years (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    institution_id CHAR(36) NOT NULL REFERENCES institutions(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL, -- Contoh: '2026/2027'
    semester VARCHAR(10) NOT NULL CHECK (semester IN ('GANJIL', 'GENAP')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_academic_year_semester UNIQUE (institution_id, name, semester)
);

CREATE TABLE grade_levels (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    package_type VARCHAR(10) NOT NULL CHECK (package_type IN ('PAKET_A', 'PAKET_B', 'PAKET_C')),
    level_number INT NOT NULL, -- 1 s/d 6 untuk Paket A, 7 s/d 9 untuk Paket B, 10 s/d 12 untuk Paket C
    name VARCHAR(50) NOT NULL, -- Contoh: 'Paket C - Kelas 10'
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABEL PENGGUNA, PERAN & KEAMANAN (RBAC)
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    avatar_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    last_login_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    name VARCHAR(50) UNIQUE NOT NULL, -- 'SUPER_ADMIN', 'OPERATOR', 'TUTOR', 'SISWA', 'WALI_SANTRI'
    display_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE user_roles (
    user_id CHAR(36) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id CHAR(36) NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    institution_id CHAR(36) REFERENCES institutions(id) ON DELETE CASCADE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE refresh_tokens (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    user_id CHAR(36) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    revoked_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABEL DATA MASTER TUTOR (PENDIDIK)
CREATE TABLE tutors (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    user_id CHAR(36) UNIQUE NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    nip VARCHAR(50) UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('L', 'P')),
    specialization VARCHAR(100), -- Contoh: 'Tahfizh Al-Qur\'an', 'Matematika'
    phone VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. TABEL DATA MASTER SANTRI (SISWA) & WALI
CREATE TABLE students (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    user_id CHAR(36) UNIQUE NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    nis VARCHAR(50) UNIQUE NOT NULL,
    nisn VARCHAR(20) UNIQUE,
    nik VARCHAR(20),
    full_name VARCHAR(255) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('L', 'P')),
    birth_place VARCHAR(100),
    birth_date DATE,
    address TEXT,
    
    -- Kolom Khusus Diaspora & Multi-Timezone
    is_diaspora BOOLEAN DEFAULT FALSE,
    country VARCHAR(100) DEFAULT 'Indonesia',
    timezone VARCHAR(50) DEFAULT 'Asia/Jakarta',
    
    -- Data Orang Tua / Wali
    guardian_name VARCHAR(255),
    guardian_phone VARCHAR(50),
    guardian_relationship VARCHAR(50), -- 'Ayah', 'Ibu', 'Wali'
    
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' 
        CHECK (status IN ('ACTIVE', 'ON_LEAVE', 'GRADUATED', 'DROPPED_OUT')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. TABEL ROMBONGAN BELAJAR (ROMBEL/KELAS)
CREATE TABLE classrooms (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    academic_year_id CHAR(36) NOT NULL REFERENCES academic_years(id) ON DELETE RESTRICT,
    grade_level_id CHAR(36) NOT NULL REFERENCES grade_levels(id) ON DELETE RESTRICT,
    name VARCHAR(100) NOT NULL, -- Contoh: 'Kelas X Paket C - Al-Fatih'
    homeroom_tutor_id CHAR(36) REFERENCES tutors(id) ON DELETE SET NULL,
    capacity INT DEFAULT 30,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_classroom_name_per_year UNIQUE (academic_year_id, name)
);

CREATE TABLE classroom_students (
    classroom_id CHAR(36) NOT NULL REFERENCES classrooms(id) ON DELETE CASCADE,
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (classroom_id, student_id)
);

-- 6. TABEL AUDIT LOG SEDERHANA
CREATE TABLE audit_logs (
    id CHAR(36) PRIMARY KEY DEFAULT (CHAR(36)()),
    user_id CHAR(36) REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL, -- 'CREATE_STUDENT', 'UPDATE_INSTITUTION', etc.
    target_table VARCHAR(100) NOT NULL,
    target_id CHAR(36),
    details JSON,
    ip_address VARCHAR(45),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indeks Kinerja
CREATE INDEX idx_users_username_email ON users(username, email);
CREATE INDEX idx_students_nis_nisn ON students(nis, nisn);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_classroom_students_cid ON classroom_students(classroom_id);
```

---

## 4. Spesifikasi REST API Endpoints

Semua response dikembalikan dalam format standar:
```json
{
  success: true,
  message: Operasi berhasil,
  data: { ... }
}
```

### 4.1 Autentikasi (/api/v1/auth)
- POST /login: Request { username: admin, password: ... }. Menghasilkan { access_token: ..., refresh_token: ..., user: { ... } }.
- POST /refresh: Request { refresh_token: ... }. Menghasilkan access token baru.
- POST /logout: Mencabut refresh token yang aktif.
- GET /me: Mengambil data profil dan permission user yang sedang login.
- PUT /change-password: Ganti kata sandi { current_password: ..., new_password: ... }.

### 4.2 Pengaturan Lembaga & Akademik (/api/v1/master)
- GET /institution: Profil lembaga & tahun ajaran aktif.
- PUT /institution: Update kontak/profil lembaga.
- GET /academic-years: Daftar tahun ajaran & semester.
- POST /academic-years: Buat tahun ajaran baru.
- PUT /academic-years/:id/activate: Aktifkan tahun ajaran (hanya 1 yang aktif).
- GET /grade-levels: Daftar jenjang (Paket A, B, C).

### 4.3 Master Data Tutor (/api/v1/tutors)
- GET /: Daftar tutor (pagination, pencarian nama/NIP).
- POST /: Tambah data tutor baru + opsi auto-generate akun user.
- GET /:id: Detail data tutor.
- PUT /:id: Update profil tutor.
- DELETE /:id: Nonaktifkan tutor.

### 4.4 Master Data Santri (/api/v1/students)
- GET /: Daftar santri (filter status, jenjang, rombel, pencarian nama/NIS).
- POST /: Input data santri baru + auto-generate akun user.
- POST /bulk-import: Unggah file CSV/Excel daftar santri dengan auto-validasi format.
- GET /:id: Detail profil santri & informasi wali.
- PUT /:id: Update biodata santri.
- DELETE /:id: Nonaktifkan / ubah status santri.

### 4.5 Manajemen Rombel / Kelas (/api/v1/classrooms)
- GET /: Daftar rombel pada tahun ajaran aktif beserta jumlah siswa dan wali kelas.
- POST /: Buat rombel baru (pilih jenjang & tunjuk wali kelas).
- GET /:id/students: Daftar santri dalam rombel tersebut.
- POST /:id/students: Tambah/plot santri ke dalam rombel.
- DELETE /:id/students/:student_id: Keluarkan santri dari rombel.

---

## 5. Kebutuhan Antarmuka Frontend (UI Screens)

> **Catatan Integrasi UI:**  
> Seluruh tata letak, palet warna Islami modern (*Emerald Green #047857*, *Gold #b8892b*, tema terang/gelap, font *Plus Jakarta Sans* & *Amiri*), sidebar navigasi, header zona waktu, dan kartu dashboard **mengacu langsung pada prototipe antarmuka yang telah dibuat sebelumnya** di berkas:  
> [`referensi/PKBM Digital Dar El Iman — Prototipe UI.html`](file:///D:/lms-darel-iman/referensi/PKBM%20Digital%20Dar%20El%20Iman%20-%20Prototipe%20UI.html).

Halaman antarmuka yang difungsikan pada Tahap 1:
1. **Halaman Login (`/login`)**:
   - Layout login bersih mengadopsi identitas visual Dar El Iman.
   - Form input username/email, password, pesan validasi error.
2. **Dashboard Master Admin (`/dashboard`)**:
   - Kartu statistik: Total Santri Aktif, Total Tutor, Jumlah Rombel Aktif, Tahun Ajaran Aktif.
3. **Halaman Manajemen Lembaga (`/admin/institution`)**:
   - Form profil lembaga, daftar tahun ajaran, dan aktivasi semester.
4. **Halaman Data Pendidik / Tutor (`/admin/tutors`)**:
   - Tabel tutor, filter status aktif, modal tambah/edit data tutor.
5. **Halaman Data Santri (`/admin/students`)**:
   - Tabel santri dengan filter rombel dan status diaspora.
   - Tombol "Tambah Santri Manual" dan "Impor Excel/CSV" dengan unduhan format template.
6. **Halaman Pembagian Rombel (`/admin/classrooms`)**:
   - Pembagian kelas per jenjang (Paket A / B / C) dan penetapan wali kelas & santri.

## 6. Skenario Pengujian & Kriteria Selesai (Definition of Done)

Tahap 1 dinyatakan **SELESAI & LULUS** jika:
1. Skrip database MySQL 8.0 berhasil di-migrate tanpa error.
2. Data seeder awal (Super Admin default, Jenjang Paket A, B, C, dan Tahun Ajaran 2026/2027 Ganjil) terisi.
3. Login Super Admin berhasil dan menerima token JWT.
4. Operator dapat mengunggah minimal 1 file Excel contoh berisi 30 santri; semua data masuk ke tabel students dan otomatis terbuat akun login di tabel users.
5. Tutor dan Santri yang telah diinput dapat login menggunakan username/password mereka dan melihat profil masing-masing.
6. Rombel terbentuk dan 30 santri tersebut berhasil dimasukkan ke rombel kelas.

---

## 7. PROMPT INSTRUKSI SIAP PAKAI (Decoupled Backend & Frontend)

Karena arsitektur sistem memisahkan Backend (Go API) dan Frontend (SPA) serta tata letak awal mengacu pada prototipe Claude, Anda dapat menggunakan prompt sesuai kebutuhan berikut:

### Opsi A: Prompt untuk Generate Backend Saja (Go API & MySQL 8.0)
```text
Tolong bangun BACKEND API untuk TAHAP 1 PKBM DIGITAL DAR EL IMAN sesuai dokumen spesifikasi Tahap_01_Fondasi_Auth_dan_Master_Data.md:

1. Buat migration database MySQL 8.0: institutions, academic_years, grade_levels, users, roles, user_roles, refresh_tokens, tutors, students, classrooms, classroom_students, audit_logs.
2. Sediakan seeder: Super Admin default (username: admin, pass: admin123), master roles, jenjang Paket A/B/C, dan tahun ajaran 2026/2027 Ganjil aktif.
3. Bangun REST API Go (Chi router + sqlc / GORM dengan driver go-sql-driver/mysql):
   - Auth JWT (login, refresh, me, logout, change-password)
   - CRUD Master Data Tutor + auto-create user account
   - CRUD Master Data Santri + bulk import Excel/CSV + auto-create user account
   - CRUD Rombel/Classroom + plotting siswa ke rombel
4. Lengkapi dengan middleware JWT auth dan evaluasi role RBAC.
```

### Opsi B: Prompt untuk Frontend (Mengadopsi Desain Layout Prototipe Claude)
```text
Tolong bangun FRONTEND SPA untuk TAHAP 1 PKBM DIGITAL DAR EL IMAN:

1. Gunakan acuan tata letak, warna (Emerald & Gold), font, dan komponen dari prototipe yang sudah dibuat:
   referensi/PKBM Digital Dar El Iman — Prototipe UI.html.
2. Implementasikan halaman-halaman Tahap 1:
   - Halaman Login (koneksi ke /api/v1/auth/login)
   - Dashboard Admin (statistik ringkasan data)
   - Halaman Kelola Data Tutor (tabel + modal tambah tutor)
   - Halaman Kelola Data Santri (tabel + form santri + upload file impor Excel/CSV)
   - Halaman Plotting Rombel/Kelas.
3. Integrasikan pemanggilan data ke REST API backend Go sesuai spesifikasi Tahap 1.
```

### Opsi C: Prompt Fullstack (Backend + Frontend Sekaligus)
```text
Tolong implementasikan backend Go dan frontend SPA untuk TAHAP 1 PKBM DIGITAL DAR EL IMAN sesuai dokumen spesifikasi Tahap_01_Fondasi_Auth_dan_Master_Data.md, dengan tampilan antarmuka yang mengadopsi komponen dari referensi/PKBM Digital Dar El Iman — Prototipe UI.html.
```
