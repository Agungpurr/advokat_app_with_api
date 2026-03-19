
---

````markdown
# ⚖️ Advokat App

Aplikasi mobile sederhana untuk manajemen data advokat dengan fitur CRUD (Create, Read, Update, Delete). Dibangun menggunakan Flutter dan terintegrasi dengan REST API berbasis Express JS serta database PostgreSQL.

---

## 🚀 Fitur Utama

- ✅ Tambah data advokat
- 📄 Lihat daftar advokat
- ✏️ Edit data advokat
- ❌ Hapus data advokat
- 🔗 Terintegrasi dengan REST API

---

## 🛠️ Tech Stack

### Frontend
- Flutter
- Dart

### Backend
- Express JS (Node.js)
- REST API

### Database
- PostgreSQL

---

## 📁 Struktur Project

```bash
lib/
├── data/       # Data source / API handling
├── models/     # Model data advokat
├── screens/    # UI halaman aplikasi
├── services/   # Logic untuk API
├── widgets/    # Komponen reusable
└── main.dart   # Entry point aplikasi
````

---

## ⚙️ Cara Menjalankan Project

### 1. Clone Repository

```bash
git clone https://github.com/Agungpurr/advokat_app_with_api.git
cd advokat_app_with_api
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Jalankan Aplikasi

```bash
flutter run
```

---

## 🔌 Konfigurasi API

Pastikan backend Express JS sudah berjalan dan endpoint API sudah sesuai dengan yang digunakan di folder `services/`.

Contoh:

```dart
const baseUrl = "http://localhost:3000/api";
```

---

## 📸 Screenshot

> Tambahkan screenshot aplikasi di sini biar makin menarik 👀

---

## 📌 Catatan

* Project ini merupakan aplikasi sederhana untuk pembelajaran integrasi Flutter dengan REST API.
* Belum mencakup autentikasi atau fitur kompleks lainnya.

---

## 👨‍💻 Author

**Agung Purnomo**
GitHub: [https://github.com/Agungpurr](https://github.com/Agungpurr)

---


