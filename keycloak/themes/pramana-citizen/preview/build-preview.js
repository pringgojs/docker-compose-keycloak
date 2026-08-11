/**
 * build-preview.js
 * -----------------------------------------------------------------------------
 * Generator preview HTML statis untuk theme Keycloak "pramana-citizen"
 * (halaman masuk & daftar WARGA · realm ponorogo-citizen) TANPA menjalankan
 * Keycloak.
 *
 * Cara pakai:
 *   cd subapps/sso/keycloak
 *   npm run build:pramana     # compile Tailwind -> styles.css
 *   npm run preview:pramana   # render preview/*.html
 *
 * Output: preview/*.html (+ index.html sebagai daftar isi)
 *
 * CATATAN:
 * - Ini BUKAN FreeMarker renderer, melainkan REPLIKA VISUAL supaya desain bisa
 *   dinilai sebelum ada yang di-deploy. Markup dibuat semirip mungkin dengan
 *   target output template.ftl nanti.
 * - Dark mode mengikuti preferensi sistem (Tailwind darkMode:'media'), tanpa
 *   tombol toggle — warga tidak akan mencari tombol tema di halaman login.
 * - Semua ikon SVG Lucide inline. Dilarang emoji (12-design-system bagian 4:
 *   emoji dirender OS, jadi tampil berbeda tiap merek ponsel).
 * - Semua teks Bahasa Indonesia, termasuk pesan galat.
 */
const fs = require("fs");
const path = require("path");

const DIR = __dirname;
const RES = "../login/resources";

// =============================================================================
// IKON — inline SVG gaya Lucide
// =============================================================================
function svg(paths, size = 18, w = 2, cls = "") {
  return `<svg${cls ? ` class="${cls}"` : ""} width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${paths}</svg>`;
}

const ICON = {
  mail: (s = 18, w = 2, c = "") =>
    svg(`<rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>`, s, w, c),
  lock: (s = 18, w = 2, c = "") =>
    svg(`<rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>`, s, w, c),
  user: (s = 18, w = 2, c = "") =>
    svg(`<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>`, s, w, c),
  eye: (s = 18, w = 2, c = "") =>
    svg(`<path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/>`, s, w, c),
  fingerprint: (s = 18, w = 2, c = "") =>
    svg(`<path d="M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4"/><path d="M14 13.12c0 2.38 0 6.38-1 8.88"/><path d="M17.29 21.02c.12-.6.43-2.3.5-3.02"/><path d="M2 12a10 10 0 0 1 18-6"/><path d="M2 16h.01"/><path d="M21.8 16c.2-2 .131-5.354 0-6"/><path d="M5 19.5C5.5 18 6 15 6 12a6 6 0 0 1 .34-2"/><path d="M8.65 22c.21-.66.45-1.32.57-2"/><path d="M9 6.8a6 6 0 0 1 9 5.2v2"/>`, s, w, c),
  google: (s = 18) =>
    `<svg width="${s}" height="${s}" viewBox="0 0 24 24" aria-hidden="true"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.65l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84A11 11 0 0 0 12 23z"/><path fill="#FBBC05" d="M5.84 14.11a6.6 6.6 0 0 1 0-4.22V7.05H2.18a11 11 0 0 0 0 9.9l3.66-2.84z"/><path fill="#EA4335" d="M12 4.75c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 1.46 14.97.5 12 .5A11 11 0 0 0 2.18 7.05l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg>`,
  check: (s = 18, w = 2, c = "") => svg(`<path d="M20 6 9 17l-5-5"/>`, s, w, c),
  alert: (s = 18, w = 2, c = "") =>
    svg(`<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/>`, s, w, c),
  info: (s = 18, w = 2, c = "") =>
    svg(`<circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/>`, s, w, c),
  x: (s = 18, w = 2, c = "") =>
    svg(`<circle cx="12" cy="12" r="10"/><path d="m15 9-6 6"/><path d="m9 9 6 6"/>`, s, w, c),
  arrowLeft: (s = 16, w = 2, c = "") => svg(`<path d="m12 19-7-7 7-7"/><path d="M19 12H5"/>`, s, w, c),
  send: (s = 18, w = 2, c = "") =>
    svg(`<path d="M14.536 21.686a.5.5 0 0 0 .937-.024l6.5-19a.496.496 0 0 0-.635-.635l-19 6.5a.5.5 0 0 0-.024.937l7.93 3.18a2 2 0 0 1 1.112 1.11z"/><path d="m21.854 2.147-10.94 10.939"/>`, s, w, c),
};

