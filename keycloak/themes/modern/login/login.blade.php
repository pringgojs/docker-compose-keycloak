<x-guest-layout>
    <div
        class="min-h-screen flex flex-col justify-center items-center bg-gradient-to-br from-green-200 via-white to-green-300 dark:from-neutral-900 dark:via-neutral-800 dark:to-green-900">
        <div
            class="w-full max-w-md p-8 md:p-10 bg-white/70 dark:bg-neutral-900/80 rounded-3xl shadow-2xl border border-green-200 dark:border-neutral-700 backdrop-blur-lg relative overflow-hidden">
            <div
                class="absolute -top-10 -right-10 w-40 h-40 bg-green-100 dark:bg-green-900/30 rounded-full blur-2xl opacity-60 z-0">
            </div>
            <div
                class="absolute -bottom-10 -left-10 w-40 h-40 bg-green-200 dark:bg-green-800/30 rounded-full blur-2xl opacity-60 z-0">
            </div>
            <div class="flex flex-col items-center mb-8 relative z-10">
                <div class="mb-3 animate-fade-in">
                    <x-authentication-card-logo class="w-20 h-20 drop-shadow-lg" />
                </div>
                <h1
                    class="text-3xl font-extrabold text-green-700 dark:text-green-400 tracking-tight mb-1 animate-fade-in">
                    Selamat Datang</h1>
                <p class="text-gray-500 dark:text-gray-300 text-base animate-fade-in-slow">Masuk ke <span
                        class="font-semibold">{{ env('APP_NAME') }}</span></p>
            </div>
            <x-validation-errors class="mb-4" />
            @session('status')
                <div class="mb-4 font-medium text-sm text-green-600">
                    {{ $value }}
                </div>
            @endsession
            <form method="POST" action="{{ route('login') }}" class="space-y-6 relative z-10">
                @csrf
                <div>
                    <label for="email"
                        class="block mb-1 text-sm font-semibold text-gray-700 dark:text-gray-200">Email atau
                        Username</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-green-400">
                            <x-bi-person class="w-5 h-5" />
                        </span>
                        <input id="email" name="email" type="text" autocomplete="username" required autofocus
                            :value="old('email')"
                            class="pl-10 pr-3 py-2 w-full rounded-xl border border-gray-300 dark:border-neutral-700 focus:ring-2 focus:ring-green-400 focus:border-green-500 bg-white/80 dark:bg-neutral-800/80 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-500 shadow-sm transition-all duration-200 hover:border-green-400"
                            placeholder="Email atau Username" />
                    </div>
                </div>
                <div>
                    <label for="password"
                        class="block mb-1 text-sm font-semibold text-gray-700 dark:text-gray-200">Password</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-green-400">
                            <x-bi-lock class="w-5 h-5" />
                        </span>
                        <input id="password" name="password" type="password" autocomplete="current-password" required
                            class="pl-10 pr-3 py-2 w-full rounded-xl border border-gray-300 dark:border-neutral-700 focus:ring-2 focus:ring-green-400 focus:border-green-500 bg-white/80 dark:bg-neutral-800/80 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-500 shadow-sm transition-all duration-200 hover:border-green-400"
                            placeholder="Password" />
                    </div>
                </div>
                <div class="flex items-center justify-between">
                    <label for="remember_me" class="flex items-center cursor-pointer select-none">
                        <input id="remember_me" name="remember" type="checkbox"
                            class="rounded border-gray-300 text-green-600 shadow-sm focus:ring-green-500" />
                        <span class="ml-2 text-sm text-gray-600 dark:text-gray-300">Ingat saya</span>
                    </label>
                    @if (Route::has('password.request'))
                        <a href="{{ route('password.request') }}"
                            class="text-sm text-green-600 hover:underline dark:text-green-400 transition-colors">Lupa
                            password?</a>
                    @endif
                </div>
                <button type="submit"
                    class="w-full py-3 px-4 bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white font-bold rounded-xl shadow-lg transition-all text-lg tracking-wide flex items-center justify-center gap-2 focus:outline-none focus:ring-2 focus:ring-green-400 focus:ring-offset-2">
                    <x-bi-box-arrow-in-right class="w-5 h-5" />
                    Login
                </button>
            </form>
        </div>
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
    </div>
</x-guest-layout>
