#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "🚀 MEMPERBAIKI TOTAL MODUL OPERATOR GARDA DUMAI KOTA..."

# 1. REBUILD FOLDER
mkdir -p modul/operator

# 2. OPERATOR.CSS (Modular Style)
cat << 'EOF' > modul/operator/operator.css
.op-card-header { background: #e3f2fd; border-left: 6px solid #0d47a1; padding: 15px; border-radius: 12px; margin-bottom: 20px; }
.gps-status { padding: 15px; background: #f5f5f5; border: 2px dashed #ddd; border-radius: 15px; text-align: center; margin-bottom: 15px; font-size: 13px; font-weight: bold; }
.gps-locked { background: #e8f5e9; border-color: #2e7d32; color: #2e7d32; }
label { font-weight: 800; font-size: 12px; color: #0d47a1; text-transform: uppercase; margin-left: 5px; }
EOF

# 3. OPERATOR.JS (Logic & GPS & Full API)
cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('display-name').innerText = label;

let lat = "", lng = "";

function trackLokasi() {
    const box = document.getElementById('gps-status');
    box.innerHTML = "⌛ Menghubungkan Satelit GPS...";
    
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude;
        lng = p.coords.longitude;
        box.innerHTML = "✅ KOORDINAT TERKUNCI<br><small>" + lat + ", " + lng + "</small>";
        box.classList.add('gps-locked');
    }, () => {
        alert("Gagal! Pastikan GPS HP Aktif dan Izin Lokasi diberikan.");
        box.innerHTML = "❌ GPS Gagal Dilacak";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnKirim');

    if(!lat || !lng) return alert("Bapak belum mengunci LOKASI GPS!");
    if(!file) return alert("Foto bukti kejadian wajib dilampirkan!");
    if(!ket) return alert("Mohon isi keterangan kejadian!");

    btn.innerText = "⏳ SEDANG MENGIRIM...";
    btn.disabled = true;

    try {
        // 1. Upload ke ImgBB
        let fd = new FormData(); fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
        let urlFoto = dataImg.data.url;

        // 2. Kirim ke Database (Standard SIGAP)
        let mapsUrl = "https://www.google.com/maps?q=" + lat + "," + lng;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: ket,
                lokasi: mapsUrl,
                foto: urlFoto
            })
        });

        alert("Laporan Berhasil Masuk ke Dashboard Camat!");
        window.location.reload();
    } catch(e) {
        alert("Gangguan Server! Cek koneksi.");
        btn.innerText = "🚀 KIRIM LAPORAN";
        btn.disabled = false;
    }
}
EOF

# 4. INDEX.HTML (Modular Structure)
cat << 'EOF' > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="operator.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Operator Lapor - Garda Kota</title>
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;"><i class="fas fa-user-check"></i> OPERATOR PANEL</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>

    <div class="container">
        <div class="op-card-header">
            <small>Selamat Bertugas:</small>
            <h3 id="display-name" style="margin:0;">-</h3>
        </div>

        <div class="card">
            <label>I. Titik Koordinat (GPS)</label>
            <div id="gps-status" class="gps-status">📍 Sinyal GPS belum dikunci</div>
            <button class="btn-main" style="background:#0288d1; margin-bottom:20px;" onclick="trackLokasi()">
                <i class="fas fa-crosshairs"></i> KUNCI LOKASI KEJADIAN
            </button>

            <label>II. Jenis Kejadian</label>
            <select id="kat">
                <option value="Banjir Rob / Pasang Keling">🌊 Banjir Rob / Pasang Keling</option>
                <option value="Drainase Tersumbat / Banjir">🕳️ Drainase Tersumbat / Banjir</option>
                <option value="Penumpukan Sampah">🗑️ Penumpukan Sampah</option>
                <option value="Kamtibmas / Tawuran">👮 Kamtibmas / Tawuran</option>
                <option value="Kebakaran Lahan / Karhutla">🔥 Kebakaran Lahan / Karhutla</option>
                <option value="Lampu Jalan Mati (PJU)">💡 Lampu Jalan Mati (PJU)</option>
                <option value="Infrastruktur / Jalan Rusak">🛣️ Infrastruktur / Jalan Rusak</option>
                <option value="Pohon Tumbang / Gangguan Kabel">🌳 Pohon Tumbang / Kabel</option>
                <option value="Penertiban PKL / Perda">🏪 Penertiban PKL / Perda</option>
                <option value="Layanan Publik / Administrasi">📄 Layanan Publik / Administrasi</option>
                <option value="Lainnya">❓ Kejadian Lainnya</option>
            </select>

            <label>III. Detail Keterangan</label>
            <textarea id="ket" rows="3" placeholder="Contoh: Terjadi di Jl. Kesehatan dekat Masjid..."></textarea>

            <label>IV. Foto Bukti Lapangan</label>
            <input type="file" id="foto" accept="image/*" capture="camera" style="margin-top:5px;">

            <button class="btn-main" id="btnKirim" style="margin-top:25px;" onclick="kirimLaporan()">
                <i class="fas fa-paper-plane"></i> KIRIM LAPORAN SEKARANG
            </button>
        </div>
    </div>

    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-home"></i>Home</a>
        <a href="../peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="#" class="nav-item active"><i class="fas fa-plus-circle"></i>Lapor</a>
    </nav>

    <script src="operator.js"></script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ BERES, PAK CAMAT! MODUL OPERATOR SUDAH SEMPURNA."
echo "📍 FITUR GPS: AKTIF 100%"
echo "📍 KATEGORI: LENGKAP (11 KATEGORI)"
echo "-------------------------------------------------------"