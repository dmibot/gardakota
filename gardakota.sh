#!/bin/bash

echo "🚀 Memulai instalasi struktur GARDA KOTA IDAMAN..."

# 1. Membuat Folder
mkdir -p css assets/img modul/aksi modul/peta modul/admin

# 2. Membuat file CSS Global (Seragam & Mobile Friendly)
cat << 'EOF' > css/style.css
:root {
    --primary: #2e7d32; /* Hijau Logo */
    --accent: #d32f2f;  /* Merah Logo */
    --light: #f4f7f6;
    --white: #ffffff;
}
body { font-family: 'Segoe UI', Roboto, sans-serif; margin: 0; background: var(--light); padding-bottom: 70px; }
.app-bar { background: var(--primary); color: white; padding: 15px; text-align: center; font-weight: bold; position: sticky; top: 0; z-index: 1000; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 12px; padding: 15px; margin-bottom: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
.btn { background: var(--primary); color: white; border: none; padding: 15px; border-radius: 30px; width: 100%; font-weight: bold; cursor: pointer; display: block; text-align: center; text-decoration: none; box-sizing: border-box; }
.bottom-nav { position: fixed; bottom: 0; width: 100%; background: white; display: flex; border-top: 1px solid #eee; padding: 10px 0; z-index: 1000; }
.nav-item { flex: 1; text-align: center; font-size: 11px; color: #888; text-decoration: none; }
.nav-item.active { color: var(--primary); font-weight: bold; }
EOF

# 3. Membuat manifest.json (Agar bisa di-install di HP)
cat << 'EOF' > manifest.json
{
  "name": "GARDA DUMAI KOTA",
  "short_name": "GardaKota",
  "start_url": "/index.html",
  "display": "standalone",
  "background_color": "#2e7d32",
  "theme_color": "#2e7d32",
  "icons": [
    {
      "src": "assets/img/garda-dumaikota.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
EOF

# 4. Membuat sw.js (Service Worker)
cat << 'EOF' > sw.js
const CACHE_NAME = 'garda-kota-v1';
const assets = ['/', '/index.html', '/css/style.css', '/assets/img/garda-dumaikota.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(assets)));
});

self.addEventListener('fetch', e => {
  e.respondWith(caches.match(e.request).then(res => res || fetch(e.request)));
});
EOF

# 5. Membuat index.html (Dashboard + Registrasi PWA)
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Garda Dumai Kota</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="manifest" href="manifest.json">
</head>
<body>
    <div class="app-bar">🛡️ GARDA DUMAI KOTA</div>
    <div class="container">
        <div class="card" style="background: linear-gradient(135deg, #1e3c72, #2a5298); color:white;">
            <small>Kondisi Cuaca Dumai</small>
            <h3 id="txt-cuaca">29°C - Cerah Berawan</h3>
        </div>
        <div style="display:flex; gap:10px; margin-bottom:15px;">
            <div class="card" style="flex:1; text-align:center; margin-bottom:0;"><h2 style="color:#f39c12; margin:0">12</h2><small>PROSES</small></div>
            <div class="card" style="flex:1; text-align:center; margin-bottom:0;"><h2 style="color:#2ecc71; margin:0">142</h2><small>SELESAI</small></div>
        </div>
        <a href="modul/aksi/index.html" class="btn">📝 BUAT LAPORAN BARU</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active">🏠<br>Home</a>
        <a href="modul/peta/index.html" class="nav-item">📍<br>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item">⚡<br>Aksi</a>
        <a href="modul/admin/login.html" class="nav-item">👤<br>Admin</a>
    </nav>
    <script>
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('/sw.js');
        }
    </script>
</body>
</html>
EOF

echo "✅ SELESAI! Struktur aplikasi GARDA KOTA sudah siap."
echo "💡 Jangan lupa masukkan file logo Bapak ke folder: assets/img/garda-dumaikota.png"