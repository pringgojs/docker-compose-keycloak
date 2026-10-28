<#--
  template.ftl — chrome bersama SEMUA halaman theme sumpah-pemuda-2026
  (Hari Sumpah Pemuda ke-98 · Kisara SSO · Kabupaten Ponorogo).
  Disalin dari agustusan-2026; yang berbeda hanya hero, palet, dan pita.

  MEKANIK KEYCLOAK 26.7 — JANGAN DIUBAH:
  - signature macro registrationLayout + seluruh blok <#nested "..."> (header,
    show-username, form, socialProviders, info) supaya setiap base form page
    ikut ke-render lewat chrome ini tanpa override per page.
  - <script type="importmap"> yang memetakan "rfc4648" — WAJIB untuk passkey;
    tanpa itu webauthnAuthenticate.js gagal resolve module.
  - authChecker.js dengan startSessionPolling + checkAuthSession (API KC26).
    JANGAN dikembalikan ke API KC24 yang lama — nama export-nya berbeda, dan
    salah nama membuat seluruh module gagal dimuat serta ikut mematikan passkey.

  VISUAL: hero kertas lama + cap pos "98 TAHOEN" + tiga ikrar Sumpah Pemuda
  bergantian (ejaan asli) + pita merah-putih di kepala dan kaki kartu.
  Styling memakai utility Tailwind lewat properties kc*Class (theme.properties);
  komponen non-utility ada di resources/css/input.css.

  IKON: seluruhnya SVG Lucide inline (stroke=currentColor). Tidak ada
  FontAwesome, tidak ada emoji.
