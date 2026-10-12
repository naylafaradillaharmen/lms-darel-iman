-- ==============================================================================
-- SEED DATA: PKBM DIGITAL DAR EL IMAN - TAHAP 4
-- PPDB Online, Keuangan SPP & Ekspor Dapodik Kemendikbudristek
-- ==============================================================================

USE pkbm_digital_darel_iman;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. GELOMBANG PPDB AKTIF
INSERT INTO ppdb_periods (id, academic_year_id, title, start_date, end_date, is_open) VALUES
('per00001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'PPDB Santri Baru Gelombang 1 TA 2027/2028 (Nasional & Diaspora Internasional)', '2026-10-01', '2026-12-31', TRUE)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- PENDAFTARAN PPDB (DIASPORA & NASIONAL)
INSERT INTO ppdb_registrations (id, ppdb_period_id, registration_number, target_package, full_name, gender, nik, nisn, birth_place, birth_date, phone, email, is_diaspora, country, timezone, guardian_name, guardian_phone, guardian_relationship, mother_name, status, notes) VALUES
('preg0001-0000-0000-0000-000000000001', 'per00001-0000-0000-0000-000000000001', 'REG-2027-001', 'PAKET_C', 'Zaid Al-Khair', 'L', '1371012304090001', '0098712345', 'Doha', '2009-04-12', '+97455123456', 'zaid.qatar@darel-iman.sch.id', TRUE, 'Qatar', 'Asia/Qatar', 'Ir. Salman Al-Farisi', '+97455123456', 'Ayah Kandung', 'Khadijah S.E.', 'ACCEPTED', 'Berkas lengkap, placement test tahfizh 3 juz Mumtaz. Siap konversi ke santri resmi.'),
('preg0002-0000-0000-0000-000000000002', 'per00001-0000-0000-0000-000000000001', 'REG-2027-002', 'PAKET_B', 'Aisyah Humaira', 'P', '1371025510110002', '0112345678', 'Padang', '2011-10-15', '+628137788990', 'aisyah.padang@gmail.com', FALSE, 'Indonesia', 'Asia/Jakarta', 'dr. Rahman Hakim', '+628137788990', 'Ayah Kandung', 'Fatimah Az-Zahra', 'DOCUMENTS_VERIFIED', 'Berkas digital KK dan Akta kelahiran telah tervalidasi oleh panitia.')
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- DOKUMEN PPDB
INSERT INTO ppdb_documents (id, ppdb_registration_id, document_type, file_url, is_verified, verification_notes) VALUES
('pdoc0001-0000-0000-0000-000000000001', 'preg0001-0000-0000-0000-000000000001', 'AKTA_LAHIR', 'https://cdn.darel-iman.or.id/ppdb/akta-zaid-qatar.pdf', TRUE, 'Akta kelahiran resmi KBRI terverifikasi sah.'),
('pdoc0002-0000-0000-0000-000000000001', 'preg0001-0000-0000-0000-000000000001', 'KK', 'https://cdn.darel-iman.or.id/ppdb/kk-salman.pdf', TRUE, 'Kartu Keluarga sah.'),
('pdoc0003-0000-0000-0000-000000000002', 'preg0002-0000-0000-0000-000000000002', 'AKTA_LAHIR', 'https://cdn.darel-iman.or.id/ppdb/akta-aisyah.pdf', TRUE, 'Dokumen kependudukan valid.')
ON DUPLICATE KEY UPDATE is_verified=VALUES(is_verified);

-- 2. TARIF SPP PER JENJANG
INSERT INTO tuition_tariffs (id, academic_year_id, grade_level_id, amount, description) VALUES
('tt000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'c0000010-0000-0000-0000-000000000010', 350000.00, 'SPP Bulanan Paket C Kesetaraan & Pembinaan Tahfizh Terpadu'),
('tt000002-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'b0000007-0000-0000-0000-000000000007', 300000.00, 'SPP Bulanan Paket B Kesetaraan & Pembinaan Tahfizh Terpadu'),
('tt000003-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'a0000001-0000-0000-0000-000000000001', 250000.00, 'SPP Bulanan Paket A Kesetaraan & Pembinaan Tahfizh Terpadu')
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

-- INVOICE SPP SANTRI FATIH
INSERT INTO student_invoices (id, student_id, invoice_number, month, year, amount, discount_amount, final_amount, due_date, status) VALUES
('inv00001-0000-0000-0000-000000000001', 's0000001-0000-0000-0000-000000000001', 'INV-2026-10-0001', 10, 2026, 350000.00, 0.00, 350000.00, '2026-10-10', 'PAID'),
('inv00002-0000-0000-0000-000000000002', 's0000001-0000-0000-0000-000000000001', 'INV-2026-11-0001', 11, 2026, 350000.00, 0.00, 350000.00, '2026-11-10', 'PENDING_VERIFICATION')
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- TRANSAKSI PEMBAYARAN TRANSFER BANK
INSERT INTO payment_transactions (id, student_invoice_id, payment_method, amount_paid, proof_file_url, status, verified_by_user_id, verified_at) VALUES
('ptrx0001-0000-0000-0000-000000000001', 'inv00001-0000-0000-0000-000000000001', 'BANK_TRANSFER', 350000.00, 'https://cdn.darel-iman.or.id/bukti-transfer/bsi-fatih-okt.jpg', 'APPROVED', 'u0000001-0000-0000-0000-000000000001', '2026-10-05 14:00:00'),
('ptrx0002-0000-0000-0000-000000000002', 'inv00002-0000-0000-0000-000000000002', 'BANK_TRANSFER', 350000.00, 'https://cdn.darel-iman.or.id/bukti-transfer/bsi-fatih-nov.jpg', 'PENDING', NULL, NULL)
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- 3. BEASISWA POTONGAN SPP
INSERT INTO scholarship_grants (id, student_id, program_name, discount_percentage, donor_name, is_active) VALUES
('sg000001-0000-0000-0000-000000000001', 's0000001-0000-0000-0000-000000000001', 'Beasiswa Santri Huffazh Berprestasi Yayasan Dar El Iman', 100, 'Lembaga Amil Zakat Dar El Iman Padang', TRUE)
ON DUPLICATE KEY UPDATE program_name=VALUES(program_name);

-- 4. LOG EKSPOR DAPODIK RESMI
INSERT INTO dapodik_export_logs (id, exported_by_user_id, academic_year_id, export_type, total_records, download_url) VALUES
('del00001-0000-0000-0000-000000000001', 'u0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'DATA_SISWA', 150, 'https://cdn.darel-iman.or.id/dapodik/ekspor-siswa-dapodik-2026.csv')
ON DUPLICATE KEY UPDATE total_records=VALUES(total_records);

SET FOREIGN_KEY_CHECKS = 1;
