# Panduan & Checklist Pengujian Fitur PKBM Digital Dar El Iman
**Dokumen Pengujian Komprehensif (Tahap 1 s.d. Tahap 5)**  
*Gunakan checklist ini untuk memverifikasi seluruh alur sistem sebelum diunggah ke Easypanel.*

---

## 🔑 Akun Login Cepat untuk Pengujian

| Peran (Role) | Username | Password | Deskripsi Hak Akses |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `admin` | *(bebas)* | Akses penuh master data, plotting rombel, bank soal CBT, panitia PPDB, keuangan SPP, akreditasi BAN-PDM. |
| **Ustadz / Tutor** | `tutor` | *(bebas)* | Akses ruang pengajar LMS, buat materi/tugas, input link Google Meet, catat kelancaran & tajwid setoran tahfizh. |
| **Santri / Siswa** | `santri` | *(bebas)* | Akses ruang belajar santri, kerjakan tugas, gabung Meet, ujian CBT Kiosk, lihat pembahasan, pantau E-Rapor. |
| **Tamu / Calon Santri** | `tamu` | *(bebas)* | Hanya bisa melihat dan mengisi formulir pendaftaran PPDB & unggah berkas (sidebar menu internal terkunci). |

---

## TAHAP 1: Fondasi Sistem, Autentikasi & Input Master Data

- [ ] **1.1. Login Multi-Peran (RBAC)**
  - *Cara Cek:* Masuk dengan username `admin`, `tutor`, `santri`, dan `tamu`.
  - *Hasil yang diharapkan:* Tampilan dashboard dan menu sidebar menyesuaikan secara tepat dengan peran yang sedang aktif.
- [ ] **1.2. Master Data Santri Terintegrasi**
  - *Cara Cek:* Buka menu **Data Santri / Siswa** (Login Admin).
  - *Hasil yang diharapkan:* Tampil data santri lengkap dengan NIS, Rombel, status aktif, penanda Diaspora / Nasional, dan kontak wali.
- [ ] **1.3. Master Data Tutor & Tenaga Pendidik**
  - *Cara Cek:* Buka menu **Data Tutor & Guru** (Login Admin).
  - *Hasil yang diharapkan:* Tampil daftar tutor, NIP, spesialisasi mata pelajaran, kontak, dan username aktif.
- [ ] **1.4. Rombongan Belajar (Rombel / Kelas)**
  - *Cara Cek:* Buka menu **Rombel & Kelas** (Login Admin).
  - *Hasil yang diharapkan:* Kelas Paket A, B, dan C terdaftar lengkap dengan penunjukan Wali Kelas dan kapasitas santri.
- [ ] **1.5. Impor Data Massal (CSV / Excel)**
  - *Cara Cek:* Di menu Data Santri, klik **Unduh Contoh CSV** lalu klik **Impor CSV**.
  - *Hasil yang diharapkan:* File template CSV berhasil terunduh dan tombol impor berhasil memasukkan data santri baru secara otomatis.

---

## TAHAP 2: Kurikulum, Pembelajaran LMS & Halaqah Tahfizh

