const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
if(localStorage.getItem("role") !== "admin") window.location.href="login.html";

async function loadData() {
    try {
        const r = await fetch(SAKTI);
        const d = await r.json();
        
        // Cek Sinyal Tracking Terakhir (Ping)
        const lastLog = d.logs[d.logs.length - 1];
        if (lastLog && lastLog[2].includes("Melacak")) {
            const timeDiff = (new Date().getTime() - new Date(lastLog[0]).getTime()) / 1000;
            if (timeDiff < 20) { // Jika ping terjadi dalam 20 detik terakhir
                showPingAlert(lastLog[1]);
            }
        }

        let logH = "";
        d.logs.reverse().slice(0,10).forEach(l => {
            logH += `<div>[${new Date(l[0]).toLocaleTimeString()}] ${l[1]} ${l[2]}</div>`;
        });
        document.getElementById('log-list').innerHTML = logH;

        let html = "";
        d.laporan.reverse().forEach((i, idx) => {
            if(idx === d.laporan.length - 1 || !i[0]) return;
            html += `<div class="card" style="border-left:5px solid var(--primary);">
                <div style="display:flex; justify-content:space-between;">
                    <small><b>${i[1]}</b> | ${new Date(i[0]).toLocaleDateString()}</small>
                    <span class="badge b-${i[6].toLowerCase()}">${i[6]}</span>
                </div>
                <p style="font-size:13px; margin:10px 0;">${i[3]}</p>
                <div style="display:flex; gap:5px;">
                    <button class="btn-main" style="padding:5px; font-size:10px; background:#0288d1; flex:1;" onclick="updStatus('${i[0]}','Verifikasi')">VERIF</button>
                    <button class="btn-main" style="padding:5px; font-size:10px; background:#ff9800; flex:1;" onclick="updStatus('${i[0]}','Penanganan')">TANGANI</button>
                    <button class="btn-main" style="padding:5px; font-size:10px; background:#388e3c; flex:1;" onclick="updStatus('${i[0]}','Selesai')">DONE</button>
                    <a href="${i[5]}" target="_blank" class="btn-main" style="padding:5px; background:#333; width:40px;"><i class="fas fa-image"></i></a>
                </div>
            </div>`;
        });
        document.getElementById('wf-list').innerHTML = html;
    } catch(e) { console.error(e); }
}

function showPingAlert(user) {
    const alertBox = document.getElementById('ping-alert');
    alertBox.innerHTML = `<i class="fas fa-location-dot"></i> <b>SIAGA!</b> ${user} sedang berada di TKP & melakukan pelacakan lokasi.`;
    alertBox.style.display = 'block';
    setTimeout(() => { alertBox.style.display = 'none'; }, 8000);
}

async function updStatus(id, st) {
    if(!confirm("Ubah status ke " + st + "?")) return;
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:id, status:st }) });
    alert("Berhasil!"); window.location.reload();
}

setInterval(loadData, 10000); // Auto-refresh setiap 10 detik
loadData();
