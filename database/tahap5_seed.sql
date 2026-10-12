-- ==============================================================================
-- BASIS DATA: PKBM DIGITAL DAR EL IMAN
-- DATA AWAL (SEED): TAHAP 5
-- ==============================================================================

USE pkbm_digital_darel_iman;

-- 1. Data Mitra Lembaga
INSERT INTO partners (id, name, partner_type, country, city, contact_person, phone, email, is_active) VALUES
('prt-001', 'Pesantren Tahfizh Mitra Darul Qur''an Bukittinggi', 'PESANTREN', 'Indonesia', 'Bukittinggi', 'Ust. Lukman Hakim, Lc.', '+628126789001', 'pesantren.dq@gmail.com', TRUE),
('prt-002', 'Komunitas Muslim Indonesia Arab Saudi (KSA)', 'KOMUNITAS_DIASPORA', 'Arab Saudi', 'Riyadh', 'Bpk. Ir. Hendra Saputra', '+966509988776', 'diaspora.ksa@darel-iman.or.id', TRUE),
('prt-003', 'Japan Islamic Indonesian Center (Tokyo & Osaka)', 'KOMUNITAS_DIASPORA', 'Jepang', 'Tokyo', 'Ust. Dr. Fajar Nugroho', '+818012345678', 'jiic.tokyo@gmail.com', TRUE),
('prt-004', 'Majelis Taklim Al-Muhajirin Malaysia', 'MAJELIS_TAKLIM', 'Malaysia', 'Kuala Lumpur', 'Ibu Hj. Siti Nurhaliza', '+60123456789', 'mt.almuhajirin@kl.my', TRUE);

-- 2. Data Standar Akreditasi BAN-PDM (8 Standar Nasional Pendidikan Kesetaraan)
INSERT INTO accreditation_standards (id, code, standard_name, component_name, max_score) VALUES
('std-001', 'BAN-PDM-01', 'Standar Kompetensi Lulusan (SKL)', 'Capaian Pembelajaran Kurikulum Merdeka & Tahfizh Khas Dar El Iman', 4.00),
('std-002', 'BAN-PDM-02', 'Standar Isi', 'Kurikulum Operasional Satuan Pendidikan (KOSP) PKBM Kesetaraan', 4.00),
('std-003', 'BAN-PDM-03', 'Standar Proses', 'KBM Daring Sinkron (Meet) & Asinkron (LMS Terpadu)', 4.00),
('std-004', 'BAN-PDM-04', 'Standar Pendidik dan Tenaga Kependidikan', 'Kualifikasi Akademik S1/S2 dan Sertifikasi Pendidik Tutor', 4.00),
('std-005', 'BAN-PDM-05', 'Standar Sarana dan Prasarana', 'Infrastruktur Server Cloud LMS, Video Conference & Studio', 4.00),
('std-006', 'BAN-PDM-06', 'Standar Pengelolaan', 'Tata Kelola Digital, SOP Terpadu & Layanan Santri Diaspora', 4.00),
('std-007', 'BAN-PDM-07', 'Standar Pembiayaan', 'Transparansi Kas SPP, Beasiswa Donatur & Akuntabilitas Keuangan', 4.00),
('std-008', 'BAN-PDM-08', 'Standar Penilaian Pendidikan', 'Engine CBT Digital, Anti-Cheat Proctoring & E-Rapor Sah Ber-QR', 4.00);

-- 3. Butir Instrumen Indikator Eviden Akreditasi
INSERT INTO accreditation_items (id, standard_id, item_number, indicator_description, fulfillment_status, evidence_file_url, notes) VALUES
('item-001', 'std-001', '1.1', 'Dokumen Capaian Kelulusan Santri Paket A/B/C dan sertifikat hafalan juz 30', 'FULFILLED', 'https://cdn.darel-iman.sch.id/mutu/eviden_skl_tahfizh.pdf', '100% santri melampaui KKM nasional dan tuntas target juz'),
('item-002', 'std-002', '2.1', 'Dokumen KOSP Kurikulum Operasional Satuan Pendidikan disahkan Dinas Pendidikan', 'FULFILLED', 'https://cdn.darel-iman.sch.id/mutu/kosp_pkbm_2026.pdf', 'Telah divalidasi penilik kesetaraan Disdikbud Padang'),
('item-003', 'std-003', '3.1', 'Rekam jejak KBM interaktif daring, presensi real-time, dan modul ajar terbit', 'READY_AUDIT', 'https://cdn.darel-iman.sch.id/mutu/log_kbm_virtual_lms.pdf', 'Sistem LMS merekam 100% riwayat interaksi santri'),
('item-004', 'std-008', '8.1', 'Sistem penilaian sumatif CBT dengan rekaman proctoring dan verifikasi QR rapor', 'FULFILLED', 'https://cdn.darel-iman.sch.id/mutu/laporan_cbt_dan_rapor_digital.pdf', 'Menerapkan verifikasi publik hash QR code');

