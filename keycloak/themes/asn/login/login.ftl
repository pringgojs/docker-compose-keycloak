<#-- Custom Keycloak login page dengan layout dan style seperti themes/anomic/login/login.html -->
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login SSO - Satu Akun untuk Semua</title>
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
      <!-- Logo Pemerintah -->
      <div class="flex justify-center mb-4">
        <img src="${url.resourcesPath}/img/logo.png" alt="Centralized Authentication System" class="w-auto block dark:hidden" style="height:6rem" />
        <img src="${url.resourcesPath}/img/logo-dark-mode.png" alt="Centralized Authentication System" class="w-auto hidden dark:block" style="height:6rem" />
      </div>
      <!-- Judul dan Tagline -->
      <div class="text-center mb-6">
        <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">Masuk ke Akun Anda</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Satu Akun untuk Semua</p>
      </div>
      
      <#if message?has_content>
        <div
          class="bg-yellow-50 dark:bg-yellow-900 mb-2 border-yellow-200 dark:border-yellow-700 text-sm text-yellow-800 dark:text-yellow-200 rounded-lg p-4"
          role="alert"
          tabindex="-1"
          aria-labelledby="hs-with-description-label"
        >
          <div class="flex">
            <div class="shrink-0">
              <svg
                class="shrink-0 size-4 mt-0.5"
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <path
                  d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"
                ></path>
                <path d="M12 9v4"></path>
                <path d="M12 17h.01"></path>
              </svg>
            </div>
            <div class="ms-4">
              <h3 class="text-sm font-semibold">
                Error.
              </h3>
              <div class="mt-1 text-sm text-yellow-700 dark:text-yellow-200">
                ${message.summary}.
              </div>
            </div>
          </div>
        </div>
      </#if>

      <!-- Form Login -->
      <form id="kc-form-login" method="post" action="${url.loginAction}" class="space-y-4">
        <input type="hidden" name="credentialId" value="${credentialId!}"/>
        <div>
          <label for="username" class="block text-sm font-medium text-gray-700 dark:text-gray-200">Username</label>
          <input id="username" name="username" type="text" required autofocus autocomplete="username"
            class="mt-1 w-full px-4 py-2 border rounded-xl shadow-sm focus:ring-blue-500 focus:border-blue-500 border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-100"
            placeholder="Username" value="${username!}" />
        </div>
        <div>
          <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-200">Password</label>
          <input id="password" name="password" type="password" required autocomplete="current-password"
            class="mt-1 w-full px-4 py-2 border rounded-xl shadow-sm focus:ring-blue-500 focus:border-blue-500 border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-100"
            placeholder="Password" />
        </div>
        <button tabindex="3" type="submit"
          class="w-full bg-blue-600 dark:bg-blue-700 text-white font-semibold py-2 px-4 rounded-xl hover:bg-blue-700 dark:hover:bg-blue-800 transition duration-200 flex items-center justify-center gap-2">
          Masuk
        </button>
      </form>
      <div class="mt-6 text-center text-sm text-gray-500 dark:text-gray-400">
        Belum punya akun? Hubungi administrator.
      </div>
      <!-- Ikon Aplikasi -->
      <div class="mt-8">
        <p class="text-center text-gray-500 dark:text-gray-400 text-sm mb-2">Terintegrasi dengan:</p>
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
