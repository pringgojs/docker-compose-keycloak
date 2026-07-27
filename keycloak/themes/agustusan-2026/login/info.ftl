<#--
  info.ftl — halaman informasi umum (mis. email terverifikasi, aksi selesai).
  Seluruh logika <#if> bawaan (skipLink, pageRedirectUri, actionUri, client.baseUrl,
  requiredActions) dipertahankan; hanya presentasinya yang diubah.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    <#if messageHeader??>${kcSanitize(messageHeader)?no_esc}<#else>${kcSanitize(message.summary)?no_esc}</#if>
  <#elseif section = "form">
    <div id="kc-info-message">
      <#-- Lingkaran ikon centang (lucide: check-circle) -->
      <div class="w-[68px] h-[68px] rounded-full mx-auto mb-3.5 grid place-items-center bg-blue-50 dark:bg-blue-500/15 text-blue-600 dark:text-blue-400">
        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg>
      </div>

      <p class="text-xs text-slate-400 dark:text-neutral-500 text-center mt-1.5 mb-4 leading-relaxed">
        ${kcSanitize(message.summary)?no_esc}<#if requiredActions??><#list requiredActions>: <b class="text-slate-700 dark:text-neutral-200"><#items as reqActionItem>${kcSanitize(msg("requiredAction.${reqActionItem}"))?no_esc}<#sep>, </#items></b></#list><#else></#if>
      </p>

      <#if skipLink??>
      <#else>
        <#if pageRedirectUri?has_content>
          <a href="${pageRedirectUri}"
             class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition no-underline">
            ${kcSanitize(msg("backToApplication"))?no_esc}
            <#-- lucide: arrow-right -->
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
          </a>
        <#elseif actionUri?has_content>
          <a href="${actionUri}"
             class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition no-underline">
            ${kcSanitize(msg("proceedWithAction"))?no_esc}
            <#-- lucide: arrow-right -->
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
          </a>
        <#elseif (client.baseUrl)?has_content>
          <a href="${client.baseUrl}"
             class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition no-underline">
            ${kcSanitize(msg("backToApplication"))?no_esc}
            <#-- lucide: arrow-right -->
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
          </a>
        </#if>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
