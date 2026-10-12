# Spesifikasi Teknis Tahap 5: Kemitraan, Penjaminan Mutu & Fitur Lanjutan (Scale & AI)
**Proyek:** PKBM Digital Dar El Iman  
**Fase:** Tahap 5 (EKSPANSI EKOSISTEM, PENJAMINAN MUTU BAN-PDM & KECERDASAN BUATAN)  
**Tujuan Utama:** Menghubungkan jaringan mitra pesantren dan komunitas diaspora luar negeri, mengotomasi audit kepatuhan mutu akreditasi BAN-PDM & Balanced Scorecard (BSC), serta meluncurkan asisten pintar Tutor AI.

---

## 1. Sasaran Operasional & Batasan Tahap

Setelah tahap ini selesai dibangun:
- [x] Portal khusus mitra (pesantren, majelis taklim, dan komunitas perwakilan luar negeri/KBRI) aktif untuk mendaftarkan dan memantau santri binaannya.
- [x] Dashboard pemantauan wilayah dan diaspora memberikan peta persebaran santri lintas zona waktu dunia secara visual.
- [x] Tim Penjamin Mutu memiliki instrumen checklist digital untuk akreditasi BAN-PDM (Badan Akreditasi Nasional Pendidikan Anak Usia Dini, Dasar, dan Menengah) lengkap dengan repositori bukti fisik (eviden).
- [x] Sistem manajemen SOP dan register risiko operasional terdokumentasi dan terpantau mitigasinya secara berkala.
- [x] Direktur dan Dewan Pembina memiliki akses ke Executive Dashboard Balanced Scorecard (BSC) dengan 4 perspektif (Pembelajaran, Proses Internal, Kepuasan Santri, Finansial).
- [x] Santri dapat berinteraksi dengan **Tutor AI Assistant** (Chatbot cerdas yang dilatih berbasis silabus materi PKBM Dar El Iman) untuk pendalaman materi belajar mandiri 24/7 dengan filter kesesuaian syar'i.

---

## 2. Modul yang Dikerjakan

| Modul | Deskripsi Fungsional | Role Terkait |
|---|---|---|
| **M28: Portal Mitra & Kolektif** | Registrasi institusi mitra (pesantren cabang / komunitas diaspora), pendaftaran santri secara kolektif, pemantauan santri per mitra. | Koordinator Mitra, Operator |
| **M29: Dashboard Sebaran Diaspora** | Visualisasi data sebaran santri per provinsi di Indonesia dan per negara di dunia, filter zona waktu (UTC/WIB/WITA/WIT/Luar Negeri). | Pimpinan, Manajer Diaspora |
| **M30: Checklist Akreditasi BAN-PDM** | Manajemen butir instrumen akreditasi PKBM, status pemenuhan eviden (dokumen pendukung), simulasi skor akreditasi (A/B/C). | Tim Penjamin Mutu, Direktur |
| **M31: Repositori SOP & Register Risiko** | Katalog Standar Operasional Prosedur digital terpusat, identifikasi risiko operasional dan penanggung jawab mitigasi. | Tim Mutu, Manajerial |
| **M32: Survei Kepuasan Layanan** | Pembuat instrumen survei berkala (kuesioner kepuasan tutor, santri, dan orang tua), rekapitulasi indeks kepuasan. | Tim Mutu, Santri, Orang Tua |
| **M33: Executive Dashboard BSC** | Balanced Scorecard 4 perspektif: Pembelajaran & Pertumbuhan, Proses Internal Lembaga, Kepuasan Pengguna, Finansial Lembaga. | Dewan Pembina, Direktur |
| **M34: Asisten Cerdas Tutor AI** | Chatbot AI berbasis pengetahuan kurikulum resmi Dar El Iman untuk menjawab pertanyaan belajar santri kapan saja. | Santri, Tutor |

---

## 3. Skema Basis Data MySQL 8.0 (DDL)

