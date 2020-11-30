'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "bf9d916abcfeb7ded0bef8c1e97913de",
"/": "bf9d916abcfeb7ded0bef8c1e97913de",
"main.dart.js": "760048e53d55ccb6eebb4978f7d27628",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "fca7e08cbce899df3ef578b6640bfc07",
"assets/AssetManifest.json": "7cebde723195add456e8ca38e53b8d5d",
"assets/NOTICES": "f789e9d394161ce771f25d948aeb63eb",
"assets/FontManifest.json": "21d0940593f2947b1a202ad22870c890",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/packages/awesome_card/images/contactless_icon.png": "a092b99c8a1f820436ddf6e540eb632d",
"assets/packages/awesome_card/images/card_provider/discover.png": "50f59532bededb551c5ed62fb1009e69",
"assets/packages/awesome_card/images/card_provider/rupay.png": "3e3018d92a1b51fde09382939664a22d",
"assets/packages/awesome_card/images/card_provider/maestro.png": "6800b310fc27f91d0231ab6556284c5b",
"assets/packages/awesome_card/images/card_provider/visa.png": "b6cf8805abcc16ca2bc2ed401958cce1",
"assets/packages/awesome_card/images/card_provider/diners_club.png": "4288121f0ec6619f2ea56bc7cbb2685a",
"assets/packages/awesome_card/images/card_provider/master_card.png": "6ecc2a7c3b3d7e1c30ac7cf7a083d5af",
"assets/packages/awesome_card/images/card_provider/jcb.png": "434316972590e7d17d65cd133c018f82",
"assets/packages/awesome_card/images/card_provider/american_express.png": "25d34d555cc835f008806163bf889bf9",
"assets/packages/awesome_card/fonts/MavenPro-Regular.ttf": "ebc7385f9f207b4ad5d0cc4204bf4068",
"assets/packages/awesome_card/fonts/MavenPro-Medium.ttf": "06dcc8cf4f85c46c6985b69ed0b6b5b6",
"assets/packages/awesome_card/fonts/MavenPro-Bold.ttf": "c3c32db501249a4a864e3359d88469fb",
"assets/packages/progress_dialog/assets/double_ring_loading_io.gif": "e5b006904226dc824fdb6b8027f7d930",
"assets/fonts/Roboto-Regular.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/fonts/Roboto-Thin.ttf": "321de678e592d0b8f44f1a82d7ca4b62",
"assets/assets/icon.png": "9bf20cb0d58fbe86ad59325ad45f113d",
"assets/assets/img/star_on.png": "4dbae94dff734e57608edb7744099150",
"assets/assets/img/pin_on.png": "d855c56a4aede19f0e8d14a2b659f696",
"assets/assets/img/fake_user.png": "0854e2d3f4fd9aba4b3e4ad71d016b67",
"assets/assets/img/lion_logo.png": "afa0b60446d887fc56b25b4815f05e63",
"assets/assets/img/aboutus.png": "3dc5d5191bb59b08efc003a64d744a70",
"assets/assets/img/hotel.png": "62baa26526af7e22bfa80aa844e7be58",
"assets/assets/img/group.png": "6cb3245a89b4634809f406ab5a64a575",
"assets/assets/img/star_off.png": "96667b7ce14da197c49e8b0392932267",
"assets/assets/img/facebook_logo.png": "82ba04a596e6fb7053f9332f00fc381b",
"assets/assets/img/euro_off.png": "6a4e4e0af7d7397e35252ce1286ec9a7",
"assets/assets/img/nfc.png": "4fede72aa564fa5d19fa8fab38fd4266",
"assets/assets/img/brand/logo_appbar.png": "4eb4bca11068b346c866bd6f17c82f3c",
"assets/assets/img/brand/logo.png": "af4c79aa33a886550992502c75286015",
"assets/assets/img/brand/logo_appbar.svg": "7ac845a78fe95f731fb335700fc43c02",
"assets/assets/img/visa.jpg": "8247b41b63efcf124a392c7c49fa7b3a",
"assets/assets/img/image_placeholder.png": "c513ed8da6464789fbc4f670676b1201",
"assets/assets/img/user.png": "65582cb7e1a90d43963252a9ef4822c8",
"assets/assets/img/pointer.png": "855f2f4507044699b52812f13fdd50b1",
"assets/assets/img/search.png": "789fa218ffecce15fdcdbad04f5f07cb",
"assets/assets/img/back_blue.png": "b17f3e8067bd1e49aaf88bf274b98372",
"assets/assets/img/white_plus.png": "bd638a8d1230e668e8a749f01bbb9b5d",
"assets/assets/img/euro_on.png": "f633723e519f3acdc81f075c653999b8",
"assets/assets/img/food.png": "3cd4c189fa2d81499d62c52691e1452f",
"assets/assets/img/upload.png": "835c88338f2d278f8ef814cb9c9e64bb",
"assets/assets/img/zucchetta.jpeg": "002b0fb97d7c16cb2a4ebc8482e1d808",
"assets/assets/img/google_logo.png": "b75aecaf9e70a9b1760497e33bcd6db1",
"assets/assets/img/google_pay.jpg": "7029cace5aed38528f3b230cfa6d2284",
"assets/assets/img/qr_code.png": "2e531e862d32488744c6ef4cb8ff1b7c",
"assets/assets/img/apple_pay.jpg": "3b1dd1867240b26e6f875d04f8e5fc51",
"assets/assets/img/approdo.jpeg": "e810686f70395e6fab568062b931b65b",
"assets/assets/img/back_button.png": "f67404fb3cbfe89b3880ff82cf1e91d8",
"assets/assets/img/blue_plus.png": "fead22b216028ec0d1a254bd0506d9bf",
"assets/assets/img/img_buytime.png": "9bf20cb0d58fbe86ad59325ad45f113d",
"assets/assets/img/mach1.jpg": "5837cd6d40f7ae15588c8f57715b6880",
"assets/assets/img/mastercard.png": "80c7bd98b1d4c9727e91fa061773a111",
"assets/assets/img/magic.png": "1e99214e5f3418bb5cf9f1dfd52ddc57",
"assets/assets/img/rifrullo.jpg": "c78dd941f7947913a14df498bcb6dc78",
"assets/assets/img/lion_photo.png": "7f726808ff2c09183e3b5489c7e0f6cc",
"assets/assets/img/back.png": "de22055e11fdc782acd5dcd33419718d",
"assets/assets/img/3archi.jpg": "a43953be876480852299a88f7d57d727",
"assets/assets/img/hand_nfc.png": "ca7f943257ca012483e5355fe8437b2f",
"assets/assets/img/pin_off.png": "624f34b13e324b4c4c801a64a5ff13bc",
"assets/assets/icon.jpeg": "20a4c69c4728f6ba9cc8b2d0c44139b0"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
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
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list, skip the cache.
  if (!RESOURCES[key]) {
    return event.respondWith(fetch(event.request));
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
    return self.skipWaiting();
  }
  if (event.message === 'downloadOffline') {
    downloadOffline();
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
  for (var resourceKey in Object.keys(RESOURCES)) {
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
