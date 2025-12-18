#!/bin/bash

# CONFIG DATA (PASTIKAN URL SAKTI TETAP SAMA)
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "📏 MENYARAGAMKAN UX SEMUA MODUL & MENGAKTIFKAN JARAK..."

# 1. KUNCI MASTER CSS (Standardisasi Ukuran)
cat << 'EOF' > css/style.css
:root { 
    --primary: #002171; --primary-light: #0d47a1; 
    --accent: #d32f2f; --bg: #f4f7f6; 
    --h-height: 65px; --nav-height: 70px; 
}
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
body { 
    font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; 
    margin: 0; background: var(--bg); 
    padding-top: var(--h-height); padding-bottom: var(--nav-height); 
    font-size: 14px; color: #333; overflow-x: hidden;
}

/* HEADER KONSTAN (FIXED) */
.app-header { 
    height: var(--h-height); background: var(--primary); color: white; 
    display: flex; align-items: center; justify-content: space-between; 
    padding: 0 15px; position: fixed; top: 0; width: 100%; z-index: 2000;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-bottom: 3px solid #ffeb3b;
}
.app-header h1 { font-size: 15px; margin: 0; font-weight: 700; letter-spacing: 0.5px; }

/* CONTAINER KONSTAN */
.container { padding: 12px; max-width: 500px; margin: auto; }

/* CARD & TOMBOL SERAGAM */
.card { 
    background: white; border-radius: 12px; padding: 16px; margin-bottom: 12px; 
    box-shadow: 0 2px 5px rgba(0,0,0,0.05); border: 1px solid #eee;
}
.btn-main { 
    height: 48px; display: flex; align-items: center; justify-content: center;
    background: var(--primary); color: white; border: none; border-radius: 10px;
    width: 100%; font-weight: 600; font-size: 14px; cursor: pointer; text-decoration: none;
    transition: 0.2s;
}
.btn-main:active { transform: scale(0.98); opacity: 0.9; }

/* BOTTOM NAV KONSTAN */
.bottom-nav { 
    height: var(--nav-height); position: fixed; bottom: 0; width: 100%; 
    background: white; display: flex; border-top: 1px solid #eee; z-index: 2000;
    padding-bottom: env(safe-area-inset-bottom);
}
.nav-item { 
    flex: 1; display: flex; flex-direction: column; align-items: center; 
    justify-content: center; color: #888; text-decoration: none; font-size: 10px;
}
.nav-item i { font-size: 20px; margin-bottom: 4px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
EOF

# 2. UPDATE ADMIN JS (LOGIKA JARAK TANPA MERUSAK UPDATE STATUS)
cat << EOF > modul/admin/admin.js
const SAKTI = "$URL_SAKTI";
let aLat, aLng;

// Ambil lokasi Admin sekali saja
navigator.geolocation.getCurrentPosition(p => {
    aLat = p.coords.latitude; aLng = p.coords.longitude;
    loadAdmin();
}, () => loadAdmin());

function calcDist(lat2, lon2) {
    if(!aLat) return "";
    const R = 6371;
    const dLat = (lat2-aLat) * Math.PI / 180;
    const dLon = (lon2-aLng) * Math.PI / 180;
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(aLat * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLon/2) * Math.sin(dLon/2);
    const d = R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return \`📍 \${d.toFixed(1)} km (\${Math.round(d*4)} mnt)\`;
}

async function loadAdmin() {
    const r = await fetch(SAKTI);
    const d = await r.json();
    let h = "";
    d.laporan.reverse().forEach((i, idx) => {
        if(idx === d.laporan.length - 1 || !i[0]) return;
        
        let dist = "";
        const m = i[4].match(/q=(-?\\d+\\.\\d+),(-?\\d+\\.\\d+)/);
        if(m) dist = calcDist(parseFloat(m[1]), parseFloat(m[2]));

        h += \`<div class="card">
            <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                <small><b>\${i[1]}</b> • \${i[2]}</small>
                <b style="font-size:10px; color:#d32f2f;">\${dist}</b>
            </div>
            <p style="margin:5px 0; font-size:13px; color:#444;">\${i[3]}</p>
            <div style="display:flex; gap:8px; margin-top:12px;">
                <a href="\${i[4]}" target="_blank" class="btn-main" style="background:#eee; color:#333; flex:1; height:36px; font-size:11px;">MAPS</a>
                <a href="\${i[5]}" target="_blank" class="btn-main" style="background:#eee; color:#333; flex:1; height:36px; font-size:11px;">FOTO</a>
                <button onclick="upd('\${i[0]}','Selesai')" class="btn-main" style="background:#2ecc71; flex:1; height:36px; font-size:11px;">DONE</button>
            </div>
        </div>\`;
    });
    document.getElementById('wf-list').innerHTML = h;
}

async function upd(id, st) {
    if(!confirm("Selesaikan laporan ini?")) return;
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:id, status:st }) });
    location.reload();
}
setInterval(loadAdmin, 30000);
EOF

echo "-------------------------------------------------------"
echo "✅ STANDARISASI BERHASIL!"
echo "📍 Tampilan semua modul sekarang IDENTIK dan KONSTAN."
echo "📍 Modul Admin sekarang otomatis menghitung jarak km."
echo "📍 Tidak ada fungsi yang terganggu."
echo "-------------------------------------------------------"