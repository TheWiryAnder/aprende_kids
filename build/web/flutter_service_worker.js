'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "309bd91bdeabe11984227c44b3001cc9",
"assets/AssetManifest.bin.json": "dc09ebbaf60ba9066a8b7d83286cf9a0",
"assets/AssetManifest.json": "ce5552fb60a3053d7bda46ec141985e4",
"assets/assets/avatar/backgrounds/classroom.svg": "624c47942541ed533feae13e2ad1383b",
"assets/assets/avatar/backgrounds/library.svg": "a84b408379bb910c534b8ca5638c3a6e",
"assets/assets/avatar/backgrounds/science_lab.svg": "b36a752f0b3a7ce4a8b5356364fa9807",
"assets/assets/avatar/backgrounds/space.svg": "01b186faf678bea122e7f643c5ea57ea",
"assets/assets/avatar/body/cuerpo.png": "b14cc91d3b80c62d62e7a8c5065039b9",
"assets/assets/avatar/body/cuerpo_2.png": "4791acbdca4458bcc8470d75a723dcde",
"assets/assets/avatar/body/cuerpo_3.png": "bb0f8f991b5c4bc5835c0d22c5799276",
"assets/assets/avatar/body/cuerpo_ni%25C3%25B1a.png": "77a9a1bc10f0b8617090dc0ddc945de4",
"assets/assets/avatar/body/cuerpo_ni%25C3%25B1a_2.png": "34e59603f7f2b9066d4f1dff049d46f2",
"assets/assets/avatar/bottom/falda.png": "90e1c029ef78dd0c969fbe234ea1077b",
"assets/assets/avatar/bottom/falda_2.png": "63ea08f405220f622705cfaff4eae42a",
"assets/assets/avatar/bottom/pantalon.png": "972d75600355dbf14ef7adb636b65c7a",
"assets/assets/avatar/bottom/pantalon_2.png": "3dc5e0d0eac6908fc07038fc6351c130",
"assets/assets/avatar/bottom/short.png": "58cbb9c86d3ca9c21a7f041f0fce66bc",
"assets/assets/avatar/bottom/short_2.png": "131773faaac74b559f9d1ba423ce1295",
"assets/assets/avatar/face/rostro.png": "7fb27281a2dceba6f9d2cc35c742eeb2",
"assets/assets/avatar/face/rostro_ni%25C3%25B1a.png": "0f473861697cf8a953c2fbf5c41d3d62",
"assets/assets/avatar/hair/cabello.png": "38a2b53ddf749b45a6d048bd982acf4a",
"assets/assets/avatar/hair/cabello_ni%25C3%25B1a.png": "f33e991ec5708f5b35f2fb09016ef7b5",
"assets/assets/avatar/shoes/zapatos.png": "ba5dcf4d2d700c43881143511d8f3e27",
"assets/assets/avatar/shoes/zapatos_ni%25C3%25B1a.png": "ae59f74c417e71d9bfc25cbdf94f3645",
"assets/assets/avatar/top/polo.png": "1015ecaf7ce2dab986bcbfc83fd8a2b3",
"assets/assets/avatar/top/polo_2.png": "b78b367896d784455c88642fd150b1a9",
"assets/assets/avatar/top/polo_3.png": "6457d5bf97a62aaed30107c0ad975ce0",
"assets/assets/avatar/top/polo_ni%25C3%25B1a.png": "dccc3c019cfc303dbc307e4bc37b5173",
"assets/assets/avatar/top/polo_ni%25C3%25B1a_2.png": "892835efcf0228e8f9e03d88ed6c8088",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "e29441fb529f3dd167e3475ac104ff50",
"assets/NOTICES": "972b59725478697955f29d6b7086980a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "3d6139215244555d1c78105d53fe5dc7",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "8fcbb680588fd4b054747f095d94ca40",
"/": "8fcbb680588fd4b054747f095d94ca40",
"main.dart.js": "c7666e62c015111139ce8abd1d53f105",
"manifest.json": "fbc235097eca25e9b69fd333e0ae4a9f",
"version.json": "f9a46998b14b993f210abf7c0623e757"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
