#!/bin/bash

echo "💎 MEMBANGUN SISTEM COMMAND CENTER & WORKFLOW GARDA DUMAI KOTA..."

# 1. STRUKTUR FOLDER
mkdir -p css assets/img modul/aksi modul/peta modul/admin modul/operator

# 2. CSS WORKFLOW (style.css)
cat << 'EOF' > css/style.css
:root { 
    --primary: #2e7d32; --primary-dark: #1b5e20;
    --accent: #d32f2f; --warning: #ff9800; --info: #0288d1; --done: #388e3c;
    --bg: #f4f7f6; --white: #ffffff;
}
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 80px; }
.app-header { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; padding: 20px 15px; border-radius: 0 0 20px 20px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 12px rgba(0,0,0,0.2); }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 15px; padding: 15px; margin-bottom: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

/* Status Badges */
.badge { padding: 4px 8px; border-radius: 6px; font-size: 10px; color: white; font-weight: bold; text-transform: uppercase; }
.b-masuk { background: #9e9e9e; }
.b-verif { background: var(--info); }
.b-proses { background: var(--warning); }
.b-selesai { background: var(--done); }

.btn-main { background: var(--primary); color: white; border: none; padding: 12px; border-radius: 10px; width: 100%; font-weight: bold; cursor: pointer; display: block; text-align: center; text-decoration: none; box-sizing: border-box; }
.btn-sm { padding: 5px 10px; font-size: 11px; border: none; border-radius: 5px; color: white; cursor: pointer; margin-right: 5px; }

input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 10px; font-size: 14px; box-sizing: border-box; }
.bottom-nav { position: fixed; bottom: 0; width: 100%; background: white; display: flex; padding: 10px 0; border-top: 1px solid #eee; z-index: 1000; }
.nav-item { flex: 1; text-align: center; font-size: 11px; color: #999; text-decoration: none; }
.nav-item i { font-size: 20px; display: block; margin-bottom: 3px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
EOF

# 3. LOGIN SISTEM (modul/admin/login.html)
cat << 'EOF' > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Login Garda Kota</title>
</head>
<body style="background:linear-gradient(135deg, #2e7d32, #1b5e20); height:100vh; display:flex; align-items:center;">
    <div class="container" style="text-align:center;">
        <div class="card">
            <img src="../../assets/img/garda-dumaikota.png" style="width:80px; margin-bottom:10px;">
            <h3 style="margin-bottom:20px">SISTEM LOGIN GARDA</h3>
            <input type="text" id="user" placeholder="Username">
            <input type="password" id="pass" placeholder="Password">
            <button class="btn-main" onclick="auth()">MASUK</button>
        </div>
    </div>
    <script>
        const SCRIPT_URL = "URL_APPS_SCRIPT_BAPAK";
        const admins = ["camat", "sekcam", "trantib", "kapolsek", "danramil", "binmas", "ramil01"];
        const kel = ["rimbas", "sukajadi", "laksamana", "dumaikota", "bintan"];
        const roles = ["lurah", "babinsa", "bhabin", "trantibkel", "pamong"];

        async function auth() {
            const u = document.getElementById('user').value.toLowerCase();
            const p = document.getElementById('pass').value;

            let role = "", label = "";
            if (admins.includes(u) && p === "dksiaga") {
                role = "admin"; label = u.toUpperCase();
            } else {
                kel.forEach(k => roles.forEach(r => {
                    if (u === `${r}-${k}` && p === "pantaudk") {
                        role = "operator"; label = u.toUpperCase().replace('-', ' ');
                    }
                }));
            }

            if (role) {
                localStorage.setItem("role", role);
                localStorage.setItem("user_label", label);
                // Log Aktivitas ke Google Sheets
                fetch(SCRIPT_URL, { method: 'POST', mode: 'no-cors', body: JSON.stringify({ action: 'log', user: label }) });
                window.location.href = role === "admin" ? "index.html" : "../operator/index.html";
            } else alert("Akses Ditolak!");
        }
    </script>
</body>
</html>
EOF

# 4. MODUL OPERATOR (modul/operator/index.html)
cat << 'EOF' > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Operator Lapor</title>
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;">OPERATOR LAPOR</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); window.location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card" style="background:#e8f5e9;">
            <small>Petugas Pelapor:</small>
            <h4 id="user-name" style="margin:0;">-</h4>
        </div>
        <div class="card">
            <select id="kat"><option>Drainase/Banjir</option><option>Sampah</option><option>Kamtibmas</option></select>
            <textarea id="ket" placeholder="Keterangan kejadian..."></textarea>
            <button class="btn-main" style="background:#0288d1; margin-bottom:10px;" onclick="getGPS()">📍 KUNCI LOKASI</button>
            <input type="file" id="foto" accept="image/*" capture="camera">
            <button class="btn-main" id="btnKirim" style="margin-top:10px;" onclick="kirim()">🚀 KIRIM LAPORAN</button>
        </div>
    </div>
    <script>
        const label = localStorage.getItem("user_label");
        if(!label) window.location.href="../admin/login.html";
        document.getElementById('user-name').innerText = label;

        let lat="", lng="";
        function getGPS(){
            navigator.geolocation.getCurrentPosition(p => {
                lat = p.coords.latitude; lng = p.coords.longitude;
                alert("Lokasi Terkunci!");
            });
        }
        function kirim(){ alert("Mengirim Laporan..."); }
    </script>
</body>
</html>
EOF

# 5. MODUL ADMIN COMMAND CENTER (modul/admin/index.html)
cat << 'EOF' > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Admin Dashboard</title>
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;">COMMAND CENTER</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); window.location.href='login.html'"></i>
    </div>
    <div class="container">
        <div class="card">
            <h4 style="margin:0 0 10px 0;"><i class="fas fa-history"></i> Log Aktivitas Login</h4>
            <div id="log-list" style="font-size:11px; max-height:100px; overflow-y:auto;">Memuat log...</div>
        </div>

        <div class="card">
            <h4><i class="fas fa-tasks"></i> Workflow Tahapan Laporan</h4>
            <div id="report-list">Memuat laporan...</div>
        </div>
    </div>
    <script>
        const label = localStorage.getItem("user_label");
        if(localStorage.getItem("role")!=="admin") window.location.href="login.html";

        function updateWorkflow(id, nextStatus) {
            if(confirm("Ubah status laporan ke " + nextStatus + "?")){
                alert("Status diperbarui menjadi " + nextStatus);
                // Logika fetch update ke Google Sheets
            }
        }

        // Dummy Data Workflow
        const reports = [
            { id: 1, tgl: '18/12', user: 'LURAH RIMBAS', status: 'Masuk' },
            { id: 2, tgl: '18/12', user: 'BABINSA BINTAN', status: 'Verifikasi' }
        ];

        let html = "";
        reports.forEach(r => {
            html += `<div style="border-bottom:1px solid #eee; padding:10px 0;">
                <small>${r.tgl} - <b>${r.user}</b></small><br>
                <span class="badge b-${r.status.toLowerCase()}">${r.status}</span>
                <div style="margin-top:5px;">
                    <button class="btn-sm" style="background:#0288d1" onclick="updateWorkflow(${r.id}, 'Verifikasi')">Verif</button>
                    <button class="btn-sm" style="background:#ff9800" onclick="updateWorkflow(${r.id}, 'Penanganan')">Tangani</button>
                    <button class="btn-sm" style="background:#388e3c" onclick="updateWorkflow(${r.id}, 'Selesai')">Selesai</button>
                </div>
            </div>`;
        });
        document.getElementById('report-list').innerHTML = html;
    </script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ SISTEM WORKFLOW GARDA DUMAI KOTA SIAP!"
echo "📍 Password Admin: dksiaga | Password Operator: pantaudk"
echo "-------------------------------------------------------"