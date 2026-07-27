<#--
  login-config-totp.ftl — aktivasi verifikasi dua langkah (scan QR + nama perangkat).
  Kotak OTP memakai kait .asn-otp / .asn-otp-cell — lihat catatan di login-otp.ftl.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp') displayRequiredFields=false; section>
  <#if section = "header">
    Aktifkan Verifikasi Dua Langkah
  <#elseif section = "form">
    <p class="text-xs text-slate-400 dark:text-neutral-500 text-center mt-1 mb-4">Pindai kode QR dengan aplikasi authenticator</p>

    <form id="kc-totp-settings-form" action="${url.loginAction}" method="post">
      <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
      <#if mode??><input type="hidden" id="mode" name="mode" value="${mode}" /></#if>

      <#-- Kode QR -->
      <div class="w-[150px] h-[150px] mx-auto mb-4 rounded-2xl border-2 border-dashed border-slate-200 dark:border-neutral-700 grid place-items-center bg-slate-50 dark:bg-neutral-950 overflow-hidden">
        <img src="data:image/png;base64,${totp.totpSecretQrCode}" alt="Kode QR OTP" class="w-full h-full object-contain p-1.5" />
      </div>

      <#-- Kunci manual -->
      <div class="rounded-xl bg-slate-50 dark:bg-neutral-950 border-[1.5px] border-slate-200 dark:border-neutral-700 p-3 mb-4 text-center">
        <p class="text-[11px] text-slate-400 dark:text-neutral-500 mb-1">Atau masukkan kunci ini secara manual</p>
        <code class="text-sm font-bold tracking-wider text-slate-800 dark:text-neutral-100 break-all">${totp.totpSecretEncoded}</code>
      </div>

      <label class="${properties.kcLabelClass!} text-center">Kode Verifikasi</label>
      <input type="hidden" id="totp" name="totp" value="" />
      <div class="asn-otp flex gap-2 justify-center mb-4" data-otp-target="totp" data-otp-autofocus>
        <#list 1..6 as i>
          <input class="asn-otp-cell w-11 h-[52px] text-center text-[22px] font-bold rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-900 dark:text-white focus:outline-none focus:border-merah focus:ring-4 focus:ring-merah/10 transition"
                 type="text" inputmode="numeric" maxlength="1"
                 autocomplete="<#if i==1>one-time-code<#else>off</#if>" aria-label="Digit ${i}" />
        </#list>
      </div>
      <#if messagesPerField.existsError('totp')>
        <p id="input-error-otp-code" class="text-[11px] font-semibold text-rose-600 dark:text-rose-400 text-center -mt-2 mb-4" aria-live="polite">${kcSanitize(messagesPerField.get('totp'))?no_esc}</p>
      </#if>

      <label for="userLabel" class="${properties.kcLabelClass!}">Nama Perangkat</label>
      <div class="field-wrap relative mb-4">
        <input type="text" id="userLabel" name="userLabel" autocomplete="off"
               class="w-full py-3 pl-[42px] pr-3.5 text-sm rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-800 dark:text-neutral-100 placeholder-slate-300 dark:placeholder-neutral-600 focus:outline-none focus:border-merah focus:bg-white dark:focus:bg-neutral-900 focus:ring-4 focus:ring-merah/10 transition"
               value="OTP Google Authenticator" placeholder="Misal: HP Kantor / HP Pribadi"
               aria-invalid="<#if messagesPerField.existsError('userLabel')>true</#if>" />
        <#-- lucide: smartphone -->
        <svg class="field-ikon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="5" y="2" width="14" height="20" rx="2"/><path d="M12 18h.01"/></svg>
      </div>
      <#if messagesPerField.existsError('userLabel')>
        <span id="input-error-otp-label" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">${kcSanitize(messagesPerField.get('userLabel'))?no_esc}</span>
      </#if>

      <#if isAppInitiatedAction??>
        <button type="submit" id="saveTOTPBtn" name="submitAction" value="Save"
                class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition">
          Simpan &amp; Aktifkan
        </button>
        <button type="submit" id="cancelTOTPBtn" name="cancel-aia" value="true"
                class="w-full mt-2.5 py-3 rounded-[13px] text-sm font-semibold border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-600 dark:text-neutral-300 hover:border-merah hover:text-merah transition">
          Batal
        </button>
      <#else>
        <button type="submit" id="saveTOTPBtn"
                class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition">
          Simpan &amp; Aktifkan
        </button>
      </#if>
    </form>

    <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5 leading-relaxed">
      Kesulitan masuk?
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
