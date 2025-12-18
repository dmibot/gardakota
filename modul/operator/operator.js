const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let infoJalan = "";
let infoKel = "";
let infoKec = "";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Sinkronisasi 3 Layer Wilayah...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // REQUEST 1: ZOOM 18 (BARIS 1 - JALAN)
            const res1 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=18&accept-language=id-ID&format=jsonv2`);
            const d1 = await res1.json();
            
            // REQUEST 2: ZOOM 14 (BARIS 2 - KELURAHAN)
            const res2 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=14&accept-language=id-ID&format=jsonv2`);
            const d2 = await res2.json();

            // REQUEST 3: ZOOM 12 (BARIS 3 - KECAMATAN FIX)
            const res3 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=12&accept-language=id-ID&format=jsonv2`);
            const d3 = await res3.json();
            
            // --- PARSING DATA ---

            // 1. BARIS 1 (Logika Bapak yang sudah berhasil)
            let adj = d1.address;
            let nmJalan = adj.road || adj.pedestrian || adj.path || "";
            infoJalan = nmJalan ? `Jln. ${nmJalan}` : "(Jalan tdk terdeteksi)";

            // 2. BARIS 2 (Logika Bapak yang sudah berhasil)
            let adk = d2.address;
            let nmKel = adk.village || adk.suburb || adk.neighbourhood || adk.quarter || d2.name || "";
            if (!nmKel || nmKel == "Dumai") {
                 nmKel = adj.village || adj.suburb || adj.neighbourhood || "Wilayah tdk terdeteksi";
            }
            infoKel = `Kel. ${nmKel}`;

            // 3. BARIS 3 (LOGIKA BARU - FIX LEVEL 12)
            // Di Level 12 Nominatim akan mengembalikan City District atau District secara luas
            let adz = d3.address;
            let nmKec = adz.city_district || adz.district || adz.city || "Dumai";
            infoKec = `Kec. ${nmKec}`;

            // TAMPILAN UI
            let tampilanHTML = `
                ✅ TERKUNCI<br>
                <div style="text-align:left; margin-top:8px; padding-left:12px; border-left:4px solid #2e7d32;">
                    <div style="font-size:12px; color:#555; margin-bottom:2px;">${infoJalan}</div>
                    <div style="font-size:16px; font-weight:800; color:#000; text-transform:uppercase; margin-bottom:2px;">${infoKel}</div>
                    <div style="font-size:13px; color:#333;">${infoKec}</div>
                </div>
                <small style="color:#aaa; font-size:10px; display:block; margin-top:5px;">${lat}, ${lng}</small>
            `;
            
            box.innerHTML = tampilanHTML;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.border = "1px solid #c8e6c9";
            
        } catch (err) {
            box.innerHTML = "✅ TERKUNCI<br><small>Koneksi Lambat (Ulangi Klik).</small>";
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

        const wilayahFull = `[${infoKel}, ${infoKec} | ${infoJalan}]`;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: `${wilayahFull} ${ket}`,
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
