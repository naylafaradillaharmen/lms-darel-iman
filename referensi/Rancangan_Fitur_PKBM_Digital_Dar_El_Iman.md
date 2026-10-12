# Rancangan Fitur Aplikasi PKBM Digital Dar El Iman

*Arsitektur modular dengan RBAC, disusun berdasarkan Master Plan PKBM Dar El Iman 2027–2032*

## 1. Gambaran Umum

Aplikasi terdiri dari lima bagian besar: **PPDB dan kesiswaan, akademik dan pembelajaran, penilaian dan dokumen, keuangan dan mitra, serta manajemen mutu dan sistem**. Seluruh fitur dirancang **modular**: setiap bagian adalah modul yang berdiri sendiri, dapat diaktifkan atau dinonaktifkan, dan dikembangkan bertahap sesuai roadmap 2027–2032. Dokumen ini hanya membahas fitur, tidak membahas teknologi.

## 2. Peran Pengguna (Role)

| Kelompok | Role |
|---|---|
| **Pimpinan** | Super Admin, Dewan Pembina (read-only), Direktur PKBM |
| **Manajerial** | Manajer Akademik, Manajer Kesiswaan & Layanan Internasional, Manajer Keuangan & Legal, Manajer Teknologi |
| **Operasional** | Tutor/Pendidik, Wali Kelas/Pendamping, Proktor Ujian, Staf Administrasi/Operator Dapodik, Staf Helpdesk, Tim Mutu |
| **Pengguna layanan** | Siswa, Orang Tua/Wali |
| **Eksternal** | Koordinator Mitra (pesantren, majelis taklim, perwakilan luar negeri), Donatur/Pemberi Beasiswa (opsional) |

## 3. Prinsip Modular

1. **Satu modul, satu tanggung jawab.** Modul Keuangan hanya mengurus tagihan dan pembayaran, bukan nilai.
2. **Bisa diaktifkan/dinonaktifkan oleh Super Admin.** Modul yang belum dipakai (misalnya Beasiswa atau Tutor AI) tidak muncul di menu siapa pun.
3. **Setiap modul membawa paket menu, permission, dan pengaturannya sendiri.** Saat diaktifkan, menu dan hak akses RBAC-nya ikut tersedia. Saat dinonaktifkan, semuanya tersembunyi, tetapi data tetap tersimpan.
4. **Antar modul hanya bertukar data yang diperlukan.** Rapor mengambil nilai dari Penilaian, tetapi tidak mengubahnya.
5. **Modul bisa dikembangkan atau diganti tanpa membongkar modul lain.**
6. **Pengaturan per modul.** Tarif diatur di modul Keuangan, bobot nilai di modul Penilaian, dan seterusnya.

## 4. Pembagian Modul

### 4.1 Modul Inti (wajib, selalu aktif)

| Modul | Isi |
|---|---|
| Akun & Autentikasi | Login, profil, keamanan akun (ubah kata sandi, 2FA) |
| RBAC & Pengguna | Role, permission, cakupan data, multi-role, akses sementara |
| Pengaturan Lembaga | Tahun ajaran, jenjang, tarif, parameter umum |
| Notifikasi & Pesan | Pemberitahuan lintas modul, template pesan |
| Audit Log | Rekam jejak semua perubahan penting |
| Manajemen Modul | Mengaktifkan/menonaktifkan modul dan melihat statusnya |

### 4.2 Modul Bisnis (dipasang sesuai kebutuhan)

