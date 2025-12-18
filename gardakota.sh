#!/bin/bash

# Aset Logo yang PASTI muncul (Wikimedia)
URL_LOGO="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png"
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "⚙️ Memperbaiki Jalur Navigasi & Logo..."

# 1. Pastikan Header di SEMUA Modul punya tombol HOME
# --- MODUL OPERATOR ---
cat << EOF > modul/operator/index.html
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
        <a href="../../index.html" class="header-icon" style="color:white;"><i class="fas fa-home"></i></a>
        <h1>PANEL OPERATOR</h1>
        <i class="fas fa-sign-out-alt" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card">
            <small>Petugas:</small> <b id="op-name">-</b>
        </div>
        <div class="card">
            <button class="btn-main" onclick="trackGPS()" style="background:#333; margin-bottom:10px;">KUNCI GPS</button>
            <div id="gps-box" style="text-align:center; font-size:12px; padding:10px; background:#eee; border-radius:8px;">GPS Belum Kunci</div>
            <select id="kat" style="margin-top:15px;">
                <option>Banjir Rob</option><option>Sampah</option><option>Kamtibmas</option><option>Kebakaran</option>
            </select>
            <textarea id="ket" placeholder="Keterangan..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnLapor" onclick="kirim()" style="margin-top:15px;">KIRIM LAPORAN</button>
        </div>
    </div>
    <script src="operator.js"></script>
</body>
</html>
EOF

# --- MODUL ADMIN ---
cat << EOF > modul/admin/index.html
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
        <a href="../../index.html" class="header-icon" style="color:white;"><i class="fas fa-home"></i></a>
        <h1>COMMAND CENTER</h1>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='login.html'"></i>
    </div>
    <div class="container">
        <div id="wf-list">Memuat laporan...</div>
    </div>
    <script src="admin.js"></script>
</body>
</html>
EOF

# 2. Fix Logo di Halaman Login
cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <title>Login</title>
</head>
<body style="display:flex; align-items:center; justify-content:center; height:100vh; background:#f0f2f5;">
    <div class="card" style="text-align:center; width:320px;">
        <img src="$URL_LOGO" width="80" style="margin-bottom:15px;">
        <h2 style="margin:0; color:#002171;">GARDA DUMAI</h2>
        <input type="text" id="user" placeholder="Username" style="margin-top:20px;">
        <input type="password" id="pass" placeholder="Password">
        <button class="btn-main" onclick="auth()">MASUK</button>
    </div>
    <script>
        function auth() {
            const u = document.getElementById('user').value.toLowerCase();
            const p = document.getElementById('pass').value;
            // Logika login Bapak sebelumnya di sini...
            if(u === 'camat' && p === 'dksiaga') {
                localStorage.setItem("role", "admin");
                localStorage.setItem("user_label", "CAMAT");
                window.location.href = "index.html";
            } else if(p === 'pantaudk') {
                localStorage.setItem("role", "operator");
                localStorage.setItem("user_label", u.toUpperCase());
                window.location.href = "../operator/index.html";
            } else { alert("Salah!"); }
        }
    </script>
</body>
</html>
EOF

# 3. Fix CSS Header agar Ikon Muncul Benar
cat << 'EOF' > css/style.css
:root { --primary: #0066FF; --dark: #001a4d; --bg: #f4f7f6; --h: 60px; }
body { font-family: sans-serif; margin: 0; background: var(--bg); padding-top: var(--h); }
.app-header { 
    height: var(--h); background: var(--dark); color: white; 
    display: flex; align-items: center; padding: 0 15px; 
    position: fixed; top: 0; width: 100%; z-index: 2000;
    justify-content: space-between;
}
.app-header h1 { font-size: 14px; margin: 0; flex: 1; text-align: center; }
.header-icon { width: 30px; font-size: 20px; text-decoration: none; }
.container { padding: 15px; }
.card { background: white; border-radius: 12px; padding: 15px; margin-bottom: 12px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
.btn-main { background: var(--primary); color: white; border: none; padding: 12px; border-radius: 8px; width: 100%; font-weight: bold; cursor: pointer; }
input, select, textarea { width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
EOF

echo "✅ Selesai. Silakan cek kembali."