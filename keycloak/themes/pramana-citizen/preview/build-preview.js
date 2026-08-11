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
 * =============================================================================
 * ACUAN DESAIN: MOCKUP PRAMANA, bukan tafsir bebas design system.
 * -----------------------------------------------------------------------------
 * Markup di bawah mengikuti ponorogo-super-apps/mockup/src/screens/*.jsx.
 *
 * ⚠️ DUA LAYAR BERBEDA YANG MUDAH TERTUKAR:
 *
 *   mockup Login.jsx  = LAYAR APLIKASI FLUTTER, bukan halaman Keycloak.
 *   Ia muncul SEBELUM alur OAuth dimulai, dan memuat "Lanjut tanpa masuk" —
 *   pilihan yang TIDAK MUNGKIN ada di halaman Keycloak, karena pada saat
 *   halaman itu tampil alur OAuth sudah berjalan dan satu-satunya jalan
 *   membatalkannya adalah error=access_denied.
 *
 *   Halaman Keycloak baru tampil SETELAH warga memilih cara masuk, di dalam
 *   Custom Tabs. Ia mengurus kredensial saja.
 *
 *   Preview app-welcome.html merekam layar aplikasi itu sebagai ACUAN TIM
 *   FLUTTER — bukan bagian dari theme ini. Sisanya halaman Keycloak sungguhan.
 *
 * Dua pola visual yang dipakai:
 *
 *   1. LAYAR BERLATAR MARUN (app-welcome, login) — gradien marun penuh, logo
 *      besar di tengah, tombol putih menonjol. TIDAK memakai kartu putih.
 *
 *   2. LAYAR LANJUTAN (VerifikasiOtp.jsx) — latar PUTIH, header ramping dengan
 *      tombol kembali, kotak keterangan berwarna, tombol marun di bawah.
 *
 *      Latarnya HARUS putih, bukan zinc-50. Kotak catatan privasi di dalamnya
 *      memakai bg-zinc-50 + ring-zinc-200; kalau latar layarnya ikut zinc-50,
 *      kotak itu melebur dan tampak seperti kotak putih polos tanpa isi.
 *
 * Logo memakai path SVG asli dari mockup/src/components/Logo.jsx — dadak merak
 * Reog: kipas bulu emas, lengkung pangkal marun membentuk "P" sekaligus tangan
 * menengadah, titik emas di tengah sebagai warga.
 *
 * CATATAN LAIN:
 * - Ini BUKAN FreeMarker renderer, melainkan REPLIKA VISUAL supaya desain bisa
 *   dinilai sebelum ada yang di-deploy.
 * - Dark mode SENGAJA TIDAK dipakai: mockup PRAMANA hanya punya mode terang,
 *   dan halaman masuk berlatar marun sudah gelap dengan sendirinya.
 * - Semua ikon SVG Lucide inline, sama seperti mockup. Dilarang emoji.
 * - Semua teks Bahasa Indonesia, menyapa "Sedulur".
 */
const fs = require("fs");
const path = require("path");

const DIR = __dirname;
const RES = "../login/resources";

// =============================================================================
// LOGO — path SVG asli dari mockup/src/components/Logo.jsx
// =============================================================================
function logoMark(size = 54) {
  const id = `pg-${size}`;
  return `<svg width="${size}" height="${size}" viewBox="0 0 64 64" role="img" aria-label="Logo Pramana">
  <defs>
    <linearGradient id="${id}-emas" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#f9d947"/><stop offset="100%" stop-color="#c68407"/>
    </linearGradient>
    <linearGradient id="${id}-marun" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#a32c2c"/><stop offset="100%" stop-color="#7a1f1f"/>
    </linearGradient>
  </defs>
  <path d="M32 6C20 6 10 16 8 30c0 0 6-4 10-4s7 3 7 3-2-9 2-14 5-9 5-9z" fill="url(#${id}-emas)" opacity=".55"/>
  <path d="M32 6c12 0 22 10 24 24 0 0-6-4-10-4s-7 3-7 3 2-9-2-14-5-9-5-9z" fill="url(#${id}-emas)" opacity=".55"/>
  <path d="M32 8c-8 0-15 8-16 20 0 0 4-3 7-3s5 2 5 2-1-8 1-12 3-7 3-7z" fill="url(#${id}-emas)" opacity=".8"/>
  <path d="M32 8c8 0 15 8 16 20 0 0-4-3-7-3s-5 2-5 2 1-8-1-12-3-7-3-7z" fill="url(#${id}-emas)" opacity=".8"/>
  <path d="M32 7c-3 0-5 6-5 14s2 12 5 12 5-4 5-12-2-14-5-14z" fill="url(#${id}-emas)"/>
  <path d="M14 34c0 12 8 22 18 24 10-2 18-12 18-24 0 0-7 5-18 5s-18-5-18-5z" fill="url(#${id}-marun)"/>
  <circle cx="32" cy="43" r="5" fill="#f9d947"/><circle cx="32" cy="43" r="2.2" fill="#7a1f1f"/>
</svg>`;
}

