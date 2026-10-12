# Spesifikasi Teknis Tahap 2: Kurikulum, Pembelajaran LMS & Halaqah Tahfizh
**Proyek:** PKBM Digital Dar El Iman  
**Fase:** Tahap 2 (MILESTONE KRUSIAL — KEGIATAN BELAJAR MENGAJAR DIMULAI)  
**Tujuan Utama:** Menghubungkan guru dan santri dalam ruang kelas virtual (LMS), mendistribusikan materi ajar, memberikan penugasan & presensi, serta mengaktifkan Halaqah Tahfizh Al-Qur'an terpadu.

---

## 1. Sasaran Operasional & Batasan Tahap

Setelah tahap ini selesai dibangun:
- [x] Kurikulum terstruktur (Mapel umum kesetaraan & kurikulum khas Dar El Iman: Tahfizh, Adab & Akidah, Bahasa Arab, AI Literacy) telah terdaftar.
- [x] Jadwal KBM per kelas/rombel tersusun rapi dengan informasi waktu yang jelas.
- [x] Tutor dapat membuat topik mingguan, mengunggah materi (PDF, dokumen, video link YouTube/Google Drive), dan membagikannya ke kelas.
- [x] Santri dapat membuka materi ajar, membaca modul, dan mengisi presensi kehadiran sesi kelas.
- [x] Tutor dapat memberikan tugas, dan santri dapat mengunggah file jawaban tugas secara online.
- [x] Tutor Tahfizh dapat mencatat setoran hafalan harian santri (surah, ayat, kelancaran, tajwid) sehingga progres santri terpantau jelas.
- [x] **TARGET PIMPINAN TERCAPAI**: Santri dan Tutor telah aktif belajar-mengajar secara digital!

---

## 2. Modul yang Dikerjakan

