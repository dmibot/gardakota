const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
var map = L.map('map').setView([1.680, 101.448], 14);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

async function loadMarkers() {
    try {
        const r = await fetch(SAKTI);
        const d = await r.json();
        d.laporan.reverse().forEach((item, idx) => {
            if(idx === d.laporan.length - 1 || !item[4]) return;
            const coords = item[4].match(/(-?\d+\.\d+),(-?\d+\.\d+)/);
            if(coords) {
                let color = item[6] === 'Selesai' ? '#388e3c' : (item[6] === 'Penanganan' ? '#ff9800' : '#d32f2f');
                L.circleMarker([coords[1], coords[2]], { radius: 8, fillColor: color, color: "#fff", fillOpacity: 0.9 }).addTo(map)
                    .bindPopup(`
                        <div style="width:180px">
                            <b style="color:#0d47a1">${item[2]}</b><br>
                            <small>${item[1]} | ${item[6]}</small><hr>
                            <p style="font-size:12px">${item[3]}</p>
                            <img src="${item[5]}" class="popup-img">
                        </div>
                    `);
            }
        });
    } catch(e) { console.error("Peta Gagal!"); }
}
loadMarkers();
