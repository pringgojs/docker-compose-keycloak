/**
 * build-preview.js
 * -----------------------------------------------------------------------------
 * Generator preview HTML statis untuk theme asn-v2 TANPA menjalankan Keycloak.
 *
 * Tujuannya UJI COBA visual cepat: tiap halaman login Keycloak (login, OTP,
 * reset password, reset OTP, recovery codes, update profile, verify email,
 * select authenticator, terms, page expired, logout, info, error) di-render
 * memakai chrome yang SAMA dengan template.ftl + styles.css hasil build, dengan
 * data mock. Bisa toggle light/dark via tombol di pojok.
 *
 * Jalankan:  node preview/build-preview.js
 * Output:    preview/*.html  (+ preview/index.html)
 *
 * CATATAN: ini BUKAN FreeMarker renderer. Ini replika HTML untuk visual saja —
 * markup-nya dibuat semirip mungkin dengan output template.ftl + properties.
 */
const fs = require("fs");
const path = require("path");

const DIR = __dirname;
const RES = "../login/resources"; // relatif dari file html di preview/

// ----- properties kc*Class (disalin dari theme.properties, ringkas) -----
const P = {
  input:
    "asn-input mt-1 w-full px-4 py-2 text-sm border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500 border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-900 text-gray-800 dark:text-gray-100 placeholder-gray-400",
  label: "block text-sm font-medium text-gray-700 dark:text-gray-200",
  group: "mb-4",
  btn: "asn-btn inline-flex items-center justify-center gap-2 font-semibold rounded-xl transition duration-200 cursor-pointer",
  btnPrimary: "bg-red-600 dark:bg-red-800 text-white hover:bg-red-700 dark:hover:bg-red-700",
  btnDefault:
    "bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-600 border border-gray-300 dark:border-gray-600",
  btnBlock: "w-full",
  btnLarge: "py-2 px-4 text-sm",
  inputErr: "asn-input-error mt-1 block text-xs font-medium text-red-600 dark:text-red-400",
  inputGroup: "asn-input-group relative flex items-stretch",
  pwToggle:
    "asn-pw-toggle absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200",
  otpItem:
    "asn-otp-item flex items-center gap-3 p-3 mb-2 rounded-lg border border-gray-300 dark:border-gray-700 cursor-pointer hover:border-red-500 dark:hover:border-red-500",
  selectAuthItem:
    "asn-select-auth-item w-full flex items-center gap-4 p-4 rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-900 hover:border-red-500 dark:hover:border-red-500 transition cursor-pointer text-left",
};

function btn(label, kind = "primary", block = true) {
  const kindClass = kind === "primary" ? P.btnPrimary : P.btnDefault;
  return `<button type="button" class="${P.btn} ${kindClass} ${block ? P.btnBlock : ""} ${P.btnLarge}">${label}</button>`;
}

// Segmented OTP boxes — 6 kotak STATIS (terlihat tanpa JS); otp-input.js hanya enhance.
function otpBoxes(target = "otp") {
  var cells = "";
  for (var i = 1; i <= 6; i++) {
    cells += `<input class="asn-otp-cell" type="text" inputmode="numeric" maxlength="1" autocomplete="${i === 1 ? "one-time-code" : "off"}" aria-label="Digit ${i}" />`;
  }
  return `<input type="hidden" id="${target}" name="${target}" />
    <div class="asn-otp mt-2" data-otp-target="${target}" data-otp-autofocus>${cells}</div>`;
}

function alert(type, msg) {
  const map = {
    error: "bg-red-50 dark:bg-red-900/30 border-red-200 dark:border-red-800 text-red-800 dark:text-red-200|fa-circle-exclamation",
    success:
      "bg-emerald-50 dark:bg-emerald-900/30 border-emerald-200 dark:border-emerald-800 text-emerald-800 dark:text-emerald-200|fa-circle-check",
    warning:
      "bg-amber-50 dark:bg-amber-900/30 border-amber-200 dark:border-amber-800 text-amber-800 dark:text-amber-200|fa-triangle-exclamation",
    info: "bg-sky-50 dark:bg-sky-900/30 border-sky-200 dark:border-sky-800 text-sky-800 dark:text-sky-200|fa-circle-info",
  };
  const [cls, icon] = map[type].split("|");
  return `<div class="asn-alert flex items-start gap-3 rounded-lg p-3 mb-4 text-sm border ${cls}">
    <span class="shrink-0 mt-0.5"><i class="fa-solid ${icon}"></i></span>
    <span class="leading-snug">${msg}</span>
  </div>`;
}