// =============================================================================
// IKON — Lucide inline, sama seperti mockup
// =============================================================================
function svg(paths, size = 18, w = 2.3, cls = "") {
  return `<svg${cls ? ` class="${cls}"` : ""} width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${paths}</svg>`;
}

const ICON = {
  shieldCheck: (s = 14, w = 2.5, c = "") =>
    svg(`<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/><path d="m9 12 2 2 4-4"/>`, s, w, c),
  chevronRight: (s = 13, w = 3, c = "") => svg(`<path d="m9 18 6-6-6-6"/>`, s, w, c),
  arrowLeft: (s = 20, w = 2.5, c = "") => svg(`<path d="m12 19-7-7 7-7"/><path d="M19 12H5"/>`, s, w, c),
  fingerprint: (s = 17, w = 2.5, c = "") =>
    svg(`<path d="M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4"/><path d="M14 13.12c0 2.38 0 6.38-1 8.88"/><path d="M17.29 21.02c.12-.6.43-2.3.5-3.02"/><path d="M2 12a10 10 0 0 1 18-6"/><path d="M2 16h.01"/><path d="M21.8 16c.2-2 .131-5.354 0-6"/><path d="M5 19.5C5.5 18 6 15 6 12a6 6 0 0 1 .34-2"/><path d="M8.65 22c.21-.66.45-1.32.57-2"/><path d="M9 6.8a6 6 0 0 1 9 5.2v2"/>`, s, w, c),
  mail: (s = 16, w = 2.3, c = "") =>
    svg(`<rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>`, s, w, c),
  lock: (s = 16, w = 2.3, c = "") =>
    svg(`<rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>`, s, w, c),
  user: (s = 16, w = 2.3, c = "") =>
    svg(`<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>`, s, w, c),
  eye: (s = 16, w = 2.3, c = "") =>
    svg(`<path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/>`, s, w, c),
  info: (s = 15, w = 2.3, c = "") =>
    svg(`<circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/>`, s, w, c),
  alert: (s = 15, w = 2.3, c = "") =>
    svg(`<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/>`, s, w, c),
  circleX: (s = 15, w = 2.3, c = "") =>
    svg(`<circle cx="12" cy="12" r="10"/><path d="m15 9-6 6"/><path d="m9 9 6 6"/>`, s, w, c),
  messageCircle: (s = 17, w = 2.3, c = "") =>
    svg(`<path d="M7.9 20A9 9 0 1 0 4 16.1L2 22z"/>`, s, w, c),
  mailOpen: (s = 30, w = 1.8, c = "") =>
    svg(`<path d="M21.2 8.4c.5.38.8.97.8 1.6v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V10a2 2 0 0 1 .8-1.6l8-6a2 2 0 0 1 2.4 0z"/><path d="m22 10-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 10"/>`, s, w, c),
};

/** Logo Google — SVG inline persis dari mockup Login.jsx. */
const LOGO_GOOGLE = (s = 18) => `<svg width="${s}" height="${s}" viewBox="0 0 48 48" aria-hidden="true">
  <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
  <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
  <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
  <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
</svg>`;

// =============================================================================
// KERANGKA
// =============================================================================

/** Bingkai ponsel — preview ditampilkan seukuran layar aslinya. */
function halaman(namaFile, judulTab, isi, { latar = "bg-white" } = {}) {
  const html = `<!doctype html>
<html lang="id">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${judulTab} · PRAMANA</title>
<link rel="stylesheet" href="${RES}/css/styles.css">
</head>
<body class="min-h-screen bg-zinc-100 py-8 px-4 font-sans">
  <div class="mx-auto" style="max-width:390px">
    <div class="overflow-hidden rounded-[28px] bg-white shadow-2xl ring-1 ring-zinc-900/10" style="min-height:780px">
      <div class="flex min-h-full flex-col ${latar}" style="min-height:780px">
${isi}
      </div>
    </div>
    <p class="mt-3 text-center text-[11px] text-zinc-400">${judulTab}</p>
  </div>
</body>
</html>`;
  fs.writeFileSync(path.join(DIR, namaFile), html, "utf8");
  return namaFile;
}

/** Header layar lanjutan — pola VerifikasiOtp.jsx / VerifikasiNik.jsx. */
function header(judul, sub = "") {
  return `        <header class="flex items-center gap-3 border-b border-zinc-100 bg-white px-4 pb-3 pt-12">
          <span class="text-zinc-700">${ICON.arrowLeft(20)}</span>
          <div>
            <h1 class="text-sm font-extrabold text-zinc-900">${judul}</h1>
            ${sub ? `<p class="text-[10px] text-zinc-400">${sub}</p>` : ""}
          </div>
        </header>`;
}

