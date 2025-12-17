#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
WA_CAMAT="6285172206884"

echo "🚨 MENGEMBALIKAN NAVIGASI & FITUR LENGKAP GARDA DUMAI KOTA..."

# 1. MODUL PETA: KEMBALIKAN NAVBAR & HOME
cat << 'EOF' > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Peta Pantau</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-home"></i></a>
        <div style="font-weight:bold;">PETA SEBARAN KEJADIAN</div>
        <i class="fas fa-sync" onclick="location.reload()"></i>
    </div>
    
    <div id="map" style="height:calc(100vh - 135px); width:100%;"></div>

    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-house"></i>Home</a>
        <a href="index.html" class="nav-item active"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="../aksi/index.html" class="nav-item"><i class="fas fa-bolt"></i>Darurat</a>
        <a href="../admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Petugas</a>
    </nav>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="peta.js"></script>
</body>
</html>
EOF

# 2. MODUL OPERATOR: KEMBALIKAN SEMUA JENIS KEJADIAN (11 KATEGORI)
cat << 'EOF' > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-home"></i></a>
        <div style="font-weight:bold;">OPERATOR PANEL</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card" style="background:#e8f5e9; border-left:5px solid #2e7d32;">
            <small>Selamat Bertugas:</small> <h4 id="op-name" style="margin:0;">-</h4>
        </div>
        <div class="card">
            <button class="btn-main" onclick="track()"><i class="fas fa-crosshairs"></i> KUNCI LOKASI GPS</button>
            <p id="gps-msg" style="text-align:center; font-size:11px; margin:5px 0;">GPS belum dikunci</p>
            <div id="map-preview" style="height:150px; width:100%; border-radius:12px; display:none; border:2px solid #0d47a1; margin-top:10px;"></div>
            <hr>
            <label><b>Jenis Kejadian:</b></label>
            <select id="kat">
                <option value="Banjir Rob / Pasang Keling">🌊 Banjir Rob / Pasang Keling</option>
                <option value="Drainase Tersumbat / Banjir">🕳️ Drainase Tersumbat / Banjir</option>
                <option value="Penumpukan Sampah">🗑️ Penumpukan Sampah</option>
                <option value="Kamtibmas / Tawuran">👮 Kamtibmas / Tawuran</option>
                <option value="Kebakaran Lahan / Karhutla">🔥 Kebakaran Lahan / Karhutla</option>
                <option value="Lampu Jalan Mati (PJU)">💡 Lampu Jalan Mati (PJU)</option>
                <option value="Infrastruktur / Jalan Rusak">🛣️ Infrastruktur / Jalan Rusak</option>
                <option value="Pohon Tumbang / Gangguan Kabel">🌳 Pohon Tumbang</option>
                <option value="Penertiban PKL / Perda">🏪 Penertiban PKL / Perda</option>
                <option value="Layanan Publik / Administrasi">📄 Layanan Publik / Administrasi</option>
                <option value="Lainnya">❓ Kejadian Lainnya</option>
            </select>
            <textarea id="ket" placeholder="Detail keterangan kejadian..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnKirim" onclick="lapor()">🚀 KIRIM LAPORAN SEKARANG</button>
        </div>
    </div>
    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-home"></i>Home</a>
        <a href="../peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="index.html" class="nav-item active"><i class="fas fa-edit"></i>Lapor</a>
        <a href="../admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Petugas</a>
    </nav>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="operator.js"></script>
</body>
</html>
EOF

echo "------------------------------------------------------------"
echo "✅ NAVIGASI & KATEGORI LENGKAP TELAH DIKEMBALIKAN!"
echo "📍 Modul Peta: Navbar & Tombol Home Aktif."
echo "📍 Modul Operator: 11 Jenis Kejadian & Navbar Aktif."
echo "------------------------------------------------------------"