// Chrome replika template.ftl
function chrome(title, bodyHtml, { headerExtra = "", requiredHint = false } = {}) {
  return `    <div class="w-full flex items-center justify-center">
      <div class="asn-card relative z-10 w-full max-w-md bg-white dark:bg-gray-800/90 shadow-2xl rounded-2xl overflow-hidden">
        <div class="asn-brand bg-white dark:bg-gradient-to-r dark:from-gray-800 dark:via-gray-700 dark:to-gray-600 px-6 pt-5 pb-4 flex items-center gap-3 border-b border-gray-100 dark:border-gray-700">
          <img src="${RES}/img/logo_warna.png" alt="Logo" class="block dark:hidden w-auto h-14" />
          <img src="${RES}/img/logo_hitam-putih.png" alt="Logo" class="hidden dark:block w-auto h-14" />
          <div class="leading-tight">
            <h1 class="text-lg font-bold text-gray-800 dark:text-gray-100">Single Sign-On ASN</h1>
            <p class="text-xs text-gray-500 dark:text-gray-300">Kabupaten Ponorogo</p>
          </div>
        </div>
        <header class="asn-card-header px-8 pt-6 pb-2 text-center">
          <h1 class="text-xl font-bold text-gray-800 dark:text-gray-100">${title}</h1>
          ${requiredHint ? '<p class="mt-1 text-xs text-gray-400 dark:text-gray-500"><span class="text-red-500">*</span> Wajib diisi</p>' : ""}
          ${headerExtra}
        </header>
        <div class="px-8 pb-6 pt-2">
          <div>${bodyHtml}</div>
        </div>
        <div class="asn-footer">
          <div class="bg-[#bd4137] dark:bg-gray-600 h-1 w-full">&nbsp;</div>
          <div class="px-6 py-3 text-center">
            <p class="text-[11px] leading-tight text-gray-500 dark:text-gray-400">© 2025 Pemerintah Kabupaten Ponorogo<br />Dinas Komunikasi Informatika dan Statistik</p>
          </div>
        </div>
      </div>
    </div>`;
}

function page(title, inner, opts) {
  return `<!DOCTYPE html>
<html class="h-full" lang="id">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${title} — preview asn-v2</title>
    <link href="${RES}/css/styles.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" rel="stylesheet" />
    <style>body{font-family:"Inter",sans-serif}</style>
  </head>
  <body class="asn-body min-h-screen bg-gray-300 dark:bg-gray-900 flex items-center justify-center p-2">
    <button onclick="document.documentElement.classList.toggle('dark')"
      class="fixed top-3 right-3 z-50 px-3 py-1.5 text-xs rounded-lg bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-200 shadow">
      <i class="fa-solid fa-circle-half-stroke"></i> Toggle dark
    </button>
${chrome(title, inner, opts)}
    <script src="${RES}/js/otp-input.js"></script>
  </body>
</html>`;
}

// ===================== Definisi tiap halaman =====================
const inputErr = (id, msg) => `<span class="${P.inputErr}">${msg}</span>`;