/** Kotak keterangan berwarna — pola mockup (bg-X-50 + ring-X-100). */
function kotak(warna, ikon, judul, isi) {
  return `        <div class="flex gap-2.5 rounded-xl bg-${warna}-50 p-3.5 ring-1 ring-${warna}-100">
          <span class="mt-0.5 shrink-0 text-${warna}-600">${ikon}</span>
          <div>
            ${judul ? `<p class="text-[11px] font-bold text-${warna}-900">${judul}</p>` : ""}
            <p class="${judul ? "mt-1 " : ""}text-[10px] leading-relaxed text-${warna}-800">${isi}</p>
          </div>
        </div>`;
}

/** Kolom isian — pola VerifikasiNik.jsx: ring-1 zinc-200, ikon kiri. */
function field(label, ikon, isi, { wajib = false, hint = "", kanan = "" } = {}) {
  return `        <div class="mb-4">
          <label class="text-[11px] font-bold text-zinc-700">${label}${wajib ? ' <span class="text-rose-600">*</span>' : ""}</label>
          <div class="mt-2 flex items-center gap-2.5 rounded-xl bg-white px-3 py-3 ring-1 ring-zinc-200 focus-within:ring-2 focus-within:ring-marun-500">
            <span class="shrink-0 text-zinc-400">${ikon}</span>
            <span class="flex-1 text-[13px] text-zinc-800">${isi}</span>
            ${kanan}
          </div>
          ${hint ? `<p class="mt-1.5 text-[9.5px] text-zinc-400">${hint}</p>` : ""}
        </div>`;
}

/** Tombol utama marun — pola mockup. */
function tombolUtama(teks, { ikon = "", nonaktif = false } = {}) {
  return nonaktif
    ? `        <button class="w-full rounded-xl bg-zinc-200 py-3.5 text-[13px] font-bold text-zinc-400">${teks}</button>`
    : `        <button class="flex w-full items-center justify-center gap-2 rounded-xl bg-marun-700 py-3.5 text-[13px] font-bold text-white shadow-lg shadow-marun-700/20 transition hover:bg-marun-800">${ikon}${teks}</button>`;
}

/** Catatan privasi UU 27/2022 — ada di mockup Login.jsx, jangan dihilangkan. */
/* Persis mockup VerifikasiOtp.jsx baris 82: bg-zinc-50 + ring-zinc-200 di
   atas layar PUTIH. Kontras itu yang membuat kotaknya terbaca — kalau latar
   layarnya ikut zinc-50, kotak ini melebur jadi putih polos. */
const privasiTerang = `        <div class="mt-6 flex gap-2 rounded-xl bg-zinc-50 p-3 ring-1 ring-zinc-200">
          <span class="mt-0.5 shrink-0 text-zinc-500">${ICON.shieldCheck(13, 2.3)}</span>
          <p class="text-[9.5px] leading-relaxed text-zinc-500">
            Data Sedulur dilindungi sesuai <b class="text-zinc-700">UU No. 27 Tahun 2022</b> tentang
            Pelindungan Data Pribadi.
          </p>
        </div>`;

const dibuat = [];

