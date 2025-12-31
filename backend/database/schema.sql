-- Creme Database Schema
-- Run this script to create the database and tables

-- Create database
CREATE DATABASE IF NOT EXISTS creme_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the database
USE creme_db;

-- Background Images Table
CREATE TABLE IF NOT EXISTS background_images (
  id INT AUTO_INCREMENT PRIMARY KEY,
  image_path VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default/example (optional)
-- INSERT INTO background_images (image_path) VALUES ('default-background.jpg');

