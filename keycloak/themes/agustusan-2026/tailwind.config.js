const path = require("path");

/** @type {import('tailwindcss').Config} */
// Config khusus theme agustusan-2026 (event HUT RI ke-81).
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
          DEFAULT: "#c8102e",
          tua: "#9e0b23",
          muda: "#e5405a",
        },
      },
    },
  },
  plugins: [],
};
