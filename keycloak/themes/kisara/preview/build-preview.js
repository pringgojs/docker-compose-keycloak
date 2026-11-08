/**
 * build-preview.js — preview statis theme Keycloak "kisara" TANPA Keycloak.
 *
 *   cd subapps/sso/keycloak
 *   npm run build:kisara      # Tailwind -> login/resources/css/styles.css
 *   npm run preview:kisara    # tulis preview/*.html
 *
 * Bukan renderer FreeMarker: replika visual supaya desain dinilai sebelum
 * dikonversi ke .ftl. Markup di sini = markup yang akan dipakai .ftl, dan CSS
 * yang dimuat = styles.css hasil build theme ini, bukan CSS terpisah.
 *
 * Tombol "Mode gelap" di pojok hanya ada di preview; theme aslinya mengikuti
 * pengaturan perangkat.
 */
const fs = require("fs");
const path = require("path");

const OUT = __dirname;
const R = "../login/resources";

const brand = `
      <div class="flex items-center gap-3">
        <img src="${R}/img/kisara-sso.svg" alt="" class="h-10 w-10 shrink-0" />
        <div class="min-w-0 leading-tight">
          <div class="text-[1.35rem] tracking-tight"><span class="text-slate-500 dark:text-slate-400">Kisara</span> <span class="font-bold text-slate-900 dark:text-white">SSO</span></div>
          <div class="text-xs text-slate-500 dark:text-slate-400">Pemerintah Kabupaten Ponorogo</div>
        </div>
        <img src="${R}/img/ponorogo.png" alt="Lambang Kabupaten Ponorogo" class="ml-auto h-10 w-auto shrink-0" />
      </div>`;

function page(file, title, body, { subtitle = "", back = false } = {}) {
  const html = `<!DOCTYPE html>
<html lang="id" class="h-full">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${title} — Kisara SSO (preview)</title>
  <link rel="icon" href="${R}/img/kisara-sso.svg" type="image/svg+xml" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <link href="${R}/css/styles.css" rel="stylesheet" />
  <script>if (matchMedia('(prefers-color-scheme: dark)').matches) document.documentElement.classList.add('dark');</script>
</head>
<body class="min-h-full bg-slate-100 font-sans text-slate-800 antialiased dark:bg-slate-950 dark:text-slate-200">
  <button type="button" onclick="document.documentElement.classList.toggle('dark')" class="fixed right-3 top-3 z-10 rounded-full border border-slate-300 bg-white px-3 py-1.5 text-xs font-medium text-slate-600 shadow-sm dark:border-slate-700 dark:bg-slate-900 dark:text-slate-300">Mode gelap (preview)</button>
  <main class="mx-auto flex min-h-screen w-full max-w-[440px] flex-col justify-center px-4 py-10">
    <div class="overflow-hidden rounded-[28px] border border-slate-200 bg-white shadow-[0_12px_40px_-16px_rgb(15_23_42/.25)] dark:border-slate-800 dark:bg-slate-900">
      <div class="ks-strip"></div>
      <div class="px-7 pb-8 pt-6 sm:px-9">
${brand}
        <div class="mt-7">
          ${back ? `<a href="login.html" class="mb-3 inline-flex items-center gap-1.5 text-sm font-medium text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-white"><span class="ks-icon ks-icon-back"></span>Kembali</a>` : ""}
          <h1 class="text-2xl font-semibold tracking-tight text-slate-900 dark:text-white">${title}</h1>
          ${subtitle ? `<p class="mt-1.5 text-sm text-slate-500 dark:text-slate-400">${subtitle}</p>` : ""}
        </div>
${body}
      </div>
    </div>
    <footer class="mt-6 flex flex-wrap items-center justify-center gap-x-4 gap-y-1 text-xs text-slate-500 dark:text-slate-400">
      <span>© 2026 Pemerintah Kabupaten Ponorogo</span>
      <a href="https://rakaca.ponorogo.go.id/bantuan" class="hover:text-slate-800 hover:underline dark:hover:text-white">Bantuan</a>
      <span>Diskominfo</span>
    </footer>
  </main>
</body>
</html>
`;
  fs.writeFileSync(path.join(OUT, file), html);
}

