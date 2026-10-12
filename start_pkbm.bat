@echo off
title PKBM Digital Dar El Iman - Launcher Terpadu
echo ========================================================
echo   PKBM DIGITAL DAR EL IMAN - FULL PLATFORM (TAHAP 1 - 5)
echo   Fondasi, LMS, CBT/Rapor, PPDB/Keuangan/Dapodik,
echo   Kemitraan, BAN-PDM Mutu, BSC & Asisten Tutor AI 24/7
echo ========================================================
echo.
echo [1/3] Menjalankan Backend API Go di Port 8080...
start "PKBM Backend (Go)" /d "%~dp0backend" cmd /c run_backend.bat

timeout /t 2 /nobreak >nul

echo [2/3] Membuka Antarmuka Frontend SPA...
start "" "%~dp0frontend\index.html"

echo.
echo ========================================================
echo   SELURUH FITUR RANCANGAN PKBM DIGITAL LENGKAP 100%%!
echo   - Backend API : http://localhost:8080/health (Stage 5)
echo   - Frontend UI : %~dp0frontend\index.html
echo   - Fitur Baru  :
echo     * Kemitraan Pesantren & Jaringan Santri Diaspora
echo     * Instrumen Akreditasi BAN-PDM & Repositori SOP Mutu
echo     * Executive Balanced Scorecard (BSC 4 Perspektif)
echo     * Asisten Cerdas Tutor AI 24/7 Berbasis Silabus
echo   - Akun Super Admin : admin / admin123
echo   - Akun Operator    : operator / admin123
echo   - Akun Tutor       : tutor.ahmad / tutor123
echo   - Akun Santri      : santri.fatih / santri123
echo ========================================================
echo.
pause
