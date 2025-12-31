import { Request, Response } from 'express';
import { db } from '../config/database';

export async function getBackgroundImage(req: Request, res: Response) {
  try {
    const stmt = db.prepare(
      'SELECT image_path, created_at FROM background_images ORDER BY created_at DESC LIMIT 1'
    );
    
    const row = stmt.get() as any;

    if (!row) {
      return res.json({ 
        imageUrl: null, 
        message: 'No background image set' 
      });
    }

    const imagePath = row.image_path;
    const imageUrl = `/uploads/${imagePath}`;

    res.json({ 
      imageUrl,
      createdAt: row.created_at
    });
  } catch (error: any) {
    console.error('Error fetching background image:', error);
    res.status(500).json({ 
      error: 'Failed to fetch background image',
      message: error.message
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
      const stmt = db.prepare(
        'INSERT INTO background_images (image_path) VALUES (?)'
      );
      stmt.run(imagePath);
    } catch (dbError: any) {
      console.error('Database error:', dbError.message);
      throw dbError;
    }

    const imageUrl = `/uploads/${imagePath}`;

    res.json({ 
      success: true,
      imageUrl,
      message: 'Background image updated successfully' 
    });
  } catch (error: any) {
    console.error('Error updating background image:', error);
    res.status(500).json({ 
      error: 'Failed to update background image',
      message: error.message
    });
  }
}
