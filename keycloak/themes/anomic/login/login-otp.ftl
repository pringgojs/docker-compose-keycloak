<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Verifikasi OTP - Satu Akun untuk Semua</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/tailwind.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet" />
    <style>
      body { font-family: "Inter", sans-serif; }
      #particles-js {
        position: fixed;
        width: 100%;
        height: 100%;
        z-index: -1;
        top: 0;
        left: 0;
      }
    </style>
  </head>
  <body class="min-h-screen bg-gray-100 dark:bg-gray-900 flex items-center justify-center px-4">
    <!-- Particles Background -->
    <div id="particles-js"></div>
    <div class="max-w-md w-full bg-white dark:bg-gray-800 shadow-2xl rounded-2xl p-8 relative z-10">
      <!-- Logo -->
      <div class="flex justify-center mb-4">
        <img src="${url.resourcesPath}/img/logo.png" alt="Centralized Authentication System" class="w-auto block dark:hidden" style="height:6rem" />
        <img src="${url.resourcesPath}/img/logo-dark-mode.png" alt="Centralized Authentication System" class="w-auto hidden dark:block" style="height:6rem" />
      </div>
      <!-- Judul -->
      <div class="text-center mb-6">
        <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">Verifikasi OTP</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Masukkan kode dari aplikasi Authenticator Anda</p>
      </div>

      <!-- Form OTP -->
      <form id="kc-totp-login-form" method="post" action="${url.loginAction}" class="space-y-4">
        <#if message?has_content>
          <div class="mb-4 text-red-600 dark:text-red-400 font-medium text-sm">${message.summary}</div>
        </#if>

        <div>
          <label for="otp" class="block text-sm font-medium text-gray-700 dark:text-gray-200">Kode OTP</label>
          <input id="otp" name="otp" type="text" required autofocus
            class="mt-1 w-full px-4 py-2 border rounded-xl shadow-sm focus:ring-blue-500 focus:border-blue-500 border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-100"
            placeholder="123 456" />
        </div>

        <button type="submit"
          class="w-full bg-blue-600 dark:bg-blue-700 text-white font-semibold py-2 px-4 rounded-xl hover:bg-blue-700 dark:hover:bg-blue-800 transition duration-200 flex items-center justify-center gap-2">
          Verifikasi
        </button>
      </form>

      <div class="mt-6 text-center text-sm text-gray-500 dark:text-gray-400">
        Bermasalah dengan OTP? Hubungi administrator.
      </div>

      <!-- Ikon Aplikasi -->
      <div class="mt-8">
        <p class="text-center text-gray-500 text-sm mb-2">Terintegrasi dengan:</p>
        <div class="flex justify-center gap-4 flex-wrap">
          <img src="${url.resourcesPath}/img/simas.png" alt="Simashebat" class="w-10 h-10" title="Simas Hebat" />
          <img src="${url.resourcesPath}/img/jathilan.png" alt="Jathilan" class="w-auto h-10" title="Presensi Online Jathilan" />
          <img src="${url.resourcesPath}/img/sadap.png" alt="satu data ponorogo" class="w-auto h-10" title="Satu Data Ponorogo" />
        </div>
      </div>
    </div>

    <!-- Particles Config -->
    <script src="${url.resourcesPath}/js/particles.min.js"></script>
    <script>
      particlesJS && particlesJS("particles-js", {
        particles: {
          number: { value: 60, density: { enable: true, value_area: 800 } },
          color: { value: "#60A5FA" },
          shape: { type: "circle" },
          opacity: { value: 0.4 },
          size: { value: 3 },
          line_linked: {
            enable: true,
            distance: 150,
            color: "#3B82F6",
            opacity: 0.3,
            width: 1,
          },
          move: {
            enable: true,
            speed: 2,
            direction: "none",
            out_mode: "out",
          },
        },
        interactivity: {
          events: {
            onhover: { enable: true, mode: "grab" },
            onclick: { enable: true, mode: "push" },
          },
          modes: {
            grab: { distance: 140, line_linked: { opacity: 0.5 } },
            push: { particles_nb: 4 },
          },
        },
        retina_detect: true,
      });
    </script>
  </body>
</html>
