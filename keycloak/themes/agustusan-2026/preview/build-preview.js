/**
 * build-preview.js
 * -----------------------------------------------------------------------------
 * Generator preview HTML statis untuk theme Keycloak "agustusan-2026"
 * (HUT RI ke-81 · Kisara SSO · Kabupaten Ponorogo) TANPA menjalankan Keycloak.
 *
 * Tujuannya UJI COBA VISUAL cepat: tiap halaman login Keycloak (login, OTP,
 * reset kata sandi, recovery code, pilih metode, verifikasi email, syarat &
 * ketentuan, halaman kedaluwarsa, keluar, informasi, kesalahan) di-render
 * memakai chrome yang SAMA dengan preview-tailwind.html, dengan data mock.
 *
 * Cara pakai:
 *   cd themes/agustusan-2026
 *   node preview/build-preview.js
 * atau dari dalam folder preview:
 *   node build-preview.js
 *
 * Output:  preview/*.html  (+ preview/index.html sebagai daftar isi)
 *
 * CATATAN PENTING:
 * - Ini BUKAN FreeMarker renderer. Ini REPLIKA VISUAL (HTML statis) supaya
 *   desain bisa dinilai tanpa deploy ke Keycloak. Markup dibuat semirip
 *   mungkin dengan target output template.ftl + theme.css nanti.
 * - Dark mode OTOMATIS mengikuti preferensi sistem (Tailwind darkMode:'media').
 *   TIDAK ada tombol toggle — ubah tema terang/gelap di pengaturan OS.
 * - Semua ikon adalah inline SVG bergaya Lucide (stroke="currentColor").
 *   Dilarang emoji, dilarang FontAwesome.
 * - Semua teks Bahasa Indonesia. Nama aplikasi selalu "Kisara SSO".
 */
const fs = require("fs");
const path = require("path");

const DIR = __dirname;
const RES = "../login/resources"; // relatif dari file html di preview/

// =============================================================================
// IKON — inline SVG gaya Lucide (stroke currentColor, 24x24 viewBox)
// =============================================================================
function svg(pathsHtml, size = 18, strokeWidth = 2, cls = "") {
  return `<svg${cls ? ` class="${cls}"` : ""} width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="${strokeWidth}" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${pathsHtml}</svg>`;
}

const ICON = {
  // lucide: contact (dipakai untuk field NIP)
  contact: (s = 18, w = 2, c = "") =>
    svg(
      `<rect x="3" y="4" width="18" height="16" rx="2"/><circle cx="9" cy="10" r="2"/><path d="M15 8h3M15 12h3M7 16h10"/>`,
      s,
      w,
      c
    ),
  // lucide: lock
  lock: (s = 18, w = 2, c = "") =>
    svg(`<rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>`, s, w, c),
  // lucide: eye
  eye: (s = 18, w = 2, c = "") =>
    svg(
      `<path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/>`,
      s,
      w,
      c
    ),
  // lucide: arrow-right
  arrowRight: (s = 16, w = 2.5, c = "") => svg(`<path d="M5 12h14M13 6l6 6-6 6"/>`, s, w, c),
  // lucide: arrow-left
  arrowLeft: (s = 16, w = 2.5, c = "") => svg(`<path d="M19 12H5M11 18l-6-6 6-6"/>`, s, w, c),
  // lucide: fingerprint
  fingerprint: (s = 22, w = 1.8, c = "") =>
    svg(
      `<path d="M2 12C2 6.5 6.5 2 12 2a10 10 0 0 1 8 4"/><path d="M5 19.5C5.5 18 6 15 6 12a6 6 0 0 1 .34-2"/><path d="M17.29 21.02c.12-.6.43-2.3.5-3.02"/><path d="M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4"/><path d="M8.65 22c.21-.66.45-1.32.57-2"/><path d="M14 13.12c0 2.38 0 6.38-1 8.88"/><path d="M2 16h.01"/><path d="M21.8 16c.2-2 .131-5.354 0-6"/><path d="M9 6.8a6 6 0 0 1 9 5.2c0 .47 0 1.17-.02 2"/>`,
      s,
      w,
      c
    ),
  // lucide: info
  info: (s = 18, w = 2, c = "") =>
    svg(`<circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/>`, s, w, c),
  // lucide: alert-triangle
  alertTriangle: (s = 18, w = 2, c = "") =>
    svg(
      `<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/>`,
      s,
      w,
      c
    ),
  // lucide: alert-circle
  alertCircle: (s = 18, w = 2, c = "") =>
    svg(`<circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/>`, s, w, c),
  // lucide: log-out
  logOut: (s = 18, w = 2, c = "") =>
    svg(
      `<path d="m16 17 5-5-5-5"/><path d="M21 12H9"/><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>`,
      s,
      w,
      c
    ),
  // lucide: mail
  mail: (s = 18, w = 2, c = "") =>
    svg(
      `<rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>`,
      s,
      w,
      c
    ),
  // lucide: smartphone
  smartphone: (s = 18, w = 2, c = "") =>
    svg(`<rect x="5" y="2" width="14" height="20" rx="2"/><path d="M12 18h.01"/>`, s, w, c),
  // lucide: key
  key: (s = 18, w = 2, c = "") =>
    svg(
      `<path d="m15.5 7.5 2.3 2.3a1 1 0 0 0 1.4 0l2.1-2.1a1 1 0 0 0 0-1.4L19 4"/><path d="m21 2-9.6 9.6"/><circle cx="7.5" cy="15.5" r="5.5"/>`,
      s,
      w,
      c
    ),
  // lucide: shield
  shield: (s = 18, w = 2, c = "") =>
    svg(
      `<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>`,
      s,
      w,
      c
    ),
  // lucide: check-circle
  checkCircle: (s = 18, w = 2, c = "") =>
    svg(`<circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>`, s, w, c),
  // lucide: message-circle (bantuan)
  messageCircle: (s = 18, w = 2.2, c = "") => svg(`<path d="M7.9 20A9 9 0 1 0 4 16.1L2 22z"/>`, s, w, c),
  // lucide: clock (page expired)
  clock: (s = 18, w = 2, c = "") => svg(`<circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>`, s, w, c),
  // lucide: timer
  timer: (s = 18, w = 2, c = "") =>
    svg(`<path d="M10 2h4"/><path d="M12 14v-4"/><circle cx="12" cy="14" r="8"/>`, s, w, c),
  // lucide: file-text (terms)
  fileText: (s = 18, w = 2, c = "") =>
    svg(
      `<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/>`,
      s,
      w,
      c
    ),
  // lucide: refresh-cw
  refreshCw: (s = 18, w = 2, c = "") =>
    svg(
      `<path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/><path d="M8 16H3v5"/>`,
      s,
      w,
      c
    ),
  // lucide: user
  user: (s = 18, w = 2, c = "") =>
    svg(`<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>`, s, w, c),
  // lucide: chevron-right
  chevronRight: (s = 18, w = 2.2, c = "") => svg(`<path d="m9 18 6-6-6-6"/>`, s, w, c),
  // lucide: qr-code
  qrCode: (s = 18, w = 2, c = "") =>
    svg(
      `<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><path d="M14 14h3v3h-3z"/><path d="M21 14v.01"/><path d="M14 21v.01"/><path d="M21 21v.01"/><path d="M18 21v.01"/><path d="M21 18v.01"/>`,
      s,
      w,
      c
    ),
  // lucide: copy
  copy: (s = 16, w = 2, c = "") =>
    svg(
      `<rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>`,
      s,
      w,
      c
    ),
  // lucide: download
  download: (s = 16, w = 2, c = "") =>
    svg(`<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><path d="M7 10l5 5 5-5"/><path d="M12 15V3"/>`, s, w, c),
  // lucide: list-checks (recovery code)
  listChecks: (s = 18, w = 2, c = "") =>
    svg(
      `<path d="m3 17 2 2 4-4"/><path d="m3 7 2 2 4-4"/><path d="M13 6h8"/><path d="M13 12h8"/><path d="M13 18h8"/>`,
      s,
      w,
      c
    ),
};

