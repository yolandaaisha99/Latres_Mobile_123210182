# NontonSkuy! - Latihan Responsi Mobile IF-B

Aplikasi nonton series/show TV berbasis Flutter yang menggunakan data dari TVMaze API.

## Fitur

- ✅ **Login Page** — Input username & password, disimpan di SharedPreferences
- ✅ **Home Page** — Grid daftar shows dari TVMaze API dengan infinite scroll & search
- ✅ **Detail Page** — Info lengkap show (gambar, judul, rating, genre, summary)
- ✅ **Favorite Page** — Daftar favorit menggunakan Hive, bisa dihapus
- ✅ **Profile Page** — Tampilkan username, kesan & pesan, tombol logout
- ✅ **BottomNavigationBar** — Navigasi antara Home, Favorit, Profil
- ✅ **Loading Indicator** — Shimmer saat fetch data
- ✅ **Service terpisah dari UI** — `TvMazeService`, `FavoriteService`, `AuthService`

## Struktur Proyek

```
lib/
├── main.dart                  # Entry point
├── models/
│   ├── tv_show.dart           # Model TvShow
│   └── tv_show.g.dart         # Hive adapter (generated)
├── services/
│   ├── tv_maze_service.dart   # Fetch data dari TVMaze API
│   ├── favorite_service.dart  # CRUD favorit dengan Hive
│   └── auth_service.dart      # Login/logout dengan SharedPreferences
├── pages/
│   ├── login_page.dart        # Halaman login
│   ├── main_page.dart         # Wrapper BottomNavigationBar
│   ├── home_page.dart         # Daftar shows (grid)
│   ├── detail_page.dart       # Detail show
│   ├── favorite_page.dart     # Daftar favorit
│   └── profile_page.dart      # Profil user
└── widgets/
    ├── app_theme.dart          # Theme & warna aplikasi
    └── show_card.dart          # Komponen card show
```

## API Endpoints

| Endpoint | Keterangan |
|----------|-----------|
| `GET /shows?page=0` | Daftar semua shows (paginasi) |
| `GET /shows/{id}` | Detail satu show |
| `GET /search/shows?q={query}` | Pencarian show |

## Setup & Instalasi

### 1. Clone atau copy project ini

### 2. Install dependencies
```bash
flutter pub get
```

### 3. (Opsional) Regenerate Hive adapter
File `tv_show.g.dart` sudah disertakan. Jika ingin regenerate:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Jalankan aplikasi
```bash
flutter run
```

## Dependencies

```yaml
dependencies:
  http: ^1.2.0               # HTTP client untuk API
  shared_preferences: ^2.2.2  # Simpan sesi login
  hive: ^2.2.3               # Database lokal untuk favorit
  hive_flutter: ^1.1.0       # Integrasi Hive dengan Flutter
  cached_network_image: ^3.3.1 # Cache gambar
  flutter_html: ^3.0.0       # Render HTML summary
  google_fonts: ^6.1.0       # Font Poppins
  shimmer: ^3.0.0            # Loading skeleton
```

## Catatan

- Login menggunakan input bebas (username & password tidak boleh kosong)
- Session disimpan di SharedPreferences, akan tetap login meski app ditutup
- Favorit disimpan di Hive (persisten)
- Data API tidak wajib disimpan lokal — langsung di-parse dari JSON
- Infinite scroll pada Home Page untuk load lebih banyak show

## Pengumpulan

Upload ke GitHub dengan nama repo: `Latres_Mobile_[NIM]`
