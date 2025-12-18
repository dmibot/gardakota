const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";

let lat = "", lng = "";
let teksWilayah = ""; 

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Mengunci Satelit...";
    
    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        try {
            // TRACK 3 LAPIS (Zoom 18, 14, 12) untuk akurasi maksimal
            const r1 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=18&accept-language=id-ID&format=jsonv2`);
            const d1 = await r1.json();
            const r2 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=14&accept-language=id-ID&format=jsonv2`);
            const d2 = await r2.json();
            const r3 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=12&accept-language=id-ID&format=jsonv2`);
            const d3 = await r3.json();

            const jln = d1.address.road || d1.address.pedestrian || "Jln. Tidak Terdeteksi";
            const kel = d2.address.village || d2.address.suburb || d2.address.neighbourhood || "Kelurahan";
            const kec = d3.address.city_district || d3.address.district || "Kecamatan";

            teksWilayah = `[Kel. ${kel}, ${kec} | ${jln}]`;
            box.innerHTML = `✅ TERKUNCI<br><small style="font-size:10px;">${teksWilayah}</small>`;
            box.style.background = "#e8f5e9";
        } catch (e) { 
            teksWilayah = "[Lokasi Terkunci via GPS]"; 
            box.innerHTML = "✅ TERKUNCI (GPS OK)"; 
        }
    }, (err) => { 
        alert("GPS WAJIB AKTIF!");
        box.innerHTML = "❌ GPS MATI";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const btn = document.getElementById('btnLapor');
    const fileInput = document.getElementById('foto').files[0];
    
    if(!lat || !fileInput) return alert("Kunci GPS & Ambil Foto Bukti!");

    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        // 1. Upload ke ImgBB
        let fd = new FormData(); fd.append("image", fileInput);
        let rImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dImg = await rImg.json();

        // 2. KOORDINAT MURNI (Mencegah 404 Vercel)
        const linkMapsMurni = `https://www.google.com/maps?q=${lat},${lng}`;

        // 3. TEKS WILAYAH MASUK KE KETERANGAN
        const keteranganFinal = `${teksWilayah} ${document.getElementById('ket').value}`;

        // 4. Kirim ke Google Sheets
        await fetch(SAKTI, {
            method: 'POST', 
            mode: 'no-cors',
            body: JSON.stringify({
                nama: localStorage.getItem("user_label") || "PETUGAS",
                kategori: document.getElementById('kat').value,
                keterangan: keteranganFinal,
                lokasi: linkMapsMurni,
                foto: dImg.data.url
            })
        });

        alert("✅ LAPORAN TERKIRIM!");
        window.location.reload();
    } catch(e) { 
        alert("Gagal Kirim!"); 
        btn.innerText = "KIRIM KE DASHBOARD"; 
        btn.disabled = false; 
    }
}