const input = (id, label, opts = {}) => `
          <div>
            <label for="${id}" class="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300">${label}</label>
            <div class="relative">
              <input id="${id}" type="${opts.type || "text"}" ${opts.value ? `value="${opts.value}"` : ""} placeholder="${opts.placeholder || ""}" ${opts.inputmode ? `inputmode="${opts.inputmode}"` : ""}
                     class="h-12 w-full rounded-xl border ${opts.error ? "border-red-500 focus:ring-red-500/25" : "border-slate-300 focus:border-ks-accent focus:ring-ks-accent/20 dark:border-slate-700"} bg-white px-4 ${opts.type === "password" ? "pr-12" : ""} text-[15px] text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-4 dark:bg-slate-950 dark:text-white" />
              ${opts.type === "password" ? `<button type="button" aria-label="Tampilkan kata sandi" class="absolute inset-y-0 right-0 grid w-12 place-items-center text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-white"><i class="ks-icon ks-icon-eye" aria-hidden="true"></i></button>` : ""}
            </div>
            ${opts.error ? `<p class="mt-1.5 flex items-center gap-1.5 text-sm text-red-600 dark:text-red-400"><span class="ks-icon ks-icon-alert"></span>${opts.error}</p>` : ""}
          </div>`;

const primary = (label) => `<button type="submit" class="h-12 w-full rounded-full bg-ks-accent text-[15px] font-semibold text-white shadow-sm transition hover:bg-ks-accent-dark focus:outline-none focus:ring-4 focus:ring-ks-accent/30">${label}</button>`;

const passkey = `
        <div class="my-5 flex items-center gap-3">
          <span class="h-px flex-1 bg-slate-200 dark:bg-slate-700"></span>
          <span class="text-xs font-medium uppercase tracking-wider text-slate-400">atau</span>
          <span class="h-px flex-1 bg-slate-200 dark:bg-slate-700"></span>
        </div>
        <button type="button" id="authenticateWebAuthnButton" class="ks-passkey-btn inline-flex h-12 w-full items-center justify-center gap-2.5 rounded-full border border-slate-300 bg-white text-[15px] font-semibold text-slate-800 transition hover:bg-slate-50 focus:outline-none focus:ring-4 focus:ring-ks-accent/20 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:hover:bg-slate-800">Masuk dengan passkey</button>
        <p class="mt-2 text-center text-xs text-slate-500 dark:text-slate-400">Sidik jari, wajah, atau PIN perangkat — tanpa kata sandi.</p>`;

const loginForm = (errors) => `
        <form class="mt-6 space-y-4" onsubmit="return false">
${input("username", "NIP", { placeholder: "18 digit NIP", inputmode: "numeric", value: errors ? "198001012010011001" : "", error: errors ? "NIP atau kata sandi salah." : "" })}
${input("password", "Kata sandi", { type: "password", placeholder: "Kata sandi", error: "" })}
          <div class="flex items-center justify-between pt-0.5">
            <label class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300"><input type="checkbox" class="h-4 w-4 accent-[#0f8b8d]" /> Ingat saya</label>
            <a href="reset-password.html" class="text-sm font-semibold text-ks-accent hover:underline dark:text-teal-300">Lupa kata sandi?</a>
          </div>
        </form>
        <div class="ks-actions mt-4">
          <button type="submit" class="inline-flex h-12 flex-1 items-center justify-center rounded-full bg-ks-accent px-6 text-[15px] font-semibold text-white shadow-sm transition hover:bg-ks-accent-dark focus:outline-none focus:ring-4 focus:ring-ks-accent/30">Masuk</button>
          <form id="webauth" action="#" method="post"><input type="hidden" name="clientDataJSON" /></form>
          <a id="authenticateWebAuthnButton" href="#" class="ks-passkey-btn inline-flex h-12 w-full items-center justify-center gap-2.5 rounded-full border border-slate-300 bg-white text-[15px] font-semibold text-slate-800 no-underline transition hover:bg-slate-50 focus:outline-none focus:ring-4 focus:ring-ks-accent/20 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:hover:bg-slate-800 mt-3">Masuk dengan Passkey</a>
        </div>
        <p class="mt-2.5 flex items-center justify-center gap-1.5 text-xs text-slate-500 dark:text-slate-400"><i class="ks-icon ks-icon-fingerprint !h-3.5 !w-3.5 text-ks-accent dark:text-teal-300" aria-hidden="true"></i>Masuk dengan passkey: sidik jari, wajah, atau PIN perangkat.</p>
        <p class="mt-6 rounded-xl bg-slate-50 px-4 py-3 text-xs leading-relaxed text-slate-500 dark:bg-slate-800/60 dark:text-slate-400">NIP dan kata sandi sama dengan SIMASHEBAT. Kesulitan masuk? <a href="https://rakaca.ponorogo.go.id/bantuan" class="font-semibold text-ks-accent hover:underline dark:text-teal-300">Hubungi bantuan</a>.</p>`;

