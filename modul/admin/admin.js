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
    return `${d.toFixed(1)}km`;
}

async function loadAdmin() {
    try {
        const r = await fetch(SAKTI);
        const d = await r.json();
        let h = "";
        d.laporan.reverse().forEach((i, idx) => {
            if(idx === d.laporan.length - 1 || !i[0]) return;
            let dist = "";
            const m = i[4].match(/query=(-?\d+\.\d+),(-?\d+\.\d+)/);
            if(m) dist = calcDist(parseFloat(m[1]), parseFloat(m[2]));

            h += `<div class="card">
                <div class="card-title">
                    <span>${i[1]} • ${i[2]}</span>
                    <span style="color:var(--danger)">${dist}</span>
                </div>
                <div style="font-size:12px; color:#555; margin-bottom:10px;">${i[3]}</div>
                <div class="btn-group">
                    <a href="${i[4]}" target="_blank" class="btn-small btn-blue">MAPS</a>
                    <a href="${i[5]}" target="_blank" class="btn-small btn-dark">FOTO</a>
                    <button onclick="upd('${i[0]}','Selesai')" class="btn-small btn-green">DONE</button>
                </div>
            </div>`;
        });
        document.getElementById('wf-list').innerHTML = h;
    } catch(e) { document.getElementById('wf-list').innerHTML = "Gagal memuat data..."; }
}

async function upd(id, st) {
    if(!confirm("Selesaikan laporan?")) return;
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:id, status:st }) });
    location.reload();
}
setInterval(loadAdmin, 30000);
