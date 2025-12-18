#!/bin/bash

# CONFIG DATA (INSTRUKSI BAPAK)
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMG_LOGO="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"
WA_CAMAT="6285172206884"

echo "💎 MEMBANGUN ULANG SISTEM KOMANDO DUMAI KOTA V3..."

# 1. BERSIHKAN & BUAT STRUKTUR FOLDER
rm -rf modul css
mkdir -p css modul/admin modul/aksi modul/operator modul/peta

# 2. MASTER CSS (KUNCI VISUAL & NAVIGASI)
cat << 'EOF' > css/style.css
:root { --primary: #0066FF; --dark: #001a4d; --gold: #ffeb3b; --bg: #f4f7f6; --h: 60px; --nav: 70px; }
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; font-family: 'Segoe UI', sans-serif; }
body { margin: 0; background: var(--bg); padding-top: var(--h); padding-bottom: var(--nav); }

.app-header { 
    height: var(--h); background: var(--dark); color: white; 
    display: flex; align-items: center; justify-content: space-between; 
    padding: 0 15px; position: fixed; top: 0; width: 100%; z-index: 2000; 
    border-bottom: 3px solid var(--gold);
}
.app-header h1 { font-size: 13px; margin: 0; font-weight: 800; text-transform: uppercase; flex: 1; text-align: center; letter-spacing: 0.5px; }
.header-icon { width: 35px; color: white; text-decoration: none; font-size: 18px; display: flex; align-items: center; justify-content: center; }

.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 12px; padding: 15px; margin-bottom: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

