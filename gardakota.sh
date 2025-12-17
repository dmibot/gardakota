#!/bin/bash

# INTEGRASI URL SAKTI BAPAK
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "💎 MEMBANGUN EKOSISTEM GARDA DUMAI KOTA - KUALITAS SIGAP..."

# 1. STRUKTUR FOLDER
mkdir -p css assets/img modul/aksi modul/peta modul/admin modul/operator

# 2. CSS GLOBAL (style.css) - Desain Modern & Clean
cat << 'EOF' > css/style.css
:root { --primary: #2e7d32; --primary-dark: #1b5e20; --accent: #d32f2f; --bg: #f4f7f6; }
body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: var(--bg); padding-bottom: 80px; }
.app-header { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; padding: 20px 15px; border-radius: 0 0 20px 20px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 12px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 1000; }
.app-header img { width: 45px; height: 45px; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 15px; padding: 15px; margin-bottom: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); position: relative; }
.badge { padding: 4px 8px; border-radius: 6px; font-size: 10px; color: white; font-weight: bold; text-transform: uppercase; }
.b-masuk { background: #9e9e9e; } .b-verifikasi { background: #0288d1; } .b-penanganan { background: #ff9800; } .b-selesai { background: #388e3c; }
.btn-main { background: var(--primary); color: white; border: none; padding: 14px; border-radius: 12px; width: 100%; font-weight: bold; cursor: pointer; text-decoration: none; display: block; text-align: center; box-sizing: border-box; font-size: 16px; transition: 0.3s; }
.btn-main:active { transform: scale(0.98); opacity: 0.9; }
input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 10px; font-size: 14px; box-sizing: border-box; }
.bottom-nav { position: fixed; bottom: 0; width: 100%; background: white; display: flex; padding: 12px 0; border-top: 1px solid #eee; z-index: 1000; box-shadow: 0 -2px 10px rgba(0,0,0,0.05); }
.nav-item { flex: 1; text-align: center; font-size: 11px; color: #999; text-decoration: none; }
.nav-item i { font-size: 22px; display: block; margin-bottom: 4px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
EOF

# 3. LANDING PAGE (index.html)
cat << EOF > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Garda Dumai Kota</title><link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-header">
        <img src="assets/img/garda-dumaikota.png" alt="Logo">
        <div style="text-align:center;">
            <div style="font-size:10px; opacity:0.8; letter-spacing:1px;">PEMERINTAH KOTA DUMAI</div>
            <div style="font-size:16px; font-weight:bold;">GARDA DUMAI KOTA</div>
        </div>
        <i class="fas fa-bell"></i>
    </div>
    <div class="container">
        <div class="card" style="background: #fff5f5; border-left: 5px solid #d32f2f;">
            <h4 style="margin:0 0 5px 0; color:#d32f2f;"><i class="fas fa-house-crack"></i> Gempa Terkini (BMKG)</h4>
            <div id="gempa-info" style="font-size:13px; font-weight:600;">Menghubungkan ke BMKG...</div>
        </div>
        <div style="display:flex; gap:10px; margin-bottom:15px;">
            <div class="card" style="flex:1; text-align:center; margin-bottom:0;"><h2 id="st-proses" style="color:#f39c12; margin:0">0</h2><small>DALAM PROSES</small></div>
            <div class="card" style="flex:1; text-align:center; margin-bottom:0;"><h2 id="st-selesai" style="color:#2ecc71; margin:0">0</h2><small>LAPORAN SELESAI</small></div>
        </div>
        <div class="card">
            <h4 style="margin:0 0 10px 0;"><i class="fas fa-cloud-sun"></i> Cuaca Dumai Kota</h4>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <div id="w-desc">Cerah Berawan</div>
                <h3 id="w-temp" style="margin:0">30°C</h3>
            </div>
        </div>
        <a href="modul/aksi/index.html" class="btn-main"><i class="fas fa-plus-circle"></i> BUAT LAPORAN KEJADIAN</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-home"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-marked-alt"></i>Peta</a>
        <a href="modul/admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Petugas</a>
    </nav>
    <script>
        async function loadDashboard() {
            try {
                const r = await fetch('$URL_SAKTI');
                const d = await r.json();
                const p = d.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
                const s = d.laporan.filter(i => i[6] === 'Selesai').length;
                document.getElementById('st-proses').innerText = p;
                document.getElementById('st-selesai').innerText = s;
                
                const gRes = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
                const gData = await gRes.json();
                const g = gData.Infogempa.gempa;
                document.getElementById('gempa-info').innerHTML = \`M \${g.Magnitude} | \${g.Wilayah} <br><small>\${g.Tanggal} \${g.Jam}</small>\`;
            } catch (e) { console.log(e); }
        }
        loadDashboard();
    </script>
</body>
</html>
EOF

# 4. LOGIN PETUGAS (modul/admin/login.html)
cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Login Garda Kota</title>
</head>
<body style="background:linear-gradient(135deg, #2e7d32, #1b5e20); height:100vh; display:flex; align-items:center; justify-content:center;">
    <div class="container">
        <div class="card" style="text-align:center; padding:30px;">
            <img src="../../assets/img/garda-dumaikota.png" style="width:100px; margin-bottom:15px;">
            <h3 style="margin:0;">OTENTIKASI PETUGAS</h3>
            <p style="font-size:12px; color:#888; margin-bottom:20px;">Masukkan Kode Akses Khusus</p>
            <input type="text" id="user" placeholder="Username">
            <input type="password" id="pass" placeholder="Password">
            <button class="btn-main" onclick="auth()">MASUK KE SISTEM</button>
            <a href="../../index.html" style="display:block; margin-top:15px; font-size:12px; color:#aaa; text-decoration:none;">Kembali ke Beranda</a>
        </div>
    </div>
    <script>
        const admins = ["camat", "sekcam", "trantib", "kapolsek", "danramil", "binmas", "ramil01"];
        const kels = ["rimbas", "sukajadi", "laksamana", "dumaikota", "bintan"];
        const roles = ["lurah", "babinsa", "bhabin", "trantibkel", "pamong"];

        async function auth(){
            const u = document.getElementById('user').value.toLowerCase();
            const p = document.getElementById('pass').value;
            let role = "", label = "";

            if(admins.includes(u) && p === "dksiaga"){
                role = "admin"; label = u.toUpperCase();
            } else {
                kels.forEach(k => roles.forEach(r => {
                    if(u === \`\${r}-\${k}\` && p === "pantaudk"){
                        role = "operator"; label = u.toUpperCase().replace("-"," ");
                    }
                }));
            }

            if(role){
                localStorage.setItem("role", role); localStorage.setItem("user_label", label);
                // Log Login
                fetch('$URL_SAKTI', { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'log', user:label }) });
                window.location.href = role === "admin" ? "index.html" : "../operator/index.html";
            } else alert("Username atau Password Salah!");
        }
    </script>
</body>
</html>
EOF

# 5. OPERATOR MODUL (modul/operator/index.html) - Auto-Fill Nama
cat << EOF > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Operator - Garda Kota</title>
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;"><i class="fas fa-user-circle"></i> OPERATOR PANEL</div>
        <i class="fas fa-sign-out-alt" onclick="localStorage.clear(); window.location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card" style="background:#e8f5e9; border:1px solid #2e7d32;">
            <small>Petugas:</small><h4 id="u-name" style="margin:0;">-</h4>
        </div>
        <div class="card">
            <label>Kategori</label>
            <select id="kat"><option>Drainase/Banjir</option><option>Sampah Liar</option><option>Kebakaran</option><option>Kamtibmas</option></select>
            <textarea id="ket" placeholder="Deskripsikan kejadian..."></textarea>
            <div id="gps" style="background:#eee; padding:10px; border-radius:10px; font-size:11px; margin-bottom:10px;">📍 Lokasi GPS Belum Dikunci</div>
            <button class="btn-main" style="background:#0288d1; margin-bottom:10px;" onclick="getGps()">KUNCI LOKASI</button>
            <input type="file" id="foto" accept="image/*" capture="camera">
            <button class="btn-main" id="btn" style="margin-top:10px;" onclick="kirim()">🚀 KIRIM LAPORAN CEPAT</button>
        </div>
    </div>
    <script>
        const label = localStorage.getItem("user_label");
        if(!label || localStorage.getItem("role")!=="operator") window.location.href="../admin/login.html";
        document.getElementById('u-name').innerText = label;

        let lat="", lng="";
        function getGps(){
            navigator.geolocation.getCurrentPosition(p => {
                lat=p.coords.latitude; lng=p.coords.longitude;
                document.getElementById('gps').innerText = "✅ LOKASI TERKUNCI";
            });
        }

        async function kirim(){
            const f = document.getElementById('foto').files[0];
            if(!f || !lat) return alert("Foto dan GPS Wajib!");
            document.getElementById('btn').innerText = "⌛ Mengirim...";
            
            let fd = new FormData(); fd.append("image", f);
            let rI = await fetch("https://api.imgbb.com/1/upload?key=$IMGBB_KEY", {method:"POST", body:fd});
            let dI = await rI.json();
            
            await fetch('$URL_SAKTI', {
                method: 'POST', mode: 'no-cors',
                body: JSON.stringify({ nama:label, kategori:document.getElementById('kat').value, keterangan:document.getElementById('ket').value, lokasi:\`http://maps.google.com/maps?q=\${lat},\${lng}\`, foto:dI.data.url })
            });
            alert("Berhasil!"); window.location.reload();
        }
    </script>
</body>
</html>
EOF

# 6. ADMIN COMMAND CENTER (modul/admin/index.html) - Verif, Tangani, Selesai
cat << EOF > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Command Center</title>
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;">COMMAND CENTER</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); window.location.href='login.html'"></i>
    </div>
    <div class="container">
        <div class="card">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
                <h4 style="margin:0;"><i class="fas fa-clock-rotate-left"></i> Aktivitas Petugas</h4>
                <small id="log-count">0 Aktivitas</small>
            </div>
            <div id="log-list" style="font-size:11px; color:#666; max-height:80px; overflow-y:auto;"></div>
        </div>
        <div class="card">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
                <h4 style="margin:0;"><i class="fas fa-tasks"></i> Workflow Laporan</h4>
                <button onclick="window.print()" class="btn-main" style="width:auto; padding:5px 10px; font-size:10px;">Cetak</button>
            </div>
            <div id="list">Memuat Data...</div>
        </div>
    </div>
    <script>
        if(localStorage.getItem("role")!=="admin") window.location.href="login.html";
        async function load(){
            const r = await fetch('$URL_SAKTI');
            const d = await r.json();
            
            // Render Logs
            let lH = "";
            d.logs.reverse().slice(0,10).forEach(l => { lH += \`<div>[\${new Date(l[0]).toLocaleTimeString()}] \${l[1]} Login</div>\`; });
            document.getElementById('log-list').innerHTML = lH;
            document.getElementById('log-count').innerText = d.logs.length + " Total";

            // Render Workflow
            let html = "";
            d.laporan.reverse().forEach((i, idx) => {
                if(idx === d.laporan.length - 1) return;
                html += \`<div class="card" style="padding:10px; border-left:5px solid var(--primary);">
                    <div style="display:flex; justify-content:space-between;">
                        <small>\${i[1]}</small>
                        <span class="badge b-\${i[6].toLowerCase()}">\${i[6]}</span>
                    </div>
                    <p style="font-size:12px; margin:5px 0;">\${i[3]}</p>
                    <div style="display:flex; gap:5px; margin-top:10px;">
                        <button class="btn-main" style="flex:1; padding:5px; font-size:10px; background:#0288d1" onclick="upd('\${i[0]}','Verifikasi')">VERIF</button>
                        <button class="btn-main" style="flex:1; padding:5px; font-size:10px; background:#ff9800" onclick="upd('\${i[0]}','Penanganan')">TANGANI</button>
                        <button class="btn-main" style="flex:1; padding:5px; font-size:10px; background:#388e3c" onclick="upd('\${i[0]}','Selesai')">DONE</button>
                        <a href="\${i[5]}" target="_blank" class="btn-main" style="flex:0.5; padding:5px; font-size:10px; background:#444"><i class="fas fa-image"></i></a>
                    </div>
                </div>\`;
            });
            document.getElementById('list').innerHTML = html;
        }
        async function upd(ts, st){
            if(!confirm("Proses ke "+st+"?")) return;
            await fetch('$URL_SAKTI', { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:ts, status:st }) });
            alert("Status Diperbarui!"); window.location.reload();
        }
        load();
    </script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "🌟 GARDA DUMAI KOTA PARIPURNA BERHASIL DIINSTAL!"
echo "📍 Dashboard Utama: index.html"
echo "📍 Login Admin/Staf: modul/admin/login.html"
echo "-------------------------------------------------------"