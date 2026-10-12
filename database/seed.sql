-- ==============================================================================
-- DATA SEEDER AWAL (INITIAL SEED): PKBM DIGITAL DAR EL IMAN
-- Password default akun bawaan adalah: admin123 (bcrypt: $2a$10$7q8F7o9Zg7...)
-- ==============================================================================

USE pkbm_digital_darel_iman;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. LEMBAGA DEFAULT
INSERT INTO institutions (id, name, npsn, address, phone, email, website)
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'PKBM Digital Dar El Iman',
    'P9901234',
    'Jl. Gunung Juaro No. 1, Surau Gadang, Nanggalo, Padang, Sumatera Barat',
    '+62-751-123456',
    'info@darel-iman.or.id',
    'https://pkbm.darel-iman.or.id'
) ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 2. TAHUN AJARAN AKTIF (2026/2027 GANJIL)
INSERT INTO academic_years (id, institution_id, name, semester, start_date, end_date, is_active)
VALUES (
    '22222222-2222-2222-2222-222222222222',
    '11111111-1111-1111-1111-111111111111',
    '2026/2027',
    'GANJIL',
    '2026-07-15',
    '2026-12-20',
    TRUE
) ON DUPLICATE KEY UPDATE is_active=TRUE;

-- 3. MASTER JENJANG PENDIDIKAN
INSERT INTO grade_levels (id, package_type, level_number, name) VALUES
('a0000001-0000-0000-0000-000000000001', 'PAKET_A', 1, 'Paket A - Kelas 1'),
('a0000002-0000-0000-0000-000000000002', 'PAKET_A', 2, 'Paket A - Kelas 2'),
('a0000003-0000-0000-0000-000000000003', 'PAKET_A', 3, 'Paket A - Kelas 3'),
('a0000004-0000-0000-0000-000000000004', 'PAKET_A', 4, 'Paket A - Kelas 4'),
('a0000005-0000-0000-0000-000000000005', 'PAKET_A', 5, 'Paket A - Kelas 5'),
('a0000006-0000-0000-0000-000000000006', 'PAKET_A', 6, 'Paket A - Kelas 6'),
('b0000007-0000-0000-0000-000000000007', 'PAKET_B', 7, 'Paket B - Kelas 7'),
('b0000008-0000-0000-0000-000000000008', 'PAKET_B', 8, 'Paket B - Kelas 8'),
('b0000009-0000-0000-0000-000000000009', 'PAKET_B', 9, 'Paket B - Kelas 9'),
('c0000010-0000-0000-0000-000000000010', 'PAKET_C', 10, 'Paket C - Kelas 10'),
('c0000011-0000-0000-0000-000000000011', 'PAKET_C', 11, 'Paket C - Kelas 11'),
('c0000012-0000-0000-0000-000000000012', 'PAKET_C', 12, 'Paket C - Kelas 12')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 4. MASTER ROLES
INSERT INTO roles (id, name, display_name, description) VALUES
('r0000001-0000-0000-0000-000000000001', 'SUPER_ADMIN', 'Super Admin', 'Akses penuh seluruh konfigurasi sistem'),
('r0000002-0000-0000-0000-000000000002', 'OPERATOR', 'Staf Administrasi / Operator', 'Pengelolaan data induk kesiswaan, tutor, dan rombel'),
('r0000003-0000-0000-0000-000000000003', 'TUTOR', 'Tutor / Pendidik / Ustadz', 'Pengampu pembelajaran, materi, penugasan, dan halaqah'),
('r0000004-0000-0000-0000-000000000004', 'SISWA', 'Santri / Peserta Didik', 'Peserta kegiatan belajar mengajar PKBM'),
('r0000005-0000-0000-0000-000000000005', 'WALI_SANTRI', 'Orang Tua / Wali Santri', 'Pemantau kehadiran, nilai, dan tagihan santri')
ON DUPLICATE KEY UPDATE display_name=VALUES(display_name);

-- 5. AKUN PENGGUNA DEFAULT
-- Hash untuk password 'admin123' (bcrypt cost 10)
-- $2a$10$wT8m9Lp0yD3A7YyV9rP.7O5dKlFkPq0OvxX8P7wXbYpZ0qYvP2yKi
INSERT INTO users (id, username, email, password_hash, full_name, phone, is_active)
VALUES (
    'u0000001-0000-0000-0000-000000000001',
    'admin',
    'admin@darel-iman.or.id',
    '$2a$10$wT8m9Lp0yD3A7YyV9rP.7O5dKlFkPq0OvxX8P7wXbYpZ0qYvP2yKi',
    'Administrator Utama Yayasan',
    '+6281234567890',
    TRUE
) ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