```sql
-- 1. TABEL KEMITRAAN & DIASPORA
CREATE TABLE partners (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(200) NOT NULL, -- Contoh: 'Pesantren Mitra Darul Hadits', 'Komunitas Diaspora Jepang'
    partner_type VARCHAR(50) NOT NULL CHECK (partner_type IN ('PESANTREN', 'MAJELIS_TAKLIM', 'KOMUNITAS_DIASPORA', 'LEMBAGA_BEASISWA')),
    country VARCHAR(100) DEFAULT 'Indonesia',
    city VARCHAR(100),
    contact_person VARCHAR(150),
    phone VARCHAR(50),
    email VARCHAR(150),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE partner_students (
    partner_id CHAR(36) NOT NULL REFERENCES partners(id) ON DELETE CASCADE,
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (partner_id, student_id)
);

-- 2. TABEL PENJAMINAN MUTU, SOP & AKREDITASI
CREATE TABLE accreditation_standards (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) NOT NULL, -- Contoh: 'BAN-PDM-01'
    standard_name VARCHAR(200) NOT NULL, -- Contoh: 'Standar Kompetensi Lulusan'
    component_name VARCHAR(200) NOT NULL,
    max_score DECIMAL(5,2) DEFAULT 4.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accreditation_items (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    standard_id CHAR(36) NOT NULL REFERENCES accreditation_standards(id) ON DELETE CASCADE,
    item_number VARCHAR(20) NOT NULL,
    indicator_description TEXT NOT NULL,
    fulfillment_status VARCHAR(30) DEFAULT 'NOT_STARTED' 
        CHECK (fulfillment_status IN ('NOT_STARTED', 'IN_PROGRESS', 'READY_AUDIT', 'FULFILLED')),
    evidence_file_url TEXT,
    notes TEXT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE institution_sops (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) UNIQUE NOT NULL, -- Contoh: 'SOP-AKD-001'
    title VARCHAR(200) NOT NULL,
    department VARCHAR(100) NOT NULL, -- 'Akademik', 'Keuangan', 'Kesiswaan'
    version VARCHAR(20) DEFAULT '1.0',
    file_url TEXT NOT NULL,
    effective_date DATE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE risk_registers (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    risk_title VARCHAR(200) NOT NULL,
    category VARCHAR(50) NOT NULL, -- 'OPERASIONAL', 'TEKNOLOGI', 'REPUTASI', 'KEUANGAN'
    severity_level VARCHAR(20) NOT NULL CHECK (severity_level IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    mitigation_plan TEXT NOT NULL,
    owner_user_id CHAR(36) REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'MITIGATED', 'CLOSED')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABEL BALANCED SCORECARD (BSC)
CREATE TABLE bsc_indicators (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    perspective VARCHAR(50) NOT NULL 
        CHECK (perspective IN ('FINANCIAL', 'CUSTOMER_STAKEHOLDER', 'INTERNAL_PROCESS', 'LEARNING_GROWTH')),
    indicator_name VARCHAR(200) NOT NULL,
    target_value DECIMAL(10,2) NOT NULL,
    current_value DECIMAL(10,2) DEFAULT 0.00,
    unit VARCHAR(50) NOT NULL, -- '%', 'Orang', 'Rp', 'Skor'
    period_year INT NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. TABEL ASISTEN CERDAS TUTOR AI
CREATE TABLE ai_chat_sessions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id CHAR(36) NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    subject_id CHAR(36) REFERENCES subjects(id) ON DELETE SET NULL,
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ai_chat_messages (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    session_id CHAR(36) NOT NULL REFERENCES ai_chat_sessions(id) ON DELETE CASCADE,
    sender_type VARCHAR(10) NOT NULL CHECK (sender_type IN ('USER', 'ASSISTANT')),
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indeks Kinerja
CREATE INDEX idx_partner_students_pid ON partner_students(partner_id);
CREATE INDEX idx_accreditation_items_sid ON accreditation_items(standard_id);
CREATE INDEX idx_ai_messages_session ON ai_chat_messages(session_id);
```

---

## 4. Spesifikasi REST API Endpoints

### 4.1 Modul Kemitraan & Diaspora (`/api/v1/partners`)
- `GET /`: Daftar mitra aktif beserta jumlah santri binaan.
- `POST /`: Daftarkan lembaga mitra baru.
- `POST /:id/bulk-enroll`: Pendaftaran santri kolektif di bawah lembaga mitra tersebut.
- `GET /analytics/diaspora-map`: Data agregasi santri per negara/provinsi untuk peta visual.

### 4.2 Penjaminan Mutu & Akreditasi (`/api/v1/quality`)
- `GET /accreditation/checklist`: Mengambil daftar instrumen akreditasi BAN-PDM & progres eviden.
- `PUT /accreditation/items/:id`: Memperbarui status eviden dan mengunggah dokumen bukti fisik.
- `GET /sops`: Mengambil repositori katalog SOP lembaga.
- `POST /risks`: Menambahkan register risiko operasional dan rencana mitigasi.
- `GET /bsc/dashboard`: Mengambil data indikator Balanced Scorecard (4 perspektif) untuk pimpinan.

