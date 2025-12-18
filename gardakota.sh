#!/bin/bash

# KONFIGURASI URL (JANGAN DIUBAH)
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "🌟 MENGUBAH GAYA MENJADI CLEAN MINIMALIS & ICONS MODERN..."

# 1. MASTER CSS BARU (CLEAN LOOK)
cat << 'EOF' > css/style.css
:root { 
    --primary: #0066FF; /* Biru Teknologi Cerah */
    --danger: #FF3366; /* Merah Modern */
    --success: #00C853; /* Hijau Modern */
    --dark: #2D3436; /* Hitam Lembut */
    --grey: #636E72;
    --bg: #F8F9FA; /* Abu sangat muda */
    --surface: #FFFFFF; /* Putih Bersih */
    --h: 60px; --nav: 65px;
}
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
body { 
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    margin: 0; background: var(--bg); color: var(--dark);
    padding-top: calc(var(--h) + 15px); padding-bottom: calc(var(--nav) + 20px);
    line-height: 1.5;
}

/* HEADER MODERN MINIMALIS (Putih Bersih) */
.app-header { 
    height: var(--h); background: var(--surface);
    display: flex; align-items: center; justify-content: space-between;
    padding: 0 20px; position: fixed; top: 0; width: 100%; z-index: 2000;
    box-shadow: 0 1px 0 rgba(0,0,0,0.05); /* Garis tipis halus */
}
.app-header h1 { 
    font-size: 16px; font-weight: 800; color: var(--primary); margin: 0; letter-spacing: -0.5px;
}
.header-icon { color: var(--dark); font-size: 20px; text-decoration: none; }

/* CONTAINER & CARD MODERN (Soft Shadow) */
.container { padding: 0 16px; max-width: 500px; margin: auto; }
.card { 
    background: var(--surface); border-radius: 16px; padding: 20px; margin-bottom: 16px;
    border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.05); /* Bayangan halus modern */
}

