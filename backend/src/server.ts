import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';
import path from 'path';
import { imageRoutes } from './routes/image.routes';
import { testConnection } from './config/database';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// CORS configuration
const corsOptions = {
  origin: process.env.FRONTEND_URL || (NODE_ENV === 'production' ? 'https://creme.ge' : 'http://localhost:4200'),
  credentials: true,
  optionsSuccessStatus: 200
};

// Middleware
app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Swagger configuration (only in development)
if (NODE_ENV === 'development') {
  const swaggerOptions = {
    definition: {
      openapi: '3.0.0',
      info: {
        title: 'Creme Bakery API',
        version: '1.0.0',
        description: 'API for Creme Bakery website - Background image management',
      },
    servers: [
      {
        url: `http://localhost:${PORT}`,
        description: 'Development server',
      },
    ],
    },
    apis: ['./src/routes/*.ts', './src/controllers/*.ts'],
  };

  const swaggerSpec = swaggerJsdoc(swaggerOptions);
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
}

// Serve uploaded images
app.use('/uploads', express.static('uploads'));

// API Routes
app.use('/api', imageRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'Creme API is running',
    environment: NODE_ENV,
    timestamp: new Date().toISOString()
  });
});

// Serve static files from Angular build (production only)
if (NODE_ENV === 'production') {
  // Try multiple possible paths for dist folder
  const fs = require('fs');
  const possiblePaths = [
    path.join(__dirname, '../../dist'),           // Root dist
    path.join(__dirname, '../dist'),              // Backend/dist
    path.join(__dirname, '../../creme/dist'),      // Alternative structure
    path.join(process.cwd(), 'dist')              // Current working directory
  ];
  
  let distPath = null;
  for (const possiblePath of possiblePaths) {
    if (fs.existsSync(possiblePath)) {
      distPath = possiblePath;
      break;
    }
  }
  
  if (distPath) {
    console.log(`📁 Serving static files from: ${distPath}`);
    app.use(express.static(distPath));
    
    // All routes not starting with /api should serve Angular app
    app.get('*', (req, res) => {
      // Don't serve index.html for API routes
      if (req.path.startsWith('/api')) {
        return res.status(404).json({ error: 'API endpoint not found' });
      }
      res.sendFile(path.join(distPath, 'index.html'));
    });
  } else {
    console.warn('⚠️  Frontend dist folder not found. API only mode.');
  }
}

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📡 Environment: ${NODE_ENV}`);
  if (NODE_ENV === 'production') {
    console.log(`🌐 Frontend: Serving from dist/`);
    console.log(`🔗 Domain: ${process.env.DOMAIN || 'creme.ge'}`);
  } else {
    console.log(`🌐 API: http://localhost:${PORT}/api`);
    console.log(`💚 Health: http://localhost:${PORT}/api/health`);
    console.log(`📚 Swagger Docs: http://localhost:${PORT}/api-docs`);
  }
  
  // Test database connection
  testConnection();
});
