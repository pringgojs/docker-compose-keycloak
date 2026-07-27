<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    <#if messageHeader??>${kcSanitize(messageHeader)?no_esc}<#else>${kcSanitize(message.summary)?no_esc}</#if>
  <#elseif section = "form">
    <div id="kc-info-message" style="text-align:center">
      <div class="status-ikon si-biru"><i class="fa-solid fa-circle-info"></i></div>
      <p class="subjudul" style="margin-bottom:16px">
        ${kcSanitize(message.summary)?no_esc}<#if requiredActions??><#list requiredActions>: <b><#items as reqActionItem>${kcSanitize(msg("requiredAction.${reqActionItem}"))?no_esc}<#sep>, </#items></b></#list><#else></#if>
      </p>
      <#if skipLink??>
      <#else>
        <#if pageRedirectUri?has_content>
          <a href="${pageRedirectUri}" class="btn btn-block">${kcSanitize(msg("backToApplication"))?no_esc}</a>
        <#elseif actionUri?has_content>
          <a href="${actionUri}" class="btn btn-block">${kcSanitize(msg("proceedWithAction"))?no_esc}</a>
        <#elseif (client.baseUrl)?has_content>
          <a href="${client.baseUrl}" class="btn btn-block">${kcSanitize(msg("backToApplication"))?no_esc}</a>
        </#if>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
