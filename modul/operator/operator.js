// File: modul/operator/operator.js (FINAL VERSION - v2)
// Update: Google Maps link format tanpa minus

const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";

let lat = "", lng = "";
let teksWilayah = "";

// FUNGSI TRACK LOKASI 3 BARIS (AKURASI MAKSIMAL)
// Zoom 18 = Jalan, Zoom 14 = Kelurahan, Zoom 12 = Kecamatan
async function ambilLokasi() {
  const box = document.getElementById('gps-box');
  box.innerHTML = "⌛ Mengunci Satelit...";
  
  navigator.geolocation.getCurrentPosition(async (p) => {
    lat = p.coords.latitude; 
    lng = p.coords.longitude;
    try {
      // TRACKING 3 BARIS (18=Jalan, 14=Kelurahan, 12=Kecamatan)
      const res1 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=18&accept-language=id-ID&format=jsonv2`);
      const d1 = await res1.json();
      
      const res2 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=14&accept-language=id-ID&format=jsonv2`);
      const d2 = await res2.json();
      
      const res3 = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=12&accept-language=id-ID&format=jsonv2`);
      const d3 = await res3.json();

      const jln = d1.address.road || d1.address.pedestrian || "Jln. Lokasi";
      const kel = d2.address.village || d2.address.suburb || "Kelurahan";
      const kec = d3.address.city_district || "Kecamatan";

      teksWilayah = `[Kel. ${kel}, ${kec} | ${jln}]`;
      box.innerHTML = `✅ TERKUNCI<br><small style="font-size:10px;">${teksWilayah}</small>`;
      box.style.background = "#e8f5e9";
      
    } catch (e) { 
      console.warn("⚠️ Nominatim error:", e.message);
      teksWilayah = "[Lokasi GPS Terkunci]"; 
      box.innerHTML = "✅ TERKUNCI (GPS OK)"; 
      box.style.background = "#fff3cd";
    }
  }, (err) => { 
    alert("GPS WAJIB AKTIF!");
    box.innerHTML = "❌ GPS MATI";
  }, { enableHighAccuracy: true });
} // ← Closing brace untuk ambilLokasi


// FUNGSI KIRIM DATA KE GOOGLE SHEETS
async function kirimLaporan() {
  const btn = document.getElementById('btnLapor');
  const fileInput = document.getElementById('foto').files[0];
  
  if(!lat || !fileInput) return alert("Wajib Kunci GPS & Ambil Foto Bukti!");

  btn.innerText = "⏳ MENGIRIM...";
  btn.disabled = true;

  try {
    // 1. Upload Foto ke ImgBB
    let fd = new FormData(); 
    fd.append("image", fileInput);
    let rImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
    let dImg = await rImg.json();

    // Cek jika ImgBB response error
    if (!dImg.success) {
      throw new Error("ImgBB upload failed: " + (dImg.error?.message || "Unknown error"));
    }

    // 2. LOKASI: Format Google Maps dengan zoom 14z
    const linkMapsMurni = `https://www.google.com/maps/place/@${lat},${lng},14z/data=!4m4!3m3!8m2!3d${lat}!4d${lng}`;

    // 3. KETERANGAN: HANYA catatan user, tanpa wilayah
    const keteranganFinal = document.getElementById('ket').value;

    // 4. KIRIM KE SAKTI (GOOGLE SHEETS)
    await fetch(SAKTI, {
      method: 'POST', 
      mode: 'no-cors',
      body: JSON.stringify({
        nama: localStorage.getItem("user_label") || "PETUGAS",
        kategori: document.getElementById('kat').value,
        keterangan: keteranganFinal,
        lokasi: linkMapsMurni,
        foto: dImg.data.url
      })
    });

    alert("✅ LAPORAN BERHASIL TERKIRIM!");
    window.location.reload();

  } catch(e) {
    console.error("❌ Error kirim laporan:", e.message);
    alert("❌ Gagal Kirim!\n\nError: " + e.message);
    btn.innerText = "KIRIM KE DASHBOARD";
    btn.disabled = false;
  }
}

console.log("✅ operator.js loaded");
