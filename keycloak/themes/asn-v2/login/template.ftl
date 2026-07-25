<#--
  template.ftl — chrome bersama untuk SEMUA halaman login theme asn-v2.

  Signature macro registrationLayout SAMA PERSIS dengan base Keycloak 24.0.3
  (bodyClass, displayInfo, displayMessage, displayRequiredFields) + semua
  <#nested> block (header, show-username, form, socialProviders, info) supaya
  setiap base form page (login-otp, login-reset-password, login-reset-otp,
  recovery-codes, update-profile, verify-email, select-authenticator, terms,
  page-expired, code, dst.) ke-render lewat chrome ini tanpa override per page.
-->
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />
    <title>${msg("loginTitle",(realm.displayName!'Single Sign-On ASN Ponorogo'))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/logo.png" />

    <#if properties.styles?has_content>
      <#list properties.styles?split(' ') as style>
        <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
      </#list>
    </#if>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" rel="stylesheet" />

    <#if properties.scripts?has_content>
      <#list properties.scripts?split(' ') as script>
        <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
      </#list>
    </#if>

    <#-- Import map WAJIB di KC 26: JS passkey base (webauthnAuthenticate.js) meng-import
         bare specifier "rfc4648". Tanpa blok ini browser gagal resolve module →
         "Failed to resolve module specifier rfc4648" → tombol passkey mati.
         Di-port dari base 26.7 template.ftl. -->
    <script type="importmap">
        {
            "imports": {
                "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
            }
        }
    </script>

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

    <#-- KC 26.7: authChecker.js meng-export startSessionPolling + checkAuthSession
         (BUKAN checkCookiesAndSetTimer seperti KC24). Signature di-port dari base
         26.7 template.ftl. Salah nama export = "does not provide an export named
         checkCookiesAndSetTimer" → seluruh module gagal, ikut mematikan passkey. -->
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
    <div id="particles-js"></div>

    <div class="${properties.kcLoginClass!}">
      <div class="${properties.kcFormCardClass!}">

        <#-- ===== Brand header (logo Ponorogo + KORPRI) ===== -->
        <div class="asn-brand bg-white dark:bg-gradient-to-r dark:from-gray-800 dark:via-gray-700 dark:to-gray-600 px-6 pt-5 pb-4 flex items-center gap-3 border-b border-gray-100 dark:border-gray-700">
          <img src="${url.resourcesPath}/img/logo_warna.png" alt="Logo" class="block dark:hidden w-auto h-14" />
          <img src="${url.resourcesPath}/img/logo_hitam-putih.png" alt="Logo" class="hidden dark:block w-auto h-14" />
          <div class="leading-tight">
            <h1 class="text-lg font-bold text-gray-800 dark:text-gray-100">Single Sign-On ASN</h1>
            <p class="text-xs text-gray-500 dark:text-gray-300">Kabupaten Ponorogo</p>
          </div>
        </div>

        <header class="${properties.kcFormHeaderClass!}">
          <#-- Locale switcher (kalau realm pakai i18n & >1 bahasa) -->
          <#if realm.internationalizationEnabled && locale.supported?size gt 1>
            <div class="${properties.kcLocaleMainClass!}" id="kc-locale">
              <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                <div id="kc-locale-dropdown" class="${properties.kcLocaleDropDownClass!}">
                  <button type="button" id="kc-current-locale-link" aria-haspopup="true" aria-expanded="false"
                          class="px-2 py-1 rounded border border-gray-200 dark:border-gray-600 text-gray-600 dark:text-gray-300"
                          onclick="var m=document.getElementById('language-switch1'); m.classList.toggle('hidden');">
                    <i class="fa-solid fa-globe mr-1"></i>${locale.current}
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

          <#-- Page title (header block) + optional required-fields hint -->
          <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
            <h1 id="kc-page-title" class="text-xl font-bold text-gray-800 dark:text-gray-100"><#nested "header"></h1>
            <#if displayRequiredFields>
              <p class="mt-1 text-xs text-gray-400 dark:text-gray-500"><span class="text-red-500">*</span> ${msg("requiredFields")}</p>
            </#if>
          <#else>
            <#-- Mode "lanjutan dari user yang sudah terdeteksi": tampilkan username + tombol restart -->
            <h1 id="kc-page-title" class="text-xl font-bold text-gray-800 dark:text-gray-100"><#nested "header"></h1>
            <#nested "show-username">
            <div id="kc-username" class="mt-2 flex items-center justify-center gap-2 text-sm text-gray-600 dark:text-gray-300">
              <label id="kc-attempted-username">${auth.attemptedUsername}</label>
              <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg("restartLoginTooltip")}"
                 class="text-red-600 dark:text-red-400 hover:underline" title="${msg("restartLoginTooltip")}">
                <i class="${properties.kcResetFlowIcon!}"></i>
              </a>
            </div>
          </#if>
        </header>

        <#-- ===== Konten utama (alert + form + social + info) ===== -->
        <div id="kc-content" class="px-8 pb-6 pt-2">
          <div id="kc-content-wrapper">

            <#-- Alert: app-initiated action tidak perlu warning "selesaikan aksi" -->
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
              <div class="${properties.kcAlertClass!} <#if message.type = 'error'>asn-alert-error bg-red-50 dark:bg-red-900/30 border-red-200 dark:border-red-800 text-red-800 dark:text-red-200<#elseif message.type = 'success'>asn-alert-success bg-emerald-50 dark:bg-emerald-900/30 border-emerald-200 dark:border-emerald-800 text-emerald-800 dark:text-emerald-200<#elseif message.type = 'warning'>asn-alert-warning bg-amber-50 dark:bg-amber-900/30 border-amber-200 dark:border-amber-800 text-amber-800 dark:text-amber-200<#else>asn-alert-info bg-sky-50 dark:bg-sky-900/30 border-sky-200 dark:border-sky-800 text-sky-800 dark:text-sky-200</#if>"
                   role="alert" aria-live="polite">
                <span class="shrink-0 mt-0.5">
                  <#if message.type = 'success'><i class="${properties.kcFeedbackSuccessIcon!}"></i>
                  <#elseif message.type = 'warning'><i class="${properties.kcFeedbackWarningIcon!}"></i>
                  <#elseif message.type = 'error'><i class="${properties.kcFeedbackErrorIcon!}"></i>
                  <#else><i class="${properties.kcFeedbackInfoIcon!}"></i></#if>
                </span>
                <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
              </div>
            </#if>

            <#-- FORM body dari masing-masing page -->
            <#nested "form">

            <#-- Try another way (multi-authenticator) -->
            <#if auth?has_content && auth.showTryAnotherWayLink()>
              <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" class="mt-3 text-center">
                <input type="hidden" name="tryAnotherWay" value="on" />
                <a href="#" id="try-another-way" class="text-sm text-red-600 dark:text-red-400 hover:underline"
                   onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
              </form>
            </#if>

            <#nested "socialProviders">

            <#-- Info block -->
            <#if displayInfo>
              <div id="kc-info" class="${properties.kcSignUpClass!}">
                <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                  <#nested "info">
                </div>
              </div>
            </#if>
          </div>
        </div>

        <#-- ===== Footer ===== -->
        <div class="asn-footer">
          <div class="bg-[#bd4137] dark:bg-gray-600 h-1 w-full">&nbsp;</div>
          <div class="px-6 py-3 text-center">
            <p class="text-[11px] leading-tight text-gray-500 dark:text-gray-400">
              © 2025 Pemerintah Kabupaten Ponorogo<br />
              Dinas Komunikasi Informatika dan Statistik
            </p>
          </div>
        </div>

      </div>
    </div>

    <#-- Particles background config (sama seperti theme asn) -->
    <script>
      window.particlesJS && particlesJS("particles-js", {
        particles: {
          number: { value: 60, density: { enable: true, value_area: 800 } },
          color: { value: "#bd4137" },
          shape: { type: "circle" },
          opacity: { value: 0.35 },
          size: { value: 3 },
          line_linked: { enable: true, distance: 150, color: "#bd4137", opacity: 0.25, width: 1 },
          move: { enable: true, speed: 2, direction: "none", out_mode: "out" }
        },
        interactivity: {
          events: { onhover: { enable: true, mode: "grab" }, onclick: { enable: true, mode: "push" } },
          modes: { grab: { distance: 140, line_linked: { opacity: 0.4 } }, push: { particles_nb: 4 } }
        },
        retina_detect: true
      });
    </script>
  </body>
</html>
</#macro>
