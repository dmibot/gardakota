// WhatsApp SOS Integration - Garda Dumai Kota
// Kirim SOS emergency ke nomor Camat/Polsek

const EMERGENCY_NUMBERS = {
  'camat': '628123456789',      // Update dengan nomor WhatsApp Camat
  'polsek': '628198765432',     // Update dengan nomor Polsek
  'damkar': '628111222333',     // Update dengan nomor Damkar
  'puskesmas': '628144555666'   // Update dengan nomor Puskesmas
};

// ===== SEND SOS VIA WHATSAPP =====
function sendSOSWhatsApp(emergencyType = 'camat') {
  return new Promise(async (resolve, reject) => {
    try {
      // Ambil lokasi
      if ('geolocation' in navigator) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;
            const mapsLink = `https://www.google.com/maps/place/${lat},${lng}`;
            const timestamp = new Date().toLocaleString('id-ID');
            
            // Buat pesan SOS
            const sosMessage = `
🚨 EMERGENCY SOS - GARDA DUMAI KOTA 🚨

⏰ Waktu: ${timestamp}
📍 Lokasi: ${mapsLink}
🎯 Tipe: ${emergencyType.toUpperCase()}

👤 Pengirim: ${localStorage.getItem('user_label') || 'OPERATOR'}

=== KLIK LINK UNTUK NAVIGASI ===
${mapsLink}

⚠️ INI ADALAH PESAN EMERGENCY OTOMATIS
            `.trim();
            
            // Encode message untuk WhatsApp
            const encodeMsg = encodeURIComponent(sosMessage);
            const phoneNumber = EMERGENCY_NUMBERS[emergencyType] || EMERGENCY_NUMBERS['camat'];
            
            // WhatsApp URL
            const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeMsg}`;
            
            console.log('📱 Opening WhatsApp SOS...');
            window.open(whatsappUrl, '_blank');
            
            resolve({
              status: 'success',
              message: 'SOS sent to WhatsApp',
              mapsLink: mapsLink
            });
          },
          (error) => {
            console.error('❌ Geolocation error:', error);
            // Fallback: kirim tanpa lokasi
            const sosMessage = `🚨 EMERGENCY SOS - GARDA DUMAI KOTA 🚨\nPengirim: ${localStorage.getItem('user_label') || 'OPERATOR'}\n⏰ Waktu: ${new Date().toLocaleString('id-ID')}`;
            const encodeMsg = encodeURIComponent(sosMessage);
            const phoneNumber = EMERGENCY_NUMBERS[emergencyType] || EMERGENCY_NUMBERS['camat'];
            const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeMsg}`;
            window.open(whatsappUrl, '_blank');
            resolve({status: 'success', message: 'SOS sent (no location)'});
          }
        );
      } else {
        reject('Geolocation tidak support');
      }
    } catch(e) {
      console.error('❌ Error SOS:', e);
      reject(e);
    }
  });
}

// ===== CREATE SOS BUTTON =====
function createSOSButton() {
  const sosBtn = document.createElement('a');
  sosBtn.id = 'sos-emergency-btn';
  sosBtn.className = 'sos-btn';
  sosBtn.innerHTML = '<i class="fas fa-exclamation-triangle"></i> SOS DARURAT';
  sosBtn.style.cssText = `
    position: fixed;
    bottom: 80px;
    right: 10px;
    background: #d32f2f;
    color: white;
    padding: 12px 16px;
    border-radius: 50px;
    text-decoration: none;
    font-weight: bold;
    font-size: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    z-index: 1999;
    animation: pulse 2s infinite;
  `;
  
  sosBtn.onclick = (e) => {
    e.preventDefault();
    const selectedType = confirm('SOS ke CAMAT?\nCancel untuk pilih lain');
    const emergencyType = selectedType ? 'camat' : 'polsek';
    sendSOSWhatsApp(emergencyType);
  };
  
  document.body.appendChild(sosBtn);
  
  // Add pulse animation
  const style = document.createElement('style');
  style.innerHTML = `
    @keyframes pulse {
      0% { box-shadow: 0 4px 12px rgba(0,0,0,0.3), 0 0 0 0 rgba(211, 47, 47, 0.7); }
      70% { box-shadow: 0 4px 12px rgba(0,0,0,0.3), 0 0 0 10px rgba(211, 47, 47, 0); }
      100% { box-shadow: 0 4px 12px rgba(0,0,0,0.3), 0 0 0 0 rgba(211, 47, 47, 0); }
    }
  `;
  document.head.appendChild(style);
}

// Init pada document ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', createSOSButton);
} else {
  createSOSButton();
}

console.log('✅ whatsapp-sos.js loaded');
