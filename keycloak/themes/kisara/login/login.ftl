<#import "template.ftl" as layout>
<#import "passkeys.ftl" as passkeys>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=false; section>
  <#if section = "header">
    Masuk
  <#elseif section = "form">
    <p class="mt-1.5 text-sm text-slate-500 dark:text-slate-400">Satu akun untuk semua layanan Pemkab Ponorogo.</p>
    <#if messagesPerField.existsError('username','password')>
      <div class="${properties.kcAlertClass!} border-red-200 bg-red-50 text-red-700 dark:border-red-900/60 dark:bg-red-950/40 dark:text-red-300" role="alert" aria-live="polite">
        <i class="ks-icon ks-icon-alert mt-0.5" aria-hidden="true"></i>
        <span>${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}</span>
      </div>
    </#if>
    <#if realm.password>
      <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" class="mt-6 space-y-4">
        <#if !usernameHidden??>
          <div>
            <label for="username" class="${properties.kcLabelClass!}">NIP</label>
            <input tabindex="2" id="username" name="username" type="text" value="${(login.username!'')}" inputmode="numeric"
                   autofocus autocomplete="${(enableWebAuthnConditionalUI?has_content)?then('username webauthn', 'username')}"
                   class="${properties.kcInputClass!}" placeholder="18 digit NIP"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
          </div>
        </#if>

        <div>
          <label for="password" class="${properties.kcLabelClass!}">Kata sandi</label>
          <div class="${properties.kcInputGroup!}">
            <input tabindex="3" id="password" name="password" type="password" autocomplete="current-password"
                   class="${properties.kcInputClass!} pr-12" placeholder="Kata sandi"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
            <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="Tampilkan kata sandi"
                    aria-controls="password" data-password-toggle tabindex="4"
                    data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                    data-label-show="Tampilkan kata sandi" data-label-hide="Sembunyikan kata sandi">
              <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
            </button>
          </div>
        </div>

        <div class="flex items-center justify-between pt-0.5">
          <#if realm.rememberMe && !usernameHidden??>
            <label class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300">
              <input tabindex="5" id="rememberMe" name="rememberMe" type="checkbox" class="h-4 w-4 accent-[#0f8b8d]" <#if login.rememberMe??>checked</#if> />
              Ingat saya
            </label>
          <#else>
            <span></span>
          </#if>
          <#if realm.resetPasswordAllowed>
            <a tabindex="6" href="${url.loginResetCredentialsUrl}" class="text-sm font-semibold text-ks-accent hover:underline dark:text-teal-300">Lupa kata sandi?</a>
          <#else>
            <a href="https://simashebat.ponorogo.go.id/reset-password/" target="_blank" rel="noopener noreferrer" class="text-sm font-semibold text-ks-accent hover:underline dark:text-teal-300">Lupa kata sandi?</a>
          </#if>
        </div>

        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if> />
      </form>

      <#-- Masuk + passkey SEBARIS (pola theme agustusan-2026, teruji di prod):
           tombol passkey terlihat tanpa menggulir.

           Macro passkeys.conditionalUIData merender <form id="webauth">,
           opsional <form id="authn_select">, <script type="module">, lalu
           <a id="authenticateWebAuthnButton">. Semuanya ikut di .ks-actions;
           CSS menyembunyikan yang bukan tombol dan menjadikan <a> itu kotak
           ikon — tanpa JavaScript tambahan (Rocket Loader pernah merusak JS
           passkey).

           Tombol Masuk berada di LUAR <form> dan ditautkan lewat
           form="kc-form-login": menaruh macro di dalam form login akan
           membuat <form> bersarang, yang dibuang browser → POST passkey rusak.

           Tanpa passkey di realm, macro tak merender apa pun dan Masuk
           memenuhi baris. -->
      <div class="ks-actions mt-4">
        <button tabindex="7" type="submit" form="kc-form-login" name="login" id="kc-login"
                class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!} flex-1">
          Masuk
        </button>
        <@passkeys.conditionalUIData />
      </div>
      <#if enableWebAuthnConditionalUI?has_content>
        <p class="mt-2.5 flex items-center justify-center gap-1.5 text-xs text-slate-500 dark:text-slate-400">
          <i class="ks-icon ks-icon-fingerprint !h-3.5 !w-3.5 text-ks-accent dark:text-teal-300" aria-hidden="true"></i>
          Masuk dengan passkey: sidik jari, wajah, atau PIN perangkat.
        </p>
      </#if>

      <p class="mt-6 rounded-xl bg-slate-50 px-4 py-3 text-xs leading-relaxed text-slate-500 dark:bg-slate-800/60 dark:text-slate-400">NIP dan kata sandi sama dengan SIMASHEBAT. Kesulitan masuk? <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer" class="font-semibold text-ks-accent hover:underline dark:text-teal-300">Hubungi bantuan</a>.</p>
    </#if>
    <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
  </#if>
</@layout.registrationLayout>
