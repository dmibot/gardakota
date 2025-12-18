const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";

if(localStorage.getItem("role") !== "admin") window.location.href="login.html";

async function loadData() {
    try {
        const res = await fetch(SAKTI);
        const d = await res.json();
        
        // 1. Render Log Aktivitas
        let logH = "";
        d.logs.reverse().slice(0,10).forEach(l => {
            logH += `<div style="font-size:11px; padding:5px; border-bottom:1px solid #eee;">
                [${new Date(l[0]).toLocaleTimeString()}] <b>${l[1]}</b>: ${l[2]}
            </div>`;
        });
        document.getElementById('log-list').innerHTML = logH;

        // 2. Render Daftar Laporan (DENGAN TOMBOL LOKASI)
        let html = "";
        d.laporan.reverse().forEach((i, idx) => {
            // Lewati header atau baris kosong
            if(idx === d.laporan.length - 1 || !i[0]) return;

            // AMBIL DATA DARI KOLOM SPREADSHEET (Asumsi: i[4] adalah kolom lokasi)
            const linkLokasi = i[4] || "#"; 

            html += `<div class="card" style="border-left:5px solid #0d47a1; margin-bottom:15px;">
                <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                    <div>
                        <small><b>${i[1]}</b> (${i[2]})</small><br>
                        <small style="color:#666;">${new Date(i[0]).toLocaleString('id-ID')}</small>
                    </div>
                    <span class="badge b-${i[6].toLowerCase()}" style="padding:4px 8px; border-radius:5px; font-size:10px; color:white;">${i[6]}</span>
                </div>
                
                <p style="font-size:14px; margin:10px 0; color:#333; font-weight:500;">${i[3]}</p>
                
                <div style="display:flex; gap:8px; margin-bottom:10px;">
                    <a href="${linkLokasi}" target="_blank" class="btn-main" style="background:#0288d1; margin:0; padding:10px; flex:1; font-size:12px;">
                        <i class="fas fa-map-marker-alt"></i> LOKASI TKP
                    </a>
                    <a href="${i[5]}" target="_blank" class="btn-main" style="background:#333; margin:0; padding:10px; flex:1; font-size:12px;">
                        <i class="fas fa-image"></i> LIHAT FOTO
                    </a>
                </div>

                <div style="display:flex; gap:5px;">
                    <button class="btn-main" style="padding:8px; font-size:10px; background:#ff9800; flex:1; margin:0;" onclick="updStatus('${i[0]}','Penanganan')">TANGANI</button>
                    <button class="btn-main" style="padding:8px; font-size:10px; background:#388e3c; flex:1; margin:0;" onclick="updStatus('${i[0]}','Selesai')">DONE</button>
                </div>
            </div>`;
        });
        document.getElementById('wf-list').innerHTML = html;
    } catch(e) { 
        console.error("Gagal Sinkronisasi Data!"); 
    }
}

async function updStatus(id, st) {
    if(!confirm("Ubah laporan ini menjadi " + st + "?")) return;
    await fetch(SAKTI, { 
        method:'POST', 
        mode:'no-cors', 
        body: JSON.stringify({ action:'updateStatus', id:id, status:st }) 
    });
    alert("Status Berhasil Diperbarui!"); 
    loadData();
}

// Refresh otomatis setiap 20 detik agar Dashboard tetap Live
setInterval(loadData, 20000);
loadData();