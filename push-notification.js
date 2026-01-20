// Push Notification System - Garda Dumai Kota
// Menggunakan OneSignal (Gratis) untuk push notifications

const ONESIGNAL_APP_ID = 'YOUR_ONESIGNAL_APP_ID'; // Ganti dengan ID dari OneSignal.com

// ===== INIT ONE SIGNAL =====
function initPushNotification() {
  if (!('serviceWorker' in navigator)) {
    console.warn('⚠️ Service Worker tidak support');
    return;
  }

  // Load OneSignal SDK
  window.OneSignalDeferred = window.OneSignalDeferred || [];
  OneSignalDeferred.push(async function(OneSignal) {
    await OneSignal.init({
      appId: ONESIGNAL_APP_ID,
      notificationClickHandlerMatch: 'origin',
      welcomeNotification: {
        "title": "Garda Dumai Kota",
        "message": "Terima kasih sudah install! Anda akan mendapat notifikasi laporan terbaru."
      },
      allowLocalhostAsSecureOrigin: true,
    });

    // Request permission
    await OneSignal.Slidedown.promptPush();
    
    console.log('✅ Push notification initialized');
  });

  // Load OneSignal script
  const script = document.createElement('script');
  script.src = 'https://cdn.onesignal.com/sdks/web/v16/OneSignalSDK.page.js';
  script.async = true;
  document.head.appendChild(script);
}

// ===== SEND PUSH NOTIFICATION (SERVER-SIDE / GAS) =====
// Tambahkan ini di Google Apps Script untuk kirim notifikasi ke users
async function sendPushNotification(title, message, url) {
  try {
    const response = await fetch('https://onesignal.com/api/v1/notifications', {
      method: 'POST',
      headers: {
        'Authorization': 'Basic YOUR_ONESIGNAL_REST_API_KEY',
        'Content-Type': 'application/json; charset=utf-8'
      },
      body: JSON.stringify({
        app_id: ONESIGNAL_APP_ID,
        contents: {en: message},
        headings: {en: title},
        url: url,
        included_segments: ['All'],
        android_channel_id: 'gardakota',
        big_picture: 'https://gardadumaikota.netlify.app/assets/img/icon-512.png'
      })
    });
    
    const result = await response.json();
    console.log('✅ Push notif terkirim:', result);
  } catch(e) {
    console.error('❌ Error send push:', e);
  }
}

// ===== NOTIFIKASI LAPORAN BARU =====
// Handler ketika ada laporan baru di Google Sheets
function onNewReportNotification(reportData) {
  const {nama, kategori, lokasi} = reportData;
  const title = `${kategori} - ${nama}`;
  const message = `Laporan baru masuk dari ${lokasi}`;
  const url = 'https://gardadumaikota.netlify.app/modul/peta/index.html';
  
  sendPushNotification(title, message, url);
}

// Start init
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initPushNotification);
} else {
  initPushNotification();
}

console.log('✅ push-notification.js loaded');
