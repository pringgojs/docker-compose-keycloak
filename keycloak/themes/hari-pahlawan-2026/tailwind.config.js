const path = require("path");

/** @type {import('tailwindcss').Config} */
// Config khusus theme hari-pahlawan-2026 (event Hari Pahlawan 10 November).
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
        // Nama token sama dengan sumpah-pemuda-2026 supaya .ftl per halaman
        // tidak perlu diubah; hanya nilainya yang lebih tua (merah darah).
        merah: {
          DEFAULT: "#a8101c",
          tua: "#6b0a12",
          muda: "#d33a40",
        },
        // Bintang "81" dan aksen kutipan di hero
        emas: {
          DEFAULT: "#d4a72c",
          muda: "#f0cf6a",
          tua: "#8a6a12",
        },
        // Siluet gedung di hero
        senja: "#1a0708",
      },
      // Font dimuat dari Google Fonts di template.ftl. Bila gagal dimuat,
      // jatuh ke sans-serif/serif bawaan dan halaman tetap terbaca.
      fontFamily: {
        poster: ["Oswald", "sans-serif"],
        kutip: ["Lora", "serif"],
      },
    },
  },
  plugins: [],
};
