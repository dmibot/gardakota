#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "🚀 Memulihkan Modul Admin & Peta..."

# 1. Pastikan Folder Tersedia
mkdir -p modul/admin
mkdir -p modul/peta

# 2. Buat LOGIN ADMIN (modul/admin/login.html)
cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Login - GARDA DUMAI KOTA</title>
</head>
<body style="background:#1a1a1a; height:100vh; display:flex; justify-content:center; align-items:center; font-family:sans-serif;">
    <div style="background:#fff; padding:30px; border-radius:12px; width:300px; text-align:center;">
        <i class="fas fa-shield-alt" style="font-size:40px; color:#e74c3c;"></i>
        <h2 style="margin:15px 0;">COMMAND CENTER</h2>
        <input type="text" id="user" placeholder="Username" style="width:100%; padding:10px; margin-bottom:10px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box;">
        <input type="password" id="pass" placeholder="Password" style="width:100%; padding:10px; margin-bottom:15px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box;">
        <button onclick="auth()" style="width:100%; padding:12px; background:#e74c3c; color:white; border:none; border-radius:6px; font-weight:bold; cursor:pointer;">MASUK</button>
    </div>
    <script>
        function auth() {
            const u = document.getElementById('user').value.toLowerCase();
            const p = document.getElementById('pass').value;
            const admins = ["camat", "sekcam", "trantib", "kapolsek", "danramil"];
            const kels = ["rimbas", "sukajadi", "laksamana", "dumaikota", "bintan"];
            const roles = ["lurah", "babinsa", "bhabin", "pamong", "trantib"];
            let role = "", label = "";
            if(admins.includes(u) && p === "dksiaga") { role="admin"; label=u.toUpperCase(); }
            else {
                kels.forEach(k => roles.forEach(r => {
                    if(u === \`\${r}-\${k}\` && p === "pantaudk") { role="operator"; label=u.toUpperCase().replace("-"," "); }
                }));
            }
            if(role) {
                localStorage.setItem("role", role); localStorage.setItem("user_label", label);
                window.location.href = role === "admin" ? "index.html" : "../operator/index.html";
            } else alert("Akses Ditolak!");
        }
    </script>
</body>
</html>
EOF

# 3. Buat INDEX ADMIN / COMMAND CENTER (modul/admin/index.html)
cat << EOF > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Kota Command Center</title>
</head>
<body style="background:#f4f7f6; font-family:sans-serif; margin:0;">
    <div style="background:#1a1a1a; color:white; padding:15px 20px; display:flex; justify-content:space-between; align-items:center;">
        <h1 style="font-size:18px; margin:0;">Admin TRC | Halo, <span id="admin-nick"></span></h1>
        <button onclick="localStorage.clear(); location.href='login.html';" style="background:#c0392b; color:white; border:none; padding:8px 15px; border-radius:5px; cursor:pointer;">Keluar</button>
    </div>
    <div style="padding:20px; max-width:1200px; margin:auto;">
        <h2 style="border-bottom:3px solid #1a1a1a; padding-bottom:10px;">GARDA DUMAI KOTA COMMAND CENTER <span id="total-lap" style="float:right; background:#e74c3c; color:white; padding:2px 10px; border-radius:10px;">0</span></h2>
        <div style="background:white; border-radius:10px; overflow-x:auto; box-shadow:0 4px 10px rgba(0,0,0,0.1);">
            <table style="width:100%; border-collapse:collapse; min-width:900px;">
                <thead><tr style="background:#2c3e50; color:white; text-align:left;"><th style="padding:15px;">Waktu</th><th style="padding:15px;">Jenis</th><th style="padding:15px;">Lokasi / Wilayah</th><th style="padding:15px;">Status</th><th style="padding:15px;">Aksi</th></tr></thead>
                <tbody id="table-body"></tbody>
            </table>
        </div>
    </div>
    <script>
        const SAKTI = "$URL_SAKTI";
        document.getElementById('admin-nick').innerText = localStorage.getItem('user_label');
        async function loadLaporan() {
            const tbody = document.getElementById('table-body');
            try {
                const res = await fetch(SAKTI);
                const data = await res.json();
                const laporans = data.laporan;
                document.getElementById('total-lap').innerText = laporans.length;
                tbody.innerHTML = '';
                laporans.reverse().forEach((item, index) => {
                    const st = item[6] || 'Menunggu';
                    const stColor = st === 'Selesai' ? 'background:#d4edda;color:#155724' : (st === 'Proses' ? 'background:#fff3cd;color:#856404' : 'background:#ffdada;color:#c0392b');
                    tbody.innerHTML += \`<tr><td style="padding:15px; border-bottom:1px solid #eee;">\${item[0]}</td><td style="padding:15px; border-bottom:1px solid #eee;"><b>\${item[2]}</b><br><small>\${item[1]}</small></td><td style="padding:15px; border-bottom:1px solid #eee; color:#2e7d32; font-weight:bold;">\${item[4]}</td><td style="padding:15px; border-bottom:1px solid #eee;"><span style="padding:5px 10px; border-radius:15px; font-size:11px; font-weight:bold; \${stColor}">\${st}</span></td><td style="padding:15px; border-bottom:1px solid #eee;"><button onclick="window.open('\${item[3]}','_blank')" style="background:#3498db; color:white; border:none; padding:8px; border-radius:5px;"><i class="fas fa-map"></i></button></td></tr>\`;
                });
            } catch (e) { tbody.innerHTML = "Gagal muat data."; }
        }
        window.onload = loadLaporan;
    </script>
</body>
</html>
EOF

# 4. Buat PETA (modul/peta/index.html)
cat << EOF > modul/peta/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Peta Sebaran Laporan</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>#map { height: 100vh; width: 100%; }</style>
</head>
<body style="margin:0;">
    <div id="map"></div>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        const map = L.map('map').setView([1.68, 101.44], 13);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        async function loadMarkers() {
            try {
                const res = await fetch("$URL_SAKTI");
                const data = await res.json();
                data.laporan.forEach(item => {
                    const loc = item[3].match(/(-?\d+\.\d+),(-?\d+\.\d+)/);
                    if(loc) L.marker([loc[1], loc[2]]).addTo(map).bindPopup("<b>" + item[2] + "</b><br>" + item[4]);
                });
            } catch(e) { console.log("Gagal muat peta"); }
        }
        loadMarkers();
    </script>
</body>
</html>
EOF

echo "✅ Selesai! Folder ./modul/admin/ dan ./modul/peta/ sudah terisi kembali."