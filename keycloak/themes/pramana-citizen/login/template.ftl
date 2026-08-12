<#--
  template.ftl — chrome bersama SEMUA halaman theme pramana-citizen
  (halaman masuk & daftar WARGA · realm ponorogo-citizen · Keycloak 26.7).

  MEKANIK KEYCLOAK 26.7 — JANGAN DIUBAH:
  - signature macro registrationLayout + seluruh blok <#nested "..."> (header,
    show-username, form, socialProviders, info) supaya setiap base form page
    (login-reset-password, login-update-password, select-authenticator,
    webauthn-*, terms, page-expired, verify-email, register) ikut ter-render
    lewat chrome ini TANPA override per page.
  - <script type="importmap"> yang memetakan "rfc4648" — WAJIB untuk passkey;
    tanpa itu webauthnAuthenticate.js gagal resolve module.
  - authChecker.js dengan startSessionPolling + checkAuthSession (API KC26).
    JANGAN dikembalikan ke API KC24 yang lama — nama export-nya berbeda, dan
    salah nama membuat seluruh module gagal dimuat serta ikut mematikan passkey.

  VISUAL — dua pola, mengikuti mockup PRAMANA:
  - Halaman MASUK & DAFTAR: latar marun penuh bergradien, logo di tengah,
    tombol putih menonjol. Ditandai lewat `bodyClass` yang dikirim page.
  - Halaman lanjutan (OTP, reset, verify, error): latar putih, header ramping
    dengan judul. Latarnya HARUS putih — kotak catatan memakai bg-zinc-50, dan
    kalau latar layarnya ikut zinc-50 kotak itu melebur jadi putih polos.

  TANPA dark mode: mockup PRAMANA hanya punya mode terang, dan halaman masuk
  sudah gelap dengan sendirinya lewat latar marun.

  IKON: seluruhnya SVG Lucide inline (stroke=currentColor). Tidak ada
  FontAwesome, tidak ada emoji — emoji dirender OS sehingga berubah bentuk
  antar merek ponsel.
-->
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<#--
  marunPage: halaman berlatar marun penuh (masuk & daftar). Page lain memakai
  chrome putih. Dikenali dari bodyClass yang dikirim page — pola yang sama
  dipakai Keycloak sendiri untuk membedakan varian halaman.
