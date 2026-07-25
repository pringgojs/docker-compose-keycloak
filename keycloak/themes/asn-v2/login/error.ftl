<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    ${kcSanitize(msg("errorTitle"))?no_esc}
  <#elseif section = "form">
    <div id="kc-error-message" class="text-center">
      <p class="text-sm text-gray-600 dark:text-gray-400 mb-5">
        <#if message?has_content>${kcSanitize(message.summary)?no_esc}<#else>Terjadi kesalahan tak terduga. Silakan coba lagi nanti atau hubungi administrator.</#if>
      </p>
      <#if client?? && client.baseUrl?has_content>
        <a id="backToApplication" href="${client.baseUrl}"
           class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
      <#else>
        <a href="https://asn.ponorogo.go.id"
           class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}">Kembali ke Portal ASN Ponorogo</a>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