// Bendera merah-putih (SVG penuh warna, bukan stroke)
function benderaSvg(w = 14, h = 10, strokeColor = "rgba(255,255,255,.5)") {
  return `<svg width="${w}" height="${h}" viewBox="0 0 20 14" aria-hidden="true"><rect width="20" height="7" fill="#c8102e"/><rect y="7" width="20" height="7" fill="#fff"/><rect width="20" height="14" fill="none" stroke="${strokeColor}" stroke-width="1"/></svg>`;
}

// =============================================================================
// HELPER KOMPONEN
// =============================================================================

const C = {
  card:
    "w-full max-w-md bg-white dark:bg-neutral-900 rounded-[22px] shadow-[0_20px_50px_-20px_rgba(158,11,35,.35)] ring-1 ring-slate-100 dark:ring-white/10 overflow-hidden",
  hero:
    "hero-pattern relative px-6 pt-6 pb-9 text-center text-white bg-gradient-to-br from-merah-tua via-merah to-merah-muda overflow-hidden",
  body: "relative z-20 -mt-3.5 rounded-t-[20px] bg-white dark:bg-neutral-900 p-6",
  judul: "text-[17px] font-bold text-slate-900 dark:text-white",
  sub: "text-xs text-slate-400 dark:text-neutral-500",
  label: "block text-[13px] font-semibold text-slate-700 dark:text-neutral-300 mb-1.5",
  input:
    "w-full py-3 pl-[42px] pr-3.5 text-sm rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-800 dark:text-neutral-100 placeholder-slate-300 dark:placeholder-neutral-600 focus:outline-none focus:border-merah focus:bg-white dark:focus:bg-neutral-900 focus:ring-4 focus:ring-merah/10 transition",
  inputPlain:
    "w-full py-3 px-3.5 text-sm rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-800 dark:text-neutral-100 placeholder-slate-300 dark:placeholder-neutral-600 focus:outline-none focus:border-merah focus:bg-white dark:focus:bg-neutral-900 focus:ring-4 focus:ring-merah/10 transition",
  otpCell:
    "w-11 h-[52px] text-center text-[22px] font-bold rounded-xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 text-slate-900 dark:text-white focus:outline-none focus:border-merah focus:ring-4 focus:ring-merah/10 transition",
  btnPrimary:
    "btn-sapu w-full inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition",
  btnSecondary:
    "w-full py-3 rounded-[13px] text-sm font-semibold border-[1.5px] border-slate-200 dark:border-neutral-700 text-slate-600 dark:text-neutral-300 hover:border-merah hover:text-merah transition",
  pilihan:
    "w-full flex items-center gap-3.5 p-3.5 rounded-2xl border-[1.5px] border-slate-200 dark:border-neutral-700 bg-slate-50 dark:bg-neutral-950 hover:border-merah hover:bg-white dark:hover:bg-neutral-900 transition cursor-pointer text-left",
};

/** Tombol utama (gradient merah + efek sapu). */
function btnPrimary(label, { icon = ICON.arrowRight(), flex1 = false, type = "button" } = {}) {
  const base = flex1
    ? "btn-sapu flex-1 inline-flex items-center justify-center gap-2 py-3 rounded-[13px] text-[15px] font-bold text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 transition"
    : C.btnPrimary;
  return `<button type="${type}" class="${base}">${label}${icon ? "\n            " + icon : ""}</button>`;
}

/** Tombol sekunder (outline). */
function btnSecondary(label, { extraClass = "" } = {}) {
  return `<button type="button" class="${C.btnSecondary}${extraClass ? " " + extraClass : ""}">${label}</button>`;
}

