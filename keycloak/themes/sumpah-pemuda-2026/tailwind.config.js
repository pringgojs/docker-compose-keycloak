const path = require("path");

/** @type {import('tailwindcss').Config} */
// Config khusus theme sumpah-pemuda-2026 (event Hari Sumpah Pemuda ke-98).
// BEDA dari asn-v2: darkMode "media" — ikut preferensi SISTEM (auto),
// bukan class toggle. Memindai .ftl, theme.properties (utility class hidup di
// kc*Class), dan preview HTML. Path di-anchor ke __dirname supaya build benar
// dari CWD mana pun.
module.exports = {
  darkMode: "media",
  content: [
    path.join(__dirname, "login/**/*.ftl"),
    path.join(__dirname, "login/theme.properties"),
    path.join(__dirname, "*.html"),
  ],
  theme: {
    extend: {
      colors: {
        merah: {
          DEFAULT: "#b3121f",
          tua: "#7f0d16",
          muda: "#d63a45",
        },
        // Tinta cokelat tua di atas kertas hero
        tinta: "#3b2a1a",
      },
      // Font dimuat dari Google Fonts di template.ftl. Bila gagal dimuat,
      // jatuh ke monospace/serif bawaan dan halaman tetap terbaca.
      fontFamily: {
        ketik: ['"Special Elite"', "monospace"],
        judul: ['"Playfair Display"', "serif"],
      },
    },
  },
  plugins: [],
};
