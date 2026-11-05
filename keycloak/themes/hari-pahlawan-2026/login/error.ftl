<#--
  error.ftl — halaman kesalahan umum. Ikon bulat + pesan + tombol kembali,
  mengikuti pola halaman status di preview (ikonBulat + btnPrimary + btnSecondary).
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    ${kcSanitize(msg("errorTitle"))?no_esc}
  <#elseif section = "form">
    <div id="kc-error-message">
      <#-- Lingkaran ikon peringatan (lucide: alert-triangle) -->
      <div class="w-[68px] h-[68px] rounded-full mx-auto mb-3.5 grid place-items-center bg-rose-50 dark:bg-rose-500/15 text-merah">
        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
      </div>

      <p class="text-xs text-slate-400 dark:text-neutral-500 text-center mt-1.5 mb-4 leading-relaxed">
        <#if message?has_content>${kcSanitize(message.summary)?no_esc}<#else>Sesi Anda telah berakhir atau tautan tidak berlaku. Silakan masuk kembali, atau hubungi administrator apabila masalah terus berlanjut.</#if>
      </p>

      <#if client?? && client.baseUrl?has_content>
        <a id="backToApplication" href="${client.baseUrl}"
           class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition no-underline">
          ${kcSanitize(msg("backToApplication"))?no_esc}
          <#-- lucide: arrow-right -->
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
        </a>
        <a href="https://asn.ponorogo.go.id"
           class="w-full mt-2.5 inline-flex items-center justify-center py-3 rounded-[13px] text-sm font-semibold border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-600 dark:text-neutral-300 hover:border-merah hover:text-merah transition no-underline">
          Kembali ke Portal ASN Ponorogo
        </a>
      <#else>
        <a href="https://asn.ponorogo.go.id"
           class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition no-underline">
          Kembali ke Portal ASN Ponorogo
          <#-- lucide: arrow-right -->
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
        </a>
      </#if>

      <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5 leading-relaxed">
        Kesulitan masuk?
        <a href="https://rakaca.ponorogo.go.id/bantuan" target="_blank" rel="noopener noreferrer"
           class="inline-flex items-center gap-1.5 bg-merah text-white px-2.5 py-1 rounded-full font-semibold no-underline hover:brightness-110">
          <#-- lucide: message-circle -->
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M7.9 20A9 9 0 1 0 4 16.1L2 22z"/></svg>
          Bantuan RAKACA
        </a>
      </p>
    </div>
  </#if>
</@layout.registrationLayout>
