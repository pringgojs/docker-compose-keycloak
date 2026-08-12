<#--
  login.ftl — halaman masuk warga (email + kata sandi + passkey + Google).

  Tampil di dalam Custom Tabs setelah warga menekan "Masuk dengan Email" di
  aplikasi. Google dan passkey biasanya dipanggil NATIVE dari aplikasi dan
  tidak pernah sampai ke halaman ini; keduanya tetap disediakan di sini
  sebagai jaring pengaman bagi warga yang membuka tautan masuk dari peramban
  biasa.

  bodyClass="pramana-marun" memilih chrome berlatar marun di template.ftl.

  YANG TIDAK BOLEH DIUBAH (mekanik passkey KC 26.7):
  - <#import "passkeys.ftl" as passkeys> dan pemanggilan <@passkeys.conditionalUIData />
  - autocomplete="username webauthn" pada field username — syarat conditional
    UI / autofill passkey
  - hidden input credentialId

  Kenapa tombol submit memakai form="kc-form-login" dan berada di LUAR <form>:
  markup passkey ikut membawa <form id="webauth"> sendiri. Menaruhnya di dalam
  form login menghasilkan <form> bersarang — HTML tidak sah, dan browser
  membuang form dalam sehingga POST passkey rusak. Menutup form login lebih
  dulu lalu menautkan tombol lewat atribut form= adalah cara yang sah dan
  didukung semua browser modern.

  Teks label bawaan pada tombol passkey TIDAK dihapus dari DOM — hanya
  disembunyikan secara visual, supaya tetap menjadi nama aksesibel bagi
  pembaca layar.
-->
<#import "template.ftl" as layout>
<#import "passkeys.ftl" as passkeys>
<#-- displayInfo=true wajib: tanpa itu blok "info" — tautan "Daftar sekarang" —
     tidak pernah dirender template, dan warga baru tidak punya jalan masuk ke
     halaman daftar dari sini. -->
