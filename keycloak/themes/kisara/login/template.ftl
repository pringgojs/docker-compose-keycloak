<#--
  template.ftl — chrome bersama SEMUA halaman login theme "kisara".

  Signature registrationLayout sama dengan base Keycloak (bodyClass,
  displayInfo, displayMessage, displayRequiredFields) dan memanggil semua
  section (header, show-username, form, socialProviders, info), supaya
  halaman base yang tidak kita tulis ulang (login-reset-password,
  select-authenticator, update-password, webauthn-*, terms, page-expired, …)
  ikut ter-render di dalam chrome ini.

  ⚠️ <script> di halaman WAJIB berada di dalam blok section-nya: kode di luar
  blok dirender sekali per section (4×) — jebakan yang pernah kena di
  pramana-citizen.
-->
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="<#if realm.internationalizationEnabled>${locale.currentLanguageTag}<#else>id</#if>">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />
    <meta name="color-scheme" content="light dark" />
    <title>Masuk — Kisara SSO</title>
    <link rel="icon" href="${url.resourcesPath}/img/kisara-sso.svg" type="image/svg+xml" />
    <link rel="icon" href="${url.resourcesPath}/img/favicon-32.png" sizes="32x32" type="image/png" />
    <link rel="apple-touch-icon" href="${url.resourcesPath}/img/favicon-32.png" />

    <#-- Mode gelap mengikuti perangkat, dipasang sebelum CSS supaya tak berkedip. -->
    <script>if (window.matchMedia && matchMedia('(prefers-color-scheme: dark)').matches) document.documentElement.classList.add('dark');</script>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <#if properties.styles?has_content>
      <#list properties.styles?split(' ') as style>
        <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
      </#list>
    </#if>

    <#-- WAJIB di KC 26: webauthnAuthenticate.js (passkey) meng-import bare
         specifier "rfc4648". Tanpa importmap: "Failed to resolve module
         specifier rfc4648" → tombol passkey mati. -->
    <script type="importmap">
        {
            "imports": {
                "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
            }
        }
    </script>

    <#-- KC 26: authChecker.js meng-export startSessionPolling + checkAuthSession.
         Salah nama export mematikan seluruh module, termasuk passkey. -->
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

  <body class="${properties.kcBodyClass!} ${bodyClass}">
    <main class="${properties.kcLoginClass!}">
      <div class="${properties.kcFormCardClass!}">
        <div class="ks-strip"></div>
        <div class="px-7 pb-8 pt-6 sm:px-9">

          <#-- Merek: logo Kisara SSO + lambang Ponorogo sebagai tanda halaman resmi -->
          <div class="flex items-center gap-3">
            <img src="${url.resourcesPath}/img/kisara-sso.svg" alt="" class="h-10 w-10 shrink-0" />
            <div class="min-w-0 leading-tight">
              <div class="text-[1.35rem] tracking-tight"><span class="text-slate-500 dark:text-slate-400">Kisara</span> <span class="font-bold text-slate-900 dark:text-white">SSO</span></div>
              <div class="text-xs text-slate-500 dark:text-slate-400">Pemerintah Kabupaten Ponorogo</div>
            </div>
            <img src="${url.resourcesPath}/img/ponorogo.png" alt="Lambang Kabupaten Ponorogo" class="ml-auto h-10 w-auto shrink-0" />
          </div>

          <header class="${properties.kcFormHeaderClass!}">
            <h1 id="kc-page-title" class="text-2xl font-semibold tracking-tight text-slate-900 dark:text-white"><#nested "header"></h1>
            <#if auth?has_content && auth.showUsername() && !auth.showResetCredentials()>
              <#nested "show-username">
              <div id="kc-username" class="mt-3 inline-flex max-w-full items-center gap-2 rounded-full border border-slate-300 py-1 pl-3 pr-1 text-sm text-slate-700 dark:border-slate-700 dark:text-slate-200">
                <span id="kc-attempted-username" class="truncate">${auth.attemptedUsername}</span>
                <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg("restartLoginTooltip")}" title="Ganti akun"
                   class="grid h-7 w-7 place-items-center rounded-full text-slate-500 hover:bg-slate-100 hover:text-slate-800 dark:hover:bg-slate-800 dark:hover:text-white">
                  <i class="${properties.kcResetFlowIcon!}" aria-hidden="true"></i>
                </a>
              </div>
            </#if>
            <#if displayRequiredFields>
              <p class="mt-1 text-xs text-slate-500 dark:text-slate-400"><span class="text-red-500">*</span> ${msg("requiredFields")}</p>
            </#if>
          </header>

          <div id="kc-content">
            <div id="kc-content-wrapper">
              <#-- Peringatan "selesaikan aksi" tak perlu untuk aksi yang dimulai aplikasi -->
              <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="${properties.kcAlertClass!} <#if message.type = 'error'>border-red-200 bg-red-50 text-red-700 dark:border-red-900/60 dark:bg-red-950/40 dark:text-red-300<#elseif message.type = 'success'>border-emerald-200 bg-emerald-50 text-emerald-800 dark:border-emerald-900/60 dark:bg-emerald-950/40 dark:text-emerald-300<#elseif message.type = 'warning'>border-amber-200 bg-amber-50 text-amber-800 dark:border-amber-900/60 dark:bg-amber-950/40 dark:text-amber-300<#else>border-sky-200 bg-sky-50 text-sky-800 dark:border-sky-900/60 dark:bg-sky-950/40 dark:text-sky-300</#if>"
                     role="alert" aria-live="polite">
                  <span class="mt-0.5 shrink-0">
                    <#if message.type = 'success'><i class="${properties.kcFeedbackSuccessIcon!}" aria-hidden="true"></i>
                    <#elseif message.type = 'warning'><i class="${properties.kcFeedbackWarningIcon!}" aria-hidden="true"></i>
                    <#elseif message.type = 'error'><i class="${properties.kcFeedbackErrorIcon!}" aria-hidden="true"></i>
                    <#else><i class="${properties.kcFeedbackInfoIcon!}" aria-hidden="true"></i></#if>
                  </span>
                  <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
                </div>
              </#if>

              <#nested "form">

              <#-- "Coba cara lain" sengaja tidak ditampilkan: passkey sudah
                   tersedia lewat tombolnya sendiri di halaman masuk. -->

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
        </div>
      </div>

      <footer class="mt-6 flex flex-wrap items-center justify-center gap-x-4 gap-y-1 text-xs text-slate-500 dark:text-slate-400">
        <span>© ${.now?string('yyyy')} Pemerintah Kabupaten Ponorogo</span>
        <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer" class="hover:text-slate-800 hover:underline dark:hover:text-white">Bantuan</a>
        <span>Diskominfo</span>
        <#if realm.internationalizationEnabled && locale.supported?size gt 1>
          <#list locale.supported as l>
            <#if l.languageTag != locale.currentLanguageTag>
              <a href="${l.url}" class="hover:text-slate-800 hover:underline dark:hover:text-white">${l.label}</a>
            </#if>
          </#list>
        </#if>
      </footer>
    </main>
  </body>
</html>
</#macro>
