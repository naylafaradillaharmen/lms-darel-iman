# Spesifikasi Teknis Tahap 3: Asesmen, Evaluasi CBT & E-Rapor Digital
**Proyek:** PKBM Digital Dar El Iman  
**Fase:** Tahap 3 (SIKLUS EVALUASI & PENERBITAN HASIL BELAJAR)  
**Tujuan Utama:** Menyelenggarakan ujian daring terstandar (CBT) dengan pencegah kecurangan, pengolahan nilai komprehensif (akademik & tahfizh), serta penerbitan e-Rapor dan dokumen kelulusan resmi ber-QR Code.

---

## 1. Sasaran Operasional & Batasan Tahap

Setelah tahap ini selesai dibangun:
- [x] Bank soal ujian terstruktur berdasarkan mata pelajaran dan capaian kompetensi.
- [x] Engine CBT siap menggelar Ujian Tengah Semester (UTS), Ujian Akhir Semester (UAS), atau Asesmen Sumatif secara daring.
- [x] Sistem proctoring dasar aktif mendeteksi pelanggaran (berpindah tab, keluar mode layar penuh, jeda waktu mencurigakan).
- [x] Nilai pilihan ganda dinilai otomatis (*auto-graded*), nilai esai dinilai manual oleh tutor.
- [x] Skema remedial otomatis bagi santri yang belum mencapai kriteria ketuntasan minimal (KKM).
- [x] Rekapitulasi nilai akhir (kehadiran, tugas LMS, ujian CBT, dan setoran hafalan tahfizh dari Tahap 2) terkumpul otomatis ke Buku Nilai.
- [x] E-Rapor semester berformat resmi PKBM Kemendikbudristek siap dicetak ke PDF dengan QR Code verifikasi keabsahan dokumen publik.

---

## 2. Modul yang Dikerjakan

| Modul | Deskripsi Fungsional | Role Terkait |
|---|---|---|
| **M15: Bank Butir Soal** | Pengelolaan butir soal (Pilihan Ganda, Esai), bobot kesulitan, kunci jawaban, dan pembahasan. | Tutor, Tim Kurikulum |
| **M16: Engine Ujian Daring (CBT)** | Penjadwalan ujian, token akses ujian, durasi/timer otomatis, pengacakan urutan soal & pilihan ganda, auto-save jawaban santri. | Tutor, Santri, Proktor |
| **M17: Proctoring & Anti-Cheat** | Pembatasan layar penuh (*fullscreen lock*), deteksi tab-switch / kehilangan fokus kursor, log pencatatan insiden kecurangan ke proktor. | Proktor, Santri |
| **M18: Remedial & Pengayaan** | Deteksi otomatis nilai di bawah ambang batas, pengerjaan tugas/ujian susulan khusus remedial, pembaruan rekam nilai. | Tutor, Santri |
| **M19: Buku Nilai & Rubrik (Grading)** | Penentuan bobot penilaian (Presensi 10%, Tugas 20%, Tahfizh 30%, UTS 20%, UAS 20%), maker-checker penguncian nilai rapor. | Tutor, Manajer Akademik |
| **M20: E-Rapor & Dokumen Ber-QR** | Kompilasi nilai akhir, capaian deskriptif, catatan wali kelas, dan generator PDF e-Rapor resmi dengan verifikasi QR Code publik. | Wali Kelas, Santri, Orang Tua |

---

## 3. Skema Basis Data MySQL 8.0 (DDL)