| Kelompok | Modul |
|---|---|
| Kesiswaan | PPDB, Data Induk Siswa, Bimbingan & Karakter |
| Akademik | Kurikulum & Jadwal, Bank Materi & Soal |
| Pembelajaran | Kelas LMS, Kelas Live, Halaqah Tahfizh, Forum Diskusi, Gamifikasi |
| Penilaian | Penilaian & Rubrik, CBT, Proctoring, Remedial |
| Dokumen | E-Rapor & Ijazah, Ekspor Dapodik, Arsip Dokumen |
| Keuangan | SPP & Pembayaran, Beasiswa, Afiliasi, Laporan Keuangan |
| Kemitraan | Portal Mitra, Dashboard Wilayah/Negara |
| SDM | Data Tutor, Beban Mengajar, KPI & Kinerja |
| Mutu | Dashboard BSC, SOP, Survei, Register Risiko, Checklist Akreditasi |
| Layanan | Helpdesk, Pusat Bantuan |
| Lanjutan | Tutor AI, Analitik Lanjutan |

### 4.3 Keterkaitan Antar Modul

Sistem menolak pengaktifan modul jika prasyaratnya belum aktif.

| Modul | Membutuhkan |
|---|---|
| Kelas LMS | Data Induk Siswa, Kurikulum & Jadwal |
| Halaqah Tahfizh | Kelas LMS |
| CBT | Bank Soal, Kelas LMS |
| Proctoring | CBT |
| E-Rapor & Ijazah | Penilaian, Data Induk Siswa |
| Ekspor Dapodik | Data Induk Siswa, Data Tutor |
| SPP & Pembayaran | Data Induk Siswa |
| Beasiswa & Afiliasi | SPP & Pembayaran |
| Portal Mitra | PPDB, Data Induk Siswa |
| KPI Tutor | Data Tutor, Kelas LMS, Survei |
| Dashboard BSC | Minimal beberapa modul sumber data aktif |
| Tutor AI | Kelas LMS, Penilaian |

## 5. Menu per Modul

### A. Umum (semua role)
- Beranda/dashboard sesuai role
- Profil dan keamanan akun (ubah kata sandi, 2FA)
- Notifikasi dan pesan
- Pengumuman
- Kalender akademik
- Pusat bantuan/FAQ

### B. PPDB dan Kesiswaan
- Pendaftaran online (nasional dan internasional), unggah dokumen, pilihan Paket A/B/C
- Verifikasi berkas dan status pendaftaran
- Tes penempatan (placement test) untuk menentukan jenjang/kelas
- Data induk siswa, mutasi, dan status (aktif, cuti, lulus, keluar)
- Pengelompokan rombongan belajar
- Bimbingan konseling dan catatan pembinaan karakter
- Data diaspora: negara, zona waktu, kontak KBRI/komunitas

### C. Akademik dan Kurikulum
- Manajemen kurikulum (KOSP, mata pelajaran, capaian pembelajaran)
- Program unggulan: Tahfizh Tematik, Adab & Akidah, AI Literacy & Digital Dakwah, Bahasa Arab/Inggris
- Penjadwalan, termasuk penyesuaian zona waktu
- Penugasan tutor ke kelas/mapel
- Bank materi dan bank soal

### D. Pembelajaran (LMS)
- Ruang kelas virtual: modul, video, bacaan, tugas, kuis
- Pembelajaran asinkron: jalur belajar per siswa, progres, pengingat
- Kelas sinkron: jadwal live class, tautan, presensi otomatis, rekaman
- Halaqah tahfizh: setoran hafalan, penilaian tajwid/kelancaran, target dan progres hafalan, murajaah
- Forum diskusi dan tanya-jawab dengan tutor
- Gamifikasi: poin, lencana, peringkat, streak
- Tutor AI/asisten belajar (tahap 2031)

### E. Penilaian dan Ujian
- Penilaian formatif dan sumatif, rubrik penilaian
- Ujian online (CBT), pengacakan soal, jadwal ujian
- Pengawasan ujian (proctoring) dengan log dan penandaan pelanggaran
- Penilaian otomatis dan koreksi manual untuk esai
- Remedial dan pengayaan

### F. Rapor, Ijazah, dan Dokumen
- E-Rapor, transkrip, dan surat keterangan
- Pencatatan kelulusan dan ijazah/sertifikat, dengan verifikasi keaslian lewat QR code
- Ekspor data ke format Dapodik (Excel/CSV)
- Arsip dokumen siswa dan lembaga

