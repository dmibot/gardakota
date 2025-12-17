#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "🗺️ MEMBANGUN MODUL PETA MODULAR - STANDAR SIGAP DUMAI..."

# 1. MEMBUAT FOLDER MODUL PETA
mkdir -p modul/peta

# 2. PETA.CSS (Desain UI Peta Biru Tua)
cat << 'EOF' > modul/peta/peta.css
#map { height: calc(100vh - 130px); width: 100%; border-radius: 0 0 20px 20px; box-shadow: inset 0 0 10px rgba(0,0,0,0.1); }
.leaflet-popup-content-wrapper { border-radius: 12px; padding: 5px; font-family: 'Segoe UI', sans-serif; }
.popup-img { width: 100%; border-radius: 8px; margin-top: 5px; }
.legend { background: white; padding: 10px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); font-size: 11px; line-height: 1.5; }
.legend i { width: 12px; height: 12px; display: inline-block; border-radius: 50%; margin-right: 5px; }
EOF

# 3. PETA.JS (Logika Penarikan Data Live dari Google Sheets)
cat << EOF > modul/peta/peta.js
var map = L.map('map').setView([1.680, 101.448], 14); // Fokus Dumai Kota

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© Garda Dumai Kota'
}).addTo(map);

async function loadMarkers() {
    try {
        const response = await fetch('$URL_SAKTI');
        const data = await response.json();
        
        // Looping data laporan dari Google Sheets
        data.laporan.forEach((item, index) => {
            if (index === 0) return; // Skip header
            
            // Ambil koordinat dari string "http://maps.google.com/...lat,lng"
            const coordMatch = item[4].match(/(-?\d+\.\d+),(-?\d+\.\d+)/);
            if (coordMatch) {
                const lat = parseFloat(coordMatch[1]);
                const lng = parseFloat(coordMatch[2]);
                const status = item[6];
                
                // Warna marker berdasarkan status
                let color = status === 'Selesai' ? '#388e3c' : (status === 'Penanganan' ? '#ff9800' : '#d32f2f');
                
                const marker = L.circleMarker([lat, lng], {
                    radius: 8,
                    fillColor: color,
                    color: "#fff",
                    weight: 2,
                    opacity: 1,
                    fillOpacity: 0.8
                }).addTo(map);

                marker.bindPopup(\`
                    <div style="width:200px">
                        <b style="color:#0d47a1">\${item[2]}</b><br>
                        <small>\${item[1]} | \${item[0]}</small><br>
                        <hr style="border:0; border-top:1px solid #eee">
                        <p style="font-size:12px">\${item[3]}</p>
                        <img src="\${item[5]}" class="popup-img">
                        <div style="margin-top:5px; font-weight:bold; color:\${color}">Status: \${status}</div>
                    </div>
                \`);
            }
        });
    } catch (e) {
        console.error("Gagal memuat peta:", e);
    }
}

loadMarkers();
EOF

# 4. INDEX.HTML (Struktur HTML Modul Peta)
cat << 'EOF' > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="peta.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Peta Pantau - Garda Kota</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-chevron-left"></i></a>
        <div style="text-align:center;">
            <div style="font-size:16px; font-weight:bold;">PETA SEBARAN KEJADIAN</div>
            <div style="font-size:10px; opacity:0.8;">KECAMATAN DUMAI KOTA</div>
        </div>
        <i class="fas fa-refresh" onclick="location.reload()"></i>
    </div>

    <div id="map"></div>

    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-house-chimney"></i>Home</a>
        <a href="index.html" class="nav-item active"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="../aksi/index.html" class="nav-item"><i class="fas fa-bolt"></i>Lapor</a>
    </nav>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="peta.js"></script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "🗺️ MODUL PETA MODULAR SELESAI!"
echo "📍 Data ditarik otomatis dari Google Sheets Bapak."
echo "📍 Sudah termasuk Foto Popup & Status Warna."
echo "-------------------------------------------------------"