/** Field bericon kiri (field-wrap + field-ikon). */
function field(labelText, { type = "text", placeholder = "", value = "", icon = ICON.contact(), toggle = false } = {}) {
  const inputCls = toggle ? C.input.replace("pr-3.5", "pr-11") : C.input;
  const valAttr = value ? ` value="${value}"` : "";
  return `<label class="${C.label}">${labelText}</label>
          <div class="field-wrap relative mb-4">
            <input type="${type}" placeholder="${placeholder}"${valAttr} class="${inputCls}" />
            ${icon.replace("<svg", '<svg class="field-ikon"')}
            ${
              toggle
                ? `<button type="button" aria-label="Tampilkan kata sandi" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-merah transition">${ICON.eye()}</button>`
                : ""
            }
          </div>`;
}

/** 6 kotak OTP. `filled` = array nilai awal (mock). */
function otpBoxes(filled = ["8", "1"]) {
  let cells = "";
  for (let i = 0; i < 6; i++) {
    const v = filled[i] ? ` value="${filled[i]}"` : "";
    const auto = i === 0 ? ' autocomplete="one-time-code"' : ' autocomplete="off"';
    cells += `<input class="${C.otpCell}" type="text" inputmode="numeric" maxlength="1" aria-label="Digit ${i + 1}"${auto}${v} />\n            `;
  }
  return `<div class="flex gap-2 justify-center mb-4">
            ${cells.trim()}
          </div>`;
}

/** Kotak pesan (alert). */
function alert(type, msg) {
  const map = {
    error: {
      cls: "bg-rose-50 dark:bg-rose-500/15 border-rose-200 dark:border-rose-500/30 text-rose-700 dark:text-rose-300",
      icon: ICON.alertCircle(16),
    },
    warning: {
      cls: "bg-amber-50 dark:bg-amber-500/15 border-amber-200 dark:border-amber-500/30 text-amber-700 dark:text-amber-300",
      icon: ICON.alertTriangle(16),
    },
    success: {
      cls: "bg-emerald-50 dark:bg-emerald-500/15 border-emerald-200 dark:border-emerald-500/30 text-emerald-700 dark:text-emerald-300",
      icon: ICON.checkCircle(16),
    },
    info: {
      cls: "bg-sky-50 dark:bg-sky-500/15 border-sky-200 dark:border-sky-500/30 text-sky-700 dark:text-sky-300",
      icon: ICON.info(16),
    },
  };
  const a = map[type];
  return `<div class="flex items-start gap-2.5 rounded-xl border-[1.5px] p-3 mb-4 text-xs leading-relaxed ${a.cls}">
            <span class="shrink-0 mt-px">${a.icon}</span>
            <span>${msg}</span>
          </div>`;
}

/** Lingkaran ikon besar untuk halaman status (info/error/logout/expired). */
function ikonBulat(icon, tone = "merah") {
  const tones = {
    merah: "bg-rose-50 dark:bg-rose-500/15 text-merah",
    biru: "bg-blue-50 dark:bg-blue-500/15 text-blue-600 dark:text-blue-400",
    amber: "bg-amber-50 dark:bg-amber-500/15 text-amber-600 dark:text-amber-400",
    hijau: "bg-emerald-50 dark:bg-emerald-500/15 text-emerald-600 dark:text-emerald-400",
    slate: "bg-slate-100 dark:bg-neutral-800 text-slate-500 dark:text-neutral-400",
  };
  return `<div class="w-[68px] h-[68px] rounded-full mx-auto mb-3.5 grid place-items-center ${tones[tone]}">${icon}</div>`;
}

/** Baris pilihan (radio kredensial / metode autentikasi). */
function pilihanRadio(name, icon, judul, deskripsi, checked = false) {
  return `<label class="${C.pilihan} mb-2.5">
            <input type="radio" name="${name}" class="w-[15px] h-[15px] accent-merah shrink-0"${checked ? " checked" : ""} />
            <span class="shrink-0 grid place-items-center w-10 h-10 rounded-xl bg-rose-50 dark:bg-rose-500/15 text-merah">${icon}</span>
            <span class="flex-1 min-w-0">
              <span class="block text-sm font-semibold text-slate-800 dark:text-neutral-100">${judul}</span>
              <span class="block text-[11px] text-slate-400 dark:text-neutral-500">${deskripsi}</span>
            </span>
          </label>`;
}

/** Baris pilihan berbentuk tombol (select-authenticator). */
function pilihanTombol(icon, judul, deskripsi) {
  return `<button type="button" class="${C.pilihan} mb-2.5">
            <span class="shrink-0 grid place-items-center w-10 h-10 rounded-xl bg-rose-50 dark:bg-rose-500/15 text-merah">${icon}</span>
            <span class="flex-1 min-w-0">
              <span class="block text-sm font-semibold text-slate-800 dark:text-neutral-100">${judul}</span>
              <span class="block text-[11px] text-slate-400 dark:text-neutral-500">${deskripsi}</span>
            </span>
            <span class="shrink-0 text-slate-300 dark:text-neutral-600">${ICON.chevronRight()}</span>
          </button>`;
}

/** Tautan bantuan RAKACA di bawah kartu. */
const tautanBantuan = `<p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5 leading-relaxed">
            Kesulitan masuk? <a href="#" class="inline-flex items-center gap-1.5 bg-merah text-white px-2.5 py-1 rounded-full font-semibold no-underline hover:brightness-110">${ICON.messageCircle(12)} Bantuan RAKACA</a>
          </p>`;

// =============================================================================
// CHROME — kartu lengkap (hero + body + umbul)
// =============================================================================

// =============================================================================
// KEMBANG API hero (varian C3) — 4 letupan + 2 roket naik, murni CSS.
// Dibangkitkan lewat helper agar markup-nya konsisten di 18 halaman dan mudah
// disetel dari satu tempat. Padanan CSS-nya ada di login/resources/css/input.css.
// =============================================================================

/**
 * Satu letupan kembang api.
 * @param {string} posisi  gaya posisi absolut, mis. "left:-28px;bottom:-24px"
 * @param {object} o
 *   @param {number} o.mulai   detik ke berapa letupan terjadi dalam 1 siklus
 *   @param {number} o.arah    banyak percikan (dibagi rata 360°)
 *   @param {number} o.jauh    jarak lontar percikan (px, negatif = ke luar)
 *   @param {number} [o.panjang]  panjang garis percikan (px)
 *   @param {number} [o.pecahan]  banyak titik pecahan melayang
 *   @param {boolean} [o.kilau]   tampilkan kilau di titik pusat
 */
function letupan(posisi, { mulai, arah, jauh, panjang, pecahan = 0, kilau = false }) {
  const bagian = [];
  if (kilau) bagian.push(`<u style="animation-delay:${mulai}s"></u>`);

  const langkah = 360 / arah;
  for (let i = 0; i < arah; i++) {
    const sudut = Math.round(i * langkah);
    const tunda = (mulai + i * 0.03).toFixed(2);
    const h = panjang ? `--h:${panjang}px;` : "";
    bagian.push(`<i style="--r:${sudut}deg;${h}animation-delay:${tunda}s"></i>`);
  }

  const langkahPecah = 360 / (pecahan || 1);
  for (let i = 0; i < pecahan; i++) {
    const sudut = Math.round(i * langkahPecah + langkahPecah / 2);
    const tunda = (mulai + 0.1 + i * 0.06).toFixed(2);
    bagian.push(`<b style="--r:${sudut}deg;animation-delay:${tunda}s"></b>`);
  }

  return `        <div class="letup" style="${posisi};--jauh:-${Math.abs(jauh)}px">
          ${bagian.join("\n          ")}
        </div>`;
}

/**
 * Roket yang naik sebelum letupan menyusul di ujungnya.
 * @param {string} posisi  mis. "left:18%"
 * @param {number} tinggi  ketinggian naik (px)
 * @param {number} mulai   detik mulai dalam siklus
 */
function roket(posisi, tinggi, mulai) {
  return `        <div class="roket" style="${posisi};--tinggi:-${Math.abs(tinggi)}px;animation-delay:${mulai}s"></div>`;
}

/**
 * Rangkaian kembang api varian C3, dipakai di semua halaman.
 * Dua roket naik lalu meletup di ujungnya (jeda 1,15 dtk = saat roket sampai
 * puncak), ditambah dua letupan sudut sebagai pelengkap. Siklus 3,8 detik.
 */
function kembangApi() {
  return [
    // roket kiri → letupan besar di puncaknya
    roket("left:18%", 64, 0),
    letupan("left:calc(18% - 50px);top:14px", {
      mulai: 1.15, arah: 12, jauh: 42, pecahan: 4, kilau: true,
    }),
    // roket kanan → letupan sedang
    roket("right:22%", 56, 1.7),
    letupan("right:calc(22% - 50px);top:26px", {
      mulai: 2.85, arah: 10, jauh: 34, pecahan: 2, kilau: true,
    }),
    // dua letupan sudut, lebih kecil, mengisi ruang kosong
    letupan("left:-28px;bottom:-24px", { mulai: 0.6, arah: 7, jauh: 30, panjang: 20 }),
    letupan("right:-26px;top:-26px", { mulai: 2.2, arah: 7, jauh: 28, panjang: 18 }),
  ].join("\n");
}

/**
 * @param {string} bodyHtml   isi kartu (setelah hero)
 * @param {object} opts       { lencana: boolean }  lencana "Dirgahayu RI ke-81"
 *                            HANYA dipakai di halaman login.
 */
function chrome(bodyHtml, { lencana = false } = {}) {
  const badge = lencana
    ? `\n          <span class="relative z-10 inline-flex items-center gap-1.5 mt-2.5 px-3 py-0.5 text-[10.5px] font-semibold bg-white/[.16] rounded-full backdrop-blur">${benderaSvg(14, 10)} Dirgahayu RI ke-81</span>`
    : "";
  return `    <div class="${C.card}">

      <!-- hero -->
      <div class="${C.hero}">
