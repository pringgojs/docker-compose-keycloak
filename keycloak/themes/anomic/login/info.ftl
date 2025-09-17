<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Informasi - SSO</title>
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
  <body class="min-h-screen bg-gray-100 flex items-center justify-center px-4">
    <!-- Particles Background -->
    <div id="particles-js"></div>
    <div class="max-w-md w-full bg-white shadow-2xl rounded-2xl p-8 relative z-10 text-center">
      <!-- Logo -->
      <div class="flex justify-center mb-4">
        <img src="${url.resourcesPath}/img/logo.png" alt="SSO" class="w-auto h-16" />
      </div>
      <h1 class="text-2xl font-bold text-blue-600 mb-2">Informasi</h1>
      <p class="text-sm text-gray-600 mb-6">
        <#if message?has_content>
          ${(message.summary)!'Ada informasi penting terkait SSO Anda.'}
        <#else>
          Ada informasi terkait proses login atau akun Anda. Silakan cek detail di atas atau hubungi administrator jika perlu bantuan.
        </#if>
      </p>

      <a href="${url.loginUrl}" class="inline-block mt-4 bg-blue-600 text-white py-2 px-4 rounded-xl hover:bg-blue-700 transition">
        Kembali ke Halaman Login
      </a>

      <div class="mt-6 text-xs text-gray-400">SSO Pemerintah Kabupaten Ponorogo</div>
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
