<#import "template.ftl" as layout>
<#import "passkeys.ftl" as passkeys>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=false; section>
  <#if section = "header">
    Masuk ke Akun Anda
  <#elseif section = "form">
    <#if realm.password>
      <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" class="space-y-4">
        <#if !usernameHidden??>
          <div class="${properties.kcFormGroupClass!}">
            <label for="username" class="${properties.kcLabelClass!}">Nomor Induk Pegawai ( NIP )</label>
            <input tabindex="2" id="username" name="username" type="text" value="${(login.username!'')}"
                   autofocus autocomplete="${(enableWebAuthnConditionalUI?has_content)?then('username webauthn', 'username')}"
                   class="${properties.kcInputClass!}" placeholder="NIP"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
            <#if messagesPerField.existsError('username','password')>
              <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
              </span>
            </#if>
          </div>
        </#if>

        <div class="${properties.kcFormGroupClass!}">
          <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
          <div class="${properties.kcInputGroup!}">
            <input tabindex="3" id="password" name="password" type="password" autocomplete="current-password"
                   class="${properties.kcInputClass!}" placeholder="Password"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
            <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="${msg('showPassword')}"
                    aria-controls="password" data-password-toggle tabindex="4"
                    data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                    data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
              <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
            </button>
          </div>
          <#if usernameHidden?? && messagesPerField.existsError('username','password')>
            <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
              ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
            </span>
          </#if>
        </div>

        <#if realm.rememberMe && !usernameHidden??>
          <div class="flex items-center">
            <label class="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-300">
              <input tabindex="5" id="rememberMe" name="rememberMe" type="checkbox" class="accent-red-600" <#if login.rememberMe??>checked</#if> />
              ${msg("rememberMe")}
            </label>
          </div>
        </#if>

        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if> />
        <button tabindex="7" type="submit" name="login" id="kc-login"
                class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}">
          Masuk
        </button>
      </form>

      <#-- Passkey: tombol "Login dengan Passkey" + conditional-UI autofill.
           Macro conditionalUIData (dari base passkeys.ftl) HANYA render kalau
           realm punya Enable Passkeys aktif (enableWebAuthnConditionalUI terisi).
           Render: hidden #webauth form, JS webauthnAuthenticate + passkeysConditionalAuth,
           dan tombol #authenticateWebAuthnButton. Autofill jalan dari
           autocomplete="username webauthn" di field username di atas. -->
      <#if enableWebAuthnConditionalUI?has_content>
        <div class="passkey-divider flex items-center gap-3 my-4">
          <span class="flex-1 h-px bg-gray-200 dark:bg-neutral-700"></span>
          <span class="text-xs text-gray-400">atau</span>
          <span class="flex-1 h-px bg-gray-200 dark:bg-neutral-700"></span>
        </div>
      </#if>
      <@passkeys.conditionalUIData />

      <div class="flex justify-end items-center pt-2">
        <#if realm.resetPasswordAllowed>
          <a tabindex="6" href="${url.loginResetCredentialsUrl}" class="text-xs italic text-gray-500 dark:text-gray-300 hover:underline">${msg("doForgotPassword")}</a>
        <#else>
          <a href="https://simashebat.ponorogo.go.id/reset-password/" target="_blank" rel="noopener noreferrer" class="text-xs italic text-gray-500 dark:text-gray-300 hover:underline">Reset Password</a>
        </#if>
      </div>

      <div class="mt-4 text-gray-600 dark:text-gray-300">
        <ul class="space-y-2">
          <li class="text-xs italic">Username dan Password menggunakan yang ada di SIMASHEBAT</li>
          <li class="text-xs italic">jika kesulitan hubungi
            <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer"
               class="py-1 px-2 bg-red-600 dark:bg-red-900 text-white font-semibold rounded-md hover:bg-red-700 dark:hover:bg-red-800 transition">Klik disini</a>
          </li>
        </ul>
      </div>
    </#if>
    <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
  </#if>
</@layout.registrationLayout>
