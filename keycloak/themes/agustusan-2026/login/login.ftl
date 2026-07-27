<#import "template.ftl" as layout>
<#import "passkeys.ftl" as passkeys>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=false; section>
  <#if section = "header">
    Masuk ke Akun Anda
  <#elseif section = "form">
    <#if realm.password>
      <div class="subjudul">Gunakan akun <b>SIMASHEBAT</b> Anda</div>

      <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
        <#if !usernameHidden??>
          <label for="username" class="label">Nomor Induk Pegawai (NIP)</label>
          <div class="field">
            <input tabindex="2" id="username" name="username" type="text" value="${(login.username!'')}"
                   autofocus autocomplete="${(enableWebAuthnConditionalUI?has_content)?then('username webauthn', 'username')}"
                   class="inp" placeholder="Masukkan NIP Anda"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
            <svg class="ikon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="16" rx="2"/><circle cx="9" cy="10" r="2"/><path d="M15 8h3M15 12h3M7 16h10"/></svg>
          </div>
          <#if messagesPerField.existsError('username','password')>
            <span id="input-error" class="inp-error" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}</span>
          </#if>
        </#if>

        <label for="password" class="label">${msg("password")}</label>
        <div class="field has-toggle">
          <input tabindex="3" id="password" name="password" type="password" autocomplete="current-password"
                 class="inp pw" placeholder="Masukkan password"
                 aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
          <svg class="ikon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>
          <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="${msg('showPassword')}"
                  aria-controls="password" data-password-toggle tabindex="4"
                  data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                  data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
            <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
          </button>
        </div>
        <#if usernameHidden?? && messagesPerField.existsError('username','password')>
          <span id="input-error" class="inp-error" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}</span>
        </#if>

        <div class="opsi">
          <#if realm.rememberMe && !usernameHidden??>
            <label class="cek"><input tabindex="5" id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if> /> ${msg("rememberMe")}</label>
          <#else>
            <span></span>
          </#if>
          <#if realm.resetPasswordAllowed>
            <a tabindex="6" href="${url.loginResetCredentialsUrl}" class="tautan">${msg("doForgotPassword")}</a>
          <#else>
            <a href="https://simashebat.ponorogo.go.id/reset-password/" target="_blank" rel="noopener noreferrer" class="tautan">Reset Password</a>
          </#if>
        </div>

        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if> />
        <button tabindex="7" type="submit" name="login" id="kc-login" class="btn btn-block">
          Masuk
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
        </button>
      </form>

      <#-- Passkey: tombol + conditional-UI autofill. Macro dari base passkeys.ftl,
           render hanya kalau Enable Passkeys aktif (enableWebAuthnConditionalUI terisi). -->
      <#if enableWebAuthnConditionalUI?has_content>
        <div class="divider">atau</div>
      </#if>
      <@passkeys.conditionalUIData />

      <div class="catatan">
        Username &amp; Password menggunakan akun SIMASHEBAT.<br />
        Kesulitan masuk? <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer" class="pil-bantuan">💬 Bantuan RAKACA</a>
      </div>
    </#if>
    <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
  </#if>
</@layout.registrationLayout>
