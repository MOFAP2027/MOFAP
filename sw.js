// Service worker: la app carga aunque la señal sea débil (red primero, caché de respaldo)
const CACHE = "corrida-uva-v1";
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", (e) => e.waitUntil(self.clients.claim()));
self.addEventListener("fetch", (e) => {
  const url = new URL(e.request.url);
  if (url.origin !== location.origin || e.request.method !== "GET") return;
  e.respondWith(
    caches.open(CACHE).then(async (c) => {
      try {
        const r = await fetch(e.request);
        c.put(e.request, r.clone());
        return r;
      } catch {
        const m = await c.match(e.request);
        return m || Response.error();
      }
    })
  );
});
