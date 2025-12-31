import { Router } from 'express';
import { getBackgroundImage, updateBackgroundImage } from '../controllers/image.controller';
import { upload } from '../middleware/upload.middleware';

export const imageRoutes = Router();

// Get background image URL
imageRoutes.get('/background-image', getBackgroundImage);

// Update background image (upload new image)
imageRoutes.post('/background-image', upload.single('image'), updateBackgroundImage);