```sql
-- 1. TABEL BANK SOAL
CREATE TABLE question_banks (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    subject_id CHAR(36) NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    created_by_tutor_id CHAR(36) REFERENCES tutors(id) ON DELETE SET NULL,
    title VARCHAR(200) NOT NULL,
    grade_level_id CHAR(36) REFERENCES grade_levels(id) ON DELETE SET NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE questions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    question_bank_id CHAR(36) NOT NULL REFERENCES question_banks(id) ON DELETE CASCADE,
    question_type VARCHAR(20) NOT NULL CHECK (question_type IN ('MULTIPLE_CHOICE', 'ESSAY')),
    prompt_text TEXT NOT NULL,
    attachment_image_url TEXT,
    points DECIMAL(5,2) DEFAULT 10.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE question_options (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    question_id CHAR(36) NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_key VARCHAR(5) NOT NULL, -- 'A', 'B', 'C', 'D', 'E'
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABEL SESI UJIAN CBT
CREATE TABLE exam_events (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    course_class_id CHAR(36) NOT NULL REFERENCES course_classes(id) ON DELETE CASCADE,
    question_bank_id CHAR(36) NOT NULL REFERENCES question_banks(id) ON DELETE RESTRICT,
    title VARCHAR(200) NOT NULL,
    exam_type VARCHAR(30) NOT NULL CHECK (exam_type IN ('UTS', 'UAS', 'KUIS_HARIAN', 'REMEDIAL')),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 90,
    exam_token VARCHAR(20),
    randomize_questions BOOLEAN DEFAULT TRUE,
    randomize_options BOOLEAN DEFAULT TRUE,
    passing_score DECIMAL(5,2) DEFAULT 75.00,
    status VARCHAR(20) DEFAULT 'SCHEDULED' CHECK (status IN ('SCHEDULED', 'ACTIVE', 'COMPLETED')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Partisipasi Ujian per Siswa
CREATE TABLE exam_attempts (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    exam_event_id CHAR(36) NOT NULL REFERENCES exam_events(id) ON DELETE CASCADE,
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    started_at DATETIME,
    finished_at DATETIME,
    status VARCHAR(20) DEFAULT 'IN_PROGRESS' CHECK (status IN ('IN_PROGRESS', 'SUBMITTED', 'DISQUALIFIED')),
    total_score DECIMAL(5,2),
    is_passed BOOLEAN,
    cheat_incident_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_student_exam_attempt UNIQUE (exam_event_id, student_id)
);

CREATE TABLE exam_answers (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    exam_attempt_id CHAR(36) NOT NULL REFERENCES exam_attempts(id) ON DELETE CASCADE,
    question_id CHAR(36) NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    selected_option_id CHAR(36) REFERENCES question_options(id) ON DELETE SET NULL,
    essay_answer TEXT,
    is_auto_graded BOOLEAN DEFAULT FALSE,
    awarded_points DECIMAL(5,2),
    saved_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_attempt_question UNIQUE (exam_attempt_id, question_id)
);

CREATE TABLE exam_proctor_logs (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    exam_attempt_id CHAR(36) NOT NULL REFERENCES exam_attempts(id) ON DELETE CASCADE,
    incident_type VARCHAR(50) NOT NULL, -- 'TAB_SWITCH', 'FULLSCREEN_EXIT', 'IDLE_TIMEOUT'
    description TEXT,
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABEL BUKU NILAI & E-RAPOR
CREATE TABLE final_grade_weights (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    course_class_id CHAR(36) UNIQUE NOT NULL REFERENCES course_classes(id) ON DELETE CASCADE,
    attendance_weight INT DEFAULT 10,
    assignment_weight INT DEFAULT 20,
    tahfizh_weight INT DEFAULT 30,
    uts_weight INT DEFAULT 20,
    uas_weight INT DEFAULT 20,
    is_locked BOOLEAN DEFAULT FALSE,
    locked_by_user_id CHAR(36) REFERENCES users(id) ON DELETE SET NULL,
    locked_at DATETIME
);

CREATE TABLE student_report_cards (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    academic_year_id CHAR(36) NOT NULL REFERENCES academic_years(id) ON DELETE RESTRICT,
    classroom_id CHAR(36) NOT NULL REFERENCES classrooms(id) ON DELETE RESTRICT,
    homeroom_notes TEXT,
    spiritual_behavior_grade VARCHAR(5) DEFAULT 'A',
    social_behavior_grade VARCHAR(5) DEFAULT 'A',
    tahfizh_summary TEXT,
    qr_verification_code VARCHAR(100) UNIQUE NOT NULL,
    pdf_file_url TEXT,
    published_at DATETIME,
    CONSTRAINT uq_student_report UNIQUE (student_id, academic_year_id)
);

CREATE TABLE report_card_grades (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    report_card_id CHAR(36) NOT NULL REFERENCES student_report_cards(id) ON DELETE CASCADE,
    subject_id CHAR(36) NOT NULL REFERENCES subjects(id) ON DELETE RESTRICT,
    numerical_score DECIMAL(5,2) NOT NULL,
    letter_grade VARCHAR(5) NOT NULL,
    competency_notes TEXT,
    PRIMARY KEY (report_card_id, subject_id)
);

-- Indeks Kinerja
CREATE INDEX idx_exam_answers_attempt ON exam_answers(exam_attempt_id);
CREATE INDEX idx_student_report_qr ON student_report_cards(qr_verification_code);
```

---

## 4. Spesifikasi REST API Endpoints

### 4.1 Bank Soal & Ujian CBT (`/api/v1/exams`)
- `POST /banks`: Buat bank soal mapel baru.
- `POST /banks/:id/questions`: Tambah butir soal (Pilihan Ganda/Esai + opsi jawaban).
- `POST /events`: Jadwalkan sesi ujian (tentukan token, durasi, tanggal mulai/selesai).
- `POST /events/:id/start`: Santri memasukkan token dan memulai pengerjaan ujian.
- `POST /attempts/:attempt_id/answer`: Simpan jawaban butir soal secara berkala (*auto-save*).
- `POST /attempts/:attempt_id/log-incident`: Rekam insiden pindah tab / keluar layar penuh.
- `POST /attempts/:attempt_id/finish`: Santri menyelesaikan ujian dan submit final.
- `GET /events/:id/monitoring`: Proktor melihat daftar santri aktif, status online, dan peringatan kecurangan *real-time*.

### 4.2 Rekapitulasi Nilai & Remedial (`/api/v1/grading`)
- `POST /courses/:id/calculate-scores`: Hitung nilai akhir gabungan otomatis berdasarkan bobot.
- `GET /courses/:id/remedial-candidates`: Daftar santri yang nilainya di bawah KKM.
- `POST /courses/:id/lock-grades`: Kunci nilai akhir (maker-checker oleh Kepala PKBM).