-- Ikat User Admin ke Role SUPER_ADMIN
INSERT INTO user_roles (user_id, role_id, institution_id)
VALUES (
    'u0000001-0000-0000-0000-000000000001',
    'r0000001-0000-0000-0000-000000000001',
    '11111111-1111-1111-1111-111111111111'
) ON DUPLICATE KEY UPDATE role_id=VALUES(role_id);

-- AKUN OPERATOR CONTOH
INSERT INTO users (id, username, email, password_hash, full_name, phone, is_active)
VALUES (
    'u0000002-0000-0000-0000-000000000002',
    'operator',
    'operator@darel-iman.or.id',
    '$2a$10$wT8m9Lp0yD3A7YyV9rP.7O5dKlFkPq0OvxX8P7wXbYpZ0qYvP2yKi',
    'Staf Operator Dapodik',
    '+6281234567891',
    TRUE
) ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO user_roles (user_id, role_id, institution_id)
VALUES (
    'u0000002-0000-0000-0000-000000000002',
    'r0000002-0000-0000-0000-000000000002',
    '11111111-1111-1111-1111-111111111111'
) ON DUPLICATE KEY UPDATE role_id=VALUES(role_id);

-- 6. DATA CONTOH TUTOR / USTADZ
INSERT INTO users (id, username, email, password_hash, full_name, phone, is_active)
VALUES (
    'u0000003-0000-0000-0000-000000000003',
    'tutor.ahmad',
    'ahmad@darel-iman.or.id',
    '$2a$10$wT8m9Lp0yD3A7YyV9rP.7O5dKlFkPq0OvxX8P7wXbYpZ0qYvP2yKi',
    'Ustadz Ahmad Al-Hafizh, Lc.',
    '+6281234567892',
    TRUE
) ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO user_roles (user_id, role_id, institution_id)
VALUES (
    'u0000003-0000-0000-0000-000000000003',
    'r0000003-0000-0000-0000-000000000003',
    '11111111-1111-1111-1111-111111111111'
) ON DUPLICATE KEY UPDATE role_id=VALUES(role_id);

INSERT INTO tutors (id, user_id, nip, full_name, gender, specialization, phone)
VALUES (
    't0000001-0000-0000-0000-000000000001',
    'u0000003-0000-0000-0000-000000000003',
    'NIP-19850101-001',
    'Ustadz Ahmad Al-Hafizh, Lc.',
    'L',
    'Tahfizh Al-Quran & Adab',
    '+6281234567892'
) ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

-- 7. DATA CONTOH ROMBEL (KELAS X PAKET C)
INSERT INTO classrooms (id, academic_year_id, grade_level_id, name, homeroom_tutor_id, capacity)
VALUES (
    'c1111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222',
    'c0000010-0000-0000-0000-000000000010',
    'Kelas X Paket C - Umar bin Khattab',
    't0000001-0000-0000-0000-000000000001',
    30
) ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 8. CONTOH DATA SANTRI
INSERT INTO users (id, username, email, password_hash, full_name, phone, is_active)
VALUES (
    'u0000004-0000-0000-0000-000000000004',
    'santri.fatih',
    'fatih@santri.darel-iman.or.id',
    '$2a$10$wT8m9Lp0yD3A7YyV9rP.7O5dKlFkPq0OvxX8P7wXbYpZ0qYvP2yKi',
    'Muhammad Al-Fatih',
    '+6281299887766',
    TRUE
) ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO user_roles (user_id, role_id, institution_id)
VALUES (
    'u0000004-0000-0000-0000-000000000004',
    'r0000004-0000-0000-0000-000000000004',
    '11111111-1111-1111-1111-111111111111'
) ON DUPLICATE KEY UPDATE role_id=VALUES(role_id);

INSERT INTO students (
    id, user_id, nis, nisn, nik, full_name, gender, birth_place, birth_date,
    address, is_diaspora, country, timezone, guardian_name, guardian_phone, guardian_relationship, status
) VALUES (
    's0000001-0000-0000-0000-000000000001',
    'u0000004-0000-0000-0000-000000000004',
    'NIS-2026-001',
    '0089123456',
    '1371012345670001',
    'Muhammad Al-Fatih',
    'L',
    'Padang',
    '2010-05-12',
    'Jl. Belimbing No. 12, Padang',
    FALSE,
    'Indonesia',
    'Asia/Jakarta',
    'Abdullah',
    '+6281122334455',
    'Ayah',
    'ACTIVE'
) ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

-- Masukkan Santri Fatih ke Rombel Kelas X
INSERT INTO classroom_students (classroom_id, student_id)
VALUES (
    'c1111111-1111-1111-1111-111111111111',
    's0000001-0000-0000-0000-000000000001'
) ON DUPLICATE KEY UPDATE joined_at=CURRENT_TIMESTAMP;

SET FOREIGN_KEY_CHECKS = 1;
