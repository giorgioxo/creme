# 📸 How Images Work in This Project

## Where Images Are Stored

### ✅ Backend Filesystem (NOT Database!)
- **Location:** `backend/uploads/` folder
- **Why:** Databases are for data, not files
- **Database stores:** Only the image path/URL

## How It Works

### 1. Upload Image (Developer/Admin)
```
POST /api/background-image
Body: image file (multipart/form-data)
```

**What happens:**
1. Image saved to: `backend/uploads/background-1234567890.jpg`
2. Path saved to database: `background-1234567890.jpg`
3. API returns: `{ imageUrl: "/uploads/background-1234567890.jpg" }`

### 2. Get Image URL (Frontend)
```
GET /api/background-image
```

**Returns:**
```json
{
  "imageUrl": "/uploads/background-1234567890.jpg"
}
```

### 3. Display Image (Frontend)
```html
<img src="http://localhost:3000/uploads/background-1234567890.jpg" />
```

---

## File Structure

```
backend/
├── uploads/              ← Images go HERE
│   └── background-*.jpg
├── src/
└── database/
    └── schema.sql       ← Only stores path, not image
```

**Database table:**
```sql
background_images
├── id
├── image_path          ← Just the filename!
└── created_at
```

---

## For Developers

### To Upload an Image:

**Option 1: Using API (Recommended)**
```bash
curl -X POST http://localhost:3000/api/background-image \
  -F "image=@/path/to/your/image.jpg"
```

**Option 2: Manual (For Testing)**
1. Put image in `backend/uploads/` folder
2. Name it: `background-test.jpg`
3. Insert into database:
   ```sql
   INSERT INTO background_images (image_path) VALUES ('background-test.jpg');
   ```

---

## Important Notes

❌ **DON'T:**
- Store images in database (too slow, too big)
- Put images in frontend folder
- Hardcode image paths

✅ **DO:**
- Store images in `backend/uploads/`
- Store only path in database
- Use API to get image URL
- Serve images via backend (`/uploads/` route)

---

## Summary

1. **Images** → `backend/uploads/` folder
2. **Database** → Only stores filename/path
3. **Frontend** → Gets URL from API, displays image

That's it! 🎯

