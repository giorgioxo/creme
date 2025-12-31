import Database from 'better-sqlite3';
import dotenv from 'dotenv';
import path from 'path';
import fs from 'fs';

dotenv.config();

// SQLite database path
const dbPath = path.join(__dirname, '../../database.sqlite');
const dbDir = path.dirname(dbPath);

// Ensure database directory exists
if (!fs.existsSync(dbDir)) {
  fs.mkdirSync(dbDir, { recursive: true });
}

// Create SQLite database connection
export const db = new Database(dbPath);

// Enable foreign keys and other SQLite settings
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// Test connection
export function testConnection() {
  try {
    // Test query
    db.prepare('SELECT 1').get();
    console.log('✅ SQLite database connected successfully');
    console.log(`📁 Database location: ${dbPath}`);
    
    // Initialize database tables if they don't exist
    initializeDatabase();
    
    return true;
  } catch (error: any) {
    console.error('❌ Database connection failed:', error.message);
    return false;
  }
}

// Initialize database schema
function initializeDatabase() {
  try {
    // Create tables if they don't exist
    db.exec(`
      CREATE TABLE IF NOT EXISTS background_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
      
      CREATE TABLE IF NOT EXISTS site_content (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        value TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    `);
    
    // Insert default coming soon text if it doesn't exist
    const insertStmt = db.prepare('INSERT OR IGNORE INTO site_content (key, value) VALUES (?, ?)');
    insertStmt.run('coming_soon_text', 'Crème - Coming Soon');
    
    console.log('✅ Database tables initialized');
  } catch (error: any) {
    console.error('❌ Error initializing database:', error.message);
  }
}
