#!/bin/bash

# URL SAKTI BAPAK
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "🛠️ MEMPERBAIKI UX DASHBOARD (STABILITAS & KEJELASAN)..."

cat << EOF > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Kota</title>
    <style>
        /* Perbaikan UX: Kontras & Navigasi */
        body { background: #f4f7f6; margin: 0; padding-bottom: 80px; }
        .app-header { 
            background: #002171; 
            color: white; 
            padding: 15px; 
            display: flex; 
            align-items: center; 
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .container { padding: 10px; }
        .card { 
            background: white; 
            border-radius: 12px; 
            padding: 15px; 
            margin-bottom: 12px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); 
        }
        /* Widget Cuaca & Gempa: Jelas & Tegas */
        .info-box { display: flex; gap: 10px; margin-bottom: 12px; }
        .weather-box { 
            flex: 1; 
            background: #0d47a1; 
            color: white; 
            padding: 12px; 
            border-radius: 12px; 
            text-align: center; 
        }
        .gempa-box { 
            flex: 1; 
            background: #ff9800; 
            color: white; 
            padding: 12px; 
            border-radius: 12px; 
            text-align: center;
            font-size: 11px;
        }
        /* Statistik */
        .stat-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .stat-item { padding: 15px; text-align: center; border-radius: 12px; background: white; border-bottom: 4px solid #ddd; }
        /* Tombol SOS: Besar & Jelas */
        .btn-sos-big { 
            background: #d32f2f; 
            color: white; 
            display: block; 
            text-align: center; 
            padding: 20px; 
            border-radius: 15px; 
            font-weight: bold; 
            text-decoration: none;
            font-size: 18px;
            margin-top: 10px;
        }
    </style>
</head>
<body>

    <div class="app-header">
        <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png" width="35">
        <div style="text-align: center;">
            <div style="font-size: 10px;">PEMERINTAH KOTA DUMAI</div>
            <div style="font-size: 16px; font-weight: bold;">GARDA DUMAI KOTA</div>
        </div>
        <a href="modul/admin/login.html" style="color:white;"><i class="fas fa-user-shield"></i></a>
    </div>

    <div id="marquee-perintah" style="background:#ffeb3b; padding:8px; font-weight:bold; font-size:12px;">
        <marquee>Memuat informasi komando...</marquee>
    </div>

    <div class="container">
        <div class="info-box">
            <div class="weather-box">
                <div style="font-size: 10px;">CUACA DUMAI</div>
                <div id="w-temp" style="font-size: 24px; font-weight: bold;">--°C</div>
                <div id="w-desc" style="font-size: 10px; text-transform: uppercase;">--</div>
            </div>
            <div class="gempa-box">
                <div style="font-size: 10px;">GEMPA TERKINI</div>
                <div id="g-mag" style="font-size: 20px; font-weight: bold;">--</div>
                <div id="g-loc" style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">--</div>
            </div>
        </div>

        <div class="stat-grid">
            <div class="stat-item" style="border-color: #ff9800;">
                <div style="font-size: 10px; color: #666;">PROSES</div>
                <div id="st-proses" style="font-size: 24px; font-weight: bold;">0</div>
            </div>
            <div class="stat-item" style="border-color: #4caf50;">
                <div style="font-size: 10px; color: #666;">SELESAI</div>
                <div id="st-selesai" style="font-size: 24px; font-weight: bold;">0</div>
            </div>
        </div>

        <a href="modul/aksi/index.html" class="btn-sos-big">
            <i class="fas fa-bolt"></i> AKSI & DARURAT
        </a>

        <div class="card" style="margin-top:15px; background: #e3f2fd;">
            <i class="fas fa-info-circle"></i> <small>Gunakan tombol navigasi di bawah untuk pindah menu.</small>
        </div>
    </div>

    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-home"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-circle-exclamation"></i>Aksi</a>
        <a href="modul/operator/index.html" class="nav-item"><i class="fas fa-edit"></i>Lapor</a>
    </nav>

    <script>
        const API = "$URL_SAKTI";
        async function loadDash() {
            try {
                const r = await fetch(API);
                const d = await r.json();
                document.getElementById('st-proses').innerText = d.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
                document.getElementById('st-selesai').innerText = d.laporan.filter(i => i[6] === 'Selesai').length;
                if(d.info) document.querySelector('marquee').innerText = "📢 " + d.info[0][1];

                // BMKG & Weather
                const wR = await fetch('https://api.openweathermap.org/data/2.5/weather?q=Dumai,ID&units=metric&appid=99db324317112028688849b3803029f6');
                const wD = await wR.json();
                document.getElementById('w-temp').innerText = Math.round(wD.main.temp) + "°C";
                document.getElementById('w-desc').innerText = wD.weather[0].description;

                const gR = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
                const gD = await gR.json();
                document.getElementById('g-mag').innerText = gD.Infogempa.gempa.Magnitude + " SR";
                document.getElementById('g-loc').innerText = gD.Infogempa.gempa.Wilayah;
            } catch(e) {}
        }
        loadDash();
        setInterval(loadDash, 30000);
    </script>
</body>
</html>
EOF

echo "✅ DASHBOARD FIX: UX DIBERSIHKAN, NAVIGASI STABIL."