// =============================================================================
// 0. LAYAR SAMBUTAN APLIKASI — mockup Login.jsx apa adanya
//
// BUKAN halaman Keycloak. Direkam di sini sebagai acuan tim Flutter, karena
// "Lanjut tanpa masuk" hanya mungkin ada di sisi aplikasi: begitu alur OAuth
// dimulai, Keycloak tidak lagi punya konsep "batal, lanjut sebagai tamu".
// =============================================================================
dibuat.push([
  halaman(
    "app-welcome.html",
    "Layar sambutan aplikasi",
    `        <div class="flex flex-1 flex-col px-6 pb-8 pt-20">
          <div class="flex flex-1 flex-col items-center justify-center text-center">
            <div class="flex h-20 w-20 items-center justify-center rounded-3xl bg-white/10 ring-1 ring-white/20">
              ${logoMark(54)}
            </div>
            <h1 class="mt-5 text-2xl font-extrabold tracking-tight text-white">PRAMANA</h1>
            <p class="mt-1 text-[11px] font-semibold text-emas-300">Ponorogo Berdaya</p>
            <p class="mt-5 max-w-60 text-[11px] leading-relaxed text-marun-200">
              Satu aplikasi untuk semua layanan Pemerintah Kabupaten Ponorogo
            </p>
          </div>

          <div class="space-y-2.5">
            <button class="flex w-full items-center justify-center gap-2.5 rounded-xl bg-white py-3.5 shadow-lg">
              ${LOGO_GOOGLE(18)}
              <span class="text-[13px] font-bold text-zinc-800">Masuk dengan Google</span>
            </button>

            <button class="flex w-full items-center justify-center gap-2.5 rounded-xl bg-white/10 py-3.5 ring-1 ring-white/25 backdrop-blur">
              <span class="text-white">${ICON.fingerprint(17)}</span>
              <span class="text-[13px] font-bold text-white">Masuk dengan Sidik Jari</span>
            </button>

            <button class="flex w-full items-center justify-center gap-2.5 rounded-xl bg-white/10 py-3.5 ring-1 ring-white/25 backdrop-blur">
              <span class="text-white">${ICON.mail(17)}</span>
              <span class="text-[13px] font-bold text-white">Masuk dengan Email</span>
            </button>

            <div class="flex items-center gap-3 py-1.5">
              <span class="h-px flex-1 bg-white/15"></span>
              <span class="text-[9.5px] font-semibold text-marun-300">atau</span>
              <span class="h-px flex-1 bg-white/15"></span>
            </div>

            <button class="flex w-full items-center justify-center gap-1.5 py-2">
              <span class="text-[11.5px] font-bold text-emas-300">Lanjut tanpa masuk</span>
              <span class="text-emas-300">${ICON.chevronRight(13)}</span>
            </button>
            <p class="text-center text-[9.5px] leading-relaxed text-marun-300">
              Sedulur tetap bisa melihat berita, CCTV, WiFi, dan lowongan kerja.
              <br />
              Untuk membuat laporan &amp; cek pajak, perlu masuk.
            </p>
          </div>

          <div class="mt-6 flex gap-2 rounded-xl bg-white/8 p-3 ring-1 ring-white/12">
            <span class="mt-0.5 shrink-0 text-emas-300">${ICON.shieldCheck(14)}</span>
            <p class="text-[9px] leading-relaxed text-marun-200">
              Data Sedulur dilindungi sesuai <b class="text-white">UU No. 27 Tahun 2022</b> tentang
              Pelindungan Data Pribadi. Dengan masuk, Sedulur menyetujui
              <span class="underline">Ketentuan Layanan</span> dan
              <span class="underline">Kebijakan Privasi</span>.
            </p>
          </div>
        </div>`,
    { latar: "bg-gradient-to-b from-marun-900 via-marun-800 to-marun-900" }
  ),
  "Layar sambutan aplikasi",
  '⚠️ BUKAN halaman Keycloak — acuan tim Flutter. Di sinilah "Lanjut tanpa masuk" hidup',
]);

