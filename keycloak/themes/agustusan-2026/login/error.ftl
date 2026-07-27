<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    ${kcSanitize(msg("errorTitle"))?no_esc}
  <#elseif section = "form">
    <div id="kc-error-message" style="text-align:center">
      <div class="status-ikon si-merah"><i class="fa-solid fa-triangle-exclamation"></i></div>
      <p class="subjudul" style="margin-bottom:18px">
        <#if message?has_content>${kcSanitize(message.summary)?no_esc}<#else>Terjadi kesalahan tak terduga. Silakan coba lagi nanti atau hubungi administrator.</#if>
      </p>
      <#if client?? && client.baseUrl?has_content>
        <a id="backToApplication" href="${client.baseUrl}" class="btn btn-block">${kcSanitize(msg("backToApplication"))?no_esc}</a>
      <#else>
        <a href="https://asn.ponorogo.go.id" class="btn btn-block">Kembali ke Portal ASN Ponorogo</a>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