${kembangApi()}
        <span class="relative z-10 inline-block bg-white rounded-2xl px-3 py-2 shadow-lg">
          <img src="${RES}/img/hut-ri-81.png" alt="HUT RI ke-81" class="h-14 w-auto block" />
        </span>
        <h1 class="relative z-10 mt-3 mb-0.5 text-[17px] font-extrabold">Kisara SSO</h1>
        <p class="relative z-10 text-[11px] text-white/85">Kabupaten Ponorogo</p>${badge}
      </div>

      <!-- body -->
      <div class="${C.body}">
${bodyHtml}
      </div>

      <div class="umbul"></div>
    </div>`;
}

// =============================================================================
// PAGE — dokumen HTML lengkap
// =============================================================================
function page(judulTab, bodyHtml, opts = {}) {
  return `<!DOCTYPE html>
<!--
  PREVIEW STATIS — theme agustusan-2026 · HUT RI ke-81 · Kisara SSO
  Dibuat otomatis oleh preview/build-preview.js. Jangan diedit manual.
  Dark mode AUTO ikut sistem (darkMode:'media') — tidak ada tombol toggle.
-->
<html lang="id" class="h-full">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${judulTab} — preview agustusan-2026</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    darkMode: 'media',
    theme: { extend: { colors: { merah: { DEFAULT:'#c8102e', tua:'#9e0b23', muda:'#e5405a' } } } }
  };