// =============================================================================
// 1. MASUK (Keycloak) — tampil di Custom Tabs setelah warga memilih cara masuk
//
// Tanpa "Lanjut tanpa masuk": pada titik ini alur OAuth sudah berjalan.
// Tanpa tombol Google/passkey berukuran besar juga — keduanya dipanggil native
// dari aplikasi, jadi warga yang sampai ke halaman ini memang memilih email.
// Tombol Google tetap disediakan sebagai jaring pengaman bila warga membuka
// tautan masuk langsung dari peramban.
// =============================================================================
dibuat.push([
  halaman(
    "login.html",
    "Masuk (Keycloak)",
    `        <div class="flex flex-1 flex-col px-6 pb-8 pt-16">
          <div class="flex flex-col items-center text-center">
            <div class="flex h-16 w-16 items-center justify-center rounded-3xl bg-white/10 ring-1 ring-white/20">
              ${logoMark(42)}
            </div>
            <h1 class="mt-4 text-xl font-extrabold tracking-tight text-white">Masuk ke PRAMANA</h1>
            <p class="mt-1.5 text-[11px] leading-relaxed text-marun-200">
              Layanan Pemerintah Kabupaten Ponorogo
            </p>
          </div>

          <div class="mt-8 flex-1">
            <label class="text-[11px] font-bold text-marun-100">Email</label>
            <div class="mt-2 flex items-center gap-2.5 rounded-xl bg-white/95 px-3 py-3 ring-1 ring-white/20">
              <span class="shrink-0 text-zinc-400">${ICON.mail(16)}</span>
              <span class="flex-1 text-[13px] text-zinc-300">nama@email.com</span>
            </div>

            <label class="mt-4 block text-[11px] font-bold text-marun-100">Kata Sandi</label>
            <div class="mt-2 flex items-center gap-2.5 rounded-xl bg-white/95 px-3 py-3 ring-1 ring-white/20">
              <span class="shrink-0 text-zinc-400">${ICON.lock(16)}</span>
              <span class="flex-1 text-[13px] text-zinc-300">Kata sandi Sedulur</span>
              <span class="shrink-0 text-zinc-400">${ICON.eye(16)}</span>
            </div>

            <div class="mt-3.5 flex items-center justify-between">
              <label class="flex items-center gap-2 text-[11px] text-marun-200">
                <span class="grid h-4 w-4 place-items-center rounded bg-white/15 ring-1 ring-white/25"></span>
                Ingat saya
              </label>
              <span class="text-[11px] font-bold text-emas-300 underline">Lupa kata sandi?</span>
            </div>

            <button class="mt-5 flex w-full items-center justify-center rounded-xl bg-white py-3.5 shadow-lg">
              <span class="text-[13px] font-bold text-marun-800">Masuk</span>
            </button>

            <div class="flex items-center gap-3 py-4">
              <span class="h-px flex-1 bg-white/15"></span>
              <span class="text-[9.5px] font-semibold text-marun-300">atau</span>
              <span class="h-px flex-1 bg-white/15"></span>
            </div>

            <div class="space-y-2.5">
              <button class="flex w-full items-center justify-center gap-2.5 rounded-xl bg-white/10 py-3 ring-1 ring-white/25 backdrop-blur">
                ${LOGO_GOOGLE(17)}
                <span class="text-[12.5px] font-bold text-white">Masuk dengan Google</span>
              </button>
              <button class="flex w-full items-center justify-center gap-2.5 rounded-xl bg-white/10 py-3 ring-1 ring-white/25 backdrop-blur">
                <span class="text-white">${ICON.fingerprint(16)}</span>
                <span class="text-[12.5px] font-bold text-white">Masuk dengan Sidik Jari</span>
              </button>
            </div>

            <p class="mt-5 text-center text-[11px] text-marun-200">
              Belum punya akun?
              <span class="font-bold text-emas-300 underline">Daftar sekarang</span>
            </p>
          </div>

          <div class="mt-6 flex gap-2 rounded-xl bg-white/8 p-3 ring-1 ring-white/12">
            <span class="mt-0.5 shrink-0 text-emas-300">${ICON.shieldCheck(14)}</span>
            <p class="text-[9px] leading-relaxed text-marun-200">
              Data Sedulur dilindungi sesuai <b class="text-white">UU No. 27 Tahun 2022</b> tentang
              Pelindungan Data Pribadi.
            </p>
          </div>
        </div>`,
    { latar: "bg-gradient-to-b from-marun-900 via-marun-800 to-marun-900" }
  ),
  "Masuk (Keycloak)",
  "Halaman Keycloak sungguhan — tampil di Custom Tabs, tanpa \"Lanjut tanpa masuk\"",
]);

// =============================================================================
// 2. MASUK DENGAN EMAIL
// =============================================================================
dibuat.push([
  halaman(
    "login-email.html",
    "Masuk dengan email",
    `${header("Masuk dengan Email")}
        <div class="flex-1 px-4 pt-5">
          ${field("Email", ICON.mail(16), '<span class="text-zinc-300">nama@email.com</span>', { wajib: true })}
          ${field("Kata Sandi", ICON.lock(16), '<span class="tracking-widest text-zinc-800">••••••••</span>', {
            wajib: true,
            kanan: `<span class="shrink-0 text-zinc-400">${ICON.eye(16)}</span>`,
          })}

          <div class="mb-5 flex items-center justify-between">
            <label class="flex items-center gap-2 text-[11px] text-zinc-600">
              <span class="grid h-4 w-4 place-items-center rounded border border-zinc-300 bg-white"></span>
              Ingat saya
            </label>
            <span class="text-[11px] font-bold text-marun-700 underline">Lupa kata sandi?</span>
          </div>

          ${tombolUtama("Masuk")}

          <p class="mt-5 text-center text-[11px] text-zinc-500">
            Belum punya akun? <span class="font-bold text-marun-700 underline">Daftar sekarang</span>
          </p>
          ${privasiTerang}
        </div>`,
    { latar: "bg-white" }
  ),
  "Masuk dengan email",
  "Layar putih + header, pola VerifikasiOtp.jsx",
]);

// =============================================================================
// 3. DAFTAR
// =============================================================================
dibuat.push([
  halaman(
    "register.html",
    "Daftar",
    `${header("Daftar Akun", "Gratis, hanya butuh 1 menit")}
        <div class="flex-1 px-4 pt-4">
          ${kotak("sky", ICON.info(15), "Untuk apa akun ini?", "Untuk membuat laporan ke Bunda dan memantau tindak lanjutnya. Melihat berita, CCTV, dan WiFi <b>tidak perlu akun</b>.")}
          <div class="pt-5">
            ${field("Nama Lengkap", ICON.user(16), '<span class="text-zinc-300">Nama sesuai KTP</span>', { wajib: true })}
            ${field("Email", ICON.mail(16), '<span class="text-zinc-300">nama@email.com</span>', {
              wajib: true,
              hint: "Kami kirimi tautan untuk memastikan email ini milik Sedulur.",
            })}
            ${field("Kata Sandi", ICON.lock(16), '<span class="text-zinc-300">Minimal 8 huruf</span>', {
              wajib: true,
              kanan: `<span class="shrink-0 text-zinc-400">${ICON.eye(16)}</span>`,
            })}
            ${field("Ulangi Kata Sandi", ICON.lock(16), '<span class="text-zinc-300">Ketik ulang</span>', { wajib: true })}
            ${tombolUtama("Daftar")}
            <p class="mt-5 text-center text-[11px] text-zinc-500">
              Sudah punya akun? <span class="font-bold text-marun-700 underline">Masuk</span>
            </p>
            ${privasiTerang}
          </div>
        </div>`,
    { latar: "bg-white" }
  ),
  "Daftar",
  "Registrasi mandiri — form dirender Keycloak, bukan aplikasi",
]);

