#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "⚙️  Membangun Pusat Database User & Proteksi (auth.js)..."

# 1. BUAT PUSAT AUTH (modul/aksi/auth.js)
# File ini akan dipanggil oleh semua modul untuk urusan login & satpam halaman
cat << EOF > modul/aksi/auth.js
// DATABASE USER & PASSWORD
const admins = ["camat", "sekcam", "trantib", "kapolsek", "danramil"];
const kels = ["rimbas", "sukajadi", "laksamana", "dumaikota", "bintan"];
const roles = ["lurah", "babinsa", "bhabin", "pamong", "trantib"];

function authSistem() {
    const u = document.getElementById('user').value.toLowerCase();
    const p = document.getElementById('pass').value;
    let role = "";
    let label = "";

    // Cek Grup Admin (Pass: dksiaga)
    if(admins.includes(u) && p === "dksiaga") { 
        role="admin"; 
        label=u.toUpperCase(); 
    }
    // Cek Grup Operator (Pass: pantaudk)
    else {
        kels.forEach(k => roles.forEach(r => {
            if(u === \`\${r}-\${k}\` && p === "pantaudk") { 
                role="operator"; 
                label=u.toUpperCase().replace("-"," "); 
            }
        }));
    }

    if(role) {
        localStorage.setItem("role", role); 
        localStorage.setItem("user_label", label);
        // Arahkan ke folder masing-masing
        window.location.href = role === "admin" ? "index.html" : "../operator/index.html";
    } else {
        alert("Akses Ditolak!");
    }
}

// FUNGSI SATPAM (Proteksi Halaman)
// Panggil ini di setiap index.html agar orang tidak bisa tembus lewat URL
function proteksiHalaman(tipe) {
    const r = localStorage.getItem("role");
    const l = localStorage.getItem("user_label");
    if(!l || (tipe === 'admin' && r !== 'admin')) {
        window.location.href = "../admin/login.html";
    }
}
EOF

# 2. UPDATE LOGIN DI ADMIN (modul/admin/login.html)
# Menghubungkan tampilan login dengan pusat database auth.js
cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Login Garda Dumai Kota</title>
</head>
<body style="background:#1a1a1a; height:100vh; display:flex; justify-content:center; align-items:center; font-family:sans-serif;">
    <div style="background:#fff; padding:30px; border-radius:12px; width:300px; text-align:center;">
        <i class="fas fa-shield-alt" style="font-size:40px; color:#e74c3c; margin-bottom:10px;"></i>
        <h2 style="margin:0;">GARDA DUMAI KOTA</h2>
        <p style="font-size:11px; color:#888; margin-bottom:20px;">Portal Akses Terintegrasi</p>
        
        <input type="text" id="user" placeholder="Username" style="width:100%; padding:12px; margin-bottom:10px; border:1px solid #ddd; border-radius:8px; box-sizing:border-box;">
        <input type="password" id="pass" placeholder="Password" style="width:100%; padding:12px; margin-bottom:20px; border:1px solid #ddd; border-radius:8px; box-sizing:border-box;">
        
        <button onclick="authSistem()" style="width:100%; padding:12px; background:#e74c3c; color:white; border:none; border-radius:8px; font-weight:bold; cursor:pointer;">MASUK SISTEM</button>
    </div>

    <script src="../aksi/auth.js"></script>
</body>
</html>
EOF

echo "✅ Berhasil Merapikan Struktur."
echo "------------------------------------------------"
echo "File baru: ./modul/aksi/auth.js (Pusat Kendali)"
echo "File Login: ./modul/admin/login.html (Pintu Utama)"