// =============================================================================
// KERANGKA HALAMAN
// =============================================================================

/** Hero marun dengan kipas dadak merak + logo PRAMANA. */
function hero(judul, subjudul) {
  return `
    <div class="hero-pattern relative px-6 pt-7 pb-9 text-center text-white bg-gradient-to-br from-marun-900 via-marun-800 to-marun-700 overflow-hidden">
      <div class="kipas-merak"></div>
      <div class="relative">
        <div class="mx-auto mb-3 grid place-items-center w-14 h-14 rounded-2xl bg-white/12 ring-1 ring-white/20 backdrop-blur">
          <svg width="30" height="30" viewBox="0 0 48 48" fill="none" aria-hidden="true">
            <path d="M24 5 27 15 37 12 31 20 40 25 30 27 33 37 24 31 15 37 18 27 8 25 17 20 11 12 21 15Z" fill="#F5C518" opacity=".92"/>
            <circle cx="24" cy="25" r="5.5" fill="#7A1F1F" stroke="#F5C518" stroke-width="1.6"/>
          </svg>
        </div>
        <h1 class="text-[22px] font-extrabold tracking-tight">${judul}</h1>
        <p class="mt-1 text-[12px] text-white/75 leading-relaxed">${subjudul}</p>
      </div>
    </div>`;
}

/** Keterangan Pemkab di kaki kartu — warga perlu yakin ini resmi. */
const kaki = `
  <div class="px-6 pb-6 pt-1">
    <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center leading-relaxed">
      Layanan resmi <span class="font-semibold text-slate-500 dark:text-neutral-400">Pemerintah Kabupaten Ponorogo</span>
    </p>
  </div>`;

function halaman(namaFile, judulTab, isi) {
  const html = `<!doctype html>
<html lang="id" class="h-full">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${judulTab} · PRAMANA</title>
<link rel="stylesheet" href="${RES}/css/styles.css">
</head>
<body class="min-h-screen font-sans bg-gradient-to-b from-marun-50 to-slate-50 dark:from-[#1a0708] dark:to-neutral-950 text-slate-800 dark:text-neutral-100 flex items-center justify-center py-8 px-4">
  <div class="w-full flex items-center justify-center">
    <div class="w-full max-w-md bg-white dark:bg-neutral-900 rounded-[22px] shadow-[0_20px_50px_-20px_rgba(122,31,31,.4)] ring-1 ring-slate-100 dark:ring-white/10 overflow-hidden">
${isi}
${kaki}
    </div>
  </div>
</body>
</html>`;
  fs.writeFileSync(path.join(DIR, namaFile), html, "utf8");
  return namaFile;
}

// =============================================================================
// KOMPONEN
// =============================================================================

