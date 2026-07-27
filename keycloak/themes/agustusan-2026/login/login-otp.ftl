<#--
  login-otp.ftl — verifikasi kode OTP 6 digit.

  CATATAN PENTING: container OTP memakai class .asn-otp dan tiap kotak
  .asn-otp-cell karena itulah selector yang dicari resources/js/otp-input.js
  (skrip dipakai bersama theme asn-v2). Markup theme ini sebelumnya memakai
  .otp-row / .otp-input sehingga skrip tidak menemukan apa pun dan isi kotak
  TIDAK PERNAH tersalin ke input hidden name="otp" — verifikasi OTP selalu
  gagal. Jangan ganti nama class ini tanpa ikut mengubah otp-input.js.
  Tampilan kotak digambar penuh oleh utility Tailwind di bawah, jadi kedua nama
  class tersebut murni berfungsi sebagai kait JavaScript.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
  <#if section = "header">
    Masukkan Kode OTP
  <#elseif section = "form">
    <p class="text-xs text-slate-400 dark:text-neutral-500 text-center mt-1 mb-4">6 digit dari aplikasi authenticator Anda</p>

    <form id="kc-otp-login-form" action="${url.loginAction}" method="post">
      <#if otpLogin.userOtpCredentials?size gt 1>
        <div class="mb-4">
          <#list otpLogin.userOtpCredentials as otpCredential>
            <input id="kc-otp-credential-${otpCredential?index}" class="sr-only peer" type="radio" name="selectedCredentialId" value="${otpCredential.id}"
                   <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if> />
            <label for="kc-otp-credential-${otpCredential?index}"
                   class="w-full flex items-center gap-3.5 p-3.5 mb-2.5 rounded-2xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 hover:border-merah hover:bg-white dark:hover:bg-neutral-900 peer-checked:border-merah peer-checked:bg-white dark:peer-checked:bg-neutral-900 transition cursor-pointer text-left">
              <span class="shrink-0 grid place-items-center w-10 h-10 rounded-xl bg-rose-50 dark:bg-rose-500/15 text-merah">
                <#-- lucide: smartphone -->
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="5" y="2" width="14" height="20" rx="2"/><path d="M12 18h.01"/></svg>
              </span>
              <span class="block text-sm font-semibold text-slate-800 dark:text-neutral-100">${otpCredential.userLabel}</span>
            </label>
          </#list>
        </div>
      </#if>

      <input type="hidden" id="otp" name="otp" autocomplete="off" value="" />
      <div class="asn-otp flex gap-2 justify-center mb-4" data-otp-target="otp" data-otp-autofocus>
        <#list 1..6 as i>
          <input class="asn-otp-cell w-11 h-[52px] text-center text-[22px] font-bold rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-900 dark:text-white focus:outline-none focus:border-merah focus:ring-4 focus:ring-merah/10 transition"
                 type="text" inputmode="numeric" maxlength="1"
                 autocomplete="<#if i==1>one-time-code<#else>off</#if>" aria-label="Digit ${i}" />
        </#list>
      </div>
      <#if messagesPerField.existsError('totp')>
        <p id="input-error-otp-code" class="text-[11px] font-semibold text-rose-600 dark:text-rose-400 text-center -mt-2 mb-4" aria-live="polite">${kcSanitize(messagesPerField.get('totp'))?no_esc}</p>
      </#if>

      <button type="submit" name="login" id="kc-login"
              class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition">
        Verifikasi &amp; Masuk
        <#-- lucide: arrow-right -->
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
      </button>
    </form>

    <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5 leading-relaxed">
      Bermasalah dengan OTP?
      <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer"
         class="inline-flex items-center gap-1.5 bg-merah text-white px-2.5 py-1 rounded-full font-semibold no-underline hover:brightness-110">
        <#-- lucide: message-circle -->
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M7.9 20A9 9 0 1 0 4 16.1L2 22z"/></svg>
        Bantuan RAKACA
      </a>
    </p>

    <script type="module" src="${url.resourcesPath}/js/otp-input.js"></script>
  </#if>
</@layout.registrationLayout>
