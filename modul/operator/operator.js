const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
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
