<#--
  register.ftl — halaman daftar warga.

  Tampil di dalam Custom Tabs. Ada dua jalan warga sampai ke sini:
    1. dari halaman masuk lewat tautan "Daftar sekarang", atau
    2. langsung dari tombol "Daftar Akun Baru" di aplikasi, yang membuka
       /protocol/openid-connect/registrations — jalan pintas supaya warga baru
       tidak perlu singgah ke halaman masuk dulu.

  ⚠️ FIELD TIDAK DITULIS MANUAL DI SINI.

  Keycloak 26 memakai User Profile: daftar field (nama, email, dst.) berasal
  dari konfigurasi realm, bukan dari template. Macro userProfileFormFields
  me-loop `profile.attributes` dan merender tiap field lengkap dengan label,
  pesan galat, dan atribut html5-nya.

  Menulis <input> sendiri di sini berarti melawan mekanisme itu: field yang
  ditambahkan admin lewat User Profile tidak akan muncul, dan validasi
  per-atribut berhenti bekerja. Karena itu struktur DOM dibiarkan milik base,
  dan penataannya sepenuhnya lewat properties kc*Class di theme.properties.

  Blok password di bawah disalin dari base register.ftl — POSISINYA yang
  penting: ia disisipkan lewat callback "afterField" tepat setelah username
  (atau email bila email dipakai sebagai username), sehingga urutan kolom
  terasa wajar. Realm ini memakai UUID sebagai username, jadi kolom yang
  tampil ke warga adalah email.
-->
<#import "template.ftl" as layout>
<#import "user-profile-commons.ftl" as userProfileCommons>
<#import "register-commons.ftl" as registerCommons>

<#-- displayInfo=true wajib: tanpa itu blok "info" (tautan kembali ke halaman
     masuk) tidak dirender template sama sekali. -->
<@layout.registrationLayout bodyClass="pramana-marun" displayMessage=messagesPerField.exists('global') displayRequiredFields=true displayInfo=true; section>
  <#if section = "header">
    ${msg("registerTitle")}

  <#elseif section = "form">
    <form id="kc-register-form" action="${url.registrationAction}" method="post">

      <@userProfileCommons.userProfileFormFields; callback, attribute>
        <#if callback = "afterField">
          <#-- Kata sandi disisipkan tepat di bawah username/email — mengikuti
               base, supaya urutannya tidak melompat. -->
          <#if passwordRequired?? && (attribute.name == 'username' || (attribute.name == 'email' && realm.registrationEmailAsUsername))>

            <div class="${properties.kcFormGroupClass!}">
              <label for="password" class="${properties.kcLabelClass!}">
                ${msg("password")} <span class="text-emas-300">*</span>
              </label>
              <div class="${properties.kcInputGroup!}" dir="ltr">
                <input type="password" id="password" name="password" autocomplete="new-password"
                       class="${properties.kcInputClass!}"
                       aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>" />
                <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button"
                        aria-label="${msg('showPassword')}" aria-controls="password" data-password-toggle
                        data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}"
                        data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                        data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                  <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                </button>
              </div>
              <#if messagesPerField.existsError('password')>
                <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                  ${kcSanitize(messagesPerField.get('password'))?no_esc}
                </span>
              </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
              <label for="password-confirm" class="${properties.kcLabelClass!}">
                ${msg("passwordConfirm")} <span class="text-emas-300">*</span>
              </label>
              <div class="${properties.kcInputGroup!}" dir="ltr">
                <input type="password" id="password-confirm" name="password-confirm" autocomplete="new-password"
                       class="${properties.kcInputClass!}"
                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
                <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button"
                        aria-label="${msg('showPassword')}" aria-controls="password-confirm" data-password-toggle
                        data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}"
                        data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                        data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                  <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                </button>
              </div>
              <#if messagesPerField.existsError('password-confirm')>
                <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                  ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                </span>
              </#if>
            </div>

          </#if>
        </#if>
      </@userProfileCommons.userProfileFormFields>

      <@registerCommons.termsAcceptance/>

      <#-- reCAPTCHA: DISABLED di realm ini, tetapi blok dipertahankan supaya
           mengaktifkannya kelak cukup lewat pengaturan realm, tanpa menyunting
           template lagi. -->
      <#if recaptchaRequired?? && (recaptchaVisible!false)>
        <div class="${properties.kcFormGroupClass!}">
          <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
        </div>
      </#if>

      <div class="mt-5">
        <#if recaptchaRequired?? && !(recaptchaVisible!false)>
          <script>
            function onSubmitRecaptcha(token) {
              document.getElementById("kc-register-form").requestSubmit();
            }
          </script>
          <button type="submit" data-sitekey="${recaptchaSiteKey}" data-callback="onSubmitRecaptcha" data-action="${recaptchaAction}"
                  class="g-recaptcha flex w-full items-center justify-center rounded-xl bg-white py-3.5 text-[13px] font-bold text-marun-800 shadow-lg transition hover:bg-marun-50">
            ${msg("doRegister")}
          </button>
        <#else>
          <button type="submit"
                  class="flex w-full items-center justify-center rounded-xl bg-white py-3.5 text-[13px] font-bold text-marun-800 shadow-lg transition hover:bg-marun-50">
            ${msg("doRegister")}
          </button>
        </#if>
      </div>
    </form>
    <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>

  <#elseif section = "info">
    <span class="text-[11px] text-marun-200">
      ${msg("alreadyHaveAccount")}
      <a href="${url.loginUrl}" class="font-bold text-emas-300 underline">${msg("doLogIn")}</a>
    </span>
  </#if>
</@layout.registrationLayout>