### 4.3 E-Rapor Digital (`/api/v1/report-cards`)
- `POST /generate-batch`: Generate e-Rapor PDF untuk satu rombel kelas.
- `GET /student/:student_id/semester/:year_id`: Ambil e-Rapor santri.
- `GET /verify/:qr_code`: Halaman publik tanpa login untuk memverifikasi keaslian e-Rapor resmi Yayasan Dar El Iman.

---

## 5. Kebutuhan Antarmuka Frontend (UI Screens)

1. **Antarmuka Lembar Ujian CBT Santri (`/exam/take/:attempt_id`)**:
   - Mode layar penuh otomatis (*auto-fullscreen*).
   - Indikator timer hitung mundur mencolok di sudut atas.
   - Panel nomor soal dengan kode warna (Hijau: Sudah dijawab, Kuning: Ragu-ragu, Abu-abu: Belum dijawab).
   - Tombol "Selesai Ujian" dengan konfirmasi dialog berlapis.
   - Detektor peringatan: Popup peringatan merah jika santri mencoba membuka aplikasi lain atau keluar dari tab.
2. **Dashboard Pemantauan Proktor Ujian (`/exam/monitor/:event_id`)**:
   - Grid status seluruh peserta ujian (Sedang Mengerjakan, Selesai, Terindikasi Pelanggaran).
   - Tombol reset login peserta (jika koneksi santri terputus mendadak).
3. **Buku Nilai Guru & Wali Kelas (`/grading/gradebook/:class_id`)**:
   - Spreadsheet interaktif berisi rekap nilai: Presensi, Tugas, CBT, Nilai Tahfizh, dan Nilai Akhir.
4. **Halaman Pratinjau & Unduh E-Rapor (`/report-cards/view/:id`)**:
   - Tampilan format cetak A4 rapi, logo resmi Yayasan Dar El Iman Padang, tanda tangan digital, dan QR Code di sudut bawah.
5. **Halaman Publik Verifikasi QR (`/verify-rapor/:qr_code`)**:
   - Halaman publik bersih yang menampilkan status dokumen: Dokumen Rapor Ini Resmi & Valid Diterbitkan oleh PKBM Digital Dar El Iman untuk Santri: [Nama] - Tahun Ajaran: [TA].

---

## 6. Skenario Pengujian & Kriteria Selesai (Definition of Done)

Tahap 3 dinyatakan **SELESAI & LULUS** jika:
1. Tutor berhasil membuat 1 Bank Soal berisi 10 soal Pilihan Ganda dan 1 soal Esai.
2. Sesi ujian UTS berhasil dijadwalkan dengan token.
3. Santri dapat login, memasukkan token, menjawab 10 soal pilihan ganda, dan submit sebelum waktu habis.
4. Auto-save jawaban berfungsi (jika browser di-refresh, jawaban tersimpan tetap utuh).
5. Deteksi pindah tab berhasil merekam insiden kecurangan ke tabel log proktor.
6. Soal pilihan ganda dinilai otomatis dan skor langsung terkalkulasi.
7. Modul e-Rapor berhasil menghitung nilai gabungan (termasuk nilai hafalan tahfizh dari Tahap 2) dan menghasilkan 1 berkas PDF e-Rapor ber-QR Code yang valid saat di-scan kamera HP.

---

## 7. PROMPT INSTRUKSI SIAP PAKAI (Copy-Paste ke AI Generator)

Salin blok prompt berikut saat Anda ingin meminta AI membangun kode untuk Tahap 3:

```text
Tolong implementasikan backend dan frontend untuk TAHAP 3 PKBM DIGITAL DAR EL IMAN sesuai dokumen spesifikasi Tahap_03_Asesmen_CBT_dan_Rapor.md:

1. Buat migration database MySQL 8.0 untuk skema: question_banks, questions, question_options, exam_events, exam_attempts, exam_answers, exam_proctor_logs, final_grade_weights, student_report_cards, report_card_grades.
2. Bangun REST API backend:
   - Bank Soal & Manajemen butir soal (Pilihan Ganda & Esai)
   - Engine Sesi Ujian CBT: Token ujian, timer, auto-save jawaban santri, auto-grading PG
   - Proctoring log: Catat pelanggaran buka tab lain
   - Kalkulasi Buku Nilai: Kombinasi presensi, tugas LMS, nilai ujian CBT, dan nilai Halaqah Tahfizh
   - Generator E-Rapor PDF ber-QR Code + endpoint publik verifikasi keaslian rapor
3. Bangun antarmuka frontend SPA:
   - Layar Ujian CBT Santri (fullscreen lock, timer, nomor soal interaktif, peringatan curang)
   - Dashboard Proktor Ujian (monitoring status santri real-time)
   - Buku Nilai Kelas untuk Wali Kelas / Guru
   - Pratinjau dan unduh PDF e-Rapor.

Pastikan proses pengerjaan ujian tahan putus koneksi (koneksi lemot/terputus tetap aman karena auto-save).
```
