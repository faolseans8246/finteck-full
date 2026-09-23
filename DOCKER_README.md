# 🏦 FinTech Platform - Docker Setup Guide

Ushbu ko'rsatma platformani Docker orqali ishga tushirish uchun mo'ljallangan.

## 📋 Talablar

Kompyuteringizda quyidagilar o'rnatilgan bo'lishi kerak:
- **Docker** (21.0.0 yoki undan yangi)
- **Docker Compose** (2.0.0 yoki undan yangi)

### Docker o'rnatish
- **Linux**: https://docs.docker.com/install/
- **macOS**: Docker Desktop o'rnatish
- **Windows**: Docker Desktop o'rnatish

## 🚀 Ishga tushirish

### 1. Repository yuklab olish yoki ishchi papka ochish

```bash
cd /home/faolseans/Memory/MVP/FinTech/Platforma
```

### 2. Docker konteynerlarni ishga tushirish

```bash
docker-compose up --build
```

**Birinchi marta bu 5-10 daqiqani olishi mumkin** (backend va frontend yaratilishi kerak).

Quyidagi xabar ko'rsatilishi kerak:
```
fintech_postgres is healthy
fintech_backend is up and running
fintech_frontend is up and running
```

### 3. Platformaga kirish

Brauzeringizda quyidagi URL-larni oching:

| Xizmat | URL | Tavsif |
|--------|-----|--------|
| **Frontend** | http://localhost:3000 | Asosiy foydalanuvchi interfeysi |
| **Backend API** | http://localhost:2027 | REST API |
| **Swagger UI** | http://localhost:2027/swagger-ui.html | API dokumentatsiyasi |
| **Database** | localhost:5432 | PostgreSQL (dasturiy kirish) |

## 🔐 Kirish Ma'lumotlari

### Admin (Programmist)
```
Login: Login
Parol: Parol
```

### Test Foydalanuvchisi
Platformada ro'yxatdan o'ting.

## 🛠️ Foydalanuvchi Komandalar

### Konteynerlarni to'xtatish

```bash
docker-compose down
```

### Barcha ma'lumotlarni o'chirish va qayta boshlash

```bash
docker-compose down -v
docker-compose up --build
```

### Faqat bitta xizmanni qayta boshlash

```bash
docker-compose restart backend
docker-compose restart frontend
```

### Loglarni ko'rish

```bash
# Barcha loglar
docker-compose logs

# Faqat backend loglari
docker-compose logs backend

# Faqat frontend loglari
docker-compose logs frontend

# Faqat bazaning loglari
docker-compose logs postgres

# Real-time kuzatish
docker-compose logs -f
```

### Konteynerning ichiga kirish (debug uchun)

```bash
# Backend (Spring Boot)
docker-compose exec backend sh

# Frontend (Nginx)
docker-compose exec frontend sh

# Database (PostgreSQL)
docker-compose exec postgres psql -U fintech_user -d fintech_db
```

## 📊 Xitma-xitlik

### Frontend
- **Port**: 3000
- **Qayta tayyorlash**: 3 soniyada bir bor (health check)
- **Nginx** orqali statik fayllarni taqdim etadi
- **Proxy**: API so'rovlarini backend ga yo'naltiradi

### Backend
- **Port**: 2027
- **Texnologiya**: Spring Boot 4.0.7 + Java 21
- **Qayta tayyorlash**: 40 soniyadan keyin
- **Health Check**: Swagger UI orqali tekshiriladi

### Database
- **Port**: 5432
- **Sistema**: PostgreSQL 18 (Alpine)
- **Ma'lumotlar konteyneri**: `postgres_data` (uzluksiz saqlanadi)
- **Parol**: FinTeck-123

## 🔧 Muhim Fayl va Struktura

```
Platforma/
├── docker-compose.yml          # Barcha xizmalarni uyushtiruvchi
├── Main_Back_End/
│   ├── Dockerfile             # Backend build instructions
│   ├── .dockerignore          # Exclude kerak bo'lmagan fayllar
│   ├── build.gradle           # Java dependency manager
│   └── src/                   # Source code
├── browser-platform/
│   ├── Dockerfile             # Frontend build instructions
│   ├── nginx.conf             # Nginx konfiguratsiyasi
│   ├── .dockerignore          # Exclude kerak bo'lmagan fayllar
│   ├── package.json           # Node.js dependencies
│   └── src/                   # React source code
└── README.md                  # Bu fayl
```

## 🐛 Muammolarni hal qilish

### Konteynerlar ishga tushmayapti?

```bash
# Barcha konteynerlarni to'xtatish va qayta tizish
docker-compose down
docker system prune -a
docker-compose up --build
```

### Port allaqachon band?

```bash
# 3000 portini anjam beruvchi jarayonni topish
lsof -i :3000
sudo kill -9 <PID>

# 2027 portini anjam beruvchi jarayonni topish
lsof -i :2027
sudo kill -9 <PID>

# 5432 portini anjam beruvchi jarayonni topish
lsof -i :5432
sudo kill -9 <PID>
```

### Database ulanmayapti?

```bash
# Database konteynerini qayta boshlash
docker-compose restart postgres

# Logs ni tekshirish
docker-compose logs postgres
```

### Frontend API bilan bog'lana olmayapti?

```bash
# Backend logs ni tekshirish
docker-compose logs backend

# Nginx logs ni tekshirish
docker-compose logs frontend

# Backend ishlayotganini tekshirish
curl http://localhost:2027/swagger-ui.html
```

## 📝 Atrof-muhit O'zgaruvchilari

`docker-compose.yml` fayligida o'zgaruvchanlar:

```yaml
# Backend Database
DB_HOST: postgres (Docker ichida host nomi)
DB_PORT: 5432
DB_NAME: fintech_db
DB_USERNAME: fintech_user
DB_PASSWORD: FinTeck-123

# JWT
JWT_SECRET: (long secret key)
JWT_EXPIRATION: 86400000 (24 soat ms da)

# Frontend
REACT_APP_API_BASE_URL: http://localhost:2027/api
```

## 🔒 Tahlukasizlik

Ishlab chiqarish (Production) uchun:
1. JWT_SECRET va parollarni o'zgartiring
2. CORS origin-larni belgilangan domenga cheklang
3. HTTPS SSL sertifikatlarini o'rnatish
4. Database backup va recovery planini qo'ying
5. Firewall sozlamalarini tekshiring

## 📞 Qo'shimcha Ma'lumot

- **Backend API Docs**: http://localhost:2027/swagger-ui.html
- **Frontend**: http://localhost:3000
- **Database**: postgresql://fintech_user:FinTeck-123@localhost:5432/fintech_db

## ✅ Muvaffaqiyat Belgisi

Platform muvaffaqiyatli ishga tushdi agar:
- ✅ Frontend http://localhost:3000 da ochilsa
- ✅ Swagger UI http://localhost:2027/swagger-ui.html da ko'rinsa
- ✅ Login/Register toimsa va jadvallari o'zgarsa

Enjoy! 🎉
