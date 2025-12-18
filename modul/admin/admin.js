const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
let aLat, aLng;

navigator.geolocation.getCurrentPosition(p => {
    aLat = p.coords.latitude; aLng = p.coords.longitude;
    loadAdmin();
}, () => loadAdmin());

function calcDist(lat2, lon2) {
    if(!aLat) return "";
    const R = 6371;
    const dLat = (lat2-aLat) * Math.PI / 180;
    const dLon = (lon2-aLng) * Math.PI / 180;
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(aLat * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLon/2) * Math.sin(dLon/2);
    const d = R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return `📍 ${d.toFixed(1)} km (${Math.round(d*4)} mnt)`;
}

async function loadAdmin() {
    const r = await fetch(SAKTI);
    const d = await r.json();
    let h = "";
    d.laporan.reverse().forEach((i, idx) => {
        if(idx === d.laporan.length - 1 || !i[0]) return;
        let dist = "";
        const m = i[4].match(/query=(-?\d+\.\d+),(-?\d+\.\d+)/);
        if(m) dist = calcDist(parseFloat(m[1]), parseFloat(m[2]));

        h += `<div class="card">
            <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                <small><b>${i[1]}</b> • ${i[2]}</small>
                <b style="font-size:10px; color:#d32f2f;">${dist}</b>
            </div>
            <p style="font-size:13px; color:#444; margin:5px 0;">${i[3]}</p>
            <div style="display:flex; gap:8px; margin-top:12px;">
                <a href="${i[4]}" target="_blank" class="btn-main" style="background:#eee; color:#333; flex:1; height:35px; font-size:11px;">MAPS</a>
                <a href="${i[5]}" target="_blank" class="btn-main" style="background:#eee; color:#333; flex:1; height:35px; font-size:11px;">FOTO</a>
                <button onclick="upd('${i[0]}','Selesai')" class="btn-main" style="background:#2ecc71; flex:1; height:35px; font-size:11px;">DONE</button>
            </div>
        </div>`;
    });
    document.getElementById('wf-list').innerHTML = h;
}

async function upd(id, st) {
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:id, status:st }) });
    location.reload();
}
loadAdmin();