-->
<#assign marunPage = bodyClass?contains("pramana-marun")>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />
    <title>${msg("loginTitle",(realm.displayName!'PRAMANA'))}</title>

    <#if properties.styles?has_content>
      <#list properties.styles?split(' ') as style>
        <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
      </#list>
    </#if>

    <#-- Import map WAJIB di KC 26 utk passkey (webauthnAuthenticate.js import "rfc4648"). -->
    <script type="importmap">
        {
            "imports": {
                "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
            }
        }
    </script>

    <#-- KC 26.7 authChecker API: startSessionPolling + checkAuthSession. -->
    <script type="module">
        <#outputformat "JavaScript">
        import { startSessionPolling } from ${(url.resourcesPath + "/js/authChecker.js")?c};
        startSessionPolling(
            ${url.ssoLoginInOtherTabsUrl?c}
        );
        </#outputformat>
    </script>
    <#if authenticationSession??>
      <script type="module">
        <#outputformat "JavaScript">
        import { checkAuthSession } from ${(url.resourcesPath + "/js/authChecker.js")?c};
        checkAuthSession(
            ${authenticationSession.authSessionIdHash?c}
        );
        </#outputformat>
      </script>
    </#if>
  </head>

  <#-- Kelas `pramana-marun` sengaja ikut dipasang ke <body>: input.css memakainya
       untuk menyesuaikan label & ring field yang dirender base Keycloak (User
       Profile) agar terbaca di atas latar marun. Menghapusnya membuat label
       halaman daftar nyaris tak terlihat. -->
  <body class="<#if marunPage>pramana-marun min-h-screen font-sans bg-gradient-to-b from-marun-900 via-marun-800 to-marun-900 text-white<#else>${properties.kcBodyClass!}</#if>">
    <div class="${properties.kcLoginClass!}">
      <div class="<#if marunPage>flex min-h-screen w-full flex-col<#else>${properties.kcFormCardClass!}</#if>">

        <#if marunPage>
          <#-- ===== Halaman marun: logo + judul di tengah atas ===== -->
          <div class="flex flex-1 flex-col px-6 pb-8 pt-16">
            <div class="flex flex-col items-center text-center">
              <div class="flex h-16 w-16 items-center justify-center rounded-3xl bg-white/10 ring-1 ring-white/20">
                <@pramanaLogo size=42 />
              </div>
              <h1 id="kc-page-title" class="mt-4 text-xl font-extrabold tracking-tight text-white"><#nested "header"></h1>
              <p class="mt-1.5 text-[11px] leading-relaxed text-marun-200">
                Layanan Pemerintah Kabupaten Ponorogo
              </p>
              <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
                <#if displayRequiredFields>
                  <p class="mt-2 text-[10px] text-marun-300"><span class="font-bold text-emas-300">*</span> ${msg("requiredFields")}</p>
                </#if>
              <#else>
                <#nested "show-username">
                <div id="kc-username" class="mt-2 flex items-center gap-2 text-[11px] text-marun-200">
                  <label id="kc-attempted-username">${auth.attemptedUsername}</label>
                  <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg('restartLoginTooltip')}"
                     title="${msg('restartLoginTooltip')}" class="inline-flex text-marun-300 transition hover:text-emas-300">
                    <#-- lucide: rotate-ccw -->
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>
                  </a>
                </div>
              </#if>
            </div>

            <div class="mt-8 flex-1">
              <@feedbackAlert displayMessage=displayMessage marun=true />
              <#nested "form">
              <#nested "socialProviders">
              <#if displayInfo>
                <div id="kc-info" class="mt-5 text-center text-[11px] text-marun-200">
                  <div id="kc-info-wrapper"><#nested "info"></div>
                </div>
              </#if>
            </div>

            <#-- Catatan privasi UU 27/2022 — ada di mockup, jangan dihilangkan. -->
            <div class="mt-6 flex gap-2 rounded-xl bg-white/8 p-3 ring-1 ring-white/12">
              <span class="mt-0.5 shrink-0 text-emas-300">
                <#-- lucide: shield-check -->
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/><path d="m9 12 2 2 4-4"/></svg>
              </span>
              <#-- kcSanitize + ?no_esc: pesannya memuat <b> untuk menegaskan
                   nama undang-undangnya. Disanitasi lebih dulu, sesuai cara
                   base Keycloak menangani pesan ber-markup. -->
              <p class="text-[9px] leading-relaxed text-marun-200">
                ${kcSanitize(msg("pramanaPrivacyNote"))?no_esc}
              </p>
            </div>
          </div>

        <#else>
          <#-- ===== Halaman lanjutan: header ramping + isi putih ===== -->
          <header class="${properties.kcFormHeaderClass!}">
            <div class="flex items-center gap-3">
              <div>
                <h1 id="kc-page-title" class="${properties.kcHeaderClass!}"><#nested "header"></h1>
                <#if auth?has_content && auth.showUsername() && !auth.showResetCredentials()>
                  <#nested "show-username">
                  <div id="kc-username" class="flex items-center gap-1.5 text-[10px] text-zinc-400">
                    <label id="kc-attempted-username">${auth.attemptedUsername}</label>
                    <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg('restartLoginTooltip')}"
                       title="${msg('restartLoginTooltip')}" class="inline-flex text-zinc-400 transition hover:text-marun-700">
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>
                    </a>
                  </div>
                <#elseif displayRequiredFields>
                  <p class="text-[10px] text-zinc-400"><span class="font-bold text-rose-600">*</span> ${msg("requiredFields")}</p>
                </#if>
              </div>
            </div>
          </header>

          <div class="${properties.kcContentWrapperClass!}">
            <@feedbackAlert displayMessage=displayMessage marun=false />
            <#nested "form">
            <#nested "socialProviders">
            <#if displayInfo>
              <div id="kc-info" class="${properties.kcSignUpClass!}">
                <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}"><#nested "info"></div>
              </div>
            </#if>
          </div>
        </#if>

      </div>
    </div>
  </body>
</html>
</#macro>

<#--
  Alert umpan balik. Dipakai kedua pola halaman; `marun` menentukan paletnya
  karena di atas latar marun kotak berwarna terang tidak terbaca.

  Kondisi (message.type != 'warning' || !isAppInitiatedAction??) disalin dari
  base Keycloak: pada app-initiated action, peringatan "selesaikan aksi" hanya
  membingungkan warga yang memang sedang menjalankan aksi itu.
