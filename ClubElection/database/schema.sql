CREATE DATABASE IF NOT EXISTS club_election;
USE club_election;

CREATE TABLE admins (
  admin_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  has_voted BOOLEAN DEFAULT FALSE,
  is_approved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE candidates (
  candidate_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  position VARCHAR(100) NOT NULL,
  image_path VARCHAR(255),
  bio TEXT,
  vote_count INT DEFAULT 0
);

CREATE TABLE votes (
  vote_id INT AUTO_INCREMENT PRIMARY KEY,
  candidate_id INT NOT NULL,
  voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id)
);

CREATE TABLE election_settings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  election_title VARCHAR(200) DEFAULT 'Club Election',
  is_active BOOLEAN DEFAULT FALSE,
  end_time DATETIME,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO admins (username, password) VALUES ('admin', SHA2('admin', 256));
INSERT INTO election_settings (election_title, is_active) VALUES ('Club Election 2025', FALSE);
