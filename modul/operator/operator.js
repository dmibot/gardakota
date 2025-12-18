const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
let lat = "", lng = "";

function track() {
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        document.getElementById('gps-msg').innerHTML = "✅ GPS TERKUNCI";
        document.getElementById('gps-msg').style.color = "green";
    });
}

async function lapor() {
    if(!lat) return alert("Kunci GPS dulu!");
    const file = document.getElementById('foto').files[0];
    if(!file) return alert("Foto wajib!");
    
    document.getElementById('btnKirim').innerText = "⌛ MENGIRIM...";
    
    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();

    const linkMaps = "https://www.google.com/maps/search/?api=1&query=" + lat + "," + lng;

    await fetch(SAKTI, {
        method:'POST', mode:'no-cors',
        body: JSON.stringify({ 
            nama: localStorage.getItem("user_label"),
            kategori: document.getElementById('kat').value,
            keterangan: document.getElementById('ket').value,
            lokasi: linkMaps,
            foto: dI.data.url
        })
    });
    alert("Laporan Terkirim!"); location.reload();
}
