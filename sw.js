// sw.js di root
self.addEventListener('install', event => {
  // Bisa tambahkan pre-cache di sini kalau perlu
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  clients.claim();
});

self.addEventListener('fetch', event => {
  // Untuk awal cukup biarkan lewat begitu saja
  return;
});
