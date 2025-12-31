import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  user: process.env.DB_USER || 'creme_user',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'creme_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

export const pool = mysql.createPool(dbConfig);

// Test connection
export async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('✅ Database connected successfully');
    connection.release();
    return true;
  } catch (error: any) {
    console.warn('⚠️  Database connection failed (API will work without DB):');
    console.warn('   Error:', error.message);
    console.warn('   To fix: Create MySQL user and database (see START_HERE.md)');
    return false;
  }
}

