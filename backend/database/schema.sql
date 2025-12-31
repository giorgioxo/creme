-- SQLite Database Schema for Creme
-- This file is for reference only - tables are created automatically

-- Background Images Table
CREATE TABLE IF NOT EXISTS background_images (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  image_path TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
