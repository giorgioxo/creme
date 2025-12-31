import { Request, Response } from 'express';
import { pool } from '../config/database';

export async function getBackgroundImage(req: Request, res: Response) {
  try {
    const [rows] = await pool.execute(
      'SELECT image_path, created_at FROM background_images ORDER BY created_at DESC LIMIT 1'
    ) as any[];

    if (rows.length === 0) {
      return res.json({ 
        imageUrl: null, 
        message: 'No background image set' 
      });
    }

    const imagePath = rows[0].image_path;
    const imageUrl = `/uploads/${imagePath}`;

    res.json({ 
      imageUrl,
      createdAt: rows[0].created_at
    });
  } catch (error: any) {
    // If database not set up, return null (API still works)
    if (error.code === 'ER_ACCESS_DENIED_ERROR' || error.code === 'ECONNREFUSED') {
      return res.json({ 
        imageUrl: null, 
        message: 'Database not configured. API is working but database connection is needed for images.' 
      });
    }
    console.error('Error fetching background image:', error);
    res.status(500).json({ 
      error: 'Failed to fetch background image' 
    });
  }
}

export async function updateBackgroundImage(req: Request, res: Response) {
  try {
    if (!req.file) {
      return res.status(400).json({ 
        error: 'No image file provided' 
      });
    }

    const imagePath = req.file.filename;

    try {
      // Insert new image path into database
      await pool.execute(
        'INSERT INTO background_images (image_path) VALUES (?)',
        [imagePath]
      );
    } catch (dbError: any) {
      // If database not set up, still save file but warn
      if (dbError.code === 'ER_ACCESS_DENIED_ERROR' || dbError.code === 'ECONNREFUSED') {
        console.warn('⚠️  Image saved but database not available. File:', imagePath);
      } else {
        throw dbError;
      }
    }

    const imageUrl = `/uploads/${imagePath}`;

    res.json({ 
      success: true,
      imageUrl,
      message: 'Background image updated successfully' 
    });
  } catch (error) {
    console.error('Error updating background image:', error);
    res.status(500).json({ 
      error: 'Failed to update background image' 
    });
  }
}

