#!/bin/bash

# URL SAKTI APPS SCRIPT BAPAK
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
# URL CUACA BMKG DUMAI KOTA
URL_CUACA_BMKG="https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=14.72.06.1001"

echo "🚨 MENGAKTIFKAN DASHBOARD DENGAN API RESMI BMKG DUMAI KOTA..."

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
        body { background: #f4f7f6; margin: 0; padding-bottom: 90px; font-family: sans-serif; }
        .app-header { background: #002171; color: white; padding: 15px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 1000; border-bottom: 3px solid #ffeb3b; }
        .marquee-info { background: #ffeb3b; color: #b71c1c; padding: 8px; font-weight: bold; font-size: 12px; border-bottom: 1px solid #ddd; }
        .container { padding: 10px; }
        .card-info { display: flex; gap: 10px; margin-bottom: 15px; }
        .box { flex: 1; padding: 15px; border-radius: 12px; color: white; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: 0.5s; }
        .bg-cuaca { background: linear-gradient(135deg, #0d47a1, #1976d2); }
        .bg-gempa { background: linear-gradient(135deg, #ef6c00, #ff9800); }
        
        /* ALERT GEMPA BAHAYA */
        .bg-bahaya { background: #d32f2f !important; animation: pulse-danger 1s infinite; border: 2px solid yellow; }
        @keyframes pulse-danger {
            0% { transform: scale(1); }
            70% { transform: scale(1.02); box-shadow: 0 0 20px rgba(211, 47, 47, 0.8); }
            100% { transform: scale(1); }
        }

        .stat-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 15px; }
        .stat-item { background: white; padding: 15px; border-radius: 12px; text-align: center; border-bottom: 4px solid #ddd; }
        .btn-sos { background: #d32f2f; color: white; display: block; text-align: center; padding: 18px; border-radius: 12px; text-decoration: none; font-weight: bold; font-size: 18px; margin-top: 5px; box-shadow: 0 4px 10px rgba(211,47,47,0.3); }
    </style>
</head>
<body>

    <div class="app-header">
        <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png" width="35">
        <div style="text-align: center;">
            <div style="font-size: 9px; opacity: 0.8;">PEMERINTAH KOTA DUMAI</div>
            <div style="font-size: 16px; font-weight: bold;">GARDA DUMAI KOTA</div>
        </div>
        <a href="modul/admin/login.html" style="color:white;"><i class="fas fa-user-shield"></i></a>
    </div>

    <div class="marquee-info">
        <marquee id="msg-admin">⚠️ Menghubungkan ke API Pusat BMKG (Dumai Kota)...</marquee>
    </div>

    <div class="container">
        <div class="card-info">
            <div class="box bg-cuaca">
                <div style="font-size: 10px; font-weight: bold;">DUMAI KOTA (BMKG)</div>
                <div id="w-temp" style="font-size: 26px; font-weight: bold; margin: 5px 0;">--°C</div>
                <div id="w-desc" style="font-size: 11px; text-transform: uppercase;">MEMUAT...</div>
            </div>
            <div id="box-gempa" class="box bg-gempa">
                <div id="g-label" style="font-size: 10px; font-weight: bold;">GEMPA TERBARU</div>
                <div id="g-mag" style="font-size: 26px; font-weight: bold; margin: 5px 0;">--</div>
                <div id="g-loc" style="font-size: 10px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">MENUNGGU DATA...</div>
            </div>
        </div>

        <div class="stat-grid">
            <div class="stat-item" style="border-color: #fb8c00;">
                <div style="font-size: 10px; color: #666;">PROSES LAPORAN</div>
                <div id="st-proses" style="font-size: 28px; font-weight: bold; color: #333;">0</div>
            </div>
            <div class="stat-item" style="border-color: #43a047;">
                <div style="font-size: 10px; color: #666;">LAPORAN SELESAI</div>
                <div id="st-selesai" style="font-size: 28px; font-weight: bold; color: #333;">0</div>
            </div>
        </div>

        <a href="modul/aksi/index.html" class="btn-sos">
            <i class="fas fa-bolt"></i> AKSI & SOS DARURAT
        </a>

        <div style="margin-top: 15px; text-align: center;">
            <small style="color: #999;" id="last-update">Sync BMKG: --:--</small>
        </div>
    </div>

    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-home"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-circle-exclamation"></i>Aksi</a>
        <a href="modul/operator/index.html" class="nav-item"><i class="fas fa-edit"></i>Lapor</a>
    </nav>

    <script>
        const SAKTI = "$URL_SAKTI";
        const BMKG_CUACA = "$URL_CUACA_BMKG";

        async function syncData() {
            try {
                // 1. AMBIL CUACA RESMI BMKG DUMAI KOTA
                const wReq = await fetch(BMKG_CUACA);
                const wData = await wReq.json();
                // Mengambil data prakiraan terbaru dari array data[0]
                const cuacaSekarang = wData.data[0].cuaca[0][0]; 
                document.getElementById('w-temp').innerText = cuacaSekarang.t + "°C";
                document.getElementById('w-desc').innerText = cuacaSekarang.weather_desc;

                // 2. AMBIL GEMPA TERBARU
                const gReq = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
                const gData = await gReq.json();
                const g = gData.Infogempa.gempa;
                const mag = parseFloat(g.Magnitude);
                
                document.getElementById('g-mag').innerText = mag + " SR";
                document.getElementById('g-loc').innerText = g.Wilayah;

                const boxGempa = document.getElementById('box-gempa');
                if (mag >= 5.0) {
                    boxGempa.classList.add('bg-bahaya');
                    document.getElementById('g-label').innerText = "🚨 BAHAYA / SIAGA";
                } else {
                    boxGempa.classList.remove('bg-bahaya');
                    document.getElementById('g-label').innerText = "GEMPA TERBARU";
                }

                // 3. STATISTIK LAPORAN
                const sReq = await fetch(SAKTI);
                const sData = await sReq.json();
                document.getElementById('st-proses').innerText = sData.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
                document.getElementById('st-selesai').innerText = sData.laporan.filter(i => i[6] === 'Selesai').length;
                
                if(sData.info && sData.info[0]) {
                    document.getElementById('msg-admin').innerText = "📢 INSTRUKSI: " + sData.info[0][1];
                }

                document.getElementById('last-update').innerText = "Sync BMKG: " + new Date().toLocaleTimeString();
            } catch (e) { console.log("Re-syncing data..."); }
        }

        syncData();
        setInterval(syncData, 60000); // Sinkronisasi tiap 1 menit
    </script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ DASHBOARD DENGAN API RESMI BMKG DUMAI KOTA AKTIF!"
echo "📍 Data cuaca sekarang diambil langsung per kelurahan."
echo "-------------------------------------------------------"