const pages = {
  "login": page("Masuk ke Akun Anda",
    `${alert("warning", "NIP atau Password salah.")}
    <form class="space-y-4">
      <div class="${P.group}">
        <label class="${P.label}">Nomor Induk Pegawai ( NIP )</label>
        <input class="${P.input}" placeholder="NIP" />
      </div>
      <div class="${P.group}">
        <label class="${P.label}">Password</label>
        <div class="${P.inputGroup}">
          <input type="password" class="${P.input}" placeholder="Password" />
          <button type="button" class="${P.pwToggle}"><i class="fa-solid fa-eye"></i></button>
        </div>
      </div>
      ${btn("Masuk")}
    </form>
    <div class="flex justify-end items-center pt-2"><a class="text-xs italic text-gray-500 dark:text-gray-300 hover:underline" href="#">Lupa Password?</a></div>
    <div class="mt-4 text-gray-600 dark:text-gray-300"><ul class="space-y-2">
      <li class="text-xs italic">Username dan Password menggunakan yang ada di SIMASHEBAT</li>
      <li class="text-xs italic">jika kesulitan hubungi <a href="#" class="py-1 px-2 bg-red-600 dark:bg-red-900 text-white font-semibold rounded-md">Klik disini</a></li>
    </ul></div>`),

  "login-otp": page("Verifikasi OTP",
    `<form class="space-y-4">
      <div class="${P.group}"><label class="${P.label} text-center">Kode OTP</label>
        ${otpBoxes("otp")}
      </div>
      ${btn("Verifikasi")}
    </form>`),

  "login-otp-error": page("Verifikasi OTP",
    `${alert("error", "Kode OTP tidak valid, silakan coba lagi.")}
    <form class="space-y-4">
      <div class="${P.group}"><label class="${P.label} text-center">Kode OTP</label>
        ${otpBoxes("otp")}
        <span class="${P.inputErr} text-center">Kode OTP tidak valid</span>
      </div>
      ${btn("Verifikasi")}
    </form>`),

  "login-otp-multi": page("Verifikasi OTP",
    `<form class="space-y-4">
      <label class="${P.otpItem}"><input type="radio" name="cred" class="accent-red-600" checked />
        <span class="flex items-center justify-center w-9 h-9 rounded-full bg-red-50 dark:bg-red-900/40 text-red-600 dark:text-red-300"><i class="fa-solid fa-mobile-screen-button"></i></span>
        <span class="text-sm font-medium text-gray-800 dark:text-gray-100">HP Kantor</span></label>
      <label class="${P.otpItem}"><input type="radio" name="cred" class="accent-red-600" />
        <span class="flex items-center justify-center w-9 h-9 rounded-full bg-red-50 dark:bg-red-900/40 text-red-600 dark:text-red-300"><i class="fa-solid fa-mobile-screen-button"></i></span>
        <span class="text-sm font-medium text-gray-800 dark:text-gray-100">HP Pribadi</span></label>
      <div class="${P.group}"><label class="${P.label} text-center">Kode OTP</label>${otpBoxes("otp")}</div>
      ${btn("Verifikasi")}
    </form>`),

  "login-reset-password": page("Lupa Password",
    `<form class="space-y-4">
      <div class="${P.group}"><label class="${P.label}">NIP atau Email</label>
        <input class="${P.input}" placeholder="Masukkan NIP Anda" />
      </div>
      <div class="flex items-center justify-between">
        <a href="#" class="text-sm text-red-600 dark:text-red-400 hover:underline">&laquo; Kembali ke halaman masuk</a>
        ${btn("Kirim", "primary", false)}
      </div>
    </form>
    <div class="asn-info mt-4 text-center text-sm text-gray-600 dark:text-gray-300">Masukkan NIP Anda, kami akan mengirim instruksi cara mengatur ulang password.</div>`,
    { }),

  "login-reset-otp": page("Masuk",
    `<form class="space-y-4">
      <p class="text-sm text-gray-600 dark:text-gray-300">Pilih perangkat OTP yang akan dihapus</p>
      <label class="${P.otpItem}"><input type="radio" name="cred" class="accent-red-600" checked />
        <span class="flex items-center justify-center w-9 h-9 rounded-full bg-red-50 dark:bg-red-900/40 text-red-600 dark:text-red-300"><i class="fa-solid fa-mobile-screen-button"></i></span>
        <span class="text-sm font-medium text-gray-800 dark:text-gray-100">OTP Google Authenticator</span></label>
      ${btn("Kirim")}
    </form>`),

  "login-update-password": page("Perbarui Password",
    `<form class="space-y-4">
      <div class="${P.group}"><label class="${P.label}">Password Baru</label>
        <div class="${P.inputGroup}"><input type="password" class="${P.input}" /><button type="button" class="${P.pwToggle}"><i class="fa-solid fa-eye"></i></button></div>
      </div>
      <div class="${P.group}"><label class="${P.label}">Konfirmasi Password</label>
        <div class="${P.inputGroup}"><input type="password" class="${P.input}" /><button type="button" class="${P.pwToggle}"><i class="fa-solid fa-eye"></i></button></div>
      </div>
      <label class="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-300"><input type="checkbox" class="accent-red-600" checked /> Keluar dari sesi perangkat lain</label>
      ${btn("Kirim")}
    </form>`),

  "login-config-totp": page("Aktivasi OTP",
    `<p class="text-sm text-center text-gray-500 dark:text-gray-400 mb-4">Pindai QR code dengan <span class="font-semibold text-red-600 dark:text-red-400 uppercase">aplikasi Google Authenticator</span> lalu masukkan kode OTP yang muncul.</p>
    <form class="space-y-4">
      <div class="flex justify-center"><div class="w-40 h-40 rounded-lg border border-gray-200 dark:border-gray-700 flex items-center justify-center text-gray-400"><i class="fa-solid fa-qrcode text-6xl"></i></div></div>
      <div class="text-sm text-center text-gray-600 dark:text-gray-400"><p>Atau masukkan manual:</p><code class="block mt-1 font-semibold text-gray-800 dark:text-gray-100 break-all">JBSWY3DPEHPK3PXP</code></div>
      <div class="${P.group}"><label class="${P.label} text-center">Kode OTP dari aplikasi <span class="font-semibold text-amber-500 uppercase">Google Authenticator</span></label>${otpBoxes("totp")}</div>
      <div class="${P.group}"><label class="${P.label}">Nama Perangkat</label><input class="${P.input}" value="OTP Google Authenticator" placeholder="Misal: HP Kantor / HP Pribadi" /></div>
      ${btn("Aktifkan OTP")}
    </form>
    <div class="mt-5 text-center text-sm text-gray-500 dark:text-gray-400">Bermasalah dengan OTP? Layanan Bantuan <a href="#" class="py-1 px-2 bg-red-600 dark:bg-red-900 text-white font-semibold rounded-md">Klik disini</a>.</div>`),

  "login-recovery-authn-code-config": page("Kode Pemulihan",
    `<p class="text-sm text-gray-600 dark:text-gray-400 mb-3">Simpan kode pemulihan ini di tempat aman. Setiap kode hanya bisa dipakai sekali.</p>
    <div class="grid grid-cols-2 gap-2 mb-4 font-mono text-sm">
      ${Array.from({ length: 12 }, (_, i) => `<div class="px-2 py-1 rounded bg-gray-100 dark:bg-gray-900 text-gray-700 dark:text-gray-200"><span class="text-gray-400">${i + 1}:</span> ${Math.random().toString(36).slice(2, 6)}-${Math.random().toString(36).slice(2, 6)}</div>`).join("\n")}
    </div>
    <label class="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-300 mb-3"><input type="checkbox" class="accent-red-600" /> Saya sudah menyimpan kode pemulihan</label>
    ${btn("Kirim")}`),

  "login-recovery-authn-code-input": page("Masukkan Kode Pemulihan",
    `<form class="space-y-4">
      <div class="${P.group}"><label class="${P.label}">Kode Pemulihan #3</label><input class="${P.input}" placeholder="xxxx-xxxx" /></div>
      ${btn("Masuk")}
    </form>`),

  "select-authenticator": page("Pilih Metode Masuk",
    `<div class="space-y-3">
      <button class="${P.selectAuthItem}">
        <span class="flex items-center justify-center w-10 h-10 rounded-lg bg-red-50 dark:bg-red-900/40 text-red-600 dark:text-red-300 shrink-0"><i class="fa-solid fa-mobile-screen-button text-lg"></i></span>
        <span class="flex-1 min-w-0"><span class="block text-sm font-semibold text-gray-800 dark:text-gray-100">Aplikasi Authenticator</span><span class="block text-xs text-gray-500 dark:text-gray-400">Masukkan kode dari aplikasi OTP</span></span>
        <i class="fa-solid fa-chevron-right text-gray-400 dark:text-gray-500"></i>
      </button>
      <button class="${P.selectAuthItem}">
        <span class="flex items-center justify-center w-10 h-10 rounded-lg bg-red-50 dark:bg-red-900/40 text-red-600 dark:text-red-300 shrink-0"><i class="fa-solid fa-life-ring text-lg"></i></span>
        <span class="flex-1 min-w-0"><span class="block text-sm font-semibold text-gray-800 dark:text-gray-100">Kode Pemulihan</span><span class="block text-xs text-gray-500 dark:text-gray-400">Gunakan salah satu kode pemulihan Anda</span></span>
        <i class="fa-solid fa-chevron-right text-gray-400 dark:text-gray-500"></i>
      </button>
    </div>`),

  "login-update-profile": page("Perbarui Informasi Akun",
    `<form class="space-y-4">
      <div class="${P.group}"><label class="${P.label}">Email</label><input class="${P.input}" value="pegawai@ponorogo.go.id" /></div>
      <div class="grid grid-cols-2 gap-3">
        <div><label class="${P.label}">Nama Depan</label><input class="${P.input}" value="Budi" /></div>
        <div><label class="${P.label}">Nama Belakang</label><input class="${P.input}" value="Santoso" /></div>
      </div>
      ${btn("Kirim")}
    </form>`, { requiredHint: true }),

  "login-verify-email": page("Verifikasi Email",
    `<p class="text-sm text-gray-600 dark:text-gray-400 mb-4">Email verifikasi telah dikirim ke <b>pegawai@ponorogo.go.id</b>.</p>
    <div class="asn-info mt-4 text-center text-sm text-gray-600 dark:text-gray-300">Belum menerima kode verifikasi di email Anda? <a href="#" class="text-red-600 dark:text-red-400 hover:underline">Klik di sini</a> untuk mengirim ulang email.</div>`),

  "terms": page("Syarat dan Ketentuan",
    `<div class="text-sm text-gray-600 dark:text-gray-300 mb-4 max-h-48 overflow-y-auto"><p>Silakan baca syarat dan ketentuan penggunaan layanan SSO ASN Kabupaten Ponorogo. Dengan melanjutkan, Anda menyetujui kebijakan privasi dan ketentuan layanan yang berlaku.</p></div>
    <div class="flex gap-3">${btn("Setuju", "primary", false)}${btn("Tolak", "default", false)}</div>`),

  "login-page-expired": page("Halaman Kedaluwarsa",
    `<p class="text-sm text-gray-600 dark:text-gray-400">Untuk memulai ulang proses masuk <a href="#" class="text-red-600 dark:text-red-400 hover:underline">Klik di sini</a>.<br/>Untuk melanjutkan proses masuk <a href="#" class="text-red-600 dark:text-red-400 hover:underline">Klik di sini</a>.</p>`),

  "logout-confirm": page("Keluar",
    `<div class="text-center">
      <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">Apakah Anda yakin ingin keluar?</p>
      ${btn("Keluar")}
    </div>`),

  "info": page("Informasi",
    `<div class="text-center"><p class="text-sm text-gray-600 dark:text-gray-400 mb-5">Email Anda berhasil diverifikasi.</p>${btn("&laquo; Kembali ke aplikasi", "primary", false)}</div>`),

  "error": page("Oops! Terjadi Kesalahan",
    `<div class="text-center"><p class="text-sm text-gray-600 dark:text-gray-400 mb-5">Terjadi kesalahan tak terduga. Silakan coba lagi nanti atau hubungi administrator.</p>${btn("Kembali ke Portal ASN Ponorogo", "primary", false)}</div>`),
};

