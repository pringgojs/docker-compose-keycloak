<#--
  template.ftl — chrome bersama SEMUA halaman theme agustusan-2026
  (HUT RI ke-81 · Kisara SSO · Kabupaten Ponorogo).

  MEKANIK KEYCLOAK 26.7 — JANGAN DIUBAH:
  - signature macro registrationLayout + seluruh blok <#nested "..."> (header,
    show-username, form, socialProviders, info) supaya setiap base form page
    ikut ke-render lewat chrome ini tanpa override per page.
  - <script type="importmap"> yang memetakan "rfc4648" — WAJIB untuk passkey;
    tanpa itu webauthnAuthenticate.js gagal resolve module.
  - authChecker.js dengan startSessionPolling + checkAuthSession (API KC26).
    JANGAN dikembalikan ke API KC24 yang lama — nama export-nya berbeda, dan
    salah nama membuat seluruh module gagal dimuat serta ikut mematikan passkey.

  VISUAL: hero merah bergradien + kembang api CSS + logo HUT-81 + umbul-umbul.
  Styling memakai utility Tailwind lewat properties kc*Class (theme.properties);
  komponen non-utility ada di resources/css/input.css.

  IKON: seluruhnya SVG Lucide inline (stroke=currentColor). Tidak ada
  FontAwesome, tidak ada emoji.

  KEMBANG API: markup di bawah disalin apa adanya dari keluaran kembangApi()
  pada preview/build-preview.js (varian C3 — 2 roket + 4 letupan, 36 <i>,
  6 <b>, 2 <u>). Jangan diketik ulang manual; regenerasi lewat node kalau
  desainnya berubah.