### G. Keuangan
- Tagihan SPP dan pembayaran (tarif normal/premium vs beasiswa)
- Beasiswa: pengajuan, seleksi, penyaluran dana zakat/wakaf, laporan ke donatur
- Program afiliasi: kode referral dan potongan SPP
- Rekonsiliasi dan laporan keuangan, anggaran (CapEx/OpEx)

### H. Mitra dan Wilayah
- Data mitra (pesantren, majelis taklim, perwakilan luar negeri)
- Pendaftaran siswa kolektif oleh mitra
- Dashboard per wilayah/negara
- Pelaporan program daerah 3T

### I. SDM dan Tutor
- Data tutor dan sertifikasi
- Beban mengajar
- KPI tutor (waktu respons, kehadiran live class, kepuasan siswa)
- Rekrutmen dan penilaian kinerja

### J. Mutu dan Monitoring
- Dashboard Balanced Scorecard (4 perspektif)
- Dokumen SOP dan versinya
- Survei kepuasan (siswa, orang tua, mitra)
- Manajemen risiko (register risiko dan mitigasi)
- Checklist legalitas dan akreditasi

### K. Helpdesk
- Tiket keluhan teknis dan akademik
- Status dan SLA penanganan
- Basis pengetahuan

### L. Administrasi Sistem
- Manajemen pengguna, role, dan hak akses
- Pengaturan lembaga (tahun ajaran, jenjang, tarif)
- Log aktivitas (audit trail)
- Pengaturan notifikasi dan template pesan
- Manajemen Modul (lihat bagian 8)

## 6. Rancangan RBAC

Hak akses ditentukan oleh empat lapis:

1. **Akses modul**: role boleh masuk ke modul mana saja.
2. **Akses menu/fitur**: di dalam modul, fitur mana yang boleh dibuka.
3. **Aksi**: lihat, tambah, ubah, hapus, setujui, ekspor, cetak.
4. **Cakupan data (scope)**:
   - *Milik sendiri*: siswa hanya melihat nilainya sendiri.
   - *Anak terhubung*: orang tua melihat data anaknya.
   - *Kelas/mapel yang diampu*: tutor dan wali kelas.
   - *Wilayah/mitra*: koordinator mitra hanya melihat siswa binaannya.
   - *Seluruh lembaga*: manajer dan direktur.

Konsekuensi pada desain modular:
- Setiap modul **mendaftarkan permission-nya sendiri**, sehingga Super Admin tinggal mencentang pada role.
- Modul yang dinonaktifkan otomatis **mencabut akses** semua role ke modul itu.
- Tersedia **paket role siap pakai** per modul, misalnya "Operator Keuangan" atau "Pengelola Bank Soal".
- Alur persetujuan (maker-checker) **melekat pada modul**: persetujuan nilai di Penilaian, persetujuan ijazah di Dokumen, persetujuan beasiswa di Keuangan.

### Matriks Ringkas Role × Modul

| Modul | Super Admin | Direktur | Mgr Akademik | Mgr Kesiswaan | Mgr Keuangan | Tutor | Wali Kelas | Siswa | Ortu | Mitra |
|---|---|---|---|---|---|---|---|---|---|---|
| PPDB & verifikasi | ✔ | Lihat | – | Kelola | – | – | – | Daftar sendiri | Daftar anak | Daftar kolektif |
| Data induk siswa | ✔ | Lihat | Lihat | Kelola | Lihat terbatas | Kelas diampu | Kelas dibina | Sendiri | Anak | Binaan |
| Kurikulum & jadwal | ✔ | Setujui | Kelola | – | – | Lihat | Lihat | Lihat | Lihat | – |
| Materi & kelas LMS | ✔ | Lihat | Pantau | – | – | Kelola | Lihat | Akses | Pantau | – |
| Nilai & penilaian | ✔ | Lihat | Setujui | – | – | Input | Lihat | Sendiri | Anak | – |
| Ujian & proctoring | ✔ | Lihat | Kelola | – | – | Susun soal | – | Mengerjakan | – | – |
| Rapor & ijazah | ✔ | Setujui | Kelola | Cetak | – | – | Verifikasi | Sendiri | Anak | – |
| Keuangan & beasiswa | ✔ | Lihat/setujui | – | Usulan beasiswa | Kelola | – | – | Tagihan sendiri | Bayar | Laporan binaan |
| KPI tutor & SDM | ✔ | Lihat | Kelola | – | – | Sendiri | – | – | – | – |
| Dashboard mutu/BSC | ✔ | Lihat | Lihat | Lihat | Lihat | – | – | – | – | – |
| Pengaturan sistem & role | ✔ | – | – | – | – | – | – | – | – | – |