-->
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />
    <title>${msg("loginTitle",(realm.displayName!'Kisara SSO'))}</title>
    <#-- Font hero. Bila Google Fonts tak terjangkau, fontFamily di
         tailwind.config.js jatuh ke monospace/serif dan halaman tetap utuh. -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Special+Elite&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet" />

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

  <body class="${properties.kcBodyClass!}">
    <div class="${properties.kcLoginClass!}">
      <div class="${properties.kcFormCardClass!}">

        <div class="pita"></div>

        <#-- ===== HERO: kertas lama + cap 98 + tiga ikrar bergantian ===== -->
        <div class="${properties.kcFormHeaderClass!}">
          <#-- Pemilih bahasa (kalau realm memakai i18n & >1 bahasa) -->
          <#if realm.internationalizationEnabled && locale.supported?size gt 1>
            <div class="${properties.kcLocaleMainClass!}" id="kc-locale">
              <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                <div id="kc-locale-dropdown" class="${properties.kcLocaleDropDownClass!}">
                  <button type="button" id="kc-current-locale-link" aria-haspopup="true" aria-expanded="false"
                          class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-tinta/10 text-tinta dark:bg-white/10 dark:text-[#ead9b8] font-semibold"
                          onclick="var m=document.getElementById('language-switch1'); m.classList.toggle('hidden');">
                    <#-- lucide: globe -->
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"/><path d="M2 12h20"/></svg>
                    ${locale.current}
                  </button>
                  <ul id="language-switch1" class="${properties.kcLocaleListClass!}">
                    <#list locale.supported as l>
                      <li class="${properties.kcLocaleListItemClass!}">
                        <a class="${properties.kcLocaleItemClass!}" href="${l.url}">${l.label}</a>
                      </li>
                    </#list>
                  </ul>
                </div>
              </div>
            </div>
          </#if>

          <#-- Cap pos bundar -->
          <div class="cap absolute right-7 top-7 w-[62px] h-[62px] rounded-full flex flex-col items-center justify-center text-merah/80 dark:text-merah-muda/80" aria-hidden="true">
            <span class="font-judul text-[22px] font-extrabold leading-none">98</span>
            <span class="font-ketik text-[7px] tracking-widest mt-0.5">TAHOEN</span>
          </div>

          <p class="font-ketik text-[10.5px] tracking-[.2em] text-merah dark:text-merah-muda">28 OKTOBER 1928</p>
          <h1 class="font-judul text-[26px] font-extrabold leading-tight mt-2 pr-20">Soempah Pemoeda</h1>
          <p class="text-[11px] opacity-70 mt-1">Kisara SSO &middot; Kabupaten Ponorogo</p>

          <#-- Tiga ikrar dengan ejaan asli 1928 (van Ophuijsen). Teks sengaja
               tidak lewat messages_*.properties: ini kutipan sejarah, bukan
               teks antarmuka yang diterjemahkan. -->
          <div class="ikrar-wadah mt-6">
            <div class="ikrar">
              <span class="font-ketik text-[10px] tracking-widest text-merah dark:text-merah-muda">PERTAMA</span>
              <p class="font-ketik text-[13px] leading-relaxed mt-1.5 kursor">Kami poetera dan poeteri Indonesia, mengakoe bertoempah darah jang satoe, tanah Indonesia.</p>
            </div>
            <div class="ikrar">
              <span class="font-ketik text-[10px] tracking-widest text-merah dark:text-merah-muda">KEDOEA</span>
              <p class="font-ketik text-[13px] leading-relaxed mt-1.5 kursor">Kami poetera dan poeteri Indonesia, mengakoe berbangsa jang satoe, bangsa Indonesia.</p>
            </div>
            <div class="ikrar">
              <span class="font-ketik text-[10px] tracking-widest text-merah dark:text-merah-muda">KETIGA</span>
              <p class="font-ketik text-[13px] leading-relaxed mt-1.5 kursor">Kami poetera dan poeteri Indonesia, mendjoendjoeng bahasa persatoean, bahasa Indonesia.</p>
            </div>
          </div>
        </div>

        <#-- ===== BODY: judul page + alert + form + info ===== -->
        <div id="kc-content" class="relative z-20 -mt-4 rounded-t-[20px] bg-white dark:bg-neutral-900 px-8 pt-7 pb-8">
          <div id="kc-content-wrapper">

            <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
              <h1 id="kc-page-title" class="flex items-center gap-2 text-[17px] font-bold text-slate-900 dark:text-white"><#nested "header"></h1>
              <#if displayRequiredFields>
                <p class="text-xs text-slate-400 dark:text-neutral-500 mt-0.5 mb-4"><span class="text-merah font-bold">*</span> ${msg("requiredFields")}</p>
              </#if>
            <#else>
              <#-- Mode lanjutan: user sudah terdeteksi, tampilkan username + tombol mulai ulang -->
              <h1 id="kc-page-title" class="flex items-center gap-2 text-[17px] font-bold text-slate-900 dark:text-white"><#nested "header"></h1>
              <#nested "show-username">
              <div id="kc-username" class="flex items-center gap-2 text-xs text-slate-400 dark:text-neutral-500 mt-0.5 mb-4">
                <label id="kc-attempted-username">${auth.attemptedUsername}</label>
                <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg('restartLoginTooltip')}"
                   title="${msg('restartLoginTooltip')}" class="inline-flex text-slate-400 hover:text-merah transition">
                  <#-- lucide: refresh-cw -->
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/><path d="M8 16H3v5"/></svg>
                </a>
              </div>
              <#if displayRequiredFields>
                <p class="text-xs text-slate-400 dark:text-neutral-500 mt-0.5 mb-4"><span class="text-merah font-bold">*</span> ${msg("requiredFields")}</p>
              </#if>
            </#if>

            <#-- Alert: app-initiated action tidak perlu peringatan "selesaikan aksi" -->
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
              <div class="${properties.kcAlertClass!} <#if message.type = 'error'>bg-rose-50 dark:bg-rose-500/15 border-rose-200 dark:border-rose-500/30 text-rose-700 dark:text-rose-300<#elseif message.type = 'success'>bg-emerald-50 dark:bg-emerald-500/15 border-emerald-200 dark:border-emerald-500/30 text-emerald-700 dark:text-emerald-300<#elseif message.type = 'warning'>bg-amber-50 dark:bg-amber-500/15 border-amber-200 dark:border-amber-500/30 text-amber-700 dark:text-amber-300<#else>bg-sky-50 dark:bg-sky-500/15 border-sky-200 dark:border-sky-500/30 text-sky-700 dark:text-sky-300</#if>"
                   role="alert" aria-live="polite">
                <span class="shrink-0 mt-px">
                  <#if message.type = 'success'>
                    <#-- lucide: check-circle -->
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg>
                  <#elseif message.type = 'warning'>
                    <#-- lucide: alert-triangle -->
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
                  <#elseif message.type = 'error'>
                    <#-- lucide: alert-circle -->
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>
                  <#else>
                    <#-- lucide: info -->
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
                  </#if>
                </span>
                <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
              </div>
            </#if>

            <#-- FORM body dari masing-masing page -->
            <#nested "form">

            <#-- 'Coba cara lain' (tryAnotherWay) sengaja dihilangkan: pilihan
                 passkey sudah tersedia lewat tombol sidik jari di form login. -->

            <#nested "socialProviders">

            <#if displayInfo>
              <div id="kc-info" class="${properties.kcSignUpClass!}">
                <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                  <#nested "info">
                </div>
              </div>
            </#if>
            <p class="font-ketik text-[11px] text-stone-500 dark:text-neutral-500 text-center mt-4">${msg("sumpahPemudaUcapan")}</p>
          </div>
        </div>

        <div class="pita"></div>
      </div>
    </div>
  </body>
</html>
</#macro>
