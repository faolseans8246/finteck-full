# FinTech Platform - Frontend/Backend Integratsiya Qo'llanmasi

## 📋 Talqin (Overview)
Bu hujjat FinTech platformasining frontend va backend o'rtasidagi integratsiya to'liq tavsifini beradi. Hamma API endpoints, DTO strukturalari, va client-side funksiyalari to'liq dokumentlangan.

---

## ✅ 1. OTP VERIFIKATSIYA TIZIMI (COMPLETED)

### 📝 O'zgarishlar:
- **Backend**: OTP kodi 6-xonali → **5-xonali**
- **Frontend**: Input maydonlar 6 → **5**
- **Validation**: 6 xona → **5 xona**

### 🔧 Tasviri:
```
Frontend (AuthPage.jsx):
├── Email/Telefon kiritiladi
├── "Tasdiqlash kodi yuborish" bosiladi
└── 5 xonali OTP input maydonlari paydo bo'ladi

Backend (AuthServiceImpl.java):
├── generateOtp() → 10000-99999 (5 xonali)
├── OTP 5 daqiqa uchun saqlandi
└── Email/SMS orqali yuboriladi

Frontend (App.js):
├── OTP kodni 5 xona tekshirish
├── onVerifyOtp() qo'ng'iroqi
└── "Credentials" qadamiga o'tish
```

### API Endpoints:
```
POST /api/auth/register
├── Request: { email?: string, phone?: string }
└── Response: { success, data: { message, identifier } }

POST /api/auth/verify-otp
├── Request: { identifier, otpCode }  [otpCode = 5 xona]
└── Response: { success, data: { message, token } }

POST /api/auth/complete-registration
├── Request: { identifier, login, password, email?, phone? }
└── Response: { success, data: LoginResponse }
```

---

## 👤 2. USER MANAGEMENT TIZIMI (IN PROGRESS)

### 🎯 Arxitektura:

```
┌─────────────┐           ┌──────────────────┐           ┌──────────────┐
│  Frontend   │  Token    │  Backend API     │           │  Database   │
│  (React)    ├──Auth────→│  (Spring Boot)   ├──Entity──→│  (JPA)      │
│             │  Bearer   │                  │           │             │
└─────────────┘           └──────────────────┘           └──────────────┘
```

### 2.1 PROFILE BOSHQARUVI (Profile Management)

#### Backend Entities:
```java
AuthUser (Auth_base jadval):
├── username: String          // Login/Email
├── password: String          // Shifrlangan
├── email: String
├── phone: String
├── role: Roles              // USER, ADMIN, PROGRAMMIST
├── enabled: boolean         // OTP tasdiqlandi?
├── otpCode: String
├── resetCode, resetToken    // Parol tiklanishi uchun

Users (users_base jadval):
├── firstName: String
├── lastName: String
├── birthDate: LocalDate
├── address: Address         // Embedded
├── passport: Passport       // Embedded
└── authUser: AuthUser       // One-to-One FK
```

#### Frontend State Structure:
```javascript
currentUser = {
  id: UUID,
  role: 'user' | 'admin',
  username: String,
  token: JWT_TOKEN,
  firstName: String,
  lastName: String,
  avatar: String,
  profile: {
    country: String,
    city: String,
    district: String,
    street: String,
    houseNumber: String,
    birthDate: String,
    passport: {
      jshshr: String,       // Pasport raqami
      series: String,
      number: String,
      issueDate: String,
      expiryDate: String
    }
  },
  wallet: {
    cards: Card[],
    totalBalance: Number,
    primaryCardId: String
  },
  transactions: Transaction[],
  isBlocked: boolean
}
```

#### API Endpoints - User Profile:

```
1. Profil O'qish (GET):
   GET /api/users/me
   ├── Headers: Authorization: Bearer {token}
   └── Response:
       {
         "success": true,
         "data": {
           "id": "UUID",
           "username": "user@example.com",
           "firstName": "John",
           "lastName": "Doe",
           "birthDate": "1990-01-01",
           "addressDto": {
             "country": "UZB",
             "city": "Tashkent",
             "region": "",
             "district": "Chilanzar",
             "street": "Navoi",
             "houseNumber": 42
           },
           "passportDto": {
             "passportSeries": "AA",
             "passportNumber": "1234567",
             "issuedBy": "Migration Service",
             "issueDate": "2020-01-01"
           },
           "role": "USER"
         }
       }

2. Profil Yangilash (PUT):
   PUT /api/users/profile
   ├── Headers: Authorization: Bearer {token}, Content-Type: application/json
   ├── Request Body:
       {
         "firstName": "John",
         "lastName": "Doe",
         "addressDto": {
           "country": "UZB",
           "city": "Tashkent",
           "region": "",
           "district": "Chilanzar",
           "street": "Navoi",
           "houseNumber": 42
         },
         "passportDto": {
           "passportSeries": "AA",
           "passportNumber": "1234567",
           "issuedBy": "Migration Service",
           "issueDate": "2020-01-01"
         },
         "birthDateDto": "1990-01-01"
       }
   └── Response: { success, data: ProfileResponse }
```