| Modul | Deskripsi Fungsional | Role Terkait |
|---|---|---|
| **M08: Manajemen Kurikulum & Mapel** | Master mata pelajaran kesetaraan (Paket A/B/C) dan mapel keislaman/kepesantrenan Dar El Iman, capaian pembelajaran (CP). | Manajer Akademik, Tutor |
| **M09: Penugasan Pengajar & Rombel** | Memetakan Guru Pengampu pada Mata Pelajaran di Rombel tertentu (contoh: Ustadz Ahmad -> Mapel Tahfizh di Kelas X Al-Fatih). | Operator, Tutor |
| **M10: Penjadwalan Sesi KBM** | Jadwal belajar per rombel, hari, jam mulai-selesai, link kelas tatap muka virtual (Google Meet/Zoom jika ada), dukungan multi-timezone. | Operator, Tutor, Santri |
| **M11: Ruang Kelas LMS & Materi Ajar** | Struktur silabus mingguan (Pertemuan 1 s/d 16), unggah artikel/materi, file unduhan (PDF/Slide), tautan video ajar. | Tutor, Santri |
| **M12: Tugas & Submission Santri** | Pembuatan instruksi tugas dengan tenggat waktu (*deadline*), upload berkas jawaban oleh santri, review & nilai cepat dari tutor. | Tutor, Santri |
| **M13: Presensi / Kehadiran Belajar** | Pencatatan kehadiran santri per sesi pertemuan (Hadir, Izin, Sakit, Alpa), tombol 'Check-In' santri mandiri atau dicatat tutor. | Tutor, Santri |
| **M14: Halaqah Tahfizh Interaktif** | Modul khusus pencatatan setoran hafalan (Ziyadah/Muraja'ah): nama surah, rentang ayat, nilai makhraj & kelancaran, catatan ustadz. | Tutor Tahfizh, Santri, Orang Tua |

---

## 3. Skema Basis Data MySQL 8.0 (DDL)

```sql
-- 1. TABEL KURIKULUM & MATA PELAJARAN
CREATE TABLE subjects (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) UNIQUE NOT NULL, -- Contoh: 'THF-01', 'MTK-10'
    name VARCHAR(150) NOT NULL, -- Contoh: 'Tahfizh Al-Qur\'an Tematik', 'Matematika'
    category VARCHAR(50) NOT NULL CHECK (category IN ('UMUM_KEMENDIKBUD', 'KHAS_DAR_EL_IMAN', 'KETERAMPILAN')),
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Pengikatan Mapel ke Jenjang (Paket A, B, atau C)
CREATE TABLE grade_subjects (
    grade_level_id CHAR(36) NOT NULL REFERENCES grade_levels(id) ON DELETE CASCADE,
    subject_id CHAR(36) NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    credit_hours INT DEFAULT 2, -- Jumlah JP / Bobot
    PRIMARY KEY (grade_level_id, subject_id)
);

-- Pengikatan Guru Pengampu ke Rombel & Mapel (Course Offering)
CREATE TABLE course_classes (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    classroom_id CHAR(36) NOT NULL REFERENCES classrooms(id) ON DELETE CASCADE,
    subject_id CHAR(36) NOT NULL REFERENCES subjects(id) ON DELETE RESTRICT,
    tutor_id CHAR(36) NOT NULL REFERENCES tutors(id) ON DELETE RESTRICT,
    academic_year_id CHAR(36) NOT NULL REFERENCES academic_years(id) ON DELETE CASCADE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_class_subject UNIQUE (classroom_id, subject_id)
);

-- 2. TABEL JADWAL KBM
CREATE TABLE class_schedules (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    course_class_id CHAR(36) NOT NULL REFERENCES course_classes(id) ON DELETE CASCADE,
    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 1 AND 7), -- 1=Senin, 7=Ahad
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    meeting_link TEXT, -- Link Zoom / GMeet jika sesi sinkron
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABEL TOPIK / MODUL PEMBELAJARAN LMS
CREATE TABLE course_topics (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    course_class_id CHAR(36) NOT NULL REFERENCES course_classes(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL, -- Contoh: 'Pertemuan 1: Pengantar Adab Penuntut Ilmu'
    sequence_order INT NOT NULL DEFAULT 1,
    description TEXT,
    is_published BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE topic_materials (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    course_topic_id CHAR(36) NOT NULL REFERENCES course_topics(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    material_type VARCHAR(50) NOT NULL CHECK (material_type IN ('DOCUMENT', 'VIDEO_LINK', 'TEXT_ARTICLE')),
    content_body TEXT, -- Isi artikel jika teks
    file_url TEXT, -- Path dokumen PDF/file
    external_link TEXT, -- URL YouTube / Drive
    sequence_order INT DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. TABEL PENUGASAN (ASSIGNMENTS)
CREATE TABLE assignments (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    course_topic_id CHAR(36) NOT NULL REFERENCES course_topics(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    instructions TEXT NOT NULL,
    due_date DATETIME NOT NULL,
    max_score DECIMAL(5,2) DEFAULT 100.00,
    file_attachment_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE assignment_submissions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    assignment_id CHAR(36) NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    submission_text TEXT,
    file_url TEXT,
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    score DECIMAL(5,2),
    feedback TEXT,
    graded_by_tutor_id CHAR(36) REFERENCES tutors(id) ON DELETE SET NULL,
    graded_at DATETIME,
    CONSTRAINT uq_student_assignment UNIQUE (assignment_id, student_id)
);

-- 5. TABEL PRESENSI / KEHADIRAN SESI KBM
CREATE TABLE class_sessions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    course_class_id CHAR(36) NOT NULL REFERENCES course_classes(id) ON DELETE CASCADE,
    session_title VARCHAR(150) NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE session_attendances (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    class_session_id CHAR(36) NOT NULL REFERENCES class_sessions(id) ON DELETE CASCADE,
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PRESENT', 'PERMIT', 'SICK', 'ABSENT')),
    notes TEXT,
    recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_student_session UNIQUE (class_session_id, student_id)
);

-- 6. TABEL HALAQAH TAHFIZH AL-QUR'AN
CREATE TABLE tahfizh_groups (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    academic_year_id CHAR(36) NOT NULL REFERENCES academic_years(id) ON DELETE RESTRICT,
    name VARCHAR(100) NOT NULL, -- Contoh: 'Halaqah Imam Nafi - Ikhwan'
    tutor_id CHAR(36) NOT NULL REFERENCES tutors(id) ON DELETE RESTRICT,
    target_juz VARCHAR(50), -- Target juz yang sedang ditempuh
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tahfizh_group_students (
    tahfizh_group_id CHAR(36) NOT NULL REFERENCES tahfizh_groups(id) ON DELETE CASCADE,
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    PRIMARY KEY (tahfizh_group_id, student_id)
);

CREATE TABLE tahfizh_logs (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    tutor_id CHAR(36) NOT NULL REFERENCES tutors(id) ON DELETE RESTRICT,
    log_date DATE NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('ZIYADAH', 'MURAJAAH')), -- Hafalan baru vs Ulang
    surah_name VARCHAR(100) NOT NULL, -- Contoh: 'Al-Baqarah'
    start_ayah INT NOT NULL,
    end_ayah INT NOT NULL,
    fluency_score VARCHAR(20) CHECK (fluency_score IN ('MUMTAZ', 'JAYYID_JIDDAN', 'JAYYID', 'MAQBUL')),
    tajweed_score VARCHAR(20) CHECK (tajweed_score IN ('MUMTAZ', 'JAYYID_JIDDAN', 'JAYYID', 'MAQBUL')),
    audio_record_url TEXT, -- Link rekaman suara setoran jika diunggah
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indeks Kinerja
CREATE INDEX idx_course_classes_tutor ON course_classes(tutor_id);
CREATE INDEX idx_course_classes_classroom ON course_classes(classroom_id);
CREATE INDEX idx_tahfizh_logs_student ON tahfizh_logs(student_id, log_date);
```

---

## 4. Spesifikasi REST API Endpoints

### 4.1 Kurikulum & Penugasan Mapel (/api/v1/curriculum)
- GET /subjects: Ambil katalog mapel.
- POST /subjects: Tambah mapel baru (umum / khas Dar El Iman).
- GET /course-classes: Ambil daftar kelas mapel aktif (bisa filter rombel / tutor).
- POST /course-classes: Tunjuk tutor pengampu untuk mapel di suatu rombel.
- GET /schedules/classroom/:classroom_id: Jadwal mingguan satu rombel.

### 4.2 Ruang Kelas & Materi LMS (/api/v1/lms)
- GET /my-courses: Daftar kelas yang diikuti santri / diajar oleh tutor.
- GET /courses/:course_class_id/topics: Daftar silabus & topik materi ajar.
- POST /courses/:course_class_id/topics: Buat topik pertemuan baru (Tutor).
- POST /topics/:topic_id/materials: Tambah materi (upload PDF atau link YouTube) (Tutor).
- PUT /topics/:topic_id/publish: Publikasikan topik agar santri bisa membaca materi.

### 4.3 Tugas & Pengumpulan (/api/v1/assignments)
- POST /topics/:topic_id/assignments: Buat instruksi tugas baru beserta tenggat waktu.
- GET /:assignment_id: Detail instruksi tugas dan status pengumpulan.
- POST /:assignment_id/submit: Kirim jawaban tugas oleh santri (teks atau upload file lampiran).
- GET /:assignment_id/submissions: Tutor melihat seluruh jawaban santri di rombel tersebut.
- PUT /submissions/:submission_id/grade: Tutor memberi nilai dan umpan balik (feedback).

### 4.4 Presensi Belajar (/api/v1/attendances)
- POST /courses/:course_class_id/sessions: Buka sesi presensi pertemuan kelas.
- GET /sessions/:session_id: Cek daftar hadir siswa di sesi pertemuan tersebut.
- POST /sessions/:session_id/record: Catat kehadiran santri (Hadir, Sakit, Izin, Alpa) secara massal.
- POST /sessions/:session_id/check-in: Santri menekan tombol kehadiran mandiri.

### 4.5 Halaqah Tahfizh (/api/v1/tahfizh)
- GET /groups: Daftar kelompok halaqah tahfizh.
- POST /groups: Buat kelompok halaqah dan tunjuk Ustadz pembimbing.
- POST /groups/:id/students: Tambahkan santri ke halaqah.
- GET /students/:student_id/logs: Riwayat mutaba'ah setoran hafalan santri.
- POST /logs: Catat setoran harian (surah, ayat, ziyadah/muraja'ah, skor tajwid & kelancaran).

---

## 5. Kebutuhan Antarmuka Frontend (UI Screens)

1. **Dashboard Siswa / Santri (/student/portal)**:
   - Kartu mata pelajaran yang sedang ditempuh santri.
   - Jadwal kelas hari ini & link tatap muka langsung (Zoom/Meet).
   - Pengingat tugas yang mendekati tenggat waktu (*deadline banner*).
   - Ringkasan capaian hafalan Al-Qur'an (surah terakhir yang disetorkan).
2. **Dashboard Tutor / Ustadz (/tutor/portal)**:
   - Jadwal mengajar hari ini.
   - Daftar kelas binaan & daftar tugas yang perlu diperiksa/dinilai.
   - Pintasan cepat buka presensi dan catat setoran tahfizh.
3. **Ruang Kelas Virtual LMS (/lms/course/:id)**:
   - Navigasi tab: **Materi & Modul**, **Tugas**, **Presensi**, dan **Daftar Teman Sekelas**.
   - Tampilan topik bertingkat (Pertemuan 1, Pertemuan 2, dst.).
   - Pratinjau dokumen PDF terintegrasi dan video pemutar YouTube responsif.
4. **Halaman Pengumpulan & Penilaian Tugas (/lms/assignment/:id)**:
   - Sisi Santri: Form upload file drag-and-drop dan status  Sudah Dikumpulkan / Belum.
   - Sisi Tutor: Tabel periksa tugas, input nilai (0-100), dan kotak catatan evaluasi.
5. **Halaman Halaqah Tahfizh (/tahfizh)**:
   - Tampilan santri binaan per halaqah.
   - Form cepat catat setoran: dropdown Surah Al-Qur'an (1-114), input nomor ayat awal-akhir, opsi Ziyadah/Muraja'ah, dan tombol Mumtaz/Jayyid.
   - Grafik riwayat setoran bulanan santri.

---

## 6. Skenario Pengujian & Kriteria Selesai (Definition of Done)

Tahap 2 dinyatakan **SELESAI & LULUS** jika:
1. Tabel-tabel kurikulum, LMS, penugasan, presensi, dan tahfizh berhasil di-deploy ke MySQL 8.0.
2. Tutor dapat membuat 1 topik pertemuan di kelasnya, mengunggah materi (PDF / link video), dan menerbitkannya (*publish*).
3. Santri dapat login, membuka kelas tersebut, melihat materi, dan menekan tombol hadir pada sesi presensi.
4. Tutor memberikan tugas; santri mengunggah file PDF jawaban tugas; notifikasi pengumpulan muncul di layar tutor; tutor berhasil memberikan nilai 95 dan feedback.
5. Ustadz Tahfizh mencatat setoran hafalan: Santri A, Surah An-Naba' ayat 1-40, Ziyadah, Mumtaz; data tersimpan dan langsung terlihat di profil santri.
6. **KBM REAL SUDAH BERJALAN PENUH TANPA KENDALA.**

---

## 7. PROMPT INSTRUKSI SIAP PAKAI (Copy-Paste ke AI Generator)

Salin blok prompt berikut saat Anda ingin meminta AI membangun kode untuk Tahap 2:

`	ext
Tolong implementasikan backend dan frontend untuk TAHAP 2 PKBM DIGITAL DAR EL IMAN sesuai dokumen spesifikasi Tahap_02_Kurikulum_LMS_dan_Tahfizh.md:

1. Buat migration database MySQL 8.0 untuk skema: subjects, grade_subjects, course_classes, class_schedules, course_topics, topic_materials, assignments, assignment_submissions, class_sessions, session_attendances, tahfizh_groups, tahfizh_group_students, tahfizh_logs.
2. Sediakan seeder data mata pelajaran wajib kesetaraan dan mapel kepesantrenan Dar El Iman (Tahfizh Al-Qur'an Tematik, Akidah & Akhlak, Bahasa Arab, AI Literacy).
3. Bangun REST API backend:
   - Pemetaan Tutor ke Rombel & Mapel (course_classes) dan Penjadwalan Sesi
   - Ruang Kelas LMS: Silabus topik mingguan & manajemen materi (PDF/video link)
   - Penugasan: Create assignment, submit assignment oleh santri, grading oleh tutor
   - Presensi: Buka sesi kelas & pencatatan absensi siswa
   - Halaqah Tahfizh: Kelompok halaqah & log setoran hafalan (Ziyadah/Muraja'ah, tajwid, kelancaran)
4. Bangun antarmuka frontend SPA:
   - Dashboard Santri & Dashboard Tutor
   - Halaman detail Ruang Kelas LMS (materi modul mingguan)
   - Antarmuka pengumpulan tugas dan form review nilai guru
   - Antarmuka presensi pertemuan
   - Portal Halaqah Tahfizh (pencatatan setoran & grafik riwayat hafalan santri).

Pastikan seluruh fitur KBM interaktif ini berjalan mulus dan responsif di smartphone maupun desktop.
```
