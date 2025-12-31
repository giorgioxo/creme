import { Request, Response } from 'express';
import { db } from '../config/database';

export async function getComingSoonText(req: Request, res: Response) {
  try {
    const stmt = db.prepare(
      'SELECT value FROM site_content WHERE key = ?'
    );
    
    const row = stmt.get('coming_soon_text') as any;

    if (!row) {
      return res.json({ 
        text: 'Crème - Coming Soon'
      });
    }

    res.json({ 
      text: row.value || 'Crème - Coming Soon'
    });
  } catch (error: any) {
    console.error('Error fetching coming soon text:', error);
    res.status(500).json({ 
      error: 'Failed to fetch coming soon text',
      message: error.message
    });
  }
}