</script>
<style>
  /* Komponen yg tak praktis jadi utility (sama dgn input.css theme) */
  .hero-pattern::before{content:"";position:absolute;inset:0;background-image:radial-gradient(rgba(255,255,255,.10) 1.5px,transparent 1.5px);background-size:18px 18px;opacity:.45}

  /* --- Kembang api hero (varian C3): murni CSS, tanpa JavaScript ---
     opacity:0 + fill-mode "backwards" WAJIB di tiap elemen ber-animation-delay.
     Tanpa itu, selama masa tunggu delay elemen memakai gaya dasarnya (tampak
     penuh & DIAM) — gejalanya "roket beku menggantung" saat fresh reload. */
  .letup{position:absolute;width:100px;height:100px;pointer-events:none}
  .letup i{position:absolute;left:50%;top:50%;width:var(--w,1.5px);height:var(--h,26px);background:linear-gradient(to top,rgba(255,255,255,0),rgba(255,255,255,.95));transform-origin:bottom center;border-radius:2px;opacity:0;animation:letup var(--dur,3.8s) ease-out infinite backwards}
  @keyframes letup{0%{transform:rotate(var(--r)) translateY(0) scaleY(.15);opacity:0}12%{opacity:1}38%{opacity:.95}72%,100%{transform:rotate(var(--r)) translateY(var(--jauh,-36px)) scaleY(1);opacity:0}}
  .letup b{position:absolute;left:50%;top:50%;width:3px;height:3px;border-radius:50%;background:#fff;transform-origin:center;opacity:0;animation:pecah var(--dur,3.8s) ease-out infinite backwards}
  @keyframes pecah{0%{transform:rotate(var(--r)) translateY(0) scale(.4);opacity:0}18%{opacity:1}60%{opacity:.85}100%{transform:rotate(var(--r)) translateY(calc(var(--jauh,-36px) * 1.35)) translateX(2px) scale(.5);opacity:0}}
  .letup u{position:absolute;left:50%;top:50%;width:8px;height:8px;margin:-4px 0 0 -4px;border-radius:50%;background:radial-gradient(circle,#fff 0%,rgba(255,255,255,0) 70%);opacity:0;animation:kilau var(--dur,3.8s) ease-out infinite backwards}
  @keyframes kilau{0%{transform:scale(0);opacity:0}10%{transform:scale(3.2);opacity:.9}30%,100%{transform:scale(5);opacity:0}}
  .roket{position:absolute;bottom:-6px;width:1.5px;height:22px;border-radius:2px;background:linear-gradient(to top,rgba(255,255,255,0),rgba(255,255,255,.85));opacity:0;animation:naik var(--dur,3.8s) ease-in infinite backwards}
  @keyframes naik{0%{transform:translateY(0) scaleY(.4);opacity:0}8%{opacity:.9}30%{transform:translateY(var(--tinggi,-70px)) scaleY(1);opacity:.9}34%,100%{transform:translateY(var(--tinggi,-70px)) scaleY(0);opacity:0}}
  @media (prefers-reduced-motion: reduce){.letup i,.letup b,.letup u{animation:none;opacity:.3}.roket{animation:none;opacity:0}}

  .umbul{height:12px;background:repeating-linear-gradient(-45deg,#c8102e 0 12px,#fff 12px 24px)}
  .bendera-mini{display:inline-block;width:16px;height:11px;border-radius:2px;background:linear-gradient(180deg,#c8102e 50%,#fff 50%);box-shadow:0 0 0 1px rgb(226 232 240)}
  .field-ikon{position:absolute;left:14px;top:50%;transform:translateY(-50%);color:rgb(148 163 184);pointer-events:none;transition:color .2s}
  .field-wrap:focus-within .field-ikon{color:#c8102e}
  .btn-sapu{position:relative;overflow:hidden}
  .btn-sapu::after{content:"";position:absolute;top:0;left:0;width:35%;height:100%;background:linear-gradient(90deg,transparent,rgba(255,255,255,.5),transparent);animation:sapu 3.4s ease-in-out infinite}
  @keyframes sapu{0%{transform:translateX(-130%) skewX(-18deg)}55%,100%{transform:translateX(280%) skewX(-18deg)}}
</style>
</head>
<body class="min-h-screen bg-gradient-to-b from-rose-50 to-slate-50 dark:from-[#1a0508] dark:to-neutral-950 text-slate-800 dark:text-neutral-100 flex items-center justify-center py-8 px-4">
${chrome(bodyHtml, opts)}
</body>
</html>`;
}

// =============================================================================
// DEFINISI TIAP HALAMAN
// =============================================================================

// Mock kode pemulihan (deterministik supaya build stabil)
const kodePemulihan = Array.from({ length: 12 }, (_, i) => {
  const a = (0x1a2b + i * 0x2f3d).toString(16).slice(-4);
  const b = (0x7c4e + i * 0x51a7).toString(16).slice(-4);
  return `${a}-${b}`;
});

const pages = {
  // ---------------------------------------------------------------- 1. LOGIN
  login: page(
    "Masuk",
    `        <div class="flex items-center gap-2 ${C.judul}">Masuk ke Akun Anda <span class="bendera-mini"></span></div>
        <p class="${C.sub} mt-0.5 mb-4">Gunakan akun <b>SIMASHEBAT</b> Anda</p>

        ${alert("warning", "NIP atau Kata Sandi salah. Silakan periksa kembali.")}

        ${field("Nomor Induk Pegawai (NIP)", { placeholder: "Masukkan NIP Anda", icon: ICON.contact() })}

        ${field("Kata Sandi", { type: "password", placeholder: "Masukkan kata sandi", icon: ICON.lock(), toggle: true })}

        <div class="flex items-center justify-between mb-4">
          <label class="inline-flex items-center gap-2 text-xs text-slate-500 dark:text-neutral-400 cursor-pointer">
            <input type="checkbox" class="w-[15px] h-[15px] accent-merah" /> Ingat saya
          </label>
          <a href="login-reset-password.html" class="text-xs font-medium text-slate-400 hover:text-merah transition">Lupa Kata Sandi?</a>
        </div>

        <!-- AKSI: tombol Masuk + tombol Passkey (ikon saja) -->
        <div class="flex items-stretch gap-2.5">
          ${btnPrimary("Masuk", { flex1: true })}
          <a href="#" title="Masuk dengan Passkey" aria-label="Masuk dengan Passkey"
            class="shrink-0 w-[52px] inline-flex items-center justify-center rounded-[13px] text-white bg-gradient-to-r from-merah-tua via-merah to-merah-muda shadow-lg shadow-merah/30 hover:-translate-y-0.5 hover:brightness-105 active:translate-y-0 transition">
            ${ICON.fingerprint(22)}
          </a>
        </div>

        ${tautanBantuan}
        <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-2 leading-relaxed">
          NIP dan Kata Sandi menggunakan yang terdaftar di SIMASHEBAT.
        </p>`,
    { lencana: true }
  ),

  // ------------------------------------------------------------- 2. LOGIN OTP
  "login-otp": page(
    "Verifikasi OTP",
    `        <div class="${C.judul} text-center">Masukkan Kode OTP</div>
        <p class="${C.sub} text-center mt-1 mb-4">6 digit dari aplikasi authenticator Anda</p>

        ${otpBoxes(["8", "1"])}

        ${btnPrimary("Verifikasi &amp; Masuk")}

        <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-4">
          Kode tidak masuk? <a href="#" class="text-merah font-semibold hover:underline">Kirim ulang</a>
        </p>`
  ),

  // ------------------------------------------------------- 3. LOGIN OTP ERROR
  "login-otp-error": page(
    "Verifikasi OTP",
    `        <div class="${C.judul} text-center">Masukkan Kode OTP</div>
        <p class="${C.sub} text-center mt-1 mb-4">6 digit dari aplikasi authenticator Anda</p>

        ${alert("error", "Kode OTP tidak valid. Silakan coba lagi.")}

        ${otpBoxes(["9", "0", "3", "1", "7", "4"])}

        <p class="text-[11px] font-semibold text-rose-600 dark:text-rose-400 text-center -mt-2 mb-4">Kode OTP tidak valid</p>

        ${btnPrimary("Verifikasi &amp; Masuk")}
        ${btnSecondary("Gunakan Metode Lain", { extraClass: "mt-2.5" })}`
  ),

  // ------------------------------------------------------- 4. LOGIN OTP MULTI
  "login-otp-multi": page(
    "Verifikasi OTP",
    `        <div class="${C.judul} text-center">Pilih Perangkat OTP</div>
        <p class="${C.sub} text-center mt-1 mb-4">Pilih perangkat, lalu masukkan kode 6 digit</p>

        ${pilihanRadio("cred", ICON.smartphone(20), "HP Kantor", "Aplikasi authenticator perangkat dinas", true)}
        ${pilihanRadio("cred", ICON.smartphone(20), "HP Pribadi", "Aplikasi authenticator perangkat pribadi")}

        <div class="h-1"></div>
        ${otpBoxes(["8", "1"])}

        ${btnPrimary("Verifikasi &amp; Masuk")}`
  ),

  // -------------------------------------------------- 5. LOGIN RESET PASSWORD
  "login-reset-password": page(
    "Lupa Kata Sandi",
    `        <div class="${C.judul} text-center">Lupa Kata Sandi</div>
        <p class="${C.sub} text-center mt-1 mb-4">Kami akan mengirim petunjuk pengaturan ulang kata sandi</p>

        ${alert("info", "Masukkan NIP atau alamat email Anda. Petunjuk cara mengatur ulang kata sandi akan dikirim ke email yang terdaftar.")}

        ${field("NIP atau Email", { placeholder: "Masukkan NIP atau email Anda", icon: ICON.contact() })}

        ${btnPrimary("Kirim Petunjuk")}

        <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5">
          <a href="login.html" class="inline-flex items-center gap-1.5 hover:text-merah transition">${ICON.arrowLeft(13, 2.2)} Kembali ke halaman masuk</a>
        </p>`
  ),

  // ------------------------------------------------------- 6. LOGIN RESET OTP
  "login-reset-otp": page(
    "Atur Ulang OTP",
    `        <div class="${C.judul} text-center">Atur Ulang Perangkat OTP</div>
        <p class="${C.sub} text-center mt-1 mb-4">Pilih perangkat OTP yang akan dihapus dan didaftarkan ulang</p>

        ${alert("warning", "Perangkat yang dihapus tidak dapat dipakai lagi untuk verifikasi sampai Anda mendaftarkannya kembali.")}

        ${pilihanRadio("otpdev", ICON.smartphone(20), "OTP Google Authenticator", "Terdaftar 12 Agustus 2026", true)}
        ${pilihanRadio("otpdev", ICON.key(20), "Kode Pemulihan", "10 dari 12 kode masih tersedia")}

        <div class="h-1.5"></div>
        ${btnPrimary("Kirim")}
        ${btnSecondary("Batal", { extraClass: "mt-2.5" })}`
  ),

  // -------------------------------------------------- 7. LOGIN UPDATE PASSWORD
  "login-update-password": page(
    "Perbarui Kata Sandi",
    `        <div class="${C.judul} text-center">Perbarui Kata Sandi</div>
        <p class="${C.sub} text-center mt-1 mb-4">Buat kata sandi baru untuk akun Kisara SSO Anda</p>

        ${field("Kata Sandi Baru", { type: "password", placeholder: "Minimal 8 karakter", icon: ICON.lock(), toggle: true })}

        ${field("Konfirmasi Kata Sandi", { type: "password", placeholder: "Ulangi kata sandi baru", icon: ICON.shield(), toggle: true })}

        <label class="inline-flex items-center gap-2 text-xs text-slate-500 dark:text-neutral-400 cursor-pointer mb-4">
          <input type="checkbox" class="w-[15px] h-[15px] accent-merah" checked /> Keluarkan sesi di perangkat lain
        </label>

        ${btnPrimary("Simpan Kata Sandi")}`
  ),

  // ----------------------------------------------------- 8. LOGIN CONFIG TOTP
  "login-config-totp": page(
    "Aktivasi OTP",
    `        <div class="${C.judul} text-center">Aktifkan Verifikasi Dua Langkah</div>
        <p class="${C.sub} text-center mt-1 mb-4">Pindai kode QR dengan aplikasi authenticator</p>

        <div class="w-[150px] h-[150px] mx-auto mb-4 rounded-2xl border-2 border-dashed border-slate-200 dark:border-neutral-700 grid place-items-center gap-1 bg-slate-50 dark:bg-neutral-950 text-slate-300 dark:text-neutral-600">
          ${ICON.qrCode(44, 1.6)}
          <span class="text-[11px] font-semibold">Kode QR</span>
        </div>

        <div class="rounded-xl bg-slate-50 dark:bg-neutral-950 border-[1.5px] border-slate-200 dark:border-neutral-700 p-3 mb-4 text-center">
          <p class="text-[11px] text-slate-400 dark:text-neutral-500 mb-1">Atau masukkan kunci ini secara manual</p>
          <code class="text-sm font-bold tracking-wider text-slate-800 dark:text-neutral-100 break-all">JBSWY3DPEHPK3PXP</code>
        </div>

        ${field("Kode Verifikasi", { placeholder: "Masukkan 6 digit kode", icon: ICON.shield() })}

        ${field("Nama Perangkat", { value: "OTP Google Authenticator", placeholder: "Misal: HP Kantor / HP Pribadi", icon: ICON.smartphone() })}

        ${btnPrimary("Simpan &amp; Aktifkan")}
        ${btnSecondary("Batal", { extraClass: "mt-2.5" })}

        ${tautanBantuan}`
  ),

  // -------------------------------------- 9. RECOVERY AUTHN CODE — KONFIGURASI
  "login-recovery-authn-code-config": page(
    "Kode Pemulihan",
    `        <div class="${C.judul} text-center">Kode Pemulihan</div>
        <p class="${C.sub} text-center mt-1 mb-4">Simpan di tempat aman — tiap kode hanya bisa dipakai satu kali</p>

        ${alert("warning", "Kode ini hanya ditampilkan sekali. Salin atau unduh sebelum melanjutkan.")}

        <div class="grid grid-cols-2 gap-2 mb-4 rounded-xl bg-slate-50 dark:bg-neutral-950 border-[1.5px] border-slate-200 dark:border-neutral-700 p-3">
          ${kodePemulihan
            .map(
              (k, i) =>
                `<div class="font-mono text-[12.5px] text-slate-700 dark:text-neutral-200"><span class="text-slate-300 dark:text-neutral-600">${String(i + 1).padStart(2, "0")}</span> ${k}</div>`
            )
            .join("\n          ")}
        </div>

        <div class="flex gap-2.5 mb-4">
          <button type="button" class="${C.btnSecondary} inline-flex items-center justify-center gap-2">${ICON.copy(15)} Salin</button>
          <button type="button" class="${C.btnSecondary} inline-flex items-center justify-center gap-2">${ICON.download(15)} Unduh</button>
        </div>

        <label class="inline-flex items-center gap-2 text-xs text-slate-500 dark:text-neutral-400 cursor-pointer mb-4">
          <input type="checkbox" class="w-[15px] h-[15px] accent-merah" /> Saya sudah menyimpan kode pemulihan
        </label>

        ${btnPrimary("Kirim")}`
  ),

  // -------------------------------------------- 10. RECOVERY AUTHN CODE — INPUT
  "login-recovery-authn-code-input": page(
    "Masukkan Kode Pemulihan",
    `        <div class="${C.judul} text-center">Masukkan Kode Pemulihan</div>
        <p class="${C.sub} text-center mt-1 mb-4">Gunakan kode nomor <b class="text-merah">3</b> dari daftar kode pemulihan Anda</p>

        ${field("Kode Pemulihan #3", { placeholder: "xxxx-xxxx", icon: ICON.key() })}

        ${btnPrimary("Masuk")}
        ${btnSecondary("Gunakan Metode Lain", { extraClass: "mt-2.5" })}`
  ),

  // -------------------------------------------------- 11. SELECT AUTHENTICATOR
  "select-authenticator": page(
    "Pilih Metode Masuk",
    `        <div class="${C.judul} text-center">Pilih Metode Masuk</div>
        <p class="${C.sub} text-center mt-1 mb-4">Pilih cara verifikasi identitas Anda</p>

        ${pilihanTombol(ICON.smartphone(20), "Aplikasi Authenticator", "Masukkan kode 6 digit dari aplikasi OTP")}
        ${pilihanTombol(ICON.fingerprint(20, 2), "Passkey", "Masuk dengan sidik jari atau PIN perangkat")}
        ${pilihanTombol(ICON.listChecks(20), "Kode Pemulihan", "Gunakan salah satu kode pemulihan Anda")}

        <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5">
          <a href="login.html" class="inline-flex items-center gap-1.5 hover:text-merah transition">${ICON.arrowLeft(13, 2.2)} Kembali ke halaman masuk</a>
        </p>`
  ),

  // ---------------------------------------------------- 12. LOGIN UPDATE PROFILE
  "login-update-profile": page(
    "Perbarui Informasi Akun",
    `        <div class="${C.judul} text-center">Perbarui Informasi Akun</div>
        <p class="${C.sub} text-center mt-1 mb-4">Lengkapi data berikut sebelum melanjutkan. Tanda <span class="text-merah font-bold">*</span> wajib diisi.</p>

        ${field("Email <span class=\"text-merah\">*</span>", { type: "email", value: "pegawai@ponorogo.go.id", placeholder: "nama@ponorogo.go.id", icon: ICON.mail() })}

        ${field("Nama Depan <span class=\"text-merah\">*</span>", { value: "Budi", placeholder: "Nama depan", icon: ICON.user() })}

        ${field("Nama Belakang <span class=\"text-merah\">*</span>", { value: "Santoso", placeholder: "Nama belakang", icon: ICON.user() })}

        ${btnPrimary("Simpan &amp; Lanjutkan")}`
  ),

  // ------------------------------------------------------ 13. LOGIN VERIFY EMAIL
  "login-verify-email": page(
    "Verifikasi Email",
    `        ${ikonBulat(ICON.mail(32), "biru")}
        <div class="${C.judul} text-center">Verifikasi Email Anda</div>
        <p class="${C.sub} text-center mt-1.5 mb-4">
          Tautan verifikasi telah dikirim ke <b class="text-slate-700 dark:text-neutral-200">pegawai@ponorogo.go.id</b>.
          Buka email tersebut lalu klik tautan yang tersedia untuk melanjutkan.
        </p>

        ${alert("info", "Periksa juga folder Spam atau Promosi bila email belum terlihat dalam beberapa menit.")}

        <button type="button" class="${C.btnSecondary} inline-flex items-center justify-center gap-2">${ICON.refreshCw(15)} Kirim Ulang Email Verifikasi</button>

        <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5">
          <a href="login.html" class="inline-flex items-center gap-1.5 hover:text-merah transition">${ICON.arrowLeft(13, 2.2)} Kembali ke halaman masuk</a>
        </p>`
  ),

  // ------------------------------------------------------------------ 14. TERMS
  terms: page(
    "Syarat dan Ketentuan",
    `        ${ikonBulat(ICON.fileText(30), "slate")}
        <div class="${C.judul} text-center">Syarat dan Ketentuan</div>
        <p class="${C.sub} text-center mt-1.5 mb-4">Baca dan setujui sebelum menggunakan layanan Kisara SSO</p>

        <div class="max-h-48 overflow-y-auto rounded-xl bg-slate-50 dark:bg-neutral-950 border-[1.5px] border-slate-200 dark:border-neutral-700 p-3.5 mb-4 text-[12.5px] leading-relaxed text-slate-600 dark:text-neutral-300 space-y-2.5">
          <p>Layanan Kisara SSO dikelola oleh Dinas Komunikasi, Informatika dan Statistik Kabupaten Ponorogo sebagai gerbang tunggal autentikasi aplikasi pemerintah daerah.</p>
          <p>Akun bersifat pribadi dan tidak boleh dipinjamkan kepada pihak lain. Seluruh aktivitas yang tercatat pada akun Anda menjadi tanggung jawab pemilik akun.</p>
          <p>Kata sandi wajib dijaga kerahasiaannya. Segera lakukan penggantian kata sandi apabila Anda menduga akun telah diakses pihak yang tidak berwenang.</p>
          <p>Data pribadi yang dikumpulkan hanya digunakan untuk keperluan autentikasi dan layanan pemerintahan sesuai peraturan perundang-undangan yang berlaku.</p>
          <p>Dengan menekan tombol Setuju, Anda menyatakan telah membaca, memahami, dan menerima seluruh ketentuan di atas.</p>
        </div>

        ${btnPrimary("Setuju &amp; Lanjutkan")}
        ${btnSecondary("Tolak", { extraClass: "mt-2.5" })}`
  ),

  // ------------------------------------------------------- 15. LOGIN PAGE EXPIRED
  "login-page-expired": page(
    "Halaman Kedaluwarsa",
    `        ${ikonBulat(ICON.clock(32), "amber")}
        <div class="${C.judul} text-center">Halaman Kedaluwarsa</div>
        <p class="${C.sub} text-center mt-1.5 mb-4">
          Sesi masuk Anda sudah terlalu lama menganggur sehingga halaman ini tidak berlaku lagi.
          Silakan mulai ulang atau lanjutkan proses masuk.
        </p>

        ${btnPrimary("Mulai Ulang Proses Masuk", { icon: ICON.refreshCw(16, 2.4) })}
        ${btnSecondary("Lanjutkan Proses Masuk", { extraClass: "mt-2.5" })}`
  ),

  // ---------------------------------------------------------- 16. LOGOUT CONFIRM
  "logout-confirm": page(
    "Konfirmasi Keluar",
    `        ${ikonBulat(ICON.logOut(30), "amber")}
        <div class="${C.judul} text-center">Keluar dari Kisara SSO?</div>
        <p class="${C.sub} text-center mt-1.5 mb-4">Anda akan keluar dari seluruh aplikasi yang terhubung dengan akun ini.</p>

        ${btnPrimary("Ya, Keluar", { icon: ICON.logOut(16, 2.4) })}
        ${btnSecondary("Batal", { extraClass: "mt-2.5" })}`
  ),

  // ------------------------------------------------------------------- 17. INFO
  info: page(
    "Informasi",
    `        ${ikonBulat(ICON.checkCircle(32), "biru")}
        <div class="${C.judul} text-center">Email Terverifikasi</div>
        <p class="${C.sub} text-center mt-1.5 mb-4">Alamat email Anda berhasil diverifikasi. Silakan lanjutkan masuk ke aplikasi.</p>

        ${btnPrimary("Lanjutkan")}

        <p class="text-[11px] text-slate-400 dark:text-neutral-500 text-center mt-3.5">
          <a href="#" class="inline-flex items-center gap-1.5 hover:text-merah transition">${ICON.arrowLeft(13, 2.2)} Kembali ke aplikasi</a>
        </p>`
  ),

  // ------------------------------------------------------------------ 18. ERROR
  error: page(
    "Terjadi Kesalahan",
    `        ${ikonBulat(ICON.alertTriangle(32), "merah")}
        <div class="${C.judul} text-center">Terjadi Kesalahan</div>
        <p class="${C.sub} text-center mt-1.5 mb-4">
          Sesi Anda telah berakhir atau tautan tidak berlaku. Silakan masuk kembali,
          atau hubungi administrator apabila masalah terus berlanjut.
        </p>

        ${btnPrimary("Coba Lagi", { icon: ICON.refreshCw(16, 2.4) })}
        ${btnSecondary("Kembali ke Portal ASN Ponorogo", { extraClass: "mt-2.5" })}

        ${tautanBantuan}`
  ),
};

// =============================================================================
// TULIS FILE + INDEX
// =============================================================================
const judulHalaman = {
  login: "Masuk (dengan tombol Passkey)",
  "login-otp": "Verifikasi OTP",
  "login-otp-error": "Verifikasi OTP — kode salah",
  "login-otp-multi": "Verifikasi OTP — banyak perangkat",
  "login-reset-password": "Lupa Kata Sandi",
  "login-reset-otp": "Atur Ulang Perangkat OTP",
  "login-update-password": "Perbarui Kata Sandi",
  "login-config-totp": "Aktivasi OTP (QR)",
  "login-recovery-authn-code-config": "Kode Pemulihan — tampil",
  "login-recovery-authn-code-input": "Kode Pemulihan — input",
  "select-authenticator": "Pilih Metode Masuk",
  "login-update-profile": "Perbarui Informasi Akun",
  "login-verify-email": "Verifikasi Email",
  terms: "Syarat dan Ketentuan",
  "login-page-expired": "Halaman Kedaluwarsa",
  "logout-confirm": "Konfirmasi Keluar",
  info: "Informasi",
  error: "Terjadi Kesalahan",
};

let count = 0;
for (const [name, html] of Object.entries(pages)) {
  fs.writeFileSync(path.join(DIR, name + ".html"), html, "utf8");
  count++;
}

const index = `<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Preview Theme Keycloak — agustusan-2026 (Kisara SSO)</title>
<style>
  :root { color-scheme: light dark; }
  body{font-family:system-ui,-apple-system,"Segoe UI",sans-serif;max-width:780px;margin:0 auto;padding:2.5rem 1.25rem 4rem;line-height:1.65;background:#fff7f8;color:#1e293b}
  h1{color:#9e0b23;font-size:1.6rem;margin:0 0 .35rem;display:flex;align-items:center;gap:.6rem}
  h2{font-size:.8rem;text-transform:uppercase;letter-spacing:.08em;color:#94a3b8;margin:2rem 0 .6rem}
  p{margin:.4rem 0}
  .sub{color:#64748b;font-size:.92rem}
  .umbul{height:10px;background:repeating-linear-gradient(-45deg,#c8102e 0 12px,#fff 12px 24px);border-radius:6px;margin:1.25rem 0 1.75rem}
  ul{list-style:none;padding:0;margin:0;display:grid;gap:.5rem;grid-template-columns:repeat(auto-fill,minmax(250px,1fr))}
  li a{display:block;padding:.7rem .9rem;border-radius:.7rem;background:#fff;border:1.5px solid #f1f5f9;color:#0f172a;text-decoration:none;transition:.15s}
  li a:hover{border-color:#c8102e;color:#c8102e;transform:translateY(-1px)}
  li a small{display:block;color:#94a3b8;font-size:.74rem;font-family:ui-monospace,Menlo,Consolas,monospace;margin-top:.15rem}
  .catatan{margin-top:2rem;padding:.9rem 1rem;border-radius:.7rem;background:#fff;border:1.5px solid #f1f5f9;font-size:.85rem;color:#475569}
  code{background:#f1f5f9;padding:.1rem .35rem;border-radius:.25rem;font-size:.85em}
  @media (prefers-color-scheme: dark){
    body{background:#12060a;color:#e5e7eb}
    h1{color:#e5405a}
    .sub{color:#a1a1aa}
    li a{background:#171717;border-color:#262626;color:#f4f4f5}
    li a small{color:#71717a}
    .catatan{background:#171717;border-color:#262626;color:#a1a1aa}
    code{background:#262626}
  }
</style>
</head>
<body>
  <h1>
    <svg width="26" height="18" viewBox="0 0 20 14" aria-hidden="true"><rect width="20" height="7" fill="#c8102e"/><rect y="7" width="20" height="7" fill="#fff"/><rect width="20" height="14" fill="none" stroke="rgba(0,0,0,.15)" stroke-width="1"/></svg>
    Preview Theme — agustusan-2026
  </h1>
  <p class="sub">Kisara SSO &middot; Kabupaten Ponorogo &middot; HUT RI ke-81. Replika visual statis seluruh halaman login Keycloak.</p>
  <div class="umbul"></div>

  <h2>${count} Halaman</h2>
  <ul>
${Object.keys(pages)
  .map((n) => `    <li><a href="${n}.html">${judulHalaman[n] || n}<small>${n}.html</small></a></li>`)
  .join("\n")}
  </ul>

  <div class="catatan">
    <p><b>Mode gelap otomatis.</b> Tidak ada tombol pengubah tema di halaman preview &mdash;
    tampilan mengikuti preferensi sistem operasi Anda (<code>prefers-color-scheme</code> /
    Tailwind <code>darkMode: 'media'</code>). Ubah tema terang/gelap di pengaturan sistem
    untuk melihat mode gelap.</p>
    <p><b>Bukan render FreeMarker.</b> Halaman ini dihasilkan oleh
    <code>preview/build-preview.js</code> memakai Tailwind CDN dan data contoh, semata-mata
    untuk menilai desain tanpa perlu menjalankan Keycloak. Jalankan ulang dengan
    <code>node preview/build-preview.js</code> setiap kali generator diubah.</p>
  </div>
</body>
</html>`;
fs.writeFileSync(path.join(DIR, "index.html"), index, "utf8");

console.log(`Generated ${count} preview pages + index.html in ${DIR}`);