// =============================================================================
// 4. MASUK GAGAL
// =============================================================================
dibuat.push([
  halaman(
    "login-error.html",
    "Masuk gagal",
    `${header("Masuk dengan Email")}
        <div class="flex-1 px-4 pt-4">
          ${kotak("rose", ICON.circleX(15), "", "Email atau kata sandi yang Sedulur masukkan tidak cocok. Coba periksa kembali.")}
          <div class="pt-5">
            ${field("Email", ICON.mail(16), "sedulur@email.com", { wajib: true })}
            ${field("Kata Sandi", ICON.lock(16), '<span class="tracking-widest text-zinc-800">••••••</span>', {
              wajib: true,
              kanan: `<span class="shrink-0 text-zinc-400">${ICON.eye(16)}</span>`,
            })}
            ${tombolUtama("Masuk")}
            <p class="mt-5 text-center text-[11px] text-zinc-500">
              Lupa kata sandi? <span class="font-bold text-marun-700 underline">Atur ulang</span>
            </p>
          </div>
        </div>`,
    { latar: "bg-white" }
  ),
  "Masuk gagal",
  'Bahasa Indonesia — bukan "Invalid username or password"',
]);

// =============================================================================
// 5. LUPA KATA SANDI
// =============================================================================
dibuat.push([
  halaman(
    "login-reset-password.html",
    "Lupa kata sandi",
    `${header("Lupa Kata Sandi")}
        <div class="flex-1 px-4 pt-4">
          ${kotak("sky", ICON.info(15), "", "Masukkan email yang Sedulur pakai saat mendaftar. Kami kirimkan tautan untuk membuat kata sandi baru.")}
          <div class="pt-5">
            ${field("Email", ICON.mail(16), '<span class="text-zinc-300">nama@email.com</span>', { wajib: true })}
            ${tombolUtama("Kirim Tautan")}
            <p class="mt-5 text-center text-[11px] text-zinc-500">
              Ingat kata sandinya? <span class="font-bold text-marun-700 underline">Kembali masuk</span>
            </p>
          </div>
        </div>`,
    { latar: "bg-white" }
  ),
  "Lupa kata sandi",
  "Jalur pemulihan akun",
]);

// =============================================================================
// 6. VERIFIKASI EMAIL
// =============================================================================
dibuat.push([
  halaman(
    "login-verify-email.html",
    "Verifikasi email",
    `${header("Verifikasi Email")}
        <div class="flex-1 px-4 pt-4">
          ${kotak("emerald", ICON.mail(16), "Tautan sudah dikirim", "Kami mengirim tautan aktivasi ke <b>sedulur@email.com</b>")}
          <div class="px-2 pt-8 text-center">
            <div class="mx-auto grid h-20 w-20 place-items-center rounded-3xl bg-marun-50 text-marun-700 ring-1 ring-marun-100">
              ${ICON.mailOpen(34)}
            </div>
            <p class="mt-5 text-[12px] leading-relaxed text-zinc-600">
              Buka email itu lalu tekan tautannya untuk mengaktifkan akun Sedulur.
            </p>
          </div>
          <div class="mt-8">
            ${kotak("amber", ICON.alert(15), "", "Belum menerima email? Periksa folder <b>spam</b> terlebih dahulu.")}
            <div class="mt-4">
              <button class="w-full rounded-xl bg-white py-3.5 text-[13px] font-bold text-marun-700 ring-1 ring-zinc-200">Kirim Ulang Email</button>
            </div>
          </div>
        </div>`,
    { latar: "bg-white" }
  ),
  "Verifikasi email",
  "Wajib untuk registrasi mandiri",
]);

