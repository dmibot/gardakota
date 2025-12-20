// File: modul/admin/auth.js (IMPROVED VERSION)
// Fix: Syntax errors + database lookup + better error handling

// DATABASE USER (Format: username -> {role, label, pass})
const USER_DB = {
  // Admin users (Pass: dksiaga)
  "camat": { role: "admin", label: "CAMAT", pass: "dksiaga" },
  "sekcam": { role: "admin", label: "SEKCAM", pass: "dksiaga" },
  "trantib": { role: "admin", label: "TRANTIB", pass: "dksiaga" },
  "kapolsek": { role: "admin", label: "KAPOLSEK", pass: "dksiaga" },
  "danramil": { role: "admin", label: "DANRAMIL", pass: "dksiaga" },
  
  // Operator users (Pass: pantaudk)
  "lurah-rimbas": { role: "operator", label: "LURAH RIMBAS", pass: "pantaudk" },
  "lurah-sukajadi": { role: "operator", label: "LURAH SUKAJADI", pass: "pantaudk" },
  "lurah-laksamana": { role: "operator", label: "LURAH LAKSAMANA", pass: "pantaudk" },
  "lurah-dumaikota": { role: "operator", label: "LURAH DUMAIKOTA", pass: "pantaudk" },
  "lurah-bintan": { role: "operator", label: "LURAH BINTAN", pass: "pantaudk" },
  
  "babinsa-rimbas": { role: "operator", label: "BABINSA RIMBAS", pass: "pantaudk" },
  "babinsa-sukajadi": { role: "operator", label: "BABINSA SUKAJADI", pass: "pantaudk" },
  "babinsa-laksamana": { role: "operator", label: "BABINSA LAKSAMANA", pass: "pantaudk" },
  "babinsa-dumaikota": { role: "operator", label: "BABINSA DUMAIKOTA", pass: "pantaudk" },
  "babinsa-bintan": { role: "operator", label: "BABINSA BINTAN", pass: "pantaudk" },
  
  "bhabin-rimbas": { role: "operator", label: "BHABIN RIMBAS", pass: "pantaudk" },
  "bhabin-sukajadi": { role: "operator", label: "BHABIN SUKAJADI", pass: "pantaudk" },
  "bhabin-laksamana": { role: "operator", label: "BHABIN LAKSAMANA", pass: "pantaudk" },
  "bhabin-dumaikota": { role: "operator", label: "BHABIN DUMAIKOTA", pass: "pantaudk" },
  "bhabin-bintan": { role: "operator", label: "BHABIN BINTAN", pass: "pantaudk" },
  
  "pamong-rimbas": { role: "operator", label: "PAMONG RIMBAS", pass: "pantaudk" },
  "pamong-sukajadi": { role: "operator", label: "PAMONG SUKAJADI", pass: "pantaudk" },
  "pamong-laksamana": { role: "operator", label: "PAMONG LAKSAMANA", pass: "pantaudk" },
  "pamong-dumaikota": { role: "operator", label: "PAMONG DUMAIKOTA", pass: "pantaudk" },
  "pamong-bintan": { role: "operator", label: "PAMONG BINTAN", pass: "pantaudk" },
  
  "trantib-rimbas": { role: "operator", label: "TRANTIB RIMBAS", pass: "pantaudk" },
  "trantib-sukajadi": { role: "operator", label: "TRANTIB SUKAJADI", pass: "pantaudk" },
  "trantib-laksamana": { role: "operator", label: "TRANTIB LAKSAMANA", pass: "pantaudk" },
  "trantib-dumaikota": { role: "operator", label: "TRANTIB DUMAIKOTA", pass: "pantaudk" },
  "trantib-bintan": { role: "operator", label: "TRANTIB BINTAN", pass: "pantaudk" },
};

// ========== FUNGSI LOGIN SISTEM ==========
function authSistem() {
  const userInput = document.getElementById('user');
  const passInput = document.getElementById('pass');
  
  if (!userInput || !passInput) {
    alert("❌ Form input tidak ditemukan!");
    return;
  }

  const username = userInput.value.trim().toLowerCase();
  const password = passInput.value;

  // Validasi input
  if (!username) {
    alert("⚠️ Username tidak boleh kosong!");
    return;
  }

  if (!password) {
    alert("⚠️ Password tidak boleh kosong!");
    return;
  }

  // Cari user di database
  const user = USER_DB[username];

  // Validasi username & password
  if (!user || user.pass !== password) {
    console.warn(`⚠️ Login gagal: username=${username}`);
    alert("❌ AKSES DITOLAK!\nUsername atau Password salah.");
    return;
  }

  // ========== LOGIN SUKSES ==========
  console.log(`✅ Login sukses: ${username} (${user.role})`);

  // Simpan data ke localStorage
  localStorage.setItem("role", user.role);
  localStorage.setItem("user_label", user.label);

  // Redirect sesuai role (gunakan absolute path)
  const redirectUrl = user.role === "admin" 
    ? "/modul/admin/index.html" 
    : "/modul/operator/index.html";

  console.log(`📍 Redirect ke: ${redirectUrl}`);
  window.location.href = redirectUrl;
} // ← Closing brace untuk authSistem


// ========== FUNGSI SATPAM (PROTEKSI HALAMAN) ==========
function proteksiHalaman(tipe) {
  const role = localStorage.getItem("role");
  const label = localStorage.getItem("user_label");

  console.log(`🔐 Proteksi halaman [${tipe}]: role=${role}, user=${label}`);

  // Jika tidak ada data login sama sekali
  if (!role || !label) {
    console.warn("❌ User belum login, redirect ke login page");
    window.location.href = "/modul/admin/login.html";
    return;
  }

  // Jika halaman ini adalah ADMIN, tapi user role operator
  if (tipe === "admin" && role !== "admin") {
    console.warn(`❌ Operator coba akses admin area, reject!`);
    alert("❌ Akses Ditolak! Hanya admin yang bisa ke sini.");
    window.location.href = "/modul/admin/login.html";
    return;
  }

  // Kalau sampai sini, user authorized ✅
  console.log(`✅ User ${label} authorized untuk halaman [${tipe}]`);
  
  // Update UI dengan nama user (opsional)
  const userNameEl = document.getElementById('user-name');
  if (userNameEl) {
    userNameEl.textContent = label;
  }
} // ← Closing brace untuk proteksiHalaman


// ========== FUNGSI LOGOUT ==========
function logout() {
  console.log("🚪 User logout");
  localStorage.removeItem("role");
  localStorage.removeItem("user_label");
  window.location.href = "/modul/admin/login.html";
}

console.log("✅ auth.js loaded");
