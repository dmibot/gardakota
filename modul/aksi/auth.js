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
            if(u === `${r}-${k}` && p === "pantaudk") { 
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