function field({ label, tipe = "text", ikon, placeholder = "", nilai = "", hint = "" }) {
  return `
        <div class="mb-4">
          <label class="block text-[13px] font-semibold text-slate-700 dark:text-neutral-300 mb-1.5">${label}</label>
          <div class="field-wrap relative">
            <span class="field-ikon">${ikon}</span>
            <input type="${tipe}" placeholder="${placeholder}" value="${nilai}"
              class="w-full py-3 pl-[42px] pr-3.5 text-sm rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-800 dark:text-neutral-100 placeholder-slate-300 dark:placeholder-neutral-600 focus:outline-none focus:border-marun-700 focus:bg-white dark:focus:bg-neutral-900 focus:ring-4 focus:ring-marun-700/10 transition">
            ${tipe === "password" ? `<button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 dark:text-neutral-500 hover:text-marun-700 transition" aria-label="Tampilkan kata sandi">${ICON.eye(18)}</button>` : ""}
          </div>
          ${hint ? `<p class="mt-1.5 text-[11px] text-slate-400 dark:text-neutral-500 leading-relaxed">${hint}</p>` : ""}
        </div>`;
}

function tombolUtama(teks, ikon = "") {
  return `
        <button type="submit" class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-extrabold text-white bg-gradient-to-r from-marun-800 via-marun-700 to-marun-600 shadow-lg shadow-marun-700/25 hover:-translate-y-0.5 transition cursor-pointer">
          ${ikon}${teks}
        </button>`;
}

function alert(tipe, teks) {
  const gaya = {
    galat: ["border-rose-200 dark:border-rose-500/30 bg-rose-50 dark:bg-rose-500/10 text-rose-700 dark:text-rose-300", ICON.x(16)],
    info: ["border-sky-200 dark:border-sky-500/30 bg-sky-50 dark:bg-sky-500/10 text-sky-700 dark:text-sky-300", ICON.info(16)],
    sukses: ["border-emerald-200 dark:border-emerald-500/30 bg-emerald-50 dark:bg-emerald-500/10 text-emerald-700 dark:text-emerald-300", ICON.check(16)],
    peringatan: ["border-amber-200 dark:border-amber-500/30 bg-amber-50 dark:bg-amber-500/10 text-amber-700 dark:text-amber-300", ICON.alert(16)],
  }[tipe];
  return `
        <div class="flex items-start gap-2.5 rounded-xl border-[1.5px] p-3 mb-4 text-xs leading-relaxed ${gaya[0]}">
          <span class="shrink-0 mt-px">${gaya[1]}</span><span>${teks}</span>
        </div>`;
}

// =============================================================================
// HALAMAN
// =============================================================================
const dibuat = [];

// --- 1. Masuk ---------------------------------------------------------------
dibuat.push([
  halaman("login.html", "Masuk", `${hero("Sugeng Rawuh, Sedulur", "Masuk untuk mulai melapor kepada Bunda")}
      <div class="px-6 pt-6">
        <a href="#" class="w-full inline-flex items-center justify-center gap-2.5 py-3 rounded-[13px] text-sm font-bold border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-700 dark:text-neutral-200 hover:border-marun-700 hover:text-marun-700 dark:hover:text-marun-400 transition no-underline">
          ${ICON.google(18)} Masuk dengan Google
        </a>

        <div class="flex items-center gap-3 my-5">
          <span class="h-px flex-1 bg-slate-200 dark:bg-neutral-700"></span>
          <span class="text-[11px] text-slate-400 dark:text-neutral-500">atau</span>
          <span class="h-px flex-1 bg-slate-200 dark:bg-neutral-700"></span>
        </div>

        <form>
          ${field({ label: "Email", tipe: "email", ikon: ICON.mail(18), placeholder: "nama@email.com" })}
          ${field({ label: "Kata Sandi", tipe: "password", ikon: ICON.lock(18), placeholder: "Kata sandi Sedulur" })}

          <div class="flex items-center justify-between mb-4">
            <label class="inline-flex items-center gap-2 text-[12px] text-slate-600 dark:text-neutral-400 cursor-pointer">
              <input type="checkbox" class="w-4 h-4 rounded accent-marun-700"> Ingat saya
            </label>
            <a href="login-reset-password.html" class="text-[12px] font-semibold text-marun-700 dark:text-marun-400 no-underline hover:underline">Lupa kata sandi?</a>
          </div>

          <div class="flex items-stretch gap-2.5">
            <div class="flex-1">${tombolUtama("Masuk")}</div>
            <button type="button" title="Masuk dengan sidik jari" aria-label="Masuk dengan sidik jari"
              class="shrink-0 w-[52px] grid place-items-center rounded-[13px] border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-500 dark:text-neutral-400 hover:border-marun-700 hover:text-marun-700 transition cursor-pointer">
              ${ICON.fingerprint(22)}
            </button>
          </div>
        </form>

        <p class="text-[12px] text-slate-500 dark:text-neutral-400 text-center mt-5">
          Belum punya akun?
          <a href="register.html" class="font-bold text-marun-700 dark:text-marun-400 no-underline hover:underline">Daftar sekarang</a>
        </p>
      </div>`),
  "Masuk", "Google, email + kata sandi, dan sidik jari (passkey)",
]);

// --- 2. Daftar --------------------------------------------------------------
dibuat.push([
  halaman("register.html", "Daftar", `${hero("Daftar Akun", "Satu akun untuk semua layanan Pemkab Ponorogo")}
      <div class="px-6 pt-6">
        <a href="#" class="w-full inline-flex items-center justify-center gap-2.5 py-3 rounded-[13px] text-sm font-bold border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-700 dark:text-neutral-200 hover:border-marun-700 hover:text-marun-700 dark:hover:text-marun-400 transition no-underline">
          ${ICON.google(18)} Daftar dengan Google
        </a>
        <div class="flex items-center gap-3 my-5">
          <span class="h-px flex-1 bg-slate-200 dark:bg-neutral-700"></span>
          <span class="text-[11px] text-slate-400 dark:text-neutral-500">atau isi sendiri</span>
          <span class="h-px flex-1 bg-slate-200 dark:bg-neutral-700"></span>
        </div>
        <form>
          ${field({ label: "Nama Lengkap", ikon: ICON.user(18), placeholder: "Nama sesuai KTP" })}
          ${field({ label: "Email", tipe: "email", ikon: ICON.mail(18), placeholder: "nama@email.com", hint: "Kami kirimi tautan untuk memastikan email ini milik Sedulur." })}
          ${field({ label: "Kata Sandi", tipe: "password", ikon: ICON.lock(18), placeholder: "Minimal 8 huruf" })}
          ${field({ label: "Ulangi Kata Sandi", tipe: "password", ikon: ICON.lock(18), placeholder: "Ketik ulang kata sandi" })}
          ${tombolUtama("Daftar")}
        </form>
        <p class="text-[12px] text-slate-500 dark:text-neutral-400 text-center mt-5">
          Sudah punya akun?
          <a href="login.html" class="font-bold text-marun-700 dark:text-marun-400 no-underline hover:underline">Masuk</a>
        </p>
      </div>`),
  "Daftar", "Registrasi mandiri — form dirender Keycloak, bukan aplikasi",
]);

// --- 3. Galat masuk ---------------------------------------------------------
dibuat.push([
  halaman("login-error.html", "Masuk gagal", `${hero("Sugeng Rawuh, Sedulur", "Masuk untuk mulai melapor kepada Bunda")}
      <div class="px-6 pt-6">
        ${alert("galat", "Email atau kata sandi yang Sedulur masukkan tidak cocok. Coba periksa kembali.")}
        <form>
          ${field({ label: "Email", tipe: "email", ikon: ICON.mail(18), nilai: "sedulur@email.com" })}
          ${field({ label: "Kata Sandi", tipe: "password", ikon: ICON.lock(18), placeholder: "Kata sandi Sedulur" })}
          ${tombolUtama("Masuk")}
        </form>
        <p class="text-[12px] text-slate-500 dark:text-neutral-400 text-center mt-5">
          Lupa kata sandi?
          <a href="login-reset-password.html" class="font-bold text-marun-700 dark:text-marun-400 no-underline hover:underline">Atur ulang</a>
        </p>
      </div>`),
  "Masuk gagal", "Pesan galat Bahasa Indonesia — bukan \"Invalid username or password\"",
]);

// --- 4. Lupa kata sandi -----------------------------------------------------
dibuat.push([
  halaman("login-reset-password.html", "Lupa kata sandi", `${hero("Lupa Kata Sandi", "Kami bantu Sedulur masuk kembali")}
      <div class="px-6 pt-6">
        ${alert("info", "Masukkan email yang Sedulur pakai saat mendaftar. Kami kirimkan tautan untuk membuat kata sandi baru.")}
        <form>
          ${field({ label: "Email", tipe: "email", ikon: ICON.mail(18), placeholder: "nama@email.com" })}
          ${tombolUtama("Kirim Tautan", ICON.send(17) + " ")}
        </form>
        <p class="text-center mt-5">
          <a href="login.html" class="inline-flex items-center gap-1.5 text-[12px] font-semibold text-slate-500 dark:text-neutral-400 no-underline hover:text-marun-700">
            ${ICON.arrowLeft(15)} Kembali ke halaman masuk
          </a>
        </p>
      </div>`),
  "Lupa kata sandi", "Jalur pemulihan akun",
]);

// --- 5. Verifikasi email ----------------------------------------------------
dibuat.push([
  halaman("login-verify-email.html", "Verifikasi email", `${hero("Periksa Email Sedulur", "Satu langkah lagi")}
      <div class="px-6 pt-6">
        <div class="text-center mb-5">
          <div class="mx-auto mb-3 grid place-items-center w-16 h-16 rounded-2xl bg-marun-50 dark:bg-marun-900/30 text-marun-700 dark:text-marun-400">
            ${ICON.mail(30, 1.8)}
          </div>
          <p class="text-[13px] text-slate-600 dark:text-neutral-300 leading-relaxed">
            Kami sudah mengirim tautan ke<br><span class="font-bold text-slate-800 dark:text-neutral-100">sedulur@email.com</span>
          </p>
          <p class="mt-2 text-[12px] text-slate-400 dark:text-neutral-500 leading-relaxed">
            Buka email itu lalu tekan tautannya untuk mengaktifkan akun.
          </p>
        </div>
        ${alert("peringatan", "Belum menerima email? Periksa folder spam terlebih dahulu.")}
        <button type="button" class="w-full py-3 rounded-[13px] text-sm font-bold border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-600 dark:text-neutral-300 hover:border-marun-700 hover:text-marun-700 transition cursor-pointer">
          Kirim Ulang Email
        </button>
      </div>`),
  "Verifikasi email", "Wajib untuk registrasi mandiri",
]);

// --- 6. Daftar passkey ------------------------------------------------------
dibuat.push([
  halaman("webauthn-register.html", "Daftar sidik jari", `${hero("Masuk Lebih Cepat", "Tanpa mengetik kata sandi lagi")}
      <div class="px-6 pt-6">
        <div class="text-center mb-5">
          <div class="mx-auto mb-3 grid place-items-center w-16 h-16 rounded-2xl bg-marun-50 dark:bg-marun-900/30 text-marun-700 dark:text-marun-400">
            ${ICON.fingerprint(32, 1.8)}
          </div>
          <p class="text-[13px] text-slate-600 dark:text-neutral-300 leading-relaxed">
            Sedulur bisa masuk memakai <span class="font-bold">sidik jari</span> atau
            <span class="font-bold">wajah</span> — tanpa mengingat kata sandi.
          </p>
        </div>
        ${alert("info", "Sidik jari Sedulur tetap tersimpan di ponsel sendiri. Pemkab tidak pernah menerimanya.")}
        ${tombolUtama("Aktifkan Sekarang", ICON.fingerprint(18) + " ")}
        <button type="button" class="w-full mt-2.5 py-3 rounded-[13px] text-sm font-semibold text-slate-500 dark:text-neutral-400 hover:text-marun-700 transition cursor-pointer">
          Nanti saja
        </button>
        <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-4 leading-relaxed">
          Sedulur tetap bisa masuk seperti biasa bila ponselnya belum mendukung.
        </p>
      </div>`),
  "Daftar passkey", "Opsional — ada tombol \"Nanti saja\", tidak dipaksakan",
]);

// --- 7. Halaman kedaluwarsa -------------------------------------------------
dibuat.push([
  halaman("login-page-expired.html", "Sesi berakhir", `${hero("Sesi Sudah Berakhir", "Mohon mulai kembali")}
      <div class="px-6 pt-6">
        ${alert("peringatan", "Sesi Sedulur sudah berakhir karena terlalu lama menunggu. Silakan masuk kembali.")}
        <a href="login.html" class="btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-extrabold text-white bg-gradient-to-r from-marun-800 via-marun-700 to-marun-600 shadow-lg shadow-marun-700/25 hover:-translate-y-0.5 transition no-underline">
          Masuk Kembali
        </a>
      </div>`),
  "Sesi berakhir", "Pesan jelas, bukan \"An error occurred\"",
]);

// --- 8. Galat umum ----------------------------------------------------------
dibuat.push([
  halaman("error.html", "Terjadi kesalahan", `${hero("Ada Yang Tidak Beres", "Mohon maaf atas ketidaknyamanannya")}
      <div class="px-6 pt-6">
        ${alert("galat", "Kami tidak dapat memproses permintaan Sedulur saat ini. Silakan coba beberapa saat lagi.")}
        <a href="login.html" class="w-full inline-flex items-center justify-center gap-1.5 py-3 rounded-[13px] text-sm font-bold border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-600 dark:text-neutral-300 hover:border-marun-700 hover:text-marun-700 transition no-underline">
          ${ICON.arrowLeft(15)} Kembali ke halaman masuk
        </a>
      </div>`),
  "Galat", "Menjelaskan jalan keluar, bukan kode teknis",
]);

// =============================================================================
// DAFTAR ISI
// =============================================================================
const kartu = dibuat
  .map(
    ([f, judul, ket]) => `
      <a href="${f}" class="block p-4 rounded-2xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-white dark:bg-neutral-900 hover:border-marun-700 hover:-translate-y-0.5 transition no-underline">
        <div class="text-sm font-bold text-slate-800 dark:text-neutral-100">${judul}</div>
        <div class="mt-1 text-[12px] text-slate-500 dark:text-neutral-400 leading-relaxed">${ket}</div>
        <div class="mt-2 text-[11px] font-mono text-marun-700 dark:text-marun-400">${f}</div>
      </a>`
  )
  .join("");

fs.writeFileSync(
  path.join(DIR, "index.html"),
  `<!doctype html>
<html lang="id" class="h-full">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Preview theme PRAMANA — realm warga</title>
<link rel="stylesheet" href="${RES}/css/styles.css">
</head>
<body class="min-h-screen font-sans bg-slate-50 dark:bg-neutral-950 text-slate-800 dark:text-neutral-100 py-10 px-4">
  <div class="max-w-3xl mx-auto">
    <h1 class="text-2xl font-extrabold tracking-tight">Preview theme <span class="text-marun-700 dark:text-marun-400">pramana-citizen</span></h1>
    <p class="mt-1.5 text-[13px] text-slate-500 dark:text-neutral-400 leading-relaxed">
      Halaman masuk &amp; daftar warga · realm <code class="font-mono text-marun-700 dark:text-marun-400">ponorogo-citizen</code>.
      Replika visual statis — belum ada yang ter-deploy ke Keycloak.
    </p>
    <div class="mt-3 flex items-start gap-2.5 rounded-xl border-[1.5px] border-amber-200 dark:border-amber-500/30 bg-amber-50 dark:bg-amber-500/10 p-3 text-xs text-amber-700 dark:text-amber-300 leading-relaxed">
      <span class="shrink-0 mt-px">${ICON.alert(16)}</span>
      <span><b>Mode gelap mengikuti pengaturan sistem operasi.</b> Ubah tema terang/gelap di pengaturan perangkat untuk melihat keduanya — tidak ada tombol toggle, karena warga tidak akan mencarinya di halaman login.</span>
    </div>
    <div class="mt-6 grid gap-3 sm:grid-cols-2">${kartu}</div>
    <p class="mt-8 text-[11px] text-slate-400 dark:text-neutral-500 leading-relaxed">
      Palet: marun <code class="font-mono">#7A1F1F</code> · emas <code class="font-mono">#F5C518</code> —
      docs/teknis/12-design-system.md. Ikon Lucide inline, tanpa emoji. Seluruh teks Bahasa Indonesia.
    </p>
  </div>
</body>
</html>`,
  "utf8"
);

console.log(`Preview dibuat: ${dibuat.length} halaman + index.html`);
console.log(`Buka: ${path.join(DIR, "index.html")}`);
