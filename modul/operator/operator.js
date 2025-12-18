const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let wilayahInfo = "Luar Wilayah";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Menghubungkan Satelit BMKG & GPS...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // MENGGUNAKAN BIGDATACLOUD / BIG DATA API UNTUK AKURASI INDONESIA LEBIH BAIK
            const response = await fetch(`https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lng}&localityLanguage=id`);
            const data = await response.json();
            
            // Logika Pemetaan Wilayah Dumai
            const kelurahan = data.locality || data.principalSubdivision || "Dumai";
            const kecamatan = data.city || "Dumai Kota";
            
            wilayahInfo = `${kelurahan}, ${kecamatan}`;
            
            box.innerHTML = `✅ TERKUNCI<br><span style="color:#2e7d32; font-size:15px; font-weight:800;">${wilayahInfo}</span><br><small style="color:#666;">${lat}, ${lng}</small>`;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.borderColor = "#2e7d32";
            
        } catch (err) {
            // Fallback jika API pertama gagal
            box.innerHTML = "✅ TERKUNCI<br><small>Gagal mendeteksi nama jalan, koordinat GPS aman.</small>";
            box.style.background = "#e8f5e9";
        }
    }, (err) => {
        alert("GPS ERROR: Harap berikan izin akses lokasi pada browser HP Anda.");
        box.innerText = "❌ Sinyal GPS Lemah";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !lng) return alert("Mohon Kunci Titik GPS terlebih dahulu!");
    if(!file) return alert("Wajib melampirkan foto bukti!");
    if(!ket) return alert("Mohon isi detail keterangan!");

    btn.innerText = "⏳ SEDANG MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); 
        fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
        
        // Link Google Maps resmi query-based
        const mapsUrl = "https://www.google.com/maps?q=" + lat + "," + lng;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: `[${wilayahInfo}] ${ket}`,
                lokasi: mapsUrl,
                foto: dataImg.data.url
            })
        });

        alert("Laporan Berhasil Terkirim ke Dashboard!");
        window.location.reload();
    } catch(e) {
        alert("Gagal Terkirim. Periksa Koneksi Internet Anda.");
        btn.innerText = "🚀 KIRIM KE DASHBOARD";
        btn.disabled = false;
    }
}
