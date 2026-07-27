<#--
  template.ftl — chrome bersama SEMUA halaman theme agustusan-2026 (HUT RI ke-81).
  Struktur teknis (macro signature, importmap rfc4648, authChecker KC26, nested
  blocks) di-port dari asn-v2 (terbukti KC 26.7). Chrome visual = hero merah +
  logo HUT-81 + umbul-umbul, di-styling theme.css. Auto dark mode via CSS.
-->
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />
    <title>${msg("loginTitle",(realm.displayName!'Single Sign-On ASN Ponorogo'))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/hut-ri-81.png" />

    <#if properties.styles?has_content>
      <#list properties.styles?split(' ') as style>
        <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
      </#list>
    </#if>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" rel="stylesheet" />

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

        <#-- ===== HERO merah + logo HUT-81 + lencana ===== -->
        <div class="${properties.kcFormHeaderClass!}">
          <span class="hero-logo"><img src="${url.resourcesPath}/img/hut-ri-81.png" alt="HUT RI ke-81" /></span>

          <#-- Locale switcher (opsional) -->
          <#if realm.internationalizationEnabled && locale.supported?size gt 1>
            <div style="position:absolute;top:10px;right:12px;z-index:2;font-size:11px;">
              <button type="button" onclick="var m=document.getElementById('lang-sw'); m.style.display = (m.style.display==='block'?'none':'block');"
                      style="color:#fff;background:rgba(255,255,255,.18);border:none;border-radius:8px;padding:3px 8px;cursor:pointer;">
                <i class="fa-solid fa-globe"></i> ${locale.current}
              </button>
              <ul id="lang-sw" style="display:none;position:absolute;right:0;margin-top:4px;background:#fff;border-radius:8px;overflow:hidden;list-style:none;padding:4px 0;box-shadow:0 8px 20px rgba(0,0,0,.15);">
                <#list locale.supported as l>
                  <li><a href="${l.url}" style="display:block;padding:5px 14px;color:#334155;text-decoration:none;font-size:12px;">${l.label}</a></li>
                </#list>
              </ul>
            </div>
          </#if>

          <#-- Judul realm / page title (di hero) -->
          <h1>Single Sign-On ASN</h1>
          <p>Kabupaten Ponorogo</p>
          <span class="lencana">🇮🇩 ${msg("hut81Badge","Dirgahayu RI ke-81")}</span>
        </div>

        <#-- ===== BODY: title page + username (restart) + alert + form ===== -->
        <div class="body">

          <#-- Title tiap page (kecuali mode show-username lanjutan) -->
          <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
            <div class="judul"><#nested "header"> <span class="bendera-mini"></span></div>
          <#else>
            <div class="judul"><#nested "header"></div>
            <#nested "show-username">
            <div class="subjudul" style="display:flex;align-items:center;gap:8px;">
              <span>${auth.attemptedUsername}</span>
              <a href="${url.loginRestartFlowUrl}" class="tautan" title="${msg('restartLoginTooltip')}"><i class="${properties.kcResetFlowIcon!}"></i></a>
            </div>
          </#if>

          <#if displayRequiredFields>
            <p class="subjudul"><span style="color:var(--merah)">*</span> ${msg("requiredFields")}</p>
          </#if>

          <#-- Alert (info/error/warning/success) -->
          <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
            <div class="${properties.kcAlertClass!} <#if message.type='error'>alert-error<#elseif message.type='success'>alert-success<#elseif message.type='warning'>alert-warning<#else>alert-info</#if>" role="alert" aria-live="polite">
              <span>
                <#if message.type='success'><i class="${properties.kcFeedbackSuccessIcon!}"></i>
                <#elseif message.type='warning'><i class="${properties.kcFeedbackWarningIcon!}"></i>
                <#elseif message.type='error'><i class="${properties.kcFeedbackErrorIcon!}"></i>
                <#else><i class="${properties.kcFeedbackInfoIcon!}"></i></#if>
              </span>
              <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
            </div>
          </#if>

          <#-- FORM body dari tiap page -->
          <#nested "form">

          <#-- 'Coba cara lain' sengaja dihilangkan (redundan dgn tombol passkey). -->

          <#nested "socialProviders">

          <#-- Info block -->
          <#if displayInfo>
            <div class="${properties.kcSignUpClass!}"><#nested "info"></div>
          </#if>
        </div>

        <#-- ===== Umbul-umbul zigzag di kaki ===== -->
        <div class="umbul"></div>
      </div>
    </div>

    <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
  </body>
</html>
</#macro>