### 4.3 Tutor AI Assistant (`/api/v1/ai-tutor`)
- `POST /sessions`: Membuka sesi tanya jawab santri dengan Tutor AI (opsional pilih mata pelajaran).
- `POST /sessions/:id/ask`: Mengirimkan pertanyaan santri; backend meneruskan ke layanan AI / LLM dengan konteks materi modul terkait dan mengembalikan jawaban edukatif.
- `GET /sessions/:id/history`: Riwayat tanya-jawab belajar mandiri santri.

---

## 5. Kebutuhan Antarmuka Frontend (UI Screens)

1. **Portal Khusus Mitra Lembaga (`/partner/portal`)**:
   - Tampilan khusus koordinator mitra pesantren/komunitas luar negeri.
   - Daftar santri naungan mitra, progres kehadiran, dan capaian hafalan Al-Qur'an santri mitra secara kolektif.
2. **Dashboard Visual Sebaran Diaspora (`/admin/diaspora-map`)**:
   - Peta interaktif dunia dan Indonesia menampilkan pin lokasi sebaran santri PKBM Digital.
   - Filter zona waktu (WIB, WITA, WIT, JST/Jepang, AST/Arab Saudi, dll.).
3. **Instrumen Akreditasi BAN-PDM Digital (`/quality/accreditation`)**:
   - Kartu progres per 8 Standar Nasional Pendidikan.
   - Upload berkas bukti fisik eviden dengan status checklist hijau/kuning/merah.
4. **Executive Dashboard Balanced Scorecard (`/executive/bsc`)**:
   - Tampilan ringkas untuk Dewan Pembina dan Direktur.
   - 4 kuadran: Kinerja Keuangan, Kepuasan Santri, Efektivitas Proses Pembelajaran, dan Pertumbuhan Pendidik.
5. **Antarmuka Tutor AI Santri (`/student/ai-tutor`)**:
   - Tampilan chat modern, ramah, dan bebas gangguan.
   - Rekomendasi topik tanya-jawab seputar mata pelajaran kesetaraan atau kajian adab & tahfizh.
   - Tombol "Konsultasi Bersama Ustadz Pembimbing" jika santri membutuhkan konsultasi lebih mendalam.

---

## 6. Skenario Pengujian & Kriteria Selesai (Definition of Done)

Tahap 5 dinyatakan **SELESAI & LULUS** jika:
1. Koordinator mitra luar negeri dapat login ke Portal Mitra dan melihat data kemajuan santri di bawah binaannya.
2. Dashboard diaspora berhasil merender peta persebaran santri sesuai data negara masing-masing.
3. Tim Penjamin Mutu dapat mencentang indikator akreditasi BAN-PDM, melampirkan berkas bukti dokumen PDF, dan melihat simulasi skor akreditasi.
4. Dashboard BSC pimpinan berhasil menampilkan persentase capaian target pada keempat perspektif lembaga.
5. Santri dapat mengirimkan pertanyaan belajar ke Tutor AI dan menerima jawaban relevan dalam waktu di bawah 5 detik.

---

## 7. PROMPT INSTRUKSI SIAP PAKAI (Copy-Paste ke AI Generator)

Salin blok prompt berikut saat Anda ingin meminta AI membangun kode untuk Tahap 5:

```text
Tolong implementasikan backend dan frontend untuk TAHAP 5 PKBM DIGITAL DAR EL IMAN sesuai dokumen spesifikasi Tahap_05_Kemitraan_Mutu_dan_Fitur_Lanjutan.md:

1. Buat migration database MySQL 8.0 untuk skema: partners, partner_students, accreditation_standards, accreditation_items, institution_sops, risk_registers, bsc_indicators, ai_chat_sessions, ai_chat_messages.
2. Bangun REST API backend:
   - Portal Kemitraan: Pengelolaan data mitra pesantren/diaspora & pendaftaran santri kolektif
   - Dashboard Agregasi Diaspora & Sebaran Geografis
   - Penjaminan Mutu: Checklist akreditasi BAN-PDM, repositori SOP, dan register risiko mutu
   - Executive Dashboard Balanced Scorecard (BSC 4 perspektif)
   - Tutor AI Service: Integrasi endpoint chat dengan context prompt materi ajar
3. Bangun antarmuka frontend SPA:
   - Portal Mitra Lembaga
   - Peta Visual Sebaran Santri Diaspora
   - Antarmuka Checklist Akreditasi BAN-PDM & Unggah Dokumen Eviden
   - Dashboard Eksekutif BSC untuk Direktur / Pembina
   - Layar Chatbot Tutor AI untuk Santri.

Pastikan antarmuka eksekutif tampak elegan, profesional, dan responsif.
```