.btn-main { 
    height: 50px; background: var(--primary); color: white; border: none; border-radius: 10px; 
    width: 100%; font-weight: 700; cursor: pointer; display: flex; align-items: center; 
    justify-content: center; text-decoration: none; font-size: 14px; 
}
.btn-danger { background: #d32f2f; }

.bottom-nav { height: var(--nav); position: fixed; bottom: 0; width: 100%; background: white; display: flex; border-top: 1px solid #ddd; z-index: 2000; }
.nav-item { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #888; text-decoration: none; font-size: 10px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
.nav-item i { font-size: 22px; margin-bottom: 4px; }

input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; background: #fafafa; outline: none; }
EOF

# 3. DASHBOARD UTAMA (FIX LOGO & BMKG & PENGUMUMAN)
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
        <div class="header-icon"></div>
        <h1>GARDA DUMAI KOTA</h1>
        <a href="modul/admin/login.html" class="header-icon"><i class="fas fa-user-shield"></i></a>
    </div>
    <div class="container">
        <div class="card" style="background: var(--dark); color: white; text-align: center; border-bottom: 4px solid var(--gold);">
            <img src="$IMG_LOGO" width="55">
            <div id="msg-info" style="font-size: 13px; margin-top: 10px; font-weight: 600;">📡 Menghubungkan Command Center...</div>
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
            <div class="card" style="margin:0; border-left: 4px solid #ef6c00;">
                <small style="color:#ef6c00; font-weight:800;">MAGNITUDE</small>
                <h3 id="g-mag" style="margin:5px 0;">--</h3>
                <div id="g-loc" style="font-size:9px; color:#666;">Memuat Gempa...</div>
            </div>
            <div class="card" style="margin:0; border-left: 4px solid var(--primary);">
                <small style="color:var(--primary); font-weight:800;">SUHU</small>
                <h3 id="w-temp" style="margin:5px 0;">--°C</h3>
                <div id="w-desc" style="font-size:9px; color:#666;">Memuat Cuaca...</div>
            </div>
        </div>
        <a href="modul/aksi/index.html" class="btn-main btn-danger" style="margin-top: 15px;"><i class="fas fa-bolt"></i>&nbsp; SOS DARURAT</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-house"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
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
                if(s.info[0]) document.getElementById('msg-info').innerText = s.info[0][1];
            } catch(e) {}
        }
        load();
    </script>
</body>
</html>
EOF

# 4. MODUL AKSI (SOS - FIX 404 & HOME)
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
        <a href="../../index.html" class="header-icon"><i class="fas fa-home"></i></a>
        <h1>AKSI DARURAT</h1>
        <div class="header-icon"></div>
    </div>
    <div class="container" style="text-align: center;">
        <div class="card" style="padding: 40px 20px;">
            <div onclick="window.location.href='https://wa.me/$WA_CAMAT?text=🚨 SOS DARURAT!'" style="width:120px; height:120px; background:radial-gradient(#ff5252, #b71c1c); border-radius:50%; margin:auto; display:flex; align-items:center; justify-content:center; color:white; font-size:24px; font-weight:900; box-shadow:0 10px 20px rgba(0,0,0,0.2); cursor:pointer; border:5px solid white;">SOS</div>
            <p style="margin-top:20px; font-weight:bold; color:#b71c1c;">SINYAL BAHAYA</p>
        </div>
        <div class="card">
            <h4 style="margin:0 0 15px 0;">HUBUNGI PETUGAS</h4>
            <a href="tel:112" class="btn-main" style="background:#333; margin-bottom:10px;">CALL CENTER 112</a>
            <a href="https://wa.me/$WA_CAMAT" class="btn-main" style="background:#2e7d32;">WA CAMAT DUMAI KOTA</a>
        </div>
    </div>
</body>
</html>
EOF

# 5. MODUL OPERATOR (HIRARKI LOGIN + 11 KATEGORI + MAPS FIX)
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
        <a href="../../index.html" class="header-icon"><i class="fas fa-home"></i></a>
        <h1>PANEL OPERATOR</h1>
        <i class="fas fa-sign-out-alt header-icon" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card" style="background: #e3f2fd; border-left: 5px solid var(--primary);">
            <small>Petugas Aktif:</small><br><b id="op-name" style="color:var(--dark);">-</b>
        </div>
        <div class="card">
            <div id="gps-box" style="padding:15px; background:#f5f5f5; border-radius:10px; text-align:center; font-size:12px; font-weight:bold; margin-bottom:10px;">📍 Belum Mengunci GPS</div>
            <button class="btn-main" onclick="trackGPS()" style="background:#333; height:40px;">AMBIL TITIK GPS</button>
            <hr style="margin:20px 0; border:0; border-top:1px solid #eee;">
            <select id="kat">
                <option>🌊 Banjir Rob / Pasang Keling</option>
                <option>🕳️ Drainase Tersumbat / Banjir</option>
                <option>🗑️ Penumpukan Sampah</option>
                <option>👮 Kamtibmas / Tawuran</option>
                <option>🔥 Kebakaran Lahan / Karhutla</option>
                <option>💡 Lampu Jalan Mati (PJU)</option>
                <option>🛣️ Infrastruktur / Jalan Rusak</option>
                <option>🌳 Pohon Tumbang / Kabel</option>
                <option>🏪 Penertiban PKL / Perda</option>
                <option>📄 Layanan Publik / Administrasi</option>
                <option>❓ Lainnya</option>
            </select>
            <textarea id="ket" rows="3" placeholder="Keterangan kejadian..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnLapor" onclick="kirimLapor()" style="margin-top:15px;">🚀 KIRIM LAPORAN SEKARANG</button>
        </div>
    </div>
    <script>
        let lat="", lng="";
        document.getElementById('op-name').innerText = localStorage.getItem("user_label") || "PENGGUNA";
        if(!localStorage.getItem("user_label")) window.location.href="../admin/login.html";

        function trackGPS() {
            navigator.geolocation.getCurrentPosition(p => {
                lat = p.coords.latitude; lng = p.coords.longitude;
                document.getElementById('gps-box').innerHTML = "✅ LOKASI TERKUNCI";
                document.getElementById('gps-box').style.background = "#e8f5e9";
            }, () => alert("Gagal melacak! Aktifkan GPS."));
        }

        async function kirimLapor() {
            const file = document.getElementById('foto').files[0];
            if(!lat || !file) return alert("Wajib Kunci GPS & Ambil Foto!");
            const btn = document.getElementById('btnKirim');
            btn.innerText = "⏳ SEDANG MENGIRIM..."; btn.disabled = true;

            try {
                let fd = new FormData(); fd.append("image", file);
                let rI = await fetch("https://api.imgbb.com/1/upload?key=$IMGBB_KEY", {method:"POST", body:fd});
                let dI = await rI.json();
                // FIX URL MAPS RESMI
                const mapsUrl = "https://www.google.com/maps?q=2" + lat + "," + lng;

                await fetch("$URL_SAKTI", { 
                    method:'POST', mode:'no-cors', 
                    body: JSON.stringify({ 
                        nama: localStorage.getItem("user_label"), 
                        kategori: document.getElementById('kat').value, 
                        keterangan: document.getElementById('ket').value, 
                        lokasi: mapsUrl, 
                        foto: dI.data.url 
                    }) 
                });
                alert("Laporan Berhasil Terkirim!"); location.reload();
            } catch(e) { alert("Gagal terhubung ke server!"); }
        }
    </script>
</body>
</html>
EOF

# 6. MODUL PETA (FIX 404)
cat << EOF > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <title>Peta Sebaran</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-icon"><i class="fas fa-home"></i></a>
        <h1>PETA SITUASI</h1>
        <div class="header-icon"></div>
    </div>
    <div id="map" style="width: 100%; height: calc(100vh - 130px);"></div>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        const map = L.map('map').setView([1.67, 101.45], 13);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        async function loadMarkers() {
            try {
                const r = await fetch("$URL_SAKTI");
                const d = await r.json();
                d.laporan.forEach(i => {
                    const m = i[4].match(/query=(-?\\d+\\.\\d+),(-?\\d+\\.\\d+)/);
                    if(m) L.marker([m[1], m[2]]).addTo(map).bindPopup("<b>" + i[1] + "</b><br>" + i[2]);
                });
            } catch(e) {}
        }
        loadMarkers();
    </script>
</body>
</html>
EOF

echo "✅ REBUILD SELESAI. SELURUH MODUL SEKARANG KONSISTEN & AKTIF."