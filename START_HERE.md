# 🚀 START HERE - Creme Project

## რა შევქმენი (What I Created)

### ✅ Backend (Express + TypeScript)
- API server: `backend/src/server.ts`
- Database connection: MySQL
- 2 API endpoints:
  - `GET /api/background-image` - იღებს background image URL-ს
  - `POST /api/background-image` - ატვირთავს ახალ background image-ს
- File upload system (Multer)

### ✅ Frontend (Angular)
- Dashboard component (home page)
- Fonts configured (Libre Baskerville)
- Routing ready

### ✅ Database
- MySQL schema: `backend/database/schema.sql`
- Table: `background_images`

---

## 🎯 როგორ დავიწყოთ (How to Start)

### Step 1: Backend Setup (5 წუთი)

```bash
# 1. გადადი backend folder-ში
cd backend

# 2. დააინსტალირე dependencies
npm install

# 3. შექმენი .env ფაილი
# Windows PowerShell:
copy env.example .env

# 4. გახსენი .env და შეცვალე მხოლოდ DB_PASSWORD:
# DB_PASSWORD=თქვენი_პაროლი
```

### Step 2: Database Setup (თუ MySQL გაქვს)

```bash
# შექმენი database
mysql -u root -p
# შემდეგ MySQL-ში:
CREATE DATABASE creme_db;
CREATE USER 'creme_user'@'localhost' IDENTIFIED BY 'თქვენი_პაროლი';
GRANT ALL PRIVILEGES ON creme_db.* TO 'creme_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# Import schema
mysql -u creme_user -p creme_db < database/schema.sql
```

**თუ MySQL არ გაქვს:** გამოტოვე ეს ნაბიჯი, backend მაინც იმუშავებს (მხოლოდ database error-ს დააბრუნებს)

### Step 3: Start Backend

```bash
# backend folder-ში
npm run dev
```

**უნდა დაინახო:**
```
🚀 Server running on port 3000
```

### Step 4: Start Frontend (ახალი terminal-ში)

```bash
# Root folder-ში (creme/)
npm start
```

**უნდა გაიხსნას:** `http://localhost:4200`

---

## 🧪 როგორ შევამოწმოთ რომ მუშაობს

### Test Backend API:

1. **Browser-ში გახსენი:**
   ```
   http://localhost:3000/api/health
   ```
   უნდა დაინახო: `{"status":"ok","message":"Creme API is running"}`

2. **Background Image:**
   ```
   http://localhost:3000/api/background-image
   ```
   უნდა დაინახო: `{"imageUrl":null,"message":"No background image set"}`

### Test Frontend:
- გახსენი: `http://localhost:4200`
- უნდა დაინახო dashboard page

---

## 📁 რა ფაილები შევქმენი

```
creme/
├── backend/              ← ახალი!
│   ├── src/
│   │   ├── server.ts    ← API server
│   │   ├── config/      ← Database
│   │   ├── routes/      ← API routes
│   │   └── controllers/ ← Business logic
│   ├── database/
│   │   └── schema.sql   ← MySQL schema
│   └── package.json
│
├── src/                  ← Frontend (Angular)
│   └── app/
│       └── feature/
│           └── dashboard/
│
└── DEPLOYMENT.md         ← VPS deployment guide
```

---

## 🔗 როგორ მუშაობს ერთად

1. **Frontend (Angular)** → `localhost:4200`
   - გამოიყენებს API-ს background image-ის მისაღებად

2. **Backend (Express)** → `localhost:3000`
   - აბრუნებს background image URL-ს database-დან
   - იღებს ახალ image-ებს upload-ისთვის

3. **Database (MySQL)**
   - ინახავს image path-ებს

---

## ⚠️ თუ რამე არ მუშაობს

### Backend error?
- შეამოწმე `.env` ფაილი არსებობს
- შეამოწმე MySQL მუშაობს: `sudo systemctl status mysql`

### Frontend error?
- შეამოწმე `npm install` გაქვს გაკეთებული root folder-ში

### Port already in use?
- შეცვალე PORT backend/.env-ში: `PORT=3001`

---

## 📚 დეტალური ინფორმაცია

- **Local setup:** `QUICK_START.md`
- **Deployment:** `DEPLOYMENT.md`
- **Backend API:** `backend/README.md`

---

## ✅ შემდეგი ნაბიჯი

როცა ორივე მუშაობს:
1. Frontend-ში შევქმნათ service API-სთან დასაკავშირებლად
2. Dashboard-ში დავამატოთ background image fetch
3. მერე deployment VPS-ზე

**ახლა უბრალოდ დაიწყე backend და frontend, დაინახე რომ მუშაობს! 🚀**

