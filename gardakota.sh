#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "🔧 Mengaktifkan Geofencing Lokal Kelurahan Dumai Kota..."

cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let wilayahInfo = "Kec. Dumai Kota";

// DATABASE TITIK TENGAH KELURAHAN (DUMAI KOTA)
const TITIK_KELURAHAN = [
    { nama: "Kel. Laksamana", lat: 1.6811, lng: 101.4455 },
    { nama: "Kel. Bintan", lat: 1.6755, lng: 101.4468 },
    { nama: "Kel. Dumai Kota", lat: 1.6778, lng: 101.4528 },
    { nama: "Kel. Rimba Sekampung", lat: 1.6698, lng: 101.4425 },
    { nama: "Kel. Sukajadi", lat: 1.6712, lng: 101.4495 }
];

// Fungsi Hitung Jarak Terdekat (Haversine)
function hitungKelurahan(userLat, userLng) {
    let terdekat = "";
    let jarakMin = Infinity;

    TITIK_KELURAHAN.forEach(kel => {
        const d = Math.sqrt(Math.pow(userLat - kel.lat, 2) + Math.pow(userLng - kel.lng, 2));
        if (d < jarakMin) {
            jarakMin = d;
            terdekat = kel.nama;
        }
    });
    return terdekat;
}

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Menghitung Posisi Kelurahan...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        // Deteksi Kelurahan Berdasarkan Koordinat Terdekat
        const namaKel = hitungKelurahan(lat, lng);
        wilayahInfo = \`\${namaKel}, Dumai Kota\`;
        
        box.innerHTML = \`✅ TERKUNCI<br><span style="color:#2e7d32; font-size:16px; font-weight:900;">\${wilayahInfo}</span><br><small style="color:#666;">\${lat}, \${lng}</small>\`;
        box.style.background = "#e8f5e9";
        box.style.color = "#2e7d32";
        box.style.borderColor = "#2e7d32";
        
    }, (err) => {
        alert("GPS ERROR: Aktifkan Lokasi!");
        box.innerText = "❌ GPS Gagal";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !lng) return alert("Kunci GPS dulu!");
    if(!file) return alert("Foto wajib ada!");

    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); 
        fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
        
        const mapsUrl = "https://www.google.com/maps?q=" + lat + "," + lng;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: \`[\${wilayahInfo}] \${ket}\`,
                lokasi: mapsUrl,
                foto: dataImg.data.url
            })
        });

        alert("Laporan Terkirim!");
        window.location.reload();
    } catch(e) {
        alert("Gagal Kirim!");
        btn.innerText = "🚀 KIRIM KE DASHBOARD";
        btn.disabled = false;
    }
}
EOF

echo "✅ Geofencing Kelurahan Aktif. Pasti muncul namanya sekarang."