-->
<#macro feedbackAlert displayMessage=true marun=false>
  <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
    <#if marun>
      <div class="mb-4 flex items-start gap-2.5 rounded-xl p-3 text-[11px] leading-relaxed <#if message.type = 'error'>bg-rose-500/15 text-rose-100 ring-1 ring-rose-300/30<#elseif message.type = 'success'>bg-emerald-500/15 text-emerald-100 ring-1 ring-emerald-300/30<#elseif message.type = 'warning'>bg-amber-500/15 text-amber-100 ring-1 ring-amber-300/30<#else>bg-white/10 text-marun-100 ring-1 ring-white/20</#if>"
           role="alert" aria-live="polite">
        <span class="mt-px shrink-0"><@alertIcon type=message.type /></span>
        <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
      </div>
    <#else>
      <div class="mb-4 flex gap-2.5 rounded-xl p-3.5 text-[10px] leading-relaxed ring-1 <#if message.type = 'error'>bg-rose-50 text-rose-800 ring-rose-100<#elseif message.type = 'success'>bg-emerald-50 text-emerald-800 ring-emerald-100<#elseif message.type = 'warning'>bg-amber-50 text-amber-800 ring-amber-100<#else>bg-sky-50 text-sky-800 ring-sky-100</#if>"
           role="alert" aria-live="polite">
        <span class="mt-0.5 shrink-0 <#if message.type = 'error'>text-rose-600<#elseif message.type = 'success'>text-emerald-600<#elseif message.type = 'warning'>text-amber-600<#else>text-sky-600</#if>"><@alertIcon type=message.type /></span>
        <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
      </div>
    </#if>
  </#if>
</#macro>

<#-- Ikon alert — Lucide inline, satu ukuran untuk semua tipe. -->
<#macro alertIcon type="info">
  <#if type = 'success'>
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg>
  <#elseif type = 'warning'>
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
  <#elseif type = 'error'>
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m15 9-6 6"/><path d="m9 9 6 6"/></svg>
  <#else>
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
  </#if>
</#macro>

<#--
  Logo PRAMANA — path SVG asli dari mockup/src/components/Logo.jsx.
  Dadak merak Reog: kipas bulu emas, lengkung pangkal marun yang sekaligus
  huruf "P" dan tangan menengadah, titik emas di tengah sebagai warga.
  id gradien di-suffix ukuran supaya dua logo di satu halaman tidak bentrok.
-->
<#macro pramanaLogo size=42>
<svg width="${size}" height="${size}" viewBox="0 0 64 64" role="img" aria-label="Logo Pramana">
  <defs>
    <linearGradient id="pg-${size}-emas" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#f9d947"/><stop offset="100%" stop-color="#c68407"/>
    </linearGradient>
    <linearGradient id="pg-${size}-marun" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#a32c2c"/><stop offset="100%" stop-color="#7a1f1f"/>
    </linearGradient>
  </defs>
  <path d="M32 6C20 6 10 16 8 30c0 0 6-4 10-4s7 3 7 3-2-9 2-14 5-9 5-9z" fill="url(#pg-${size}-emas)" opacity=".55"/>
  <path d="M32 6c12 0 22 10 24 24 0 0-6-4-10-4s-7 3-7 3 2-9-2-14-5-9-5-9z" fill="url(#pg-${size}-emas)" opacity=".55"/>
  <path d="M32 8c-8 0-15 8-16 20 0 0 4-3 7-3s5 2 5 2-1-8 1-12 3-7 3-7z" fill="url(#pg-${size}-emas)" opacity=".8"/>
  <path d="M32 8c8 0 15 8 16 20 0 0-4-3-7-3s-5 2-5 2 1-8-1-12-3-7-3-7z" fill="url(#pg-${size}-emas)" opacity=".8"/>
  <path d="M32 7c-3 0-5 6-5 14s2 12 5 12 5-4 5-12-2-14-5-14z" fill="url(#pg-${size}-emas)"/>
  <path d="M14 34c0 12 8 22 18 24 10-2 18-12 18-24 0 0-7 5-18 5s-18-5-18-5z" fill="url(#pg-${size}-marun)"/>
  <circle cx="32" cy="43" r="5" fill="#f9d947"/><circle cx="32" cy="43" r="2.2" fill="#7a1f1f"/>
</svg>
</#macro>