-- 4. Repositori Standar Operasional Prosedur (SOP)
INSERT INTO institution_sops (id, code, title, department, version, file_url, effective_date) VALUES
('sop-001', 'SOP-AKD-001', 'SOP Pelaksanaan KBM Virtual & Google Meet', 'Akademik', '2.1', 'https://cdn.darel-iman.sch.id/sop/sop_kbm_virtual.pdf', '2026-07-01'),
('sop-002', 'SOP-THF-002', 'SOP Halaqah Tahfizh Daring & Mutaba''ah Al-Qur''an', 'Tahfizh', '2.0', 'https://cdn.darel-iman.sch.id/sop/sop_halaqah_tahfizh.pdf', '2026-07-01'),
('sop-003', 'SOP-KEU-003', 'SOP Rekonsiliasi Kas SPP & Verifikasi Pembayaran', 'Keuangan', '1.5', 'https://cdn.darel-iman.sch.id/sop/sop_keuangan_spp.pdf', '2026-07-01'),
('sop-004', 'SOP-IT-004', 'SOP Penyelenggaraan Ujian CBT & Proctoring Daring', 'IT & Penilaian', '1.0', 'https://cdn.darel-iman.sch.id/sop/sop_cbt_proctoring.pdf', '2026-08-15');

-- 5. Register Risiko Mutu Lembaga
INSERT INTO risk_registers (id, risk_title, category, severity_level, mitigation_plan, status) VALUES
('rr-001', 'Ketidakstabilan Koneksi Internet Santri Diaspora saat KBM', 'TEKNOLOGI', 'MEDIUM', 'Menyediakan rekaman video asinkron KBM dan materi PDF terkompresi di LMS', 'MITIGATED'),
('rr-002', 'Kecurangan Akademik / Tab Switching pada Ujian Daring', 'OPERASIONAL', 'HIGH', 'Menerapkan engine CBT Fullscreen Lock dan audit log proctoring otomatis', 'MITIGATED'),
('rr-003', 'Keterlambatan Sinkronisasi NISN Santri Baru ke Dapodik', 'OPERASIONAL', 'MEDIUM', 'Audit kelengkapan NIK/Akta sejak proses PPDB Online sebelum semester berjalan', 'OPEN');

-- 6. Indikator Balanced Scorecard (BSC 4 Perspektif)
INSERT INTO bsc_indicators (id, perspective, indicator_name, target_value, current_value, unit, period_year) VALUES
-- Perspektif Keuangan
('bsc-01', 'FINANCIAL', 'Tingkat Kelancaran Pembayaran SPP Santri', 95.00, 93.50, '%', 2026),
('bsc-02', 'FINANCIAL', 'Alokasi Dana Beasiswa Santri Kurang Mampu / Yatim', 15.00, 18.00, '%', 2026),
-- Perspektif Kepuasan Pengguna / Stakeholder
('bsc-03', 'CUSTOMER_STAKEHOLDER', 'Indeks Kepuasan Orang Tua & Santri Diaspora', 90.00, 94.20, '%', 2026),
('bsc-04', 'CUSTOMER_STAKEHOLDER', 'Rasio Rekomendasi Mitra Lembaga (NPS)', 80.00, 87.50, '%', 2026),
-- Perspektif Proses Pembelajaran Internal
('bsc-05', 'INTERNAL_PROCESS', 'Tingkat Ketuntasan Hafalan Target Tahfizh (Juz 30)', 90.00, 92.00, '%', 2026),
('bsc-06', 'INTERNAL_PROCESS', 'Kepatuhan Pelaksanaan Jadwal KBM Sesuai Kalender', 98.00, 97.40, '%', 2026),
-- Perspektif Pembelajaran & Pertumbuhan Organisasi
('bsc-07', 'LEARNING_GROWTH', 'Partisipasi Tutor dalam Pelatihan Digital & AI', 100.00, 100.00, '%', 2026),
('bsc-08', 'LEARNING_GROWTH', 'Kesiapan Pemenuhan Akreditasi BAN-PDM (Skor A)', 92.00, 96.50, 'Skor', 2026);
