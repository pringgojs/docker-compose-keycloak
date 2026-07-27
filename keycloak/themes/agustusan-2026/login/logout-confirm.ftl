<#--
  logout-confirm.ftl — konfirmasi keluar dari Kisara SSO.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    ${msg("logoutConfirmTitle")}
  <#elseif section = "form">
    <div id="kc-logout-confirm">
      <#-- Lingkaran ikon keluar (lucide: log-out) -->
      <div class="w-[68px] h-[68px] rounded-full mx-auto mb-3.5 grid place-items-center bg-amber-50 dark:bg-amber-500/15 text-amber-600 dark:text-amber-400">
        <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m16 17 5-5-5-5"/><path d="M21 12H9"/><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/></svg>
      </div>

      <p class="text-xs text-slate-400 dark:text-neutral-500 text-center mt-1.5 mb-4 leading-relaxed">
        ${msg("logoutConfirmHeader")}<br />
        Anda akan keluar dari seluruh aplikasi yang terhubung dengan akun ini.
      </p>

      <form action="${url.logoutConfirmAction}" method="POST">
        <input type="hidden" name="session_code" value="${logoutConfirm.code}" />
        <button tabindex="4" type="submit" name="confirmLogout" id="kc-logout"
                class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition">
          ${msg("doLogout")}
          <#-- lucide: log-out -->
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m16 17 5-5-5-5"/><path d="M21 12H9"/><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/></svg>
        </button>
      </form>

      <#if !logoutConfirm.skipLink && (client.baseUrl)?has_content>
        <a href="${client.baseUrl}"
           class="w-full mt-2.5 inline-flex items-center justify-center py-3 rounded-[13px] text-sm font-semibold border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-600 dark:text-neutral-300 hover:border-merah hover:text-merah transition no-underline">
          ${kcSanitize(msg("backToApplication"))?no_esc}
        </a>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
