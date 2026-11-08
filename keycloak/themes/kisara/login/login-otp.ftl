<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
  <#if section = "header">
    Verifikasi dua langkah
  <#elseif section = "form">
    <p class="mt-1.5 text-sm text-slate-500 dark:text-slate-400">Akun Anda dilindungi verifikasi dua langkah.</p>
    <form id="kc-otp-login-form" action="${url.loginAction}" method="post" class="mt-6 space-y-4">

      <#-- Pilih perangkat bila punya lebih dari satu -->
      <#if otpLogin.userOtpCredentials?size gt 1>
        <div class="space-y-2">
          <#list otpLogin.userOtpCredentials as otpCredential>
            <input id="kc-otp-credential-${otpCredential?index}" class="${properties.kcLoginOTPListInputClass!} sr-only"
                   type="radio" name="selectedCredentialId" value="${otpCredential.id}"
                   <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if> />
            <label for="kc-otp-credential-${otpCredential?index}" class="${properties.kcLoginOTPListClass!}">
              <span class="${properties.kcLoginOTPListItemIconBodyClass!}"><i class="${properties.kcLoginOTPListItemIconClass!}" aria-hidden="true"></i></span>
              <span class="${properties.kcLoginOTPListItemTitleClass!}">${otpCredential.userLabel}</span>
            </label>
          </#list>
        </div>
      </#if>

      <div>
        <p class="mb-4 text-sm text-slate-600 dark:text-slate-300">Masukkan 6 digit kode dari aplikasi autentikator Anda.</p>
        <#-- Input asli yang dikirim; diisi otomatis oleh kotak-kotak (otp-input.js) -->
        <input type="hidden" id="otp" name="otp" autocomplete="off" value="" />
        <div class="ks-otp" data-otp-target="otp" data-otp-autofocus>
          <#list 1..6 as i>
            <input class="ks-otp-cell" type="text" inputmode="numeric" maxlength="1" autocomplete="<#if i==1>one-time-code<#else>off</#if>" aria-label="Digit ${i}" />
          </#list>
        </div>
        <#if messagesPerField.existsError('totp')>
          <span id="input-error-otp-code" class="${properties.kcInputErrorMessageClass!} text-center" aria-live="polite">
            ${kcSanitize(messagesPerField.get('totp'))?no_esc}
          </span>
        </#if>
      </div>

      <button type="submit" name="login" id="kc-login"
              class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}">
        Verifikasi
      </button>
    </form>

    <p class="mt-4 text-center text-sm text-slate-500 dark:text-slate-400">Bermasalah dengan kode? <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer" class="font-semibold text-ks-accent hover:underline dark:text-teal-300">Hubungi bantuan</a></p>
    <script src="${url.resourcesPath}/js/otp-input.js"></script>
  </#if>
</@layout.registrationLayout>
