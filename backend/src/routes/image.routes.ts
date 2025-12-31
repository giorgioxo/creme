import { Router } from 'express';
import { getBackgroundImage, updateBackgroundImage } from '../controllers/image.controller';
import { upload } from '../middleware/upload.middleware';

export const imageRoutes = Router();

/**
 * @swagger
 * /api/background-image:
 *   get:
 *     summary: Get current background image URL
 *     tags: [Background Image]
 *     responses:
 *       200:
 *         description: Background image URL
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 imageUrl:
 *                   type: string
 *                   nullable: true
 *                 message:
 *                   type: string
 *                 createdAt:
 *                   type: string
 *                   format: date-time
 */
imageRoutes.get('/background-image', getBackgroundImage);

/**
 * @swagger
 * /api/background-image:
 *   post:
 *     summary: Upload new background image
 *     tags: [Background Image]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *     responses:
 *       200:
 *         description: Image uploaded successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 imageUrl:
 *                   type: string
 *                 message:
 *                   type: string
 *       400:
 *         description: No image file provided
 */
imageRoutes.post('/background-image', upload.single('image'), updateBackgroundImage);

