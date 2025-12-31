# Creme 

A modern web application for Cream Bakery, built with Angular (frontend) and Express with TypeScript (backend).

## Project Overview

- **Project Name**: Creme
- **Domain**: creme.ge
- **Purpose**: Bakery website (currently static, database integration planned for future)

## Tech Stack

### Frontend
- **Framework**: Angular 20.1.0
- **Language**: TypeScript
- **Styling**: SCSS
- **Build Tool**: Angular CLI

### Backend (Planned)
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: None (static for now), PostgreSQL (future)

### DevOps (Planned)
- **CI/CD**: GitHub Actions
- **Domain**: creme.ge

## Project Structure

```
creme/
├── src/                    # Angular frontend source
│   ├── app/               # Application components
│   ├── styles.scss        # Global styles
│   └── main.ts           # Application entry point
├── public/                # Static assets
├── angular.json           # Angular configuration
├── package.json           # Dependencies
└── tsconfig.json          # TypeScript configuration
```

## Development Workflow

### Current Status
- ✅ Angular 20.1.0 project initialized
- ⏳ Frontend structure (to be built)
- ⏳ Backend API (to be built)
- ⏳ CI/CD pipeline (to be built)

### Development Rules
1. **Small Scopes**: Each step should be small and focused
2. **Code Review**: All code changes must be reviewed before implementation
3. **Documentation**: README should be updated with each significant change
4. **Step-by-Step**: Never implement large changes in one step

## Getting Started

### Prerequisites
- Node.js (v18 or higher)
- npm or yarn

### Installation
```bash
npm install
```

### Development Server
```bash
npm start
# or
ng serve
```

Navigate to `http://localhost:4200/`

### Build
```bash
npm run build
```

## Project Structure

```
creme/
├── src/                    # Angular frontend
├── backend/                # Express + TypeScript API
│   ├── src/
│   ├── database/
│   └── uploads/
├── .github/workflows/      # CI/CD pipelines
└── DEPLOYMENT.md          # Complete deployment guide
```

## Quick Start

### Frontend (Angular)
```bash
npm install
npm start
# Open http://localhost:4200
```

### Backend (Express)
```bash
cd backend
npm install
cp env.example .env
# Edit .env with your database credentials
npm run dev
# API runs on http://localhost:3000
```

## Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for complete step-by-step VPS deployment guide.

## API Endpoints

- `GET /api/health` - Health check
- `GET /api/background-image` - Get background image URL
- `POST /api/background-image` - Upload new background image

See [backend/README.md](./backend/README.md) for API documentation.

## Notes

- Design will be provided via Figma (pending)
- Currently using static data (no database required)
- All code changes should be reviewed and approved before implementation
