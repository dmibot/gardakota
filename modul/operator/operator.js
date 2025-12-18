const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
// Variabel global untuk menyimpan alamat lengkap 3 baris
let infoJalan = "";
let infoKel = "";
let infoKec = "";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Mengurai Data Lokasi (3 Layer)...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // Tarik data maksimal (Zoom 18) agar dapat semua komponen
            const response = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=18&accept-language=id-ID&format=jsonv2`);
            const data = await response.json();
            const addr = data.address;
            
            // --- PEMETAAN 3 BARIS SESUAI INSTRUKSI BAPAK ---

            // BARIS 1: Level Jalan (Zoom 18)
            // Prioritas: Nama Jalan > Nama Gedung > "Jalan tdk terdeteksi"
            let nmJalan = addr.road || addr.pedestrian || addr.building || "";
            infoJalan = nmJalan ? `Jln. ${nmJalan}` : "(Jalan tdk terdeteksi)";

            // BARIS 2: Level Kelurahan (Zoom 15)
            // Prioritas: Village > Suburb > Neighbourhood
            let nmKel = addr.village || addr.suburb || addr.neighbourhood || "";
            infoKel = nmKel ? `Kel. ${nmKel}` : "(Kelurahan tdk terdeteksi)";

            // BARIS 3: Level Kecamatan/Kota (Zoom 12)
            // Prioritas: City District > District > City
            let nmKec = addr.city_district || addr.district || addr.city || "Dumai";
            infoKec = `Kec. ${nmKec}`;

            // TAMPILAN DI UI (3 BARIS RAPI)
            let tampilanHTML = `
                ✅ TERKUNCI<br>
                <div style="text-align:left; margin-top:5px; padding-left:10px; border-left:3px solid #2e7d32;">
                    <div style="font-size:11px; color:#555;">${infoJalan}</div>
                    <div style="font-size:14px; font-weight:bold; color:#000;">${infoKel}</div>
                    <div style="font-size:12px; color:#555;">${infoKec}</div>
                </div>
                <small style="color:#aaa; font-size:9px;">${lat}, ${lng}</small>
            `;
            
            box.innerHTML = tampilanHTML;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.borderColor = "#2e7d32";
            
        } catch (err) {
            box.innerHTML = "✅ TERKUNCI<br><small>Gagal parsing detail wilayah.</small>";
        }
    }, (err) => {
        alert("GPS ERROR: Aktifkan Lokasi!");
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

        // Gabungkan 3 Baris Info ke dalam satu string keterangan
        // Format: [Kel. X, Kec. Y | Jln. Z] Keterangan User
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
