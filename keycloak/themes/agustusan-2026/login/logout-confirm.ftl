<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    ${msg("logoutConfirmTitle")}
  <#elseif section = "form">
    <div id="kc-logout-confirm" style="text-align:center">
      <div class="status-ikon si-kuning"><i class="fa-solid fa-right-from-bracket"></i></div>
      <p class="subjudul" style="margin-bottom:16px">${msg("logoutConfirmHeader")}</p>
      <form action="${url.logoutConfirmAction}" method="POST">
        <input type="hidden" name="session_code" value="${logoutConfirm.code}" />
        <button tabindex="4" type="submit" name="confirmLogout" id="kc-logout" class="btn btn-block">${msg("doLogout")}</button>
      </form>
      <#if !logoutConfirm.skipLink && (client.baseUrl)?has_content>
        <p style="margin-top:14px"><a href="${client.baseUrl}" class="tautan">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
