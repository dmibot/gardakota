#!/bin/bash

# URL SAKTI BAPAK
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "💎 MEMOLES DASHBOARD UTAMA MENJADI SITUATION ROOM..."

cat << EOF > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Garda Dumai Kota</title>
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f2f5; }
        .marquee-container { background: #d32f2f; color: white; padding: 10px; font-weight: bold; font-size: 13px; border-bottom: 3px solid #ffeb3b; }
        .app-header { background: linear-gradient(135deg, #002171 0%, #0d47a1 100%); border-bottom: 4px solid #ffeb3b; }
        .card-weather { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; border: none; box-shadow: 0 10px 20px rgba(79, 172, 254, 0.4); }
        .stat-card { text-align: center; border-bottom: 5px solid #ddd; transition: 0.3s; }
        .btn-sos { background: linear-gradient(135deg, #ff1744 0%, #b71c1c 100%); box-shadow: 0 8px 20px rgba(183, 28, 28, 0.4); border: 2px solid rgba(255,255,255,0.2); }
        .badge-live { background: #ff1744; color: white; padding: 2px 8px; border-radius: 10px; font-size: 9px; animation: blink 1s infinite; vertical-align: middle; }
        @keyframes blink { 0% { opacity: 1; } 50% { opacity: 0.3; } 100% { opacity: 1; } }
    </style>
</head>
<body>
    <div class="marquee-container">
        <marquee id="marquee-data">⚠️ SIAGA DUMAI KOTA: Memuat informasi terbaru dari Command Center...</marquee>
    </div>

    <div class="app-header">
        <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png" style="width:45px; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));">
        <div style="text-align:center;">
            <div style="font-size:10px; opacity:0.9; letter-spacing: 1px;">PEMERINTAH KOTA DUMAI</div>
            <div style="font-size:18px; font-weight:900; text-shadow: 0 2px 4px rgba(0,0,0,0.2);">GARDA DUMAI KOTA</div>
        </div>
        <div style="position:relative;">
            <i class="fas fa-bell" style="font-size:20px;"></i>
            <span style="position:absolute; top:-5px; right:-5px; background:red; width:8px; height:8px; border-radius:50%; border:2px solid white;"></span>
        </div>
    </div>

    <div class="container">
        <div class="card card-weather" style="margin-top:-20px; z-index:10; position:relative;">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <div style="font-size:12px; font-weight:bold; opacity:0.9;"><i class="fas fa-cloud-sun-rain"></i> CUACA DUMAI KOTA</div>
                    <h2 id="w-desc" style="margin:5px 0; text-transform:uppercase; font-size:20px;">MEMUAT...</h2>
                    <small id="w-update" style="font-size:10px; opacity:0.8;"></small>
                </div>
                <div style="text-align:right;">
                    <h1 id="w-temp" style="margin:0; font-size:42px; font-weight:900;">--°C</h1>
                </div>
            </div>
        </div>

        <div class="card" style="border-left:6px solid #ff9800; background: #fffde7;">
            <h4 style="margin:0; color:#e65100; font-size:14px;"><i class="fas fa-bullhorn"></i> INFO GEMPA <span class="badge-live">LIVE BMKG</span></h4>
            <div id="g-info" style="font-size:13px; font-weight:bold; margin-top:8px; color:#444;">Mencari data gempa terkini...</div>
        </div>

        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
            <div class="card stat-card" style="border-color:#f39c12;">
                <i class="fas fa-clock" style="color:#f39c12; font-size:24px; margin-bottom:8px;"></i>
                <div id="st-proses" style="font-size:28px; font-weight:900; color:#333;">0</div>
                <div style="font-size:10px; font-weight:bold; color:#f39c12;">PROSES</div>
            </div>
            <div class="card stat-card" style="border-color:#2ecc71;">
                <i class="fas fa-check-double" style="color:#2ecc71; font-size:24px; margin-bottom:8px;"></i>
                <div id="st-selesai" style="font-size:28px; font-weight:900; color:#333;">0</div>
                <div style="font-size:10px; font-weight:bold; color:#2ecc71;">DONE</div>
            </div>
        </div>

        <a href="modul/aksi/index.html" class="btn-main btn-sos" style="padding:20px;">
            <i class="fas fa-bolt"></i> AKSI CEPAT & SOS DARURAT
        </a>
    </div>

    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-house-user"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-circle-exclamation"></i>Aksi</a>
        <a href="modul/admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Admin</a>
    </nav>

    <script>
        const API = "$URL_SAKTI";

        async function init() {
            try {
                // 1. Ambil Stats & Berita Admin
                const r = await fetch(API);
                const d = await r.json();
                document.getElementById('st-proses').innerText = d.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
                document.getElementById('st-selesai').innerText = d.laporan.filter(i => i[6] === 'Selesai').length;
                
                if(d.info && d.info.length > 0) {
                    document.getElementById('marquee-data').innerText = "📢 PERINTAH CAMAT: " + d.info[0][1] + " | WASPADA PASANG KELING DI PESISIR DUMAI.";
                }

                // 2. Ambil Cuaca Dumai (OpenWeather Fallback)
                const wR = await fetch('https://api.openweathermap.org/data/2.5/weather?q=Dumai,ID&units=metric&appid=99db324317112028688849b3803029f6');
                const wD = await wR.json();
                document.getElementById('w-temp').innerText = Math.round(wD.main.temp) + "°C";
                document.getElementById('w-desc').innerText = wD.weather[0].description;
                document.getElementById('w-update').innerText = "Update: " + new Date().toLocaleTimeString();

                // 3. Ambil Gempa BMKG
                const gR = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
                const gD = await gR.json();
                const g = gD.Infogempa.gempa;
                document.getElementById('g-info').innerHTML = \`M \${g.Magnitude} - \${g.Wilayah}<br><small>\${g.Tanggal} | \${g.Jam}</small>\`;
            } catch(e) { console.log("Refresh Data..."); }
        }

        init();
        setInterval(init, 30000); // Auto refresh tiap 30 detik
    </script>
</body>
</html>
EOF

echo "💎 DASHBOARD TELAH DIPERBARUI DENGAN TAMPILAN SITUATION ROOM."