-->
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />
    <title>${msg("loginTitle",(realm.displayName!'Kisara SSO'))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/hut-ri-81.png" />

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

        <#-- ===== HERO: kembang api + logo HUT-81 + judul + lencana ===== -->
        <div class="${properties.kcFormHeaderClass!}">
        <div class="roket" style="left:18%;--tinggi:-64px;animation-delay:0s"></div>
        <div class="letup" style="left:calc(18% - 50px);top:14px;--jauh:-42px">
          <u style="animation-delay:1.15s"></u>
          <i style="--r:0deg;animation-delay:1.15s"></i>
          <i style="--r:30deg;animation-delay:1.18s"></i>
          <i style="--r:60deg;animation-delay:1.21s"></i>
          <i style="--r:90deg;animation-delay:1.24s"></i>
          <i style="--r:120deg;animation-delay:1.27s"></i>
          <i style="--r:150deg;animation-delay:1.30s"></i>
          <i style="--r:180deg;animation-delay:1.33s"></i>
          <i style="--r:210deg;animation-delay:1.36s"></i>
          <i style="--r:240deg;animation-delay:1.39s"></i>
          <i style="--r:270deg;animation-delay:1.42s"></i>
          <i style="--r:300deg;animation-delay:1.45s"></i>
          <i style="--r:330deg;animation-delay:1.48s"></i>
          <b style="--r:45deg;animation-delay:1.25s"></b>
          <b style="--r:135deg;animation-delay:1.31s"></b>
          <b style="--r:225deg;animation-delay:1.37s"></b>
          <b style="--r:315deg;animation-delay:1.43s"></b>
        </div>
        <div class="roket" style="right:22%;--tinggi:-56px;animation-delay:1.7s"></div>
        <div class="letup" style="right:calc(22% - 50px);top:26px;--jauh:-34px">
          <u style="animation-delay:2.85s"></u>
          <i style="--r:0deg;animation-delay:2.85s"></i>
          <i style="--r:36deg;animation-delay:2.88s"></i>
          <i style="--r:72deg;animation-delay:2.91s"></i>
          <i style="--r:108deg;animation-delay:2.94s"></i>
          <i style="--r:144deg;animation-delay:2.97s"></i>
          <i style="--r:180deg;animation-delay:3.00s"></i>
          <i style="--r:216deg;animation-delay:3.03s"></i>
          <i style="--r:252deg;animation-delay:3.06s"></i>
          <i style="--r:288deg;animation-delay:3.09s"></i>
          <i style="--r:324deg;animation-delay:3.12s"></i>
          <b style="--r:90deg;animation-delay:2.95s"></b>
          <b style="--r:270deg;animation-delay:3.01s"></b>
        </div>
        <div class="letup" style="left:-28px;bottom:-24px;--jauh:-30px">
          <i style="--r:0deg;--h:20px;animation-delay:0.60s"></i>
          <i style="--r:51deg;--h:20px;animation-delay:0.63s"></i>
          <i style="--r:103deg;--h:20px;animation-delay:0.66s"></i>
          <i style="--r:154deg;--h:20px;animation-delay:0.69s"></i>
          <i style="--r:206deg;--h:20px;animation-delay:0.72s"></i>
          <i style="--r:257deg;--h:20px;animation-delay:0.75s"></i>
          <i style="--r:309deg;--h:20px;animation-delay:0.78s"></i>
        </div>
        <div class="letup" style="right:-26px;top:-26px;--jauh:-28px">
          <i style="--r:0deg;--h:18px;animation-delay:2.20s"></i>
          <i style="--r:51deg;--h:18px;animation-delay:2.23s"></i>
          <i style="--r:103deg;--h:18px;animation-delay:2.26s"></i>
          <i style="--r:154deg;--h:18px;animation-delay:2.29s"></i>
          <i style="--r:206deg;--h:18px;animation-delay:2.32s"></i>
          <i style="--r:257deg;--h:18px;animation-delay:2.35s"></i>
          <i style="--r:309deg;--h:18px;animation-delay:2.38s"></i>
        </div>

          <#-- Pemilih bahasa (kalau realm memakai i18n & >1 bahasa) -->
          <#if realm.internationalizationEnabled && locale.supported?size gt 1>
            <div class="${properties.kcLocaleMainClass!}" id="kc-locale">
              <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                <div id="kc-locale-dropdown" class="${properties.kcLocaleDropDownClass!}">
                  <button type="button" id="kc-current-locale-link" aria-haspopup="true" aria-expanded="false"
                          class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-white/[.18] text-white font-semibold"
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

          <span class="relative z-10 inline-block bg-white rounded-2xl px-3 py-2 shadow-lg">
            <img src="${url.resourcesPath}/img/hut-ri-81.png" alt="HUT RI ke-81" class="h-14 w-auto block" />
          </span>
          <h1 class="relative z-10 mt-3 mb-0.5 text-[17px] font-extrabold">Kisara SSO</h1>
          <p class="relative z-10 text-[11px] text-white/85">Kabupaten Ponorogo</p>
          <#-- Lencana bendera merah-putih. Di preview lencana hanya muncul di
               halaman login; di sini chrome dipakai bersama jadi selalu tampil. -->
          <span class="relative z-10 inline-flex items-center gap-1.5 mt-2.5 px-3 py-0.5 text-[10.5px] font-semibold bg-white/[.16] rounded-full backdrop-blur">
            <svg width="14" height="10" viewBox="0 0 20 14" aria-hidden="true"><rect width="20" height="7" fill="#c8102e"/><rect y="7" width="20" height="7" fill="#fff"/><rect width="20" height="14" fill="none" stroke="rgba(255,255,255,.5)" stroke-width="1"/></svg>
            ${msg("hut81Badge","Dirgahayu RI ke-81")}
          </span>
        </div>

        <#-- ===== BODY: judul page + alert + form + info ===== -->
        <div id="kc-content" class="relative z-20 -mt-3.5 rounded-t-[20px] bg-white dark:bg-neutral-900 p-6">
          <div id="kc-content-wrapper">

            <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
              <h1 id="kc-page-title" class="flex items-center gap-2 text-[17px] font-bold text-slate-900 dark:text-white"><#nested "header"> <span class="bendera-mini"></span></h1>
              <#if displayRequiredFields>
                <p class="text-xs text-slate-400 dark:text-neutral-500 mt-0.5 mb-4"><span class="text-merah font-bold">*</span> ${msg("requiredFields")}</p>
              </#if>
            <#else>
              <#-- Mode lanjutan: user sudah terdeteksi, tampilkan username + tombol mulai ulang -->
              <h1 id="kc-page-title" class="flex items-center gap-2 text-[17px] font-bold text-slate-900 dark:text-white"><#nested "header"> <span class="bendera-mini"></span></h1>
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
          </div>
        </div>

        <#-- ===== Umbul-umbul zigzag merah-putih di kaki kartu ===== -->
        <div class="umbul"></div>
      </div>
    </div>
  </body>
</html>
</#macro>
