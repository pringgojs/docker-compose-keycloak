<#--
  login.ftl — halaman masuk utama (NIP + kata sandi + passkey).

  YANG TIDAK BOLEH DIUBAH (mekanik passkey KC 26.7):
  - <#import "passkeys.ftl" as passkeys> dan pemanggilan <@passkeys.conditionalUIData />
  - autocomplete="username webauthn" pada field username (syarat conditional UI /
    autofill passkey)
  - hidden input credentialId
  - urutan tabindex yang sudah ada

  TOMBOL PASSKEY IKON-SAJA (keputusan desain: ikon saja, sebaris di kanan
  tombol "Masuk"):
  Macro conditionalUIData merender, berurutan, <form id="webauth">, opsional
  <form id="authn_select">, sebuah <script type="module">, lalu
  <a id="authenticateWebAuthnButton"> di posisi TERAKHIR. Keempatnya kita
  bungkus bersama tombol "Masuk" dalam .aksi-masuk (flex). CSS di input.css
  menyembunyikan anak non-tombol dan mengubah <a> tersebut menjadi kotak ikon
  52px bergradien merah. Tidak ada JavaScript tambahan sama sekali (Cloudflare
  Rocket Loader pernah merusak JS passkey).

  Kenapa tombol submit memakai atribut form="kc-form-login" dan berada di LUAR
  <form>: markup passkey ikut membawa <form id="webauth"> sendiri. Menaruhnya di
  dalam form login akan menghasilkan <form> bersarang — HTML tidak sah dan
  browser akan membuang form dalam, sehingga POST passkey rusak. Menutup form
  login lebih dulu lalu menautkan tombol submit lewat atribut form= adalah cara
  yang sah dan didukung semua browser modern (sama kelasnya dengan dukungan
  WebAuthn itu sendiri, jadi tidak menambah risiko baru).

  Teks label bawaan pada tombol passkey TIDAK dihapus dari DOM — hanya
  disembunyikan secara visual, supaya tetap menjadi nama aksesibel bagi pembaca
  layar (base tidak menyediakan title/aria-label dan kita tak boleh menambahnya
  tanpa JS).
-->
<#import "template.ftl" as layout>
<#import "passkeys.ftl" as passkeys>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=false; section>
  <#if section = "header">
    Masuk ke Akun Anda
  <#elseif section = "form">
    <#if realm.password>
      <p class="text-xs text-slate-400 dark:text-neutral-500 mt-0.5 mb-4">Gunakan akun <b>SIMASHEBAT</b> Anda</p>

      <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
        <#if !usernameHidden??>
          <label for="username" class="${properties.kcLabelClass!}">Nomor Induk Pegawai (NIP)</label>
          <div class="field-wrap relative mb-4">
            <input tabindex="2" id="username" name="username" type="text" value="${(login.username!'')}"
                   autofocus autocomplete="${(enableWebAuthnConditionalUI?has_content)?then('username webauthn', 'username')}"
                   class="w-full py-3 pl-[42px] pr-3.5 text-sm rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-800 dark:text-neutral-100 placeholder-slate-300 dark:placeholder-neutral-600 focus:outline-none focus:border-merah focus:bg-white dark:focus:bg-neutral-900 focus:ring-4 focus:ring-merah/10 transition"
                   placeholder="Masukkan NIP Anda"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
            <#-- lucide: contact -->
            <svg class="field-ikon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="4" width="18" height="16" rx="2"/><circle cx="9" cy="10" r="2"/><path d="M15 8h3M15 12h3M7 16h10"/></svg>
          </div>
          <#if messagesPerField.existsError('username','password')>
            <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}</span>
          </#if>
        </#if>

        <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
        <div class="field-wrap relative mb-4">
          <input tabindex="3" id="password" name="password" type="password" autocomplete="current-password"
                 class="w-full py-3 pl-[42px] pr-11 text-sm rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-800 dark:text-neutral-100 placeholder-slate-300 dark:placeholder-neutral-600 focus:outline-none focus:border-merah focus:bg-white dark:focus:bg-neutral-900 focus:ring-4 focus:ring-merah/10 transition"
                 placeholder="Masukkan kata sandi"
                 aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
          <#-- lucide: lock -->
          <svg class="field-ikon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>
          <#-- Ikon mata di dalam <i> digambar lewat CSS mask (class ikon-mata /
               ikon-mata-coret), ditukar oleh passwordVisibility.js. -->
          <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="${msg('showPassword')}"
                  aria-controls="password" data-password-toggle tabindex="4"
                  data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                  data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
            <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
          </button>
        </div>
        <#if usernameHidden?? && messagesPerField.existsError('username','password')>
          <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}</span>
        </#if>

        <div class="flex items-center justify-between mb-4">
          <#if realm.rememberMe && !usernameHidden??>
            <label class="inline-flex items-center gap-2 text-xs text-slate-500 dark:text-neutral-400 cursor-pointer">
              <input tabindex="5" id="rememberMe" name="rememberMe" type="checkbox" class="w-[15px] h-[15px] accent-merah" <#if login.rememberMe??>checked</#if> />
              ${msg("rememberMe")}
            </label>
          <#else>
            <span></span>
          </#if>
          <#if realm.resetPasswordAllowed>
            <a tabindex="6" href="${url.loginResetCredentialsUrl}" class="text-xs font-medium text-slate-400 hover:text-merah transition">${msg("doForgotPassword")}</a>
          <#else>
            <a href="https://simashebat.ponorogo.go.id/reset-password/" target="_blank" rel="noopener noreferrer" class="text-xs font-medium text-slate-400 hover:text-merah transition">Lupa Kata Sandi?</a>
          </#if>
        </div>

        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if> />
      </form>

      <#-- AKSI: tombol "Masuk" + tombol passkey (ikon saja) sebaris. -->
      <div class="aksi-masuk">
        <button tabindex="7" type="submit" form="kc-form-login" name="login" id="kc-login"
                class="btn-sapu flex-1 inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition">
          Masuk
          <#-- lucide: arrow-right -->
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
        </button>
        <@passkeys.conditionalUIData />
      </div>

      <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5 leading-relaxed">
        Kesulitan masuk?
        <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer"
           class="inline-flex items-center gap-1.5 bg-merah text-white px-2.5 py-1 rounded-full font-semibold no-underline hover:brightness-110">
          <#-- lucide: message-circle -->
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M7.9 20A9 9 0 1 0 4 16.1L2 22z"/></svg>
          Bantuan RAKACA
        </a>
      </p>
      <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-2 leading-relaxed">
        NIP dan Kata Sandi menggunakan yang terdaftar di SIMASHEBAT.
      </p>
    </#if>
    <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
  </#if>
</@layout.registrationLayout>