page("login.html", "Masuk", loginForm(false), { subtitle: "Satu akun untuk semua layanan Pemkab Ponorogo." });

page("login-error.html", "Masuk", `
        <div class="mt-5 flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700 dark:border-red-900/60 dark:bg-red-950/40 dark:text-red-300">
          <span class="ks-icon ks-icon-alert mt-0.5"></span>
          <span>NIP atau kata sandi salah. Periksa lagi, atau masuk dengan passkey.</span>
        </div>
${loginForm(true)}`, { subtitle: "Satu akun untuk semua layanan Pemkab Ponorogo." });

page("login-otp.html", "Verifikasi dua langkah", `
        <form class="mt-6" onsubmit="return false">
          <p class="mb-4 text-sm text-slate-600 dark:text-slate-300">Masukkan 6 digit kode dari aplikasi autentikator Anda.</p>
          <div class="flex justify-center gap-2">
            ${[1, 2, 3, 4, 5, 6].map((i) => `<input class="ks-otp-cell" inputmode="numeric" maxlength="1" aria-label="Digit ${i}" ${i < 3 ? `value="${i + 3}"` : ""} />`).join("")}
          </div>
          <div class="mt-6">${primary("Verifikasi")}</div>
          <p class="mt-4 text-center text-sm text-slate-500 dark:text-slate-400">Tidak punya akses ke autentikator? <a href="#" class="font-semibold text-ks-accent hover:underline dark:text-teal-300">Reset MFA</a></p>
        </form>`, { subtitle: "Akun Anda dilindungi verifikasi dua langkah.", back: true });

page("reset-password.html", "Lupa kata sandi", `
        <form class="mt-6 space-y-4" onsubmit="return false">
${input("username", "NIP", { placeholder: "18 digit NIP", inputmode: "numeric" })}
          ${primary("Kirim tautan reset")}
        </form>
        <p class="mt-4 text-sm text-slate-500 dark:text-slate-400">Tautan dikirim ke email dinas yang tercatat pada NIP Anda.</p>`, { subtitle: "Kami kirimkan tautan untuk membuat kata sandi baru.", back: true });

page("info.html", "Periksa email Anda", `
        <div class="mt-5 flex items-start gap-3 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-800 dark:border-emerald-900/60 dark:bg-emerald-950/40 dark:text-emerald-300">
          <span class="ks-icon ks-icon-check mt-0.5"></span>
          <span>Tautan reset kata sandi sudah dikirim. Tautan berlaku 30 menit.</span>
        </div>
        <a href="login.html" class="mt-6 inline-flex h-12 w-full items-center justify-center rounded-full bg-ks-accent text-[15px] font-semibold text-white hover:bg-ks-accent-dark">Kembali ke halaman masuk</a>`, {});

page("error.html", "Sesi berakhir", `
        <div class="mt-5 flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800 dark:border-amber-900/60 dark:bg-amber-950/40 dark:text-amber-300">
          <span class="ks-icon ks-icon-alert mt-0.5"></span>
          <span>Halaman ini terlalu lama dibiarkan terbuka. Silakan mulai masuk lagi dari aplikasi yang Anda buka.</span>
        </div>
        <a href="login.html" class="mt-6 inline-flex h-12 w-full items-center justify-center rounded-full border border-slate-300 text-[15px] font-semibold text-slate-800 hover:bg-slate-50 dark:border-slate-700 dark:text-slate-100 dark:hover:bg-slate-800">Coba lagi</a>`, {});

const pages = [
  ["login.html", "Masuk (dengan tombol passkey)"],
  ["login-error.html", "Masuk — NIP/kata sandi salah"],
  ["login-otp.html", "Verifikasi dua langkah (OTP)"],
  ["reset-password.html", "Lupa kata sandi"],
  ["info.html", "Pesan sukses"],
  ["error.html", "Pesan galat / sesi berakhir"],
];
fs.writeFileSync(path.join(OUT, "index.html"), `<!DOCTYPE html><html lang="id"><head><meta charset="utf-8"><title>Preview theme kisara</title><link href="${R}/css/styles.css" rel="stylesheet"></head>
<body class="bg-slate-100 p-8 font-sans text-slate-800"><h1 class="text-xl font-bold">Theme Keycloak "kisara" — preview</h1><p class="mt-1 text-sm text-slate-500">Buka tiap halaman; tombol di pojok kanan atas mengganti mode gelap.</p>
<ul class="mt-4 list-disc space-y-1 pl-6">${pages.map(([f, l]) => `<li><a class="text-ks-accent underline" href="${f}">${l}</a></li>`).join("")}</ul></body></html>`);
console.log("preview:", pages.length, "halaman");