// =============================================================================
// 7. DAFTAR PASSKEY
// =============================================================================
dibuat.push([
  halaman(
    "webauthn-register.html",
    "Daftar sidik jari",
    `${header("Masuk Lebih Cepat", "Opsional")}
        <div class="flex-1 px-4 pt-4">
          <div class="px-2 pt-6 text-center">
            <div class="mx-auto grid h-20 w-20 place-items-center rounded-3xl bg-marun-50 text-marun-700 ring-1 ring-marun-100">
              ${ICON.fingerprint(36, 1.9)}
            </div>
            <h2 class="mt-5 text-base font-extrabold text-zinc-900">Aktifkan Sidik Jari</h2>
            <p class="mt-2 text-[12px] leading-relaxed text-zinc-600">
              Sedulur bisa masuk memakai <b>sidik jari</b> atau <b>wajah</b> — tanpa mengingat kata sandi.
            </p>
          </div>
          <div class="mt-7">
            ${kotak("emerald", ICON.shieldCheck(15, 2.3), "", "Sidik jari Sedulur tetap tersimpan di ponsel sendiri. <b>Pemkab tidak pernah menerimanya.</b>")}
            <div class="mt-5 space-y-2.5">
              ${tombolUtama("Aktifkan Sekarang", { ikon: `<span>${ICON.fingerprint(17, 2.5)}</span>` })}
              <button class="w-full rounded-xl py-3 text-[12px] font-bold text-zinc-500">Nanti saja</button>
            </div>
            <p class="mt-3 text-center text-[9.5px] leading-relaxed text-zinc-400">
              Sedulur tetap bisa masuk seperti biasa bila ponselnya belum mendukung.
            </p>
          </div>
        </div>`,
    { latar: "bg-white" }
  ),
  "Daftar passkey",
  'Opsional — ada tombol "Nanti saja", tidak dipaksakan',
]);

// =============================================================================
// 8. KODE OTP — mengikuti mockup VerifikasiOtp.jsx
// =============================================================================
dibuat.push([
  halaman(
    "login-otp.html",
    "Kode verifikasi",
    `${header("Verifikasi Nomor")}
        <div class="flex-1 px-6 pt-4">
          ${kotak("emerald", ICON.messageCircle(17), "Kode dikirim lewat WhatsApp", "Kami mengirim 6 digit kode ke nomor <b>0812-3456-7890</b>")}

          <div class="mt-7">
            <label class="text-[11px] font-bold text-zinc-700">Masukkan Kode</label>
            <div class="mt-2.5 flex gap-2">
              ${["4", "7", "2", "9", "", ""]
                .map((k, i) => {
                  const gaya = k
                    ? "bg-marun-50 text-marun-800 ring-2 ring-marun-600"
                    : i === 4
                      ? "bg-white text-zinc-800 ring-2 ring-marun-400"
                      : "bg-zinc-50 text-zinc-300 ring-zinc-200";
                  return `<div class="flex flex-1 items-center justify-center rounded-xl text-lg font-extrabold tabular-nums ring-1 ${gaya}" style="height:3.25rem">${k || "·"}</div>`;
                })
                .join("")}
            </div>
          </div>

          <div class="mt-5 text-center">
            <p class="text-[11px] text-zinc-500">
              Belum menerima kode? <span class="font-bold text-zinc-400">Kirim ulang dalam 0:47</span>
            </p>
          </div>

          <div class="mt-6">
            ${tombolUtama("Verifikasi", { nonaktif: true })}
          </div>
          <p class="mt-2 text-center text-[10px] text-zinc-400">Tombol aktif setelah 6 digit terisi</p>

          <div class="mt-8 border-t border-zinc-100 pt-5 text-center">
            <p class="text-[11px] text-zinc-500">
              Nomor salah? <span class="font-bold text-marun-700 underline">Ubah nomor</span>
            </p>
          </div>

          <div class="mt-6 flex gap-2 rounded-xl bg-zinc-50 p-3 ring-1 ring-zinc-200">
            <span class="mt-0.5 shrink-0 text-zinc-500">${ICON.shieldCheck(13, 2.3)}</span>
            <p class="text-[9.5px] leading-relaxed text-zinc-500">
              Nomor Sedulur hanya dipakai untuk masuk dan mengirim pemberitahuan status laporan.
              Tidak dibagikan kepada pihak lain.
            </p>
          </div>
        </div>`,
    { latar: "bg-white" }
  ),
  "Kode OTP",
  "Mengikuti VerifikasiOtp.jsx — kotak 6 digit, hitung mundur kirim ulang",
]);

// =============================================================================
// 9. SESI BERAKHIR
// =============================================================================
dibuat.push([
  halaman(
    "login-page-expired.html",
    "Sesi berakhir",
    `${header("Sesi Berakhir")}
        <div class="flex-1 px-4 pt-4">
          ${kotak("amber", ICON.alert(15), "", "Sesi Sedulur sudah berakhir karena terlalu lama menunggu. Silakan masuk kembali.")}
          <div class="pt-6">
            ${tombolUtama("Masuk Kembali")}
          </div>
        </div>`,
    { latar: "bg-white" }
  ),
  "Sesi berakhir",
  'Pesan jelas, bukan "An error occurred"',
]);

