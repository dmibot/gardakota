var map = L.map('map').setView([1.680, 101.448], 14); // Fokus Dumai Kota

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© Garda Dumai Kota'
}).addTo(map);

async function loadMarkers() {
    try {
        const response = await fetch('https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec');
        const data = await response.json();
        
        // Looping data laporan dari Google Sheets
        data.laporan.forEach((item, index) => {
            if (index === 0) return; // Skip header
            
            // Ambil koordinat dari string "http://maps.google.com/...lat,lng"
            const coordMatch = item[4].match(/(-?\d+\.\d+),(-?\d+\.\d+)/);
            if (coordMatch) {
                const lat = parseFloat(coordMatch[1]);
                const lng = parseFloat(coordMatch[2]);
                const status = item[6];
                
                // Warna marker berdasarkan status
                let color = status === 'Selesai' ? '#388e3c' : (status === 'Penanganan' ? '#ff9800' : '#d32f2f');
                
                const marker = L.circleMarker([lat, lng], {
                    radius: 8,
                    fillColor: color,
                    color: "#fff",
                    weight: 2,
                    opacity: 1,
                    fillOpacity: 0.8
                }).addTo(map);

                marker.bindPopup(`
                    <div style="width:200px">
                        <b style="color:#0d47a1">${item[2]}</b><br>
                        <small>${item[1]} | ${item[0]}</small><br>
                        <hr style="border:0; border-top:1px solid #eee">
                        <p style="font-size:12px">${item[3]}</p>
                        <img src="${item[5]}" class="popup-img">
                        <div style="margin-top:5px; font-weight:bold; color:${color}">Status: ${status}</div>
                    </div>
                `);
            }
        });
    } catch (e) {
        console.error("Gagal memuat peta:", e);
    }
}

loadMarkers();
