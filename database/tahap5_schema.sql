-- ==============================================================================
-- BASIS DATA: PKBM DIGITAL DAR EL IMAN
-- TAHAP 5: Kemitraan, Penjaminan Mutu BAN-PDM, Balanced Scorecard & Tutor AI
-- Mesin: MySQL 8.0+ / InnoDB / UTF8MB4
-- ==============================================================================

USE pkbm_digital_darel_iman;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. TABEL KEMITRAAN & DIASPORA
DROP TABLE IF EXISTS partner_students;
DROP TABLE IF EXISTS partners;

CREATE TABLE partners (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(200) NOT NULL, -- Contoh: 'Pesantren Mitra Darul Hadits', 'Komunitas Diaspora Jepang'
    partner_type ENUM('PESANTREN', 'MAJELIS_TAKLIM', 'KOMUNITAS_DIASPORA', 'LEMBAGA_BEASISWA') NOT NULL,
    country VARCHAR(100) DEFAULT 'Indonesia',
    city VARCHAR(100),
    contact_person VARCHAR(150),
    phone VARCHAR(50),
    email VARCHAR(150),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE partner_students (
    partner_id CHAR(36) NOT NULL,
    student_id CHAR(36) NOT NULL,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (partner_id, student_id),
    CONSTRAINT fk_ps_partner FOREIGN KEY (partner_id) REFERENCES partners(id) ON DELETE CASCADE,
    CONSTRAINT fk_ps_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. TABEL PENJAMINAN MUTU, SOP & AKREDITASI BAN-PDM
DROP TABLE IF EXISTS risk_registers;
DROP TABLE IF EXISTS institution_sops;
DROP TABLE IF EXISTS accreditation_items;
DROP TABLE IF EXISTS accreditation_standards;

CREATE TABLE accreditation_standards (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) NOT NULL, -- Contoh: 'BAN-PDM-01'
    standard_name VARCHAR(200) NOT NULL, -- Contoh: 'Standar Kompetensi Lulusan'
    component_name VARCHAR(200) NOT NULL,
    max_score DECIMAL(5,2) DEFAULT 4.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE accreditation_items (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    standard_id CHAR(36) NOT NULL,
    item_number VARCHAR(20) NOT NULL,
    indicator_description TEXT NOT NULL,
    fulfillment_status ENUM('NOT_STARTED', 'IN_PROGRESS', 'READY_AUDIT', 'FULFILLED') DEFAULT 'NOT_STARTED',
    evidence_file_url TEXT,
    notes TEXT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_ai_standard FOREIGN KEY (standard_id) REFERENCES accreditation_standards(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE institution_sops (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) UNIQUE NOT NULL, -- Contoh: 'SOP-AKD-001'
    title VARCHAR(200) NOT NULL,
    department VARCHAR(100) NOT NULL, -- 'Akademik', 'Keuangan', 'Kesiswaan', 'IT'
    version VARCHAR(20) DEFAULT '1.0',
    file_url TEXT NOT NULL,
    effective_date DATE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE risk_registers (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    risk_title VARCHAR(200) NOT NULL,
    category ENUM('OPERASIONAL', 'TEKNOLOGI', 'REPUTASI', 'KEUANGAN') NOT NULL,
    severity_level ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') NOT NULL,
    mitigation_plan TEXT NOT NULL,
    owner_user_id CHAR(36),
    status ENUM('OPEN', 'MITIGATED', 'CLOSED') DEFAULT 'OPEN',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rr_user FOREIGN KEY (owner_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. TABEL BALANCED SCORECARD (BSC)
DROP TABLE IF EXISTS bsc_indicators;

CREATE TABLE bsc_indicators (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    perspective ENUM('FINANCIAL', 'CUSTOMER_STAKEHOLDER', 'INTERNAL_PROCESS', 'LEARNING_GROWTH') NOT NULL,
    indicator_name VARCHAR(200) NOT NULL,
    target_value DECIMAL(10,2) NOT NULL,
    current_value DECIMAL(10,2) DEFAULT 0.00,
    unit VARCHAR(50) NOT NULL, -- '%', 'Orang', 'Rp', 'Skor'
    period_year INT NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. TABEL ASISTEN CERDAS TUTOR AI
DROP TABLE IF EXISTS ai_chat_messages;
DROP TABLE IF EXISTS ai_chat_sessions;

CREATE TABLE ai_chat_sessions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id CHAR(36) NOT NULL,
    subject_id CHAR(36),
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_acs_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    CONSTRAINT fk_acs_subject FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ai_chat_messages (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    session_id CHAR(36) NOT NULL,
    sender_type ENUM('USER', 'ASSISTANT') NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_acm_session FOREIGN KEY (session_id) REFERENCES ai_chat_sessions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Indeks Kinerja
CREATE INDEX idx_partner_students_pid ON partner_students(partner_id);
CREATE INDEX idx_accreditation_items_sid ON accreditation_items(standard_id);
CREATE INDEX idx_ai_messages_session ON ai_chat_messages(session_id);

SET FOREIGN_KEY_CHECKS = 1;