/* WIDGET DASHBOARD MODERN */
.modern-widget {
    display: flex; align-items: center; gap: 15px;
}
.widget-icon {
    width: 50px; height: 50px; border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    font-size: 24px;
}
.bg-blue-light { background: #E3F2FD; color: var(--primary); }
.bg-orange-light { background: #FFF3E0; color: #FF9800; }
.widget-data h3 { margin: 0; font-size: 22px; font-weight: 800; }
.widget-data small { color: var(--grey); font-size: 12px; font-weight: 600; text-transform: uppercase; }

/* TOMBOL MODERN */
.btn-main { 
    height: 50px; display: flex; align-items: center; justify-content: center;
    background: var(--primary); color: white; border: none; border-radius: 14px;
    width: 100%; font-weight: 700; font-size: 15px; cursor: pointer; text-decoration: none;
    box-shadow: 0 4px 10px rgba(0, 102, 255, 0.2); transition: 0.2s;
}
.btn-main:active { transform: scale(0.98); }
.btn-danger { background: var(--danger); box-shadow: 0 4px 10px rgba(255, 51, 102, 0.3); }

/* BOTTOM NAV MODERN (Ikon Besar Tanpa Teks) */
.bottom-nav { 
    height: var(--nav); position: fixed; bottom: 0; width: 100%; 
    background: var(--surface); display: flex; 
    box-shadow: 0 -1px 0 rgba(0,0,0,0.05); z-index: 2000;
    padding: 0 10px 5px 10px;
    border-top-left-radius: 20px; border-top-right-radius: 20px; /* Sudut membulat di bawah */
}
.nav-item { 
    flex: 1; display: flex; flex-direction: column; align-items: center; 
    justify-content: center; color: #B0B0B0; text-decoration: none; position: relative;
}
.nav-item i { font-size: 24px; /* Ikon lebih besar */ }
.nav-item.active { color: var(--primary); }
/* Indikator Titik untuk Aktif */
.nav-item.active::after {
    content: ''; position: absolute; bottom: 8px; width: 6px; height: 6px;
    background: var(--primary); border-radius: 50%;
}
EOF

# 2. UPDATE DASHBOARD UTAMA (SESUAI GAYA MODERN BARU)
cat << EOF > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Modern</title>
</head>
<body>
    <div class="app-header">
        <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png" width="30">
        <h1>GARDA DUMAI</h1>
        <a href="modul/admin/login.html" class="header-icon"><i class="fas fa-user-circle"></i></a>
    </div>

    <div class="container">
        <div style="background: #FFF3E0; color: #E65100; padding: 8px 12px; border-radius: 8px; font-size: 12px; font-weight: 600; margin-bottom: 15px;">
            <marquee id="msg-admin">📢 Memuat instruksi terbaru...</marquee>
        </div>

        <div class="card modern-widget">
            <div class="widget-icon bg-blue-light"><i class="fas fa-cloud-sun"></i></div>
            <div class="widget-data" style="flex:1;">
                <small>Cuaca Dumai Kota</small>
                <h3 id="w-temp">--°C</h3>
            </div>
            <div style="text-align:right;">
                <div id="w-desc" style="font-size:12px; font-weight:600; text-transform:uppercase; color:var(--primary);">...</div>
                <small style="font-size:10px; opacity:0.6;">BMKG Official</small>
            </div>
        </div>

        <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px;">
             <div class="card modern-widget" style="margin:0; padding: 15px;">
                <div class="widget-icon" style="background:#FFE0E6; color: var(--danger); width:40px; height:40px; font-size:18px;"><i class="fas fa-clock"></i></div>
                <div class="widget-data">
                    <h3 id="st-proses">0</h3>
                    <small>Proses</small>
                </div>
            </div>
             <div class="card modern-widget" style="margin:0; padding: 15px;">
                <div class="widget-icon" style="background:#E0F7FA; color: var(--success); width:40px; height:40px; font-size:18px;"><i class="fas fa-check-circle"></i></div>
                <div class="widget-data">
                    <h3 id="st-selesai">0</h3>
                    <small>Selesai</small>
                </div>
            </div>
        </div>

        <a href="modul/aksi/index.html" class="btn-main btn-danger">
            <i class="fas fa-bolt" style="margin-right:10px;"></i> SOS & DARURAT
        </a>
    </div>

    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-house-chimney"></i></a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i></a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-triangle-exclamation"></i></a>
        <a href="modul/operator/index.html" class="nav-item"><i class="fas fa-plus-circle" style="font-size:28px; color:var(--primary);"></i></a>
    </nav>

    <script>
        const SAKTI = "$URL_SAKTI";
        const BMKG_CUACA = "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=14.72.06.1001";

        async function syncData() {
            try {
                // Cuaca BMKG
                const wReq = await fetch(BMKG_CUACA);
                const wData = await wReq.json();
                const now = wData.data[0].cuaca[0][0];
                document.getElementById('w-temp').innerText = now.t + "°C";
                document.getElementById('w-desc').innerText = now.weather_desc;

                // Stats Admin
                const sReq = await fetch(SAKTI);
                const sData = await sReq.json();
                document.getElementById('st-proses').innerText = sData.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
                document.getElementById('st-selesai').innerText = sData.laporan.filter(i => i[6] === 'Selesai').length;
                if(sData.info && sData.info[0]) document.getElementById('msg-admin').innerText = sData.info[0][1];
            } catch(e) {}
        }
        syncData(); setInterval(syncData, 60000);
    </script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✨ TAMPILAN CLEAN MINIMALIS & MODERN ICONS AKTIF! ✨"
echo "📍 Header putih bersih, kartu modern dengan bayangan halus."
echo "📍 Navbar bawah ikon besar tanpa teks (gaya iOS/Android modern)."
echo "-------------------------------------------------------"