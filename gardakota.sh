#!/bin/bash

# CONFIG GAMBAR & URL
IMG_LOGO="https://raw.githubusercontent.com/gardakotaidaman-droid/gardakotaidaman.github.io/main/assets/img/garda-dumaikota.png"
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "🛠️ MEMPERBAIKI BUG LOGO, LOGIN, KEAMANAN, DAN PETA..."

# 1. PERBAIKI HALAMAN LOGIN (TAMPILAN MODERN + LOGO BENAR)
cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Garda Kota</title>
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        body { display: flex; align-items: center; justify-content: center; height: 100vh; padding: 20px; background: white; }
        .login-box { width: 100%; max-width: 400px; text-align: center; }
        input { width: 100%; padding: 15px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 12px; background: #f9f9f9; }
    </style>
</head>
<body>
    <div class="login-box">
        <img src="$IMG_LOGO" style="width:100px; margin-bottom:20px;">
        <h2 style="margin-bottom:5px;">GARDA DUMAI KOTA</h2>
        <p style="color:#666; font-size:12px; margin-bottom:30px;">Silakan login untuk akses sistem</p>

        <input type="text" id="user" placeholder="Username (misal: lurah, admin)">
        <input type="password" id="pass" placeholder="Password">
        
        <button class="btn-main" onclick="auth()">MASUK SISTEM</button>
        <div id="msg" style="margin-top:15px; font-size:12px; color:red;"></div>
    </div>

    <script>
        function auth() {
            const u = document.getElementById('user').value.toLowerCase();
            const p = document.getElementById('pass').value;
            const msg = document.getElementById('msg');

            // LOGIKA LOGIN SEDERHANA
            if(u === 'admin' && p === 'admin123') {
                localStorage.setItem("role", "admin");
                localStorage.setItem("user_label", "Admin Command Center");
                window.location.href = "index.html";
            } else if (p === 'siap86') { // Password Petugas Lapangan
                localStorage.setItem("role", "operator");
                localStorage.setItem("user_label", u.toUpperCase()); // Nama Operator diambil dari username
                window.location.href = "../operator/index.html";
            } else {
                msg.innerText = "Username atau Password Salah!";
            }
        }
    </script>
</body>
</html>
EOF

# 2. PERBAIKI MODUL OPERATOR (TAMBAH SECURITY CHECK & KEMBALIKAN FUNGSI)
cat << EOF > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lapor Kejadian</title>
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        // SECURITY CHECK: Kalau belum login, tendang ke halaman login
        if(!localStorage.getItem("role")) window.location.href = "../admin/login.html";
    </script>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-icon"><i class="fas fa-arrow-left"></i></a>
        <h1>LAPOR KEJADIAN</h1>
        <div style="width:20px;"></div>
    </div>

    <div class="container">
        <div class="card" style="text-align:center;">
            <small>Login sebagai:</small><br>
            <b id="op-name" style="font-size:16px;">...</b>
        </div>

        <div class="card">
            <div class="card-title">1. Titik Koordinat</div>
            <button class="btn-main" onclick="track()" style="background:#333; margin-bottom:10px;">
                <i class="fas fa-map-pin" style="margin-right:8px;"></i> KUNCI LOKASI GPS
            </button>
            <p id="gps-msg" style="text-align:center; font-size:12px; color:#999;">GPS wajib dikunci</p>
        </div>

        <div class="card">
            <div class="card-title">2. Data Laporan</div>
            <select id="kat" style="width:100%; padding:12px; border:1px solid #ddd; border-radius:8px; margin-bottom:10px;">
                <option>Banjir / Genangan</option>
                <option>Kebakaran</option>
                <option>Sampah Liar</option>
                <option>Jalan Rusak</option>
                <option>Gangguan Trantib</option>
                <option>Lainnya</option>
            </select>
            <textarea id="ket" placeholder="Keterangan detail..." style="width:100%; padding:12px; border:1px solid #ddd; border-radius:8px; height:100px; margin-bottom:10px;"></textarea>
            <input type="file" id="foto" capture="camera" style="margin-bottom:15px;">
            <button class="btn-main" id="btnKirim" onclick="lapor()">KIRIM SEKARANG</button>
        </div>
    </div>

    <script src="operator.js"></script>
    <script>document.getElementById('op-name').innerText = localStorage.getItem("user_label");</script>
</body>
</html>
EOF

# 3. PERBAIKI MODUL PETA (TAMBAH OPSI LAYERS: SATELIT & AWAN)
cat << EOF > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Peta Sebaran</title>
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <style>
        #map { width: 100%; height: calc(100vh - 130px); margin-top: -10px; }
        .leaflet-control-layers { border-radius: 8px !important; padding: 10px !important; }
    </style>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-icon"><i class="fas fa-arrow-left"></i></a>
        <h1>PETA SITUASI</h1>
        <div style="width:20px;"></div>
    </div>

    <div id="map"></div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        const SAKTI = "$URL_SAKTI";
        
        // 1. Definisikan Layer Peta
        const streets = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {attribution:'OSM'});
        const satelit = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {attribution:'Esri'});
        const hujan = L.tileLayer('https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=99db324317112028688849b3803029f6', {attribution:'OpenWeather'});
        const awan = L.tileLayer('https://tile.openweathermap.org/map/clouds_new/{z}/{x}/{y}.png?appid=99db324317112028688849b3803029f6', {attribution:'OpenWeather'});

        // 2. Inisialisasi Peta
        const map = L.map('map', {
            center: [1.67, 101.45], // Dumai
            zoom: 13,
            layers: [streets] // Default Layer
        });

        // 3. Tambahkan Kontrol Layer (Pojok Kanan Atas)
        const baseMaps = { "Peta Jalan": streets, "Satelit": satelit };
        const overlayMaps = { "Curah Hujan": hujan, "Tutupan Awan": awan };
        L.control.layers(baseMaps, overlayMaps).addTo(map);

        // 4. Ambil Data Laporan (Marker)
        async function loadMarkers() {
            try {
                const r = await fetch(SAKTI);
                const d = await r.json();
                d.laporan.forEach(i => {
                    // Regex ambil lat,lng
                    const m = i[4].match(/query=(-?\d+\.\d+),(-?\d+\.\d+)/); 
                    if(m) {
                        const iconColor = i[6] === 'Selesai' ? 'green' : 'red';
                        // Marker Sederhana
                        L.marker([m[1], m[2]]).addTo(map)
                         .bindPopup(\`<b>\${i[1]}</b><br>\${i[2]}<br><small>\${i[6]}</small>\`);
                    }
                });
            } catch(e) { console.log("Gagal muat marker"); }
        }
        loadMarkers();
    </script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ PERBAIKAN SELESAI"
echo "1. Logo Login sekarang menggunakan Raw URL (Pasti muncul)."
echo "2. Halaman Login sudah menggunakan Style.css (Tidak jelek)."
echo "3. Modul Operator AMAN (Wajib Login dulu)."
echo "4. Peta sekarang punya TOMBOL GANTI LAYER (Satelit/Hujan)."
echo "-------------------------------------------------------"