- [ ] **2.1. Katalog Kurikulum & Mata Pelajaran**
  - *Cara Cek:* Buka menu **Mata Pelajaran** (Login Admin).
  - *Hasil yang diharapkan:* Terdaftar 6 mata pelajaran resmi (Pendidikan Agama Islam, Bahasa Indonesia, AI Literacy, Tahfizh Al-Qur'an, Bahasa Arab, Akidah Akhlak).
- [ ] **2.2. Modul LMS & Pembagian Materi/Tugas**
  - *Cara Cek:* Login sebagai Ustadz (`tutor`) di menu **LMS Kelas**, lalu login sebagai Santri (`santri`) di menu **Ruang Belajar LMS**.
  - *Hasil yang diharapkan:* Materi bacaan, PDF, dan video tampil rapi. Santri dapat melihat instruksi dan tombol pengumpulan tugas.
- [ ] **2.3. Google Meet Terintegrasi (Kondisional Hak Akses)**
  - *Cara Cek:* Login Santri di **Ruang Belajar LMS**. Jika link belum disediakan Ustadz, tombol bertuliskan badge abu-abu: `Link Meet Belum Disediakan Ustadz`.
  - *Hasil yang diharapkan:* Santri tidak melihat tombol "Sediakan Link", dan tombol Meet hanya aktif menjadi link video jika Ustadz sudah menyediakannya.
- [ ] **2.4. Mutaba'ah Setoran Tahfizh (RBAC Ketat)**
  - *Cara Cek:* Buka menu **Mutaba'ah Tahfizh** sebagai Santri, lalu sebagai Ustadz.
  - *Hasil yang diharapkan:* Santri hanya dapat melihat riwayat setoran ziyadah/muraja'ah. Tombol **+ Catat Setoran Santri** dan pengisian nilai kelancaran/tajwid hanya dapat diakses oleh Ustadz.
- [ ] **2.5. Batasan Pembentukan Kelompok Halaqah**
  - *Cara Cek:* Coba klik tombol **+ Bentuk Halaqah** saat login sebagai Santri atau Tutor.
  - *Hasil yang diharapkan:* Sistem menampilkan peringatan bahwa pembentukan kelompok halaqah hanya boleh dilakukan oleh Administrator.

---

## TAHAP 3: Asesmen CBT Daring, Proctoring & E-Rapor Digital

- [ ] **3.1. Bank Soal & Jadwal Ujian CBT**
  - *Cara Cek:* Login Admin/Tutor di menu **Bank Soal & CBT**.
  - *Hasil yang diharapkan:* Daftar 11 butir soal ujian (10 Pilihan Ganda & 1 Esai) terdaftar lengkap dengan bobot dan opsi jawaban.
- [ ] **3.2. Gerbang Token CBT Santri**
  - *Cara Cek:* Login Santri di menu **Ujian CBT Daring**. Masukkan token: `TAHFIZH26`.
  - *Hasil yang diharapkan:* Token tervalidasi dan santri diarahkan masuk ke lembar pengerjaan ujian.
- [ ] **3.3. Lembar Jawaban Bersih (Tanpa Kunci Bocor)**
  - *Cara Cek:* Begitu masuk ke soal nomor 1 sampai 11, periksa opsi A, B, C, D dan palet nomor soal sebelah kanan.
  - *Hasil yang diharapkan:* Tidak ada opsi jawaban yang menyala hijau di awal. Semua palet nomor soal berstatus netral ("Belum Dijawab").
- [ ] **3.4. Mode Layar Penuh (Kiosk Fullscreen Lock)**
  - *Cara Cek:* Saat sedang mengerjakan ujian, coba tekan tombol Escape atau keluar dari layar penuh peramban.
  - *Hasil yang diharapkan:* Muncul layar peringatan merah (lockdown overlay) yang mencatat pelanggaran dan mewajibkan santri kembali ke mode layar penuh.
- [ ] **3.5. Pop-up Konfirmasi Selesai Ujian di Tengah Layar**
  - *Cara Cek:* Klik tombol **Selesai & Kirim Ujian** di bagian atas lembar CBT.
  - *Hasil yang diharapkan:* Muncul modal dialog modern di tengah layar dengan ringkasan jumlah soal sudah dijawab, ragu-ragu, dan belum dijawab. Tombol kumpulkan tetap aktif dan responsif.
- [ ] **3.6. Halaman Hasil & Pembahasan Kunci Jawaban Lengkap**
  - *Cara Cek:* Konfirmasi pengumpulan ujian.
  - *Hasil yang diharapkan:* Tampil kartu skor nilai akhir, status KKM (Lulus / Remedial), serta pembahasan ilmiah kaidah tajwid per butir soal tanpa emotikon berlebihan dan tanpa bertabrakan dengan header.
- [ ] **3.7. Riwayat Ujian & Pengulangan Latihan**
  - *Cara Cek:* Buka kembali menu **Ujian CBT Daring**, lihat tabel **Riwayat Ujian CBT Santri**.
  - *Hasil yang diharapkan:* Sesi ujian yang baru selesai tercatat di tabel riwayat. Tombol **Pembahasan** membuka ulasan kunci, dan tombol **Ulangi** memungkinkan santri berlatih kembali.
- [ ] **3.8. E-Rapor Digital & Modal Verifikasi QR**
  - *Cara Cek:* Buka menu **E-Rapor Semester**, klik tombol **Cek Keaslian QR Code** atau kotak QR di bawah rapor.
  - *Hasil yang diharapkan:* Pop-up verifikasi keabsahan dokumen muncul rapi di tengah layar, dan dapat ditutup dengan mudah via tombol `✕`, klik di luar modal, atau tombol `Esc`.

---

## TAHAP 4: PPDB Online, Keuangan SPP & Ekspor Dapodik

- [ ] **4.1. Isolasi Akses Akun Tamu (GUEST)**
  - *Cara Cek:* Login sebagai Tamu (`tamu`).
  - *Hasil yang diharapkan:* Sidebar hanya menampilkan menu **Pendaftaran Santri Baru**. Semua menu internal (LMS, SPP, CBT, Dapodik) terkunci aman.
- [ ] **4.2. Formulir PPDB & Unggah Dokumen**
  - *Cara Cek:* Pada menu pendaftaran PPDB, isi identitas calon santri dan pilih file dokumen persyaratan.
  - *Hasil yang diharapkan:* Status berkas hanya menampilkan label `(Terpilih)` jika calon santri benar-benar telah memilih file, tanpa data dummy bawaan.
- [ ] **4.3. Verifikasi Panitia PPDB (Admin)**
  - *Cara Cek:* Login Admin di menu **Panitia PPDB**. Klik salah satu calon santri.
  - *Hasil yang diharapkan:* Modal verifikasi berkas muncul, panitia dapat memeriksa biodata, berkas unggahan, dan mengubah status menjadi `DITERIMA`.
- [ ] **4.4. Menu PPDB Bersih dari Sidebar Santri**
  - *Cara Cek:* Login Santri (`santri`). Periksa kelompok menu di sidebar kiri.
  - *Hasil yang diharapkan:* Menu pendaftaran PPDB sudah tidak ada di sidebar santri (karena santri sudah resmi diterima).
- [ ] **4.5. Manajemen Keuangan & Tagihan SPP**
  - *Cara Cek:* Login Admin di menu **Kas & Keuangan SPP**.
  - *Hasil yang diharapkan:* Daftar tagihan SPP per jenjang Paket A, B, C terpantau dengan status lunas/belum lunas dan ringkasan kas masuk.
- [ ] **4.6. Ekspor Data Terstandar Dapodik Kemendikbudristek**
  - *Cara Cek:* Login Admin di menu **Sinkronisasi Dapodik**. Klik **Ekspor Data Santri (CSV Dapodik)**.
  - *Hasil yang diharapkan:* Sistem mengekspor file spreadsheet berformat standar Dapodik (NISN, NIK, Nama, Tanggal Lahir, Nama Ibu Kandung).

---

## TAHAP 5: Kemitraan Pesantren, Mutu BAN-PDM & Tutor AI

- [ ] **5.1. Portal Kemitraan Pesantren**
  - *Cara Cek:* Login Admin di menu **Kemitraan Pesantren**.
  - *Hasil yang diharapkan:* Daftar mitra lembaga, kuota santri binaan, dan status MoU kemitraan terpantau rapi.
- [ ] **5.2. Peta Persebaran Diaspora Global**
  - *Cara Cek:* Buka menu **Persebaran Diaspora** (Login Admin).
  - *Hasil yang diharapkan:* Visualisasi persebaran santri luar negeri (Arab Saudi, Jepang, Malaysia) dan pemantau jam lokal lintas zona waktu dunia (WIB, WITA, WIT, AST, JST).
- [ ] **5.3. Instrumen Akreditasi BAN-PDM & SOP Mutu**
  - *Cara Cek:* Buka menu **Akreditasi & SOP Mutu** (Login Admin/Tutor).
  - *Hasil yang diharapkan:* Checklist 8 Standar Nasional Pendidikan (SNP) BAN-PDM dan repositori dokumen bukti fisik (eviden) tersaji lengkap.
- [ ] **5.4. Executive Dashboard Balanced Scorecard (BSC)**
  - *Cara Cek:* Buka menu **Balanced Scorecard (BSC)** (Login Admin).
  - *Hasil yang diharapkan:* Tampil grafik 4 perspektif kinerja institusi (Akademik & Tahfizh, Kepuasan Wali & Santri, Proses Operasional Internal, Keberlanjutan Finansial).
- [ ] **5.5. Asisten Tutor AI 24/7**
  - *Cara Cek:* Buka menu **Tutor AI 24/7** (Login Santri/Tutor/Admin). Ketik pertanyaan: *"Apa hukum membaca mim bertasydid?"* atau *"Bagaimana adab menuntut ilmu?"*.
  - *Hasil yang diharapkan:* AI merespons dengan rujukan kaidah tajwid dan adab syar'i secara cepat dan kontekstual.

---

## 🛠️ Catatan Persiapan Upload ke Easypanel

1. **Docker Backend**: `backend/Dockerfile` multi-stage build Go 1.23 siap di-deploy pada port `8080`.
2. **Docker Frontend**: `frontend/Dockerfile` berbasis Nginx Alpine melayani SPA pada port `80`.
3. **Database**: Menggunakan MySQL 8.0 dengan migrasi tabel otomatis saat aplikasi dijalankan.
4. **Git Status**: Cabang `main` telah bersih dan seluruh perubahan tersimpan rapi.
