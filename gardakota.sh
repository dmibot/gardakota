#!/bin/bash

# CONFIG DATA (Sesuai Instruksi Bapak)
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMG_LOGO="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png"
WA_CAMAT="6285172206884"

echo "🧹 Membersihkan dan Membangun Ulang Seluruh Modul..."

# 1. REBUILD FOLDER STRUCTURE
rm -rf modul css js
mkdir -p css modul/admin modul/aksi modul/operator modul/peta

# 2. MASTER CSS (Satu aturan untuk semua modul)
cat << 'EOF' > css/style.css
:root { --primary: #0066FF; --dark: #001a4d; --bg: #f4f7f6; --h: 60px; --nav: 70px; }
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-top: var(--h); padding-bottom: var(--nav); }

/* HEADER GLOBAL */
.app-header { 
    height: var(--h); background: var(--dark); color: white; 
    display: flex; align-items: center; justify-content: space-between; 
    padding: 0 15px; position: fixed; top: 0; width: 100%; z-index: 2000; 
}
.app-header h1 { font-size: 14px; margin: 0; flex: 1; text-align: center; font-weight: 800; }
.header-btn { width: 40px; color: white; text-decoration: none; font-size: 20px; display: flex; align-items: center; justify-content: center; }

/* CONTAINER & CARD */
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 12px; padding: 15px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }

/* BUTTONS */
.btn-main { height: 48px; display: flex; align-items: center; justify-content: center; background: var(--primary); color: white; border: none; border-radius: 10px; width: 100%; font-weight: 700; text-decoration: none; cursor: pointer; border: none; }

/* NAVIGASI BAWAH */
.bottom-nav { height: var(--nav); position: fixed; bottom: 0; width: 100%; background: white; display: flex; border-top: 1px solid #eee; z-index: 2000; }
.nav-item { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #aaa; text-decoration: none; font-size: 10px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
.nav-item i { font-size: 22px; margin-bottom: 3px; }

input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; }
EOF

# 3. DASHBOARD UTAMA (index.html)
cat << EOF > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Kota</title>
</head>
<body>
    <div class="app-header">
        <div class="header-btn"></div>
        <h1>GARDA DUMAI KOTA</h1>
        <a href="modul/admin/login.html" class="header-btn"><i class="fas fa-user-shield"></i></a>
    </div>
    <div class="container">
        <div class="card" style="background: var(--dark); color: white; text-align: center;">
            <img src="$IMG_LOGO" width="60" style="margin-bottom: 10px;">
            <div id="msg-pengumuman" style="font-size: 13px; font-weight: 500;">Memuat Info...</div>
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
            <div class="card" style="margin:0;"><small>GEMPA</small><h3 id="g-mag">--</h3><div id="g-loc" style="font-size:9px;">...</div></div>
            <div class="card" style="margin:0;"><small>CUACA</small><h3 id="w-temp">--°C</h3><div id="w-desc" style="font-size:9px;">...</div></div>
        </div>
        <a href="modul/aksi/index.html" class="btn-main" style="background: #d32f2f; margin-top: 15px;"><i class="fas fa-bolt"></i>&nbsp; SOS DARURAT</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-house"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-circle-exclamation"></i>Darurat</a>
        <a href="modul/operator/index.html" class="nav-item"><i class="fas fa-plus-circle"></i>Lapor</a>
    </nav>
    <script>
        async function load() {
            try {
                const g = await (await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json')).json();
                document.getElementById('g-mag').innerText = g.Infogempa.gempa.Magnitude + " SR";
                document.getElementById('g-loc').innerText = g.Infogempa.gempa.Wilayah;
                const w = await (await fetch('https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=14.72.06.1001')).json();
                document.getElementById('w-temp').innerText = w.data[0].cuaca[0][0].t + "°C";
                document.getElementById('w-desc').innerText = w.data[0].cuaca[0][0].weather_desc;
                const s = await (await fetch("$URL_SAKTI")).json();
                document.getElementById('msg-pengumuman').innerText = s.info[0][1];
            } catch(e) {}
        }
        load();
    </script>
</body>
</html>
EOF

# 4. MODUL AKSI (Darurat - Anti 404)
cat << EOF > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>SOS</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-btn"><i class="fas fa-home"></i></a>
        <h1>AKSI DARURAT</h1>
        <div class="header-btn"></div>
    </div>
    <div class="container" style="text-align: center;">
        <div class="card" style="padding: 50px 20px;">
            <a href="https://wa.me/$WA_CAMAT?text=🚨 SOS DARURAT!" class="btn-main" style="background:#d32f2f; height: 120px; border-radius: 50%; width: 120px; margin: auto; font-size: 24px;">SOS</a>
        </div>
        <div class="card">
            <h4>HUBUNGI PETUGAS</h4>
            <a href="tel:112" class="btn-main" style="background:#333; margin-bottom: 10px;">PANGGIL 112</a>
            <a href="https://wa.me/$WA_CAMAT" class="btn-main" style="background:#2e7d32;">WHATSAPP CAMAT</a>
        </div>
    </div>
</body>
</html>
EOF

# 5. MODUL PETA (Anti 404)
cat << EOF > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <title>Peta</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-btn"><i class="fas fa-home"></i></a>
        <h1>PETA SEBARAN</h1>
        <div class="header-btn"></div>
    </div>
    <div id="map" style="width: 100%; height: calc(100vh - 130px);"></div>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        const map = L.map('map').setView([1.67, 101.45], 13);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        async function load() {
            const r = await fetch("$URL_SAKTI");
            const d = await r.json();
            d.laporan.forEach(i => {
                const m = i[4].match(/query=(-?\\d+\\.\\d+),(-?\\d+\\.\\d+)/);
                if(m) L.marker([m[1], m[2]]).addTo(map).bindPopup(i[2]);
            });
        }
        load();
    </script>
</body>
</html>
EOF

# 6. MODUL OPERATOR (Fix Form & GPS)
cat << EOF > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Lapor</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-btn"><i class="fas fa-home"></i></a>