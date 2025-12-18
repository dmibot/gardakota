#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "🔧 Update Operator: Auto-Detect Kelurahan (Range Level 13-15)..."

cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let infoJalan = "";
let infoKel = "";
let infoKec = "";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Mencari Data Wilayah (Auto Level 13-15)...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // Kita tarik data Max Zoom 18 agar semua variabel tersedia di JSON
            const response = await fetch(\`https://nominatim.openstreetmap.org/reverse?lat=\${lat}&lon=\${lng}&zoom=18&accept-language=id-ID&format=jsonv2\`);
            const data = await response.json();
            const addr = data.address;
            
            // --- LOGIKA CERDAS 3 BARIS ---

            // BARIS 1: NAMA JALAN (Level 18)
            let nmJalan = addr.road || addr.pedestrian || addr.path || "";
            infoJalan = nmJalan ? \`Jln. \${nmJalan}\` : "(Jalan tdk terdeteksi)";

            // BARIS 2: KELURAHAN (Cek Bertingkat 13 -> 14 -> 15)
            let rawKel = "";
            
            // Cek 1: Level 13 (Kelurahan Murni)
            if (addr.village) rawKel = addr.village;
            else if (addr.suburb) rawKel = addr.suburb;
            else if (addr.town) rawKel = addr.town;
            
            // Cek 2: Level 14 (Lingkungan - Jika Lvl 13 kosong)
            else if (addr.neighbourhood) rawKel = addr.neighbourhood;
            
            // Cek 3: Level 15 (Dusun/Quarter - Jika Lvl 14 kosong)
            else if (addr.quarter) rawKel = addr.quarter;
            else if (addr.hamlet) rawKel = addr.hamlet;
            
            // Fallback terakhir
            else rawKel = "Wilayah Tidak Terdeteksi";

            infoKel = \`Kel. \${rawKel}\`;

            // BARIS 3: KECAMATAN (Level 12)
            let nmKec = addr.city_district || addr.district || addr.city || "Dumai";
            infoKec = \`Kec. \${nmKec}\`;

            // TAMPILAN UI
            let tampilanHTML = \`
                ✅ TERKUNCI<br>
                <div style="text-align:left; margin-top:8px; padding-left:12px; border-left:4px solid #2e7d32;">
                    <div style="font-size:12px; color:#555; margin-bottom:2px;">\${infoJalan}</div>
                    <div style="font-size:16px; font-weight:800; color:#000; text-transform:uppercase; margin-bottom:2px;">\${infoKel}</div>
                    <div style="font-size:13px; color:#333;">\${infoKec}</div>
                </div>
                <small style="color:#aaa; font-size:10px; display:block; margin-top:5px;">\${lat}, \${lng}</small>
            \`;
            
            box.innerHTML = tampilanHTML;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.border = "1px solid #c8e6c9";
            
        } catch (err) {
            box.innerHTML = "✅ TERKUNCI<br><small>Gagal parsing (Koneksi).</small>";
        }
    }, (err) => {
        alert("GPS ERROR: Wajib izinkan lokasi!");
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

        // FORMAT DB: [Kel. X, Kec. Y | Jln. Z] Keterangan
        const wilayahFull = \`[\${infoKel}, \${infoKec} | \${infoJalan}]\`;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: \`\${wilayahFull} \${ket}\`,
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

echo "✅ Selesai. Baris 2 sekarang Otomatis menyesuaikan (Level 13->14->15)."