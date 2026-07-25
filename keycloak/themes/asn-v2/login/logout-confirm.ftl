<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    ${msg("logoutConfirmTitle")}
  <#elseif section = "form">
    <div id="kc-logout-confirm" class="text-center">
      <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">${msg("logoutConfirmHeader")}</p>

      <form class="space-y-3" action="${url.logoutConfirmAction}" method="POST">
        <input type="hidden" name="session_code" value="${logoutConfirm.code}" />
        <button tabindex="4" type="submit" name="confirmLogout" id="kc-logout"
                class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}">${msg("doLogout")}</button>
      </form>

      <#if !logoutConfirm.skipLink && (client.baseUrl)?has_content>
        <p class="mt-3">
          <a href="${client.baseUrl}" class="text-sm text-red-600 dark:text-red-400 hover:underline">${kcSanitize(msg("backToApplication"))?no_esc}</a>
        </p>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
