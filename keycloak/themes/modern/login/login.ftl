<#-- Custom Keycloak login page with Tailwind CSS, hasil konversi dari login.blade.php, tanpa dark mode -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Keycloak</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/tailwind.css" />
    <style>
        .animate-fade-in {
            animation: fadeIn 0.7s;
        }
        .animate-fade-in-slow {
            animation: fadeIn 1.2s;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: none;
            }
        }
    </style>
</head>
<body class="min-h-screen flex flex-col justify-center items-center bg-gradient-to-br from-green-200 via-white to-green-300">
    <div class="w-full max-w-md p-8 md:p-10 bg-white/70 rounded-3xl shadow-2xl border border-green-200 backdrop-blur-lg relative overflow-hidden">
        <div class="absolute -top-10 -right-10 w-40 h-40 bg-green-100 rounded-full blur-2xl opacity-60 z-0"></div>
        <div class="absolute -bottom-10 -left-10 w-40 h-40 bg-green-200 rounded-full blur-2xl opacity-60 z-0"></div>
        <div class="flex flex-col items-center mb-8 relative z-10">
            <div class="mb-3 animate-fade-in">
                <!-- Logo bisa diganti sesuai kebutuhan -->
                <!-- <img src="${url.resourcesPath}/img/keycloak-icon.png" alt="Logo" class="w-20 h-20 drop-shadow-lg" /> -->
            </div>
            <h1 class="text-3xl font-extrabold text-green-700 tracking-tight mb-1 animate-fade-in">Selamat Datang</h1>
            <p class="text-gray-500 text-base animate-fade-in-slow">Masuk ke <span class="font-semibold">SSO</span></p>
        </div>
        <#if message?has_content>
            <div class="mb-4 text-red-600 font-medium text-sm">${message.summary}</div>
        </#if>
        <form id="kc-form-login" method="post" action="${url.loginAction}" class="space-y-6 relative z-10">
            <input type="hidden" name="credentialId" value="${credentialId!}"/>
            <div>
                <label for="username" class="block mb-1 text-sm font-semibold text-gray-700">Email atau Username</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-green-400">
                        <!-- Icon user -->
                        <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                        </svg>
                    </span>
                    <input tabindex="1" id="username" name="username" type="text" autofocus required autocomplete="username" class="pl-10 pr-3 py-2 w-full rounded-xl border border-gray-300 dark:border-neutral-700 focus:ring-2 focus:ring-green-400 focus:border-green-500 bg-white/80 dark:bg-neutral-800/80 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-500 shadow-sm transition-all duration-200 hover:border-green-400" placeholder="Username" value="${username!}" />
                </div>
            </div>
            <div>
                <label for="password" class="block mb-1 text-sm font-semibold text-gray-700">Password</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-green-400">
                        <!-- Icon lock -->
                        <svg class="w-5 h-5"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 5.25a3 3 0 0 1 3 3m3 0a6 6 0 0 1-7.029 5.912c-.563-.097-1.159.026-1.563.43L10.5 17.25H8.25v2.25H6v2.25H2.25v-2.818c0-.597.237-1.17.659-1.591l6.499-6.499c.404-.404.527-1 .43-1.563A6 6 0 1 1 21.75 8.25Z" />
                        </svg>
                    </span>
                    <input tabindex="2" id="password" name="password" type="password" required autocomplete="current-password" class="pl-10 pr-3 py-2 w-full rounded-xl border border-gray-300 dark:border-neutral-700 focus:ring-2 focus:ring-green-400 focus:border-green-500 bg-white/80 dark:bg-neutral-800/80 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-500 shadow-sm transition-all duration-200 hover:border-green-400" placeholder="Password" />
                </div>
            </div>
            <div class="flex items-center justify-between">
                
                <!--
                <label for="rememberMe" class="flex items-center cursor-pointer select-none">
                    <input id="rememberMe" name="rememberMe" type="checkbox" class="rounded border-gray-300 text-green-600 shadow-sm focus:ring-green-500" />
                    <span class="ml-2 text-sm text-gray-600">Ingat saya</span>
                </label>
                -->
                <#if realm.resetPasswordAllowed>
                    <a href="${url.loginResetCredentialsUrl}" class="text-sm text-green-600 hover:underline transition-colors">Lupa password?</a>
                </#if>
            </div>
            <button tabindex="3" type="submit" class="w-full py-3 px-4 bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white font-bold rounded-xl shadow-lg transition-all text-lg tracking-wide flex items-center justify-center gap-2 focus:outline-none focus:ring-2 focus:ring-green-400 focus:ring-offset-2">
                <!-- Icon login -->
                <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10 6H6a2 2 0 00-2 2v8a2 2 0 002 2h4m5-4H8m7 0l-3-3m3 3l-3 3" /></svg>
                Login
            </button>
        </form>
    </div>
</body>
</html>