// ----- tulis file + index -----
let count = 0;
for (const [name, html] of Object.entries(pages)) {
  fs.writeFileSync(path.join(DIR, name + ".html"), html, "utf8");
  count++;
}

const index = `<!DOCTYPE html><html lang="id"><head><meta charset="utf-8"/>
<title>Preview Theme asn-v2</title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@3.4.17/lib/css/preflight.min.css" rel="stylesheet"/>
<style>body{font-family:system-ui,sans-serif;max-width:760px;margin:2rem auto;padding:0 1rem;line-height:1.6}a{color:#bd4137}h1{color:#bd4137}li{margin:.25rem 0}code{background:#f3f3f3;padding:.1rem .3rem;border-radius:.2rem}</style>
</head><body>
<h1>Preview Theme Keycloak — asn-v2</h1>
<p>Preview statis tiap halaman login. Klik tombol <b>Toggle dark</b> di pojok kanan atas tiap halaman untuk cek dark mode.</p>
<ul>
${Object.keys(pages).map((n) => `<li><a href="${n}.html">${n}</a></li>`).join("\n")}
</ul>
<hr/>
<p><small>Dibuat oleh <code>preview/build-preview.js</code>. Ini replika visual, bukan render FreeMarker asli.</small></p>
</body></html>`;
fs.writeFileSync(path.join(DIR, "index.html"), index, "utf8");

console.log(`Generated ${count} preview pages + index.html in ${DIR}`);
