<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
  <#if section = "header">
    Verifikasi OTP
  <#elseif section = "form">
    <form id="kc-otp-login-form" action="${url.loginAction}" method="post" class="space-y-4">

      <#-- Pilih perangkat OTP kalau user punya >1 -->
      <#if otpLogin.userOtpCredentials?size gt 1>
        <div class="${properties.kcFormGroupClass!}">
          <#list otpLogin.userOtpCredentials as otpCredential>
            <input id="kc-otp-credential-${otpCredential?index}" class="${properties.kcLoginOTPListInputClass!} sr-only"
                   type="radio" name="selectedCredentialId" value="${otpCredential.id}"
                   <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if> />
            <label for="kc-otp-credential-${otpCredential?index}" class="${properties.kcLoginOTPListClass!}">
              <span class="${properties.kcLoginOTPListItemHeaderClass!}">
                <span class="${properties.kcLoginOTPListItemIconBodyClass!}">
                  <i class="${properties.kcLoginOTPListItemIconClass!}" aria-hidden="true"></i>
                </span>
                <span class="${properties.kcLoginOTPListItemTitleClass!}">${otpCredential.userLabel}</span>
              </span>
            </label>
          </#list>
        </div>
      </#if>

      <div class="${properties.kcFormGroupClass!}">
        <label class="${properties.kcLabelClass!} text-center">${msg("loginOtpOneTime")}</label>
        <#-- Real input dikirim ke Keycloak; diisi otomatis oleh kotak-kotak -->
        <input type="hidden" id="otp" name="otp" autocomplete="off" value="" />
        <div class="asn-otp mt-2" data-otp-target="otp" data-otp-autofocus>
          <#list 1..6 as i>
            <input class="asn-otp-cell" type="text" inputmode="numeric" maxlength="1" autocomplete="<#if i==1>one-time-code<#else>off</#if>" aria-label="Digit ${i}" />
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

    <div class="mt-5 text-center text-sm text-gray-500 dark:text-gray-400">
      Bermasalah dengan OTP? Layanan Bantuan
      <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer"
         class="py-1 px-2 bg-red-600 dark:bg-red-900 text-white font-semibold rounded-md hover:bg-red-700 dark:hover:bg-red-800 transition">Klik disini</a>.
    </div>
    <script src="${url.resourcesPath}/js/otp-input.js"></script>
  </#if>
</@layout.registrationLayout>
