<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
  <#if section = "header">
    Verifikasi OTP
  <#elseif section = "form">
    <div class="subjudul">Masukkan 6 digit kode dari aplikasi authenticator Anda</div>

    <form id="kc-otp-login-form" action="${url.loginAction}" method="post">
      <#if otpLogin.userOtpCredentials?size gt 1>
        <div class="field-group">
          <#list otpLogin.userOtpCredentials as otpCredential>
            <input id="kc-otp-credential-${otpCredential?index}" class="otp-radio sr-only" type="radio" name="selectedCredentialId" value="${otpCredential.id}"
                   <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if> />
            <label for="kc-otp-credential-${otpCredential?index}" class="otp-item">
              <span class="otp-item-icon"><i class="${properties.kcLoginOTPListItemIconClass!}"></i></span>
              <span class="otp-item-title">${otpCredential.userLabel}</span>
            </label>
          </#list>
        </div>
      </#if>

      <input type="hidden" id="otp" name="otp" autocomplete="off" value="" />
      <div class="otp-row" data-otp-target="otp" data-otp-autofocus>
        <#list 1..6 as i>
          <input class="otp-input" type="text" inputmode="numeric" maxlength="1" autocomplete="<#if i==1>one-time-code<#else>off</#if>" aria-label="Digit ${i}" />
        </#list>
      </div>
      <#if messagesPerField.existsError('totp')>
        <span id="input-error-otp-code" class="inp-error" style="text-align:center" aria-live="polite">${kcSanitize(messagesPerField.get('totp'))?no_esc}</span>
      </#if>

      <button type="submit" name="login" id="kc-login" class="btn btn-block">Verifikasi</button>
    </form>

    <div class="catatan">Bermasalah dengan OTP? <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer" class="pil-bantuan">💬 Bantuan RAKACA</a></div>

    <script type="module" src="${url.resourcesPath}/js/otp-input.js"></script>
  </#if>
</@layout.registrationLayout>