### Aturan Penting Sejak Awal

1. **Satu pengguna bisa punya banyak role.** Contoh: tutor yang juga wali kelas, atau orang tua yang juga tutor.
2. **Pemisahan tugas (maker-checker).** Yang menginput nilai tidak boleh yang menyetujui; yang membuat tagihan tidak boleh yang mengonfirmasi pembayaran.
3. **Alur persetujuan bertingkat** untuk perubahan nilai, penerbitan ijazah, pemberian beasiswa, dan penghapusan data.
4. **Hak akses data sensitif lebih ketat** untuk data anak, dokumen identitas, dan data keuangan.
5. **Audit log** untuk semua perubahan nilai, data siswa, keuangan, dan hak akses.
6. **Role bisa dikustomisasi** oleh Super Admin tanpa mengubah sistem.
7. **Akses sementara/berbatas waktu**, misalnya untuk proktor ujian, tutor tamu, atau auditor saat akreditasi.

## 7. Tahapan Pengembangan

| Tahap | Cakupan |
|---|---|
| **Alpha (2027)** | Modul inti, akun dan RBAC, PPDB, data siswa, kurikulum, kelas LMS dasar, presensi, ekspor Dapodik |
| **Beta (2028)** | CBT dan proctoring, e-rapor, keuangan/SPP, tahfizh, helpdesk, notifikasi |
| **Ekspansi (2029–2030)** | Portal mitra, beasiswa, afiliasi, dashboard wilayah/negara, dukungan zona waktu |
| **Lanjutan (2031–2032)** | Tutor AI, dashboard BSC, manajemen mutu/ISO 21001, analitik lanjutan |

## 8. Halaman "Manajemen Modul" untuk Super Admin

Satu halaman yang menampilkan:
- Daftar semua modul, status (aktif/nonaktif), dan versi
- Prasyarat dan modul lain yang bergantung padanya
- Tombol aktif/nonaktif
- Pengaturan khusus per modul
- Daftar role yang punya akses ke modul tersebut

## 9. Manfaat Pendekatan Modular bagi Yayasan

- **Peluncuran bertahap**: 2027 cukup modul inti, PPDB, Data Siswa, Kurikulum, LMS dasar, dan Ekspor Dapodik.
- **Risiko lebih kecil**: gangguan di satu modul tidak melumpuhkan seluruh aplikasi.
- **Fleksibel untuk model bisnis**: Keuangan, Beasiswa, atau Afiliasi bisa diaktifkan belakangan sesuai kesiapan lembaga.
- **Bisa direplikasi**: jika kelak membuka PKBM cabang atau mitra, modul yang dipakai bisa berbeda per lembaga.
- **Pengembangan paralel**: tim bisa mengerjakan beberapa modul sekaligus dengan batas tanggung jawab yang jelas.

## 10. Langkah Lanjutan yang Disarankan

- Daftar permission rinci per modul
- Peta modul per tahap rilis beserta prasyaratnya
- Alur pengguna (user flow), misalnya pendaftaran siswa diaspora dan persetujuan nilai ke rapor
