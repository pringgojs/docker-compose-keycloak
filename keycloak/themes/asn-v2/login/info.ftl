<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    <#if messageHeader??>${kcSanitize(messageHeader)?no_esc}<#else>Informasi</#if>
  <#elseif section = "form">
    <div id="kc-info-message" class="text-center">
      <p class="text-sm text-gray-600 dark:text-gray-400 mb-5">
        ${message.summary}<#if requiredActions??><#list requiredActions>: <b><#items as reqActionItem>${kcSanitize(msg("requiredAction.${reqActionItem}"))?no_esc}<#sep>, </#items></b></#list></#if>
      </p>
      <#if skipLink??>
      <#else>
        <#if pageRedirectUri?has_content>
          <a href="${pageRedirectUri}" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
        <#elseif actionUri?has_content>
          <a href="${actionUri}" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("proceedWithAction"))?no_esc}</a>
        <#elseif (client.baseUrl)?has_content>
          <a href="${client.baseUrl}" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
        </#if>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
