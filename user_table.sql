CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Insert sample users (password is 'password123' hashed with BCrypt)
INSERT INTO users (username, password, full_name, role) VALUES
('admin', '$2a$10$uGCnA3z9CaWWS6pysEEoJ..XEssyXRSyHZrgoP76J0S.Hl/if50Ae', 'Admin User', 'admin'),
('john', '$2a$10$uGCnA3z9CaWWS6pysEEoJ..XEssyXRSyHZrgoP76J0S.Hl/if50Ae', 'John Doe', 'user'),
('jane', '$2a$10$uGCnA3z9CaWWS6pysEEoJ..XEssyXRSyHZrgoP76J0S.Hl/if50Ae', 'Jane Smith', 'user');