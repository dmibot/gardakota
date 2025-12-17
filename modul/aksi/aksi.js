let lat = "", lng = "";
const WA_CAMAT = "6285172206884";
function initGPS() {
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        document.getElementById('gps-status').innerHTML = "✅ LOKASI SIAP: " + lat.toFixed(4) + "," + lng.toFixed(4);
    }, () => alert("Aktifkan GPS!"));
}
async function sendSOS() {
    if(!lat) return alert("Menunggu GPS...");
    const maps = "http://googleusercontent.com/maps.google.com/q=" + lat + "," + lng;
    window.location.href = "https://wa.me/" + WA_CAMAT + "?text=*🚨 SOS DARURAT!*%0ALokasi: " + maps;
}
initGPS();