<@layout.registrationLayout bodyClass="pramana-marun" displayMessage=!messagesPerField.existsError('username','password') displayInfo=true; section>
  <#if section = "header">
    ${msg("loginAccountTitle")}

  <#elseif section = "form">
    <#if realm.password>
      <form id="kc-form-login" action="${url.loginAction}" method="post" novalidate="novalidate">
        <#if !usernameHidden??>
          <label for="username" class="text-[11px] font-bold text-marun-100">
            <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
          </label>
          <div class="mt-2 flex items-center gap-2.5 rounded-xl bg-white px-3 py-3 ring-1 ring-white/20 focus-within:ring-2 focus-within:ring-emas-400">
            <span class="shrink-0 text-zinc-400">
              <#-- lucide: mail -->
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
            </span>
            <input tabindex="1" id="username" name="username" value="${(login.username!'')}" type="text"
                   autofocus autocomplete="${(enableWebAuthnConditionalUI?has_content)?then('username webauthn', 'username')}"
                   placeholder="${msg('email')}"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                   class="flex-1 border-0 bg-transparent p-0 text-[13px] text-zinc-800 placeholder-zinc-300 focus:outline-none focus:ring-0" />
          </div>
          <#if messagesPerField.existsError('username','password')>
            <span id="input-error" class="mt-1.5 block text-[10px] font-bold text-rose-200" aria-live="polite">
              ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
            </span>
          </#if>
        </#if>

        <label for="password" class="mt-4 block text-[11px] font-bold text-marun-100">${msg("password")}</label>
        <div class="field-wrap mt-2 flex items-center gap-2.5 rounded-xl bg-white px-3 py-3 ring-1 ring-white/20 focus-within:ring-2 focus-within:ring-emas-400">
          <span class="shrink-0 text-zinc-400">
            <#-- lucide: lock -->
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>
          </span>
          <input tabindex="2" id="password" name="password" type="password" autocomplete="current-password"
                 placeholder="${msg('password')}"
                 aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                 class="flex-1 border-0 bg-transparent p-0 text-[13px] text-zinc-800 placeholder-zinc-300 focus:outline-none focus:ring-0" />
          <#-- Class-nya TIDAK memakai kcFormPasswordVisibilityButtonClass.
               Properti itu bernilai "absolute right-3 top-1/2 …" untuk field
               base yang pembungkusnya relative. Di sini pembungkusnya flex
               tanpa relative, sehingga absolute merujuk ke leluhur lain dan
               tombolnya melayang sampai ke samping tombol "Masuk".

               Karena field ini sudah flex, tombol cukup jadi anak flex biasa. -->
          <button class="shrink-0 text-zinc-400 transition hover:text-marun-700" type="button" aria-label="${msg('showPassword')}"
                  aria-controls="password" data-password-toggle tabindex="3"
                  data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                  data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
            <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
          </button>
        </div>

        <#if usernameHidden?? && messagesPerField.existsError('username','password')>
          <span id="input-error" class="mt-1.5 block text-[10px] font-bold text-rose-200" aria-live="polite">
            ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
          </span>
        </#if>

        <div class="mt-3.5 flex items-center justify-between">
          <#if realm.rememberMe && !usernameHidden??>
            <label class="flex items-center gap-2 text-[11px] text-marun-200">
              <input tabindex="4" id="rememberMe" name="rememberMe" type="checkbox"
                     <#if login.rememberMe??>checked</#if>
                     class="h-4 w-4 rounded border-0 bg-white/15 text-marun-700 ring-1 ring-white/25 focus:ring-emas-400" />
              ${msg("rememberMe")}
            </label>
          <#else>
            <span></span>
          </#if>
          <#if realm.resetPasswordAllowed>
            <a tabindex="5" href="${url.loginResetCredentialsUrl}"
               class="text-[11px] font-bold text-emas-300 underline">${msg("doForgotPassword")}</a>
          </#if>
        </div>

        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if> />
      </form>

      <#-- AKSI: tombol "Masuk" + tombol passkey. Di LUAR <form> — lihat catatan atas. -->
      <div class="aksi-masuk mt-5">
        <button tabindex="6" type="submit" form="kc-form-login" name="login" id="kc-login"
                class="flex w-full items-center justify-center rounded-xl bg-white py-3.5 text-[13px] font-bold text-marun-800 shadow-lg transition hover:bg-marun-50">
          ${msg("doLogIn")}
        </button>
        <@passkeys.conditionalUIData />
      </div>
    </#if>

  <#elseif section = "socialProviders">
    <#if realm.password && social?? && social.providers?has_content>
      <div class="flex items-center gap-3 py-4">
        <span class="h-px flex-1 bg-white/15"></span>
        <span class="text-[9.5px] font-semibold text-marun-300">${msg("identity-provider-login-label")}</span>
        <span class="h-px flex-1 bg-white/15"></span>
      </div>
      <div id="kc-social-providers" class="space-y-2.5">
        <#list social.providers as p>
          <a id="social-${p.alias}" href="${p.loginUrl}"
             class="flex w-full items-center justify-center gap-2.5 rounded-xl bg-white/10 py-3 no-underline ring-1 ring-white/25 backdrop-blur transition hover:bg-white/15">
            <#if p.alias == "google">
              <#-- Logo Google resmi — SVG inline, tanpa aset eksternal. -->
              <svg width="17" height="17" viewBox="0 0 48 48" aria-hidden="true">
                <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
                <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
                <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
                <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
              </svg>
            </#if>
            <span class="text-[12.5px] font-bold text-white">${p.displayName!}</span>
          </a>
        </#list>
      </div>
    </#if>

  <#elseif section = "info">
    <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
      <span class="text-[11px] text-marun-200">
        ${msg("noAccount")}
        <a tabindex="8" href="${url.registrationUrl}" class="font-bold text-emas-300 underline">${msg("pramanaDoRegisterLink")}</a>
      </span>
    </#if>
  </#if>
  <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
</@layout.registrationLayout>
