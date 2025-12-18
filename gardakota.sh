#!/bin/bash

URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "🚨 MEROMBAK TOTAL UX GARDA DUMAI KOTA - STANDAR ELITE..."

# 1. MASTER CSS (REVOLUSI VISUAL)
cat << 'EOF' > css/style.css
:root { 
    --midnight: #001a4d; --blue-accent: #0d47a1; 
    --gold: #ffeb3b; --danger: #d32f2f; --bg: #f8f9fa;
    --h: 55px; --nav: 65px;
}
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
body { 
    font-family: 'Segoe UI', Roboto, sans-serif; margin: 0; background: var(--bg);
    padding-top: calc(var(--h) + 10px); padding-bottom: calc(var(--nav) + 20px);
    line-height: 1.4; color: #333;
}
/* Header Tipis & Tajam */
.app-header { 
    height: var(--h); background: var(--midnight); color: white;
    display: flex; align-items: center; justify-content: space-between;
    padding: 0 15px; position: fixed; top: 0; width: 100%; z-index: 2000;
    border-bottom: 3px solid var(--gold); box-shadow: 0 3px 6px rgba(0,0,0,0.2);
}
.app-header h1 { font-size: 15px; font-weight: 800; letter-spacing: 1px; margin: 0; }

/* Container & Card Modern */
.container { padding: 0 12px; max-width: 500px; margin: auto; }
.card { 
    background: white; border-radius: 10px; padding: 12px; margin-bottom: 12px;
    border: 1px solid #e0e0e0; box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}
.card-title { font-size: 13px; font-weight: 700; color: var(--midnight); border-bottom: 1px solid #eee; padding-bottom: 5px; margin-bottom: 8px; display: flex; justify-content: space-between; }

/* Tombol Aksi Kompak */
.btn-group { display: flex; gap: 6px; margin-top: 10px; }
.btn-small { 
    flex: 1; height: 36px; border-radius: 6px; border: none; font-size: 11px; 
    font-weight: 700; cursor: pointer; display: flex; align-items: center; 
    justify-content: center; text-decoration: none; text-transform: uppercase;
}
.btn-blue { background: var(--blue-accent); color: white; }
.btn-dark { background: #333; color: white; }
.btn-green { background: #2e7d32; color: white; }

/* Bottom Nav Simetris */
.bottom-nav { 
    height: var(--nav); position: fixed; bottom: 0; width: 100%; 
    background: white; display: flex; border-top: 1px solid #ddd; z-index: 2000;
    padding-bottom: 5px;
}
.nav-item { 
    flex: 1; display: flex; flex-direction: column; align-items: center; 
    justify-content: center; color: #757575; text-decoration: none; font-size: 10px;
}
.nav-item i { font-size: 18px; margin-bottom: 3px; }
.nav-item.active { color: var(--blue-accent); font-weight: 900; }
EOF

# 2. ADMIN JS (SINKRONISASI JARAK & UI BARU)
cat << EOF > modul/admin/admin.js
const SAKTI = "$URL_SAKTI";
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
    return \`\${d.toFixed(1)}km\`;
}

async function loadAdmin() {
    try {
        const r = await fetch(SAKTI);
        const d = await r.json();
        let h = "";
        d.laporan.reverse().forEach((i, idx) => {
            if(idx === d.laporan.length - 1 || !i[0]) return;
            let dist = "";
            const m = i[4].match(/query=(-?\\d+\\.\\d+),(-?\\d+\\.\\d+)/);
            if(m) dist = calcDist(parseFloat(m[1]), parseFloat(m[2]));

            h += \`<div class="card">
                <div class="card-title">
                    <span>\${i[1]} • \${i[2]}</span>
                    <span style="color:var(--danger)">\${dist}</span>
                </div>
                <div style="font-size:12px; color:#555; margin-bottom:10px;">\${i[3]}</div>
                <div class="btn-group">
                    <a href="\${i[4]}" target="_blank" class="btn-small btn-blue">MAPS</a>
                    <a href="\${i[5]}" target="_blank" class="btn-small btn-dark">FOTO</a>
                    <button onclick="upd('\${i[0]}','Selesai')" class="btn-small btn-green">DONE</button>
                </div>
            </div>\`;
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
EOF

echo "-------------------------------------------------------"
echo "✅ REVOLUSI SELESAI! Silakan Bapak cek Modul Admin."
echo "📍 Tampilan sekarang tajam, simetris, dan fungsional."
echo "-------------------------------------------------------"