#### Frontend Implementation (App.js):
```javascript
const handleProfileUpdate = async (profileData) => {
  if (!currentUser || !token) return;

  const payload = {
    firstName: profileData.firstName || '',
    lastName: profileData.lastName || '',
    addressDto: {
      country: profileData.country || '',
      city: profileData.city || '',
      region: '', // TODO: Frontend dan qo'shish kerak
      district: profileData.district || '',
      street: profileData.street || '',
      houseNumber: parseInt(profileData.houseNumber) || 0,
    },
    passportDto: {
      passportSeries: profileData.passportSeries || '',
      passportNumber: profileData.passportNumber || '',
      issuedBy: '', // TODO: Frontend dan qo'shish kerak
      issueDate: profileData.issueDate || '',
    },
    birthDateDto: profileData.birthDate || null,
  };

  const response = await fetch('/api/users/profile', {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify(payload),
  });

  const result = await response.json();

  if (result.success) {
    setMessage(`✓ Profil muvaffaqiyatli yangilandi`);
    // Frontend state ni yangilash
    syncUserState({
      ...currentUser,
      firstName: profileData.firstName,
      lastName: profileData.lastName,
      // ... boshqa maydonlar
    });
  } else {
    setMessage(`✗ Xatolik: ${result.message}`);
  }
};
```

### 2.2 KARTA BOSHQARUVI (Card Management) - KERAK

**Status**: ⚠️ Hozirda Backend API yo'q, Frontend placeholder mavjud

#### Kerak bo'lgan Endpoints:
```
1. Kartalar Ro'yxati (GET):
   GET /api/cards
   ├── Headers: Authorization: Bearer {token}
   └── Response: { success, data: Card[] }

2. Karta Qo'shish (POST):
   POST /api/cards
   ├── Request: { scheme, type, label, currency }
   └── Response: { success, data: Card }

3. Karta Bloklash (PUT):
   PUT /api/cards/{id}/lock
   └── Response: { success, data: Card }

4. Asosiy Karta (PUT):
   PUT /api/cards/{id}/primary
   └── Response: { success, data: Card }
```

### 2.3 TRANSFER VA TO'LOV (Transfers & Payments) - KERAK

**Status**: ⚠️ Hozirda Backend API yo'q, Frontend placeholder mavjud

#### Kerak bo'lgan Endpoints:
```
1. Transfer Qilish (POST):
   POST /api/transfers
   ├── Request: { sourceCardId, targetCardId, amount, currency }
   └── Response: { success, data: Transaction }

2. To'lov (POST):
   POST /api/payments
   ├── Request: { cardId, amount, title, beneficiary }
   └── Response: { success, data: Transaction }

3. Operatsiyalar Tarixi (GET):
   GET /api/transactions
   └── Response: { success, data: Transaction[] }
```

---

## 🔐 3. AUTENTIFIKATSIYA VA AVTORIZATSIYA

### Login Flow:
```
1. Frontend: login + password yuboradi (POST /api/auth/login)
2. Backend: Tekshirish va JWT token qaytaradi
3. Frontend: Token localStorage saqlaydi
4. Frontend: Har bir requestda Authorization header ga qo'shadi
```

### Token Management:
```javascript
// Token saqlash (localStorage):
localStorage.setItem('fintech_token', token);
localStorage.setItem('fintech_user', JSON.stringify(user));

// Token kiritish (API headers):
headers: {
  'Content-Type': 'application/json',
  'Authorization': `Bearer ${token}`,
}

// Session yuklanishi (App mount):
React.useEffect(() => {
  const storedToken = localStorage.getItem('fintech_token');
  const storedUser = localStorage.getItem('fintech_user');
  if (storedToken && storedUser) {
    setToken(storedToken);
    setCurrentUser(JSON.parse(storedUser));
  }
}, []);
```

---

## 🚀 4. JORIY MASALALAR VA TAVSIYALAR

### ⚠️ Frontend Tavsiyalar:
1. **Region maydonini qo'shish** - Address formda "Region" kerak
2. **IssuedBy qo'shish** - Pasport "Tasnif qilgan" maydonini qo'shish
3. **Expiry Date qo'shish** - Passpport yaroqlilik muddati

### ⚠️ Backend Tavsiyalar:
1. **Card API yaratish** - `/api/cards` endpoints
2. **Transaction API yaratish** - `/api/transfers`, `/api/payments`
3. **Admin qo'ng'iroqlari** - User boshqarish uchun admin endpoints
4. **Xatolar bilan ishlash** - Validator exceptions to'g'ri qaytarish

### ✅ Bajarilgan:
- [x] OTP tizimi 5 xonaga o'zgartirildi
- [x] Profile update API integratsiyasi (frontend)
- [x] User state sync

### 🔄 Keyingi Qadamlar:
- [ ] Card CRUD API (backend)
- [ ] Transfer/Payment API (backend)
- [ ] Admin control panel
- [ ] Transaction history
- [ ] Notifications system

---

## 📚 REFERENSLAR

### Backend Controllers:
- `/src/main/java/com/example/main_back_end/controller/AuthController.java`
- `/src/main/java/com/example/main_back_end/controller/UserController.java`
- `/src/main/java/com/example/main_back_end/controller/CardController.java` (bo'sh)

### Frontend Components:
- `browser-platform/src/App.js` - Main state & logic
- `browser-platform/src/components/AuthPage.jsx` - Auth flows
- `browser-platform/src/components/UserDashboard.jsx` - User UI

### Services & DTOs:
- Backend: `AuthService`, `UserProfileService`
- Frontend: `api.js` - API utilities
