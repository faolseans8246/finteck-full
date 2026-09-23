# 🚀 FinTech Platform - Tez Boshlash (Quick Start)

## ⚡ 30 Soniya ichida Ishga Tushirish

### Linux/macOS:
```bash
cd /home/faolseans/Memory/MVP/FinTech/Platforma
chmod +x start.sh
./start.sh start
```

### Windows:
```bash
cd C:\path\to\Platforma
start.bat start
```

### Docker Compose (Barcha Platformalar):
```bash
cd /home/faolseans/Memory/MVP/FinTech/Platforma
docker-compose up --build
```

## 🌐 Brauzerda Oching

| Xizmat | URL | Nomi |
|--------|-----|------|
| 🎨 Frontend | http://localhost:3000 | Web App |
| 🔌 API | http://localhost:2027 | REST API |
| 📚 Docs | http://localhost:2027/swagger-ui.html | Swagger UI |
| 💾 Database | localhost:5432 | PostgreSQL |

## 🔐 Kirish Ma'lumotlari

**Admin (Programmist):**
- Login: `Login`
- Parol: `Parol`

**Yangi Foydalanuvchi:**
- Platformada "@" va "1234" bilan ro'yxatdan o'ting

## 🛑 To'xtatish

```bash
# Linux/macOS:
./start.sh stop

# Windows:
start.bat stop

# Barcha Platformalar:
docker-compose down
```

## ❓ Muammog'lar?

```bash
# Loglarni ko'rish
docker-compose logs -f

# Qayta boshlash
docker-compose down && docker-compose up --build
```

---

📖 **Ko'proq ma'lumot uchun**: [DOCKER_README.md](DOCKER_README.md)
