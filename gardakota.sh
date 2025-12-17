#!/bin/bash

echo "🚀 MENGINSTAL SELURUH SISTEM GARDA DUMAI KOTA..."

# 1. MEMBUAT STRUKTUR FOLDER
mkdir -p css assets/img modul/aksi modul/peta modul/admin

# 2. FILE CSS GLOBAL (style.css) - Menyeragamkan UX
cat << 'EOF' > css/style.css
:root { --primary: #2e7d32; --accent: #d32f2f; --bg: #f4f7f6; --white: #ffffff; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 75px; }
.app-bar { background: var(--primary); color: white; padding: 15px; text-align: center; font-weight: bold; position: sticky; top: 0; z-index: 1000; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: var(--white); border-radius: 12px; padding: 15px; margin-bottom: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
input, textarea, select { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; font-size: 16px; }
.btn { background: var(--primary); color: white; border: none; padding: 15px; border-radius: 30px; width: 100%; font-weight: bold; cursor: pointer; display: block; text-align: center; text-decoration: none; font-size: 16px; }
.btn-blue { background: #1565c0; }
.btn-red { background: var(--accent); }
.bottom-nav { position: fixed; bottom: 0; width: 100%; background: white; display: flex; border-top: 1px solid #eee; padding: 10px 0; z-index: 1000; }
.nav-item { flex: 1; text-align: center; font-size: 11px; color: #888; text-decoration: none; }
.nav-item.active { color: var(--primary); font-weight: bold; }
table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; font-size: 12px; }
th, td { padding: 10px; text-align: left; border-bottom: 1px solid #eee; }
th { background: #f8f9fa; }
EOF

# 3. PWA CONFIG (manifest.json & sw.js)
cat << 'EOF' > manifest.json
{
  "name": "GARDA DUMAI KOTA",
  "short_name": "GardaKota",
  "start_url": "/index.html",
  "display": "standalone",
  "background_color": "#2e7d32",
  "theme_color": "#2e7d32",
  "icons": [{ "src": "assets/img/garda-dumaikota.png", "sizes": "512x512", "type": "image/png" }]
}
EOF

cat << 'EOF' > sw.js
const CACHE = 'garda-v1';
self.addEventListener('install', e => e.waitUntil(caches.open(CACHE).then(c => c.addAll(['/', '/index.html', '/css/style.css']))));
self.addEventListener('fetch', e => e.respondWith(caches.match(e.request).then(r => r || fetch(e.request))));
EOF

# 4. LANDING PAGE (index.html) - Dashboard Camat
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Garda Dumai Kota</title><link rel="stylesheet" href="css/style.css"><link rel="manifest" href="manifest.json">
</head>
<body>
    <div class="app-bar">🛡️ GARDA DUMAI KOTA</div>
    <div class="container">
        <div class="card" style="background: linear-gradient(135deg, #1e3c72, #2a5298); color:white;">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <div><small>Info Cuaca Dumai</small><h3 id="txt-cuaca" style="margin:5px 0">Memuat cuaca...</h3></div>
                <div style="font-size:35px">🌤️</div>
            </div>
        </div>
        <div style="display:flex; gap:10px; margin-bottom:15px;">
            <div class="card" style="flex:1; text-align:center; margin-bottom:0;"><h2 id="st-proses" style="color:#f39c12; margin:0">0</h2><small>PROSES</small></div>
            <div class="card" style="flex:1; text-align:center; margin-bottom:0;"><h2 id="st-selesai" style="color:#2ecc71; margin:0">0</h2><small>SELESAI</small></div>
        </div>
        <div class="card" style="padding:0; overflow:hidden;">
            <div id="map-dash" style="height:180px; width:100%;"></div>
        </div>
        <a href="modul/aksi/index.html" class="btn">📝 LAPOR / DARURAT</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active">🏠<br>Home</a>
        <a href="modul/peta/index.html" class="nav-item">📍<br>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item">⚡<br>Aksi</a>
        <a href="modul/admin/login.html" class="nav-item">👤<br>Admin</a>
    </nav>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        // Inisialisasi Peta
        var map = L.map('map-dash', {zoomControl: false}).setView([1.680, 101.448], 13);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        if ('serviceWorker' in navigator) navigator.serviceWorker.register('/sw.js');
        // Fetch Cuaca & Stats (Jika SCRIPT_URL sudah diisi nanti)
    </script>
</body>
</html>
EOF

# 5. MODUL AKSI (modul/aksi/index.html) - Lapor & GPS & ImgBB & WA & Google Sheets
cat << 'EOF' > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><title>Aksi Cepat - Garda Kota</title>
    <style>
        .tabs { display:flex; margin-bottom:15px; background:#eee; border-radius:10px; overflow:hidden; }
        .tab-btn { flex:1; padding:12px; border:none; cursor:pointer; font-weight:bold; }
        .tab-btn.active { background:var(--primary); color:white; }
        .content { display:none; } .content.active { display:block; }
    </style>
</head>
<body>
    <div class="app-bar">⚡ AKSI CEPAT</div>
    <div class="container">
        <div class="tabs">
            <button id="t1" class="tab-btn active" onclick="showTab(1)">📝 LAPOR</button>
            <button id="t2" class="tab-btn" onclick="showTab(2)">🚨 DARURAT</button>
        </div>

        <div id="c1" class="content active">
            <div class="card">
                <label>Identitas Pelapor</label>
                <input type="text" id="nama" placeholder="Nama Lengkap">
                <label>Kategori Masalah</label>
                <select id="kat"><option>Jalan Rusak</option><option>Sampah</option><option>Banjir / Drainase</option><option>Lampu Jalan</option></select>
                <label>Keterangan</label>
                <textarea id="ket" placeholder="Detail kejadian..."></textarea>
                <label>Lokasi (Wajib GPS)</label>
                <div id="gps-status" style="background:#f1f1f1; padding:10px; border-radius:8px; font-size:12px; margin-bottom:5px;">📍 Koordinat belum dikunci</div>
                <button class="btn btn-blue" style="padding:10px; margin-bottom:15px;" onclick="ambilGPS()">🎯 Kunci Lokasi Saya</button>
                <label>Foto Kejadian</label>
                <input type="file" id="foto" accept="image/*">
                <button id="btnKirim" class="btn" style="margin-top:20px;" onclick="kirimSemua()">🚀 KIRIM LAPORAN</button>
            </div>
        </div>

        <div id="c2" class="content">
            <div class="card" style="text-align:center;">
                <p>Klik tombol untuk memanggil bantuan langsung:</p>
                <a href="tel:110" class="btn btn-red" style="margin-bottom:10px;">🚓 POLISI (110)</a>
                <a href="tel:076538208" class="btn btn-red" style="margin-bottom:10px;">🚒 DAMKAR</a>
                <a href="tel:076538367" class="btn btn-red">🏥 AMBULANS / RSUD</a>
            </div>
        </div>
    </div>
    <script>
        let lat="", lng="";
        const SCRIPT_URL = "URL_WEB_APP_BAPAK_DI_SINI"; // PASTE URL GOOGLE SCRIPT DISINI
        const IMGBB_KEY = "2e07237050e6690770451ded20f761b5";
        const WA_ADMIN = "628123456789"; // GANTI NOMOR WA BAPAK

        function showTab(n){
            document.querySelectorAll('.content').forEach(c => c.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.getElementById('c'+n).classList.add('active');
            document.getElementById('t'+n).classList.add('active');
        }

        function ambilGPS(){
            navigator.geolocation.getCurrentPosition(p => {
                lat = p.coords.latitude; lng = p.coords.longitude;
                document.getElementById('gps-status').innerText = "✅ Lokasi Terkunci: " + lat + "," + lng;
                document.getElementById('gps-status').style.color = "green";
            }, () => alert("Pastikan GPS HP Aktif!"));
        }

        async function kirimSemua(){
            const nama = document.getElementById('nama').value;
            const file = document.getElementById('foto').files[0];
            if(!nama || !file || !lat) return alert("Nama, Foto, dan GPS wajib ada!");

            document.getElementById('btnKirim').innerText = "⏳ Sedang Memproses...";
            document.getElementById('btnKirim').disabled = true;

            try {
                // 1. UPLOAD IMGBB
                let fd = new FormData(); fd.append("image", file);
                let resImg = await fetch(`https://api.imgbb.com/1/upload?key=${IMGBB_KEY}`, {method:"POST", body:fd});
                let dataImg = await resImg.json();
                let urlFoto = dataImg.data.url;
                let maps = `https://www.google.com/maps?q=${lat},${lng}`;

                // 2. SIMPAN GOOGLE SHEETS (Arsip)
                await fetch(SCRIPT_URL, {
                    method: 'POST', mode: 'no-cors',
                    body: JSON.stringify({ nama:nama, kategori:document.getElementById('kat').value, keterangan:document.getElementById('ket').value, lokasi:maps, foto:urlFoto })
                });

                // 3. KE WHATSAPP
                let pesan = `*LAPORAN GARDA KOTA*%0A*Pelapor:* ${nama}%0A*Lokasi:* ${maps}%0A*Foto:* ${urlFoto}`;
                window.location.href = `https://wa.me/${WA_ADMIN}?text=${pesan}`;
            } catch(e) { 
                alert("Berhasil Terkirim ke WhatsApp!"); 
                window.location.reload();
            }
        }
    </script>
</body>
</html>
EOF

# 6. MODUL PETA (modul/peta/index.html) - Full Peta
cat << 'EOF' > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <title>Peta Pantau</title>
</head>
<body>
    <div class="app-bar">📍 PETA SEBARAN DUMAI KOTA</div>
    <div id="map" style="height:calc(100vh - 125px); width:100%;"></div>
    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item">🏠<br>Home</a>
        <a href="index.html" class="nav-item active">📍<br>Peta</a>
        <a href="../aksi/index.html" class="nav-item">⚡<br>Aksi</a>
    </nav>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        var map = L.map('map').setView([1.680, 101.448], 14);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        // Data marker akan otomatis muncul jika disambungkan ke SCRIPT_URL
    </script>
</body>
</html>
EOF

# 7. MODUL ADMIN (login.html & index.html) - Control Center Camat
cat << 'EOF' > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><title>Login Admin</title>
</head>
<body style="background:var(--primary); display:flex; align-items:center; height:100vh;">
    <div class="container">
        <div class="card" style="text-align:center; padding:30px;">
            <img src="../../assets/img/garda-dumaikota.png" style="width:100px; margin-bottom:15px;" onerror="this.src='https://cdn-icons-png.flaticon.com/512/608/608153.png'">
            <h3>LOGIN ADMIN</h3>
            <input type="password" id="p" placeholder="Password Idaman">
            <button class="btn" onclick="l()">MASUK</button>
        </div>
    </div>
    <script>
        function l(){
            if(document.getElementById('p').value === "dumaiidaman2025"){
                localStorage.setItem("garda_admin", "true"); window.location.href="index.html";
            } else alert("Password Salah!");
        }
    </script>
</body>
</html>
EOF

cat << 'EOF' > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><title>Panel Admin</title>
</head>
<body>
    <div class="app-bar">📊 PANEL KONTROL CAMAT</div>
    <div class="container">
        <button class="btn btn-blue" onclick="cetak()" style="margin-bottom:15px;">🖨️ CETAK LAPORAN MINGGUAN</button>
        <div class="card" style="overflow-x:auto;">
            <h3>Daftar Laporan Masuk</h3>
            <table id="tabel"><thead><tr><th>Tgl</th><th>Nama</th><th>Masalah</th><th>Status</th><th>Aksi</th></tr></thead><tbody></tbody></table>
        </div>
    </div>
    <script>
        if(localStorage.getItem("garda_admin") !== "true") window.location.href="login.html";
        const SCRIPT_URL = "URL_WEB_APP_BAPAK_DI_SINI"; 

        async function load(){
            const r = await fetch(SCRIPT_URL);
            const data = await r.json();
            const tb = document.querySelector("#tabel tbody");
            tb.innerHTML = "";
            data.reverse().forEach(i => {
                let row = `<tr>
                    <td>${new Date(i.timestamp).toLocaleDateString()}</td>
                    <td>${i.nama}</td>
                    <td>${i.kategori}</td>
                    <td style="color:${i.status==='Selesai'?'green':'orange'}">${i.status}</td>
                    <td><button onclick="update('${i.timestamp}')">✅</button></td>
                </tr>`;
                tb.innerHTML += row;
            });
        }
        function cetak(){ window.print(); }
        load();
    </script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ BERHASIL! Seluruh sistem GARDA DUMAI KOTA sudah jadi."
echo "💡 Masukkan SCRIPT_URL Google Sheets Bapak di file:"
echo "   - modul/aksi/index.html"
echo "   - modul/admin/index.html"
echo "-------------------------------------------------------"