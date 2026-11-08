<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp') displayRequiredFields=false; section>
  <#if section = "header">
    Aktivasi OTP
  <#elseif section = "form">
    <p class="text-sm text-center text-slate-500 dark:text-slate-400 mb-4">
      Pindai QR code dengan
      <span class="font-semibold text-ks-accent dark:text-teal-300 uppercase">aplikasi Google Authenticator</span>
      lalu masukkan kode OTP yang muncul.
    </p>

    <form id="kc-totp-settings-form" action="${url.loginAction}" method="post" class="space-y-4">
      <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
      <#if mode??><input type="hidden" id="mode" name="mode" value="${mode}" /></#if>

      <#-- QR code -->
      <div class="flex justify-center">
        <img src="data:image/png;base64,${totp.totpSecretQrCode}" alt="QR Code OTP"
             class="w-40 h-40 rounded-lg border border-slate-200 dark:border-slate-700" />
      </div>

      <#-- Manual key -->
      <div class="text-sm text-center text-slate-600 dark:text-slate-300">
        <p>Atau masukkan manual:</p>
        <code class="block mt-1 font-semibold text-slate-900 dark:text-white break-all">${totp.totpSecretEncoded}</code>
      </div>

      <div class="${properties.kcFormGroupClass!}">
        <label class="${properties.kcLabelClass!} text-center">
          Kode 6 digit dari aplikasi autentikator
        </label>
        <#-- Real input (dikirim ke Keycloak), diisi otomatis oleh kotak-kotak di bawah -->
        <input type="hidden" id="totp" name="totp" value="" />
        <div class="ks-otp mt-2" data-otp-target="totp" data-otp-autofocus>
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

      <#-- Nama perangkat OTP — membantu user mengenali perangkat bila punya >1 -->
      <div class="${properties.kcFormGroupClass!}">
        <label for="userLabel" class="${properties.kcLabelClass!}">Nama Perangkat</label>
        <input type="text" id="userLabel" name="userLabel" autocomplete="off"
               value="OTP Google Authenticator" placeholder="Misal: HP Kantor / HP Pribadi"
               class="${properties.kcInputClass!}"
               aria-invalid="<#if messagesPerField.existsError('userLabel')>true</#if>" />
        <#if messagesPerField.existsError('userLabel')>
          <span id="input-error-otp-label" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
            ${kcSanitize(messagesPerField.get('userLabel'))?no_esc}
          </span>
        </#if>
      </div>

      <div class="${properties.kcFormButtonsClass!}">
        <#if isAppInitiatedAction??>
          <input type="submit" id="saveTOTPBtn"
                 class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}"
                 value="Aktifkan OTP" />
          <button type="submit" id="cancelTOTPBtn" name="cancel-aia" value="true"
                  class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}">${msg("doCancel")}</button>
        <#else>
          <input type="submit" id="saveTOTPBtn"
                 class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                 value="Aktifkan OTP" />
        </#if>
      </div>
    </form>

    <p class="mt-4 text-center text-sm text-slate-500 dark:text-slate-400">Bermasalah dengan kode? <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer" class="font-semibold text-ks-accent hover:underline dark:text-teal-300">Hubungi bantuan</a></p>
    <script src="${url.resourcesPath}/js/otp-input.js"></script>
  </#if>
</@layout.registrationLayout>
