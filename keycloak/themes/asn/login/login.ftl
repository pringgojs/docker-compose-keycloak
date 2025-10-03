<#-- Custom Keycloak login page dengan layout dan style seperti themes/anomic/login/login.html -->
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login SSO - Satu Akun untuk Semua</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/tailwind.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" rel="stylesheet" />
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
  <body class="min-h-screen bg-gray-300 dark:bg-gray-900 flex items-center justify-center p-2">
    <!-- Particles Background -->
    <div id="particles-js"></div>
     <div class="grid lg:grid-cols-2 gap-x-20">
      <div class="max-w-md w-full bg-white dark:bg-gray-800/80 shadow-2xl rounded-t-xl lg:rounded-2xl relative overflow-hidden z-10">
        <div class="h-20 flex gap-x-2 items-center w-full p-2 bg-white rounded-t-xl dark:bg-gradient-to-r dark:from-gray-800 dark:via-gray-700 dark:to-gray-600">
          <img src="${url.resourcesPath}/img/logo_warna.png" alt="Logo" class="block dark:hidden w-auto h-16" />
          <img src="${url.resourcesPath}/img/logo_hitam-putih.png" alt="Logo Dark" class="hidden dark:block w-auto h-16" />
          <div class="font-bold">
            <h1 class="text-xl lg:text-xl dark:text-gray-300">Single Sign-On ASN</h1>
            <p class="text-sm dark:text-gray-300 lg:text-lg">Kabupaten Ponorogo</p>
          </div>
        </div>
        <div class="bg-[#fdf1f1] dark:bg-transparent lg:px-2 flex flex-col items-center">
          <div class="flex lg:gap-x-2 lg:pt-3 px-2 mt-4 items-center">
            <img src="${url.resourcesPath}/img/korpri_warna.png" alt="Logo" class="block dark:hidden w-auto h-36 lg:h-42" />
            <img src="${url.resourcesPath}/img/korpri_hitam.png" alt="Logo Dark" class="hidden dark:block w-auto h-36 lg:h-42" />

            <div class="px-5">
              <div class="lg:text-lg font-bold text-[#8e4137] dark:text-gray-300">Selamat Datang</div>
              <div class="lg:text-base font-bold text-[#8e4137] dark:text-gray-300">di Portal Single <br />Sign-On (SSO) ASN</div>
              <div class="text-xs lg:text-xs mt-2 text-gray-700 dark:text-gray-300">Satu akun untuk semua layanan aplikasi ASN Kabupaten Ponorogo</div>
            </div>
          </div>
          <div class="hidden lg:block">
            <div class="flex flex-row gap-x-5 items-center p-4 my-4">
              <div>
                <div class="flex justify-center gap-x-2 items-center">
                  <i class="fa-solid fa-lock text-2xl text-red-800 dark:text-gray-500"></i>
                  <div class="text-sm font-semibold text-red-800 leading-4 dark:text-gray-300">Aman & Terpusat</div>
                </div>
                <div class="mt-1 text-xs leading-3.5 dark:text-gray-300">Satu Akun Untuk Semua Aplikasi</div>
              </div>
              <div>
                <div class="flex justify-center gap-x-2 items-center">
                  <i class="fa-solid fa-bolt-lightning text-2xl text-red-800 dark:text-gray-500"></i>
                  <div class="text-sm font-semibold text-red-800 leading-4 dark:text-gray-300">Cepat & Efisien</div>
                </div>
                <div class="mt-1 text-xs leading-3.5 dark:text-gray-300">Sekali login, langsung akses semua layanan</div>
              </div>
              <div>
                <div class="flex justify-center gap-x-2 items-center">
                  <i class="fas fa-landmark text-2xl text-red-800 dark:text-gray-500"></i>
                  <div class="text-sm font-semibold text-red-800 leading-4 dark:text-gray-300">Resmi Untuk ASN</div>
                </div>
                <div class="mt-1 text-xs leading-3.5 dark:text-gray-300">Hanya untuk ASN Kabupaten Ponorogo</div>
              </div>
            </div>
          </div>
        </div>
        <div class="hidden lg:block">
          <div class="bg-[#bd4137] dark:bg-gray-600 h-1 w-full">&nbsp;</div>
          <div class="mt-1">
            <div class="flex flex-col justify-center items-center gap-4 p-2">
              <span class="text-xs dark:text-gray-300"> © 2025 Pemerintah Kabupaten Ponorogo <br />Dinas Komunikasi Informatika dan Statistik </span>
            </div>
          </div>
        </div>
      </div>
      <div class="max-w-md w-full bg-[#fdf1f1] lg:bg-white dark:bg-gray-800/80 shadow-2xl rounded-b-xl lg:rounded-2xl relative overflow-hidden z-10">
        <div class="bg-white rounded-t-2xl dark:bg-transparent px-3 hidden lg:block">
          <div class="h-20 flex gap-x-2 items-center w-full justify-center mt-2 font-bold">
            <h1 class="lg:text-xl dark:text-gray-300">Masuk ke Akun Anda</h1>
          </div>
        </div>
        <div class="px-8 py-4 lg:py-0 lg:pb-8">
          <#if message?has_content>
          <div class="bg-yellow-50 mb-4 lg:mb-3 dark:bg-yellow-900 border-yellow-200 dark:border-yellow-700 text-sm text-yellow-800 dark:text-yellow-200 rounded-lg p-1" role="alert" tabindex="-1" aria-labelledby="hs-with-description-label">
            <div class="flex">
              <div class="shrink-0">
                <svg class="shrink-0 size-4 mt-0.5" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path>
                  <path d="M12 9v4"></path>
                  <path d="M12 17h.01"></path>
                </svg>
              </div>
              <div class="ms-4">
                <h3 class="text-sm font-semibold">Error.</h3>
                <div class="mt-1 text-sm text-yellow-700 dark:text-yellow-200">${message.summary}.</div>
              </div>
            </div>
          </div>
          </#if>
          <div class="lg:border-0 shadow-lg border-2 border-gray-200 dark:border-gray-700 px-4 rounded-xl bg-white dark:bg-transparent lg:bg-transparent">
            <form id="kc-form-login" method="post" action="${url.loginAction}" class="space-y-4">
              <input type="hidden" name="credentialId" value="${credentialId!}" />
              <div>
                <label for="username" class="block text-sm font-medium text-gray-700 dark:text-gray-200">Nomor Induk Pegawai ( NIP )</label>
                <input
                  id="username"
                  name="username"
                  type="text"
                  required
                  autofocus
                  autocomplete="username"
                  class="mt-1 w-full px-4 py-2 text-sm border rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500 border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300"
                  placeholder="NIP"
                  value="${username!}"
                />
              </div>
              <div>
                <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-200">Password</label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  required
                  autocomplete="current-password"
                  class="mt-1 w-full px-4 py-2 text-sm border rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500 border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300"
                  placeholder="Password"
                />
              </div>
              <button
                tabindex="3"
                type="submit"
                class="w-full cursor-pointer bg-red-600 dark:bg-red-900 text-white font-semibold p-2 px-4 rounded-xl hover:bg-red-700 dark:hover:bg-red-800 transition duration-200 flex items-center justify-center gap-2 mb-1.5"
              >
                Masuk
              </button>
            </form>        
            <div class="flex justify-end items-center py-2">
              <a href="https://simashebat.ponorogo.go.id/reset-password/" target="_blank" rel="noopener noreferrer" class="text-xs italic dark:text-gray-300 hover:underline">Reset Password</a>
            </div>          
          </div>
          <div class="hidden lg:block mt-4 text-gray-600 dark:text-gray-300">
            <ul>
              <li class="text-xs italic">Username dan Password Menggunakan yang ada di SIMASHEBAT</li>
              <li class="text-xs italic pt-2">jika kesulitan hubungi 
                <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer" class="py-1 px-2 cursor-pointer bg-red-600 dark:bg-red-900 text-white font-semibold  rounded-md hover:bg-red-700 dark:hover:bg-red-800 transition duration-200 "> Klik disini</a>
              </li>           
            </ul>
          </div>          
        </div>
        <div class="lg:hidden">
          <div class="bg-[#bd4137] dark:bg-gray-600 h-1 w-full">&nbsp;</div>
          <div class="mt-1 bg-white dark:bg-transparent lg:bg-transparent">
            <div class="flex flex-col justify-center items-center gap-4 p-2">
              <span class="text-xs dark:text-gray-300"> © 2025 Pemerintah Kabupaten Ponorogo <br />Dinas Komunikasi Informatika dan Statistik </span>
            </div>
          </div>
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
