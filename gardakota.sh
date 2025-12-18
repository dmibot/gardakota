#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "🔧 Set Zoom Level 15 (Fokus Kelurahan/Desa)..."

cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let wilayahInfo = "Menunggu GPS...";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Mendeteksi Wilayah (Level 15)...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // SET ZOOM=15 SESUAI INSTRUKSI (Level Kelurahan/Suburb)
            const response = await fetch(\`https://nominatim.openstreetmap.org/reverse?lat=\${lat}&lon=\${lng}&zoom=15&accept-language=id-ID&format=jsonv2\`);
            const data = await response.json();
            const addr = data.address;
            
            // LOGIKA PARSING
            // Di Level 15, biasanya 'road' hilang dan digantikan fokus ke 'village'/'suburb'
            
            // 1. Ambil Nama Wilayah
            let area = addr.village || addr.suburb || addr.quarter || addr.neighbourhood || addr.city || "Wilayah Dumai";
            
            // 2. Ambil Kecamatan/Kota (Parent)
            let parent = addr.city_district || addr.district || addr.city || "Riau";

            // Format Tampilan: "Kel. Teluk Binjai, Dumai"
            let prefix = "";
            if(addr.village || addr.suburb) prefix = "Kel. ";
            
            wilayahInfo = \`\${prefix}\${area}, \${parent}\`;
            
            box.innerHTML = \`✅ TERKUNCI<br><span style="color:#2e7d32; font-size:16px; font-weight:800;">\${wilayahInfo}</span><br><small style="color:#666;">\${lat}, \${lng}</small>\`;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.borderColor = "#2e7d32";
            
        } catch (err) {
            box.innerHTML = "✅ TERKUNCI<br><small>Sinyal GPS Oke, Nama wilayah timeout.</small>";
        }
    }, (err) => {
        alert("Wajib izinkan lokasi!");
        box.innerText = "❌ GPS Mati";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !file) return alert("Wajib Kunci GPS & Ambil Foto!");
    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); fd.append("image", file);
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
        btn.innerText = "KIRIM KE DASHBOARD";
        btn.disabled = false;
    }
}
EOF

echo "✅ Zoom Level di-set ke 15. Output akan lebih general (Kelurahan/Kecamatan)."