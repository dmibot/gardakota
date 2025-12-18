const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

document.getElementById('op-name').innerText = label;
let lat = "", lng = "", mapPreview;

// KORDINAT GEOFENCING DUMAI KOTA (Bounding Box Kasar)
const BORDER = {
    minLat: 1.6500, // Batas Selatan
    maxLat: 1.7000, // Batas Utara
    minLng: 101.4200, // Batas Barat
    maxLng: 101.4650  // Batas Timur
};

function track() {
    const msg = document.getElementById('gps-msg');
    const btnKirim = document.getElementById('btnKirim');
    msg.innerText = "⌛ Menghubungkan Satelit...";

    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;

        // LOGIKA GEOFENCING
        if (lat >= BORDER.minLat && lat <= BORDER.maxLat && lng >= BORDER.minLng && lng <= BORDER.maxLng) {
            msg.innerHTML = "✅ KOORDINAT TERKUNCI (DALAM WILAYAH)";
            msg.style.color = "green";
            btnKirim.disabled = false;
            btnKirim.style.opacity = "1";
        } else {
            msg.innerHTML = "❌ ANDA DI LUAR WILAYAH DUMAI KOTA!";
            msg.style.color = "red";
            btnKirim.disabled = true;
            btnKirim.style.opacity = "0.3";
            alert("MAAF! Laporan hanya bisa dikirim dari dalam wilayah Kecamatan Dumai Kota.");
        }

        // Tampilkan Peta Preview
        const mapDiv = document.getElementById('map-preview');
        mapDiv.style.display = "block";
        if (!mapPreview) {
            mapPreview = L.map('map-preview').setView([lat, lng], 17);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mapPreview);
        } else {
            mapPreview.setView([lat, lng], 17);
        }
        L.marker([lat, lng]).addTo(mapPreview).bindPopup("Posisi Anda").openPopup();

    }, () => alert("Gagal melacak! Aktifkan GPS."), { enableHighAccuracy: true });
}

async function lapor() {
    const file = document.getElementById('foto').files[0];
    if(!file || !lat) return alert("Foto & Kunci GPS Wajib!");

    const btn = document.getElementById('btnKirim');
    btn.innerText = "⏳ Mengirim..."; btn.disabled = true;

    let fd = new FormData(); fd.append("image", file);
    let resI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await resI.json();

    await fetch(SAKTI, {
        method:'POST', mode:'no-cors',
        body: JSON.stringify({ 
            nama: label, 
            kategori: document.getElementById('kat').value, 
            keterangan: document.getElementById('ket').value, 
            lokasi: `https://www.google.com/maps?q=${lat},${lng}`, 
            foto: dI.data.url 
        })
    });
    alert("Laporan Berhasil Terkirim ke Camat!"); 
    window.location.reload();
}