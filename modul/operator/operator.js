const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";

async function getGPS() {
    const box = document.getElementById('gps-status');
    box.innerText = "⌛ Menghubungkan GPS...";
    
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        box.innerHTML = "✅ KOORDINAT TERKUNCI";
        box.style.background = "#e8f5e9";
        
        // PING KE ADMIN BAHWA PETUGAS SEDANG DI LOKASI
        fetch(SAKTI, {
            method: 'POST', mode: 'no-cors',
            body: JSON.stringify({ action: "log", user: label, coords: lat + "," + lng, type: "Tracking TKP" })
        });
    }, () => alert("GPS Gagal!"));
}

async function kirim() {
    const file = document.getElementById('foto').files[0];
    if(!file || !lat) return alert("Foto & Kunci GPS wajib!");
    
    const btn = document.getElementById('btnLapor');
    btn.innerText = "⏳ Mengirim..."; btn.disabled = true;

    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();

    await fetch(SAKTI, {
        method:'POST', mode:'no-cors',
        body: JSON.stringify({ nama:label, kategori:document.getElementById('kat').value, keterangan:document.getElementById('ket').value, lokasi:`http://googleusercontent.com/maps.google.com/q=${lat},${lng}`, foto:dI.data.url })
    });
    alert("Laporan Terkirim!"); window.location.reload();
}