// =============================================================================
// 10. GALAT UMUM
// =============================================================================
dibuat.push([
  halaman(
    "error.html",
    "Terjadi kesalahan",
    `${header("Ada Yang Tidak Beres")}
        <div class="flex-1 px-4 pt-4">
          ${kotak("rose", ICON.circleX(15), "", "Kami tidak dapat memproses permintaan Sedulur saat ini. Silakan coba beberapa saat lagi.")}
          <div class="pt-6">
            <button class="w-full rounded-xl bg-white py-3.5 text-[13px] font-bold text-marun-700 ring-1 ring-zinc-200">Kembali ke Halaman Masuk</button>
          </div>
        </div>`,
    { latar: "bg-white" }
  ),
  "Galat",
  "Menjelaskan jalan keluar, bukan kode teknis",
]);

// =============================================================================
// DAFTAR ISI
// =============================================================================
const kartu = dibuat
  .map(
    ([f, judul, ket]) => `
      <a href="${f}" class="block rounded-2xl bg-white p-4 ring-1 ring-zinc-200 transition hover:-translate-y-0.5 hover:ring-marun-600">
        <div class="text-sm font-bold text-zinc-900">${judul}</div>
        <div class="mt-1 text-[12px] leading-relaxed text-zinc-500">${ket}</div>
        <div class="mt-2 font-mono text-[11px] text-marun-700">${f}</div>
      </a>`
  )
  .join("");

fs.writeFileSync(
  path.join(DIR, "index.html"),
  `<!doctype html>
<html lang="id">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Preview theme PRAMANA — realm warga</title>
<link rel="stylesheet" href="${RES}/css/styles.css">
</head>
<body class="min-h-screen bg-zinc-100 py-10 px-4 font-sans">
  <div class="mx-auto max-w-3xl">
    <div class="flex items-center gap-3">
      ${logoMark(44)}
      <div>
        <h1 class="text-xl font-extrabold tracking-tight text-zinc-900">Preview theme <span class="text-marun-700">pramana-citizen</span></h1>
        <p class="text-[11px] font-semibold text-marun-600">Halaman masuk &amp; daftar warga · realm ponorogo-citizen</p>
      </div>
    </div>

    <div class="mt-4 flex gap-2.5 rounded-xl bg-sky-50 p-3.5 ring-1 ring-sky-100">
      <span class="mt-0.5 shrink-0 text-sky-600">${ICON.info(15)}</span>
      <div>
        <p class="text-[11px] font-bold text-sky-900">Mengikuti mockup PRAMANA</p>
        <p class="mt-1 text-[10px] leading-relaxed text-sky-800">
          Layar berlatar marun mengikuti <code class="font-mono">mockup/src/screens/Login.jsx</code>;
          layar lanjutan memakai pola putih + header seperti <code class="font-mono">VerifikasiOtp.jsx</code>.
          Logo memakai path SVG asli dari <code class="font-mono">components/Logo.jsx</code>.
          Replika visual statis — belum ada yang ter-deploy ke Keycloak.
        </p>
      </div>
    </div>

    <div class="mt-2.5 flex gap-2.5 rounded-xl bg-amber-50 p-3.5 ring-1 ring-amber-100">
      <span class="mt-0.5 shrink-0 text-amber-600">${ICON.alert(15)}</span>
      <div>
        <p class="text-[11px] font-bold text-amber-900">Kartu pertama BUKAN halaman Keycloak</p>
        <p class="mt-1 text-[10px] leading-relaxed text-amber-800">
          <b>Layar sambutan aplikasi</b> adalah layar Flutter yang tampil <b>sebelum</b> alur masuk dimulai —
          di sanalah <b>"Lanjut tanpa masuk"</b> hidup. Pilihan itu tidak mungkin ada di halaman Keycloak:
          begitu alur OAuth berjalan, satu-satunya cara membatalkan adalah <code class="font-mono">error=access_denied</code>.
          Kartu itu disertakan sebagai acuan tim Flutter, bukan bagian dari theme.
        </p>
      </div>
    </div>

    <div class="mt-6 grid gap-3 sm:grid-cols-2">${kartu}</div>

    <p class="mt-8 text-[10.5px] leading-relaxed text-zinc-400">
      Palet marun <code class="font-mono">#7A1F1F</code> · emas <code class="font-mono">#F5C518</code>.
      Ikon Lucide inline, tanpa emoji. Seluruh teks Bahasa Indonesia, menyapa "Sedulur".
      Mode gelap sengaja tidak dipakai — mockup PRAMANA hanya punya mode terang.
    </p>
  </div>
</body>
</html>`,
  "utf8"
);

console.log(`Preview dibuat: ${dibuat.length} halaman + index.html`);
console.log(`Buka: ${path.join(DIR, "index.html")}`);
