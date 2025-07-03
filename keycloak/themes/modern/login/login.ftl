<#-- Custom Keycloak login page with Tailwind CSS -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Keycloak</title>
    <link rel="stylesheet" href="../resources/css/tailwind.css">
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <form id="kc-form-login" class="bg-white p-8 rounded shadow-md w-96" method="post" action="${url.loginAction}">
        <h1 class="text-2xl font-bold mb-6">Login</h1>
        <#if message?has_content>
            <div class="mb-4 text-red-600">${message.summary}</div>
        </#if>
        <input tabindex="1" id="username" name="username" class="border p-2 w-full mb-4" placeholder="Username" autofocus />
        <input tabindex="2" id="password" name="password" type="password" class="border p-2 w-full mb-4" placeholder="Password" />
        <button tabindex="3" type="submit" class="bg-blue-500 text-white px-4 py-2 rounded w-full">Login</button>
    </form>
</body>
</html>
