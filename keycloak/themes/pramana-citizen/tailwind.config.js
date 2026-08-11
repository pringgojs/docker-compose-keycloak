const path = require("path");

/** @type {import('tailwindcss').Config} */
// Config theme pramana-citizen — halaman masuk & daftar WARGA (realm
// ponorogo-citizen), TERPISAH dari asn-v2 yang melayani pegawai.
//
// ACUAN DESAIN: ponorogo-super-apps/mockup/src/screens/Login.jsx dan kawan-
// kawannya. Palet disalin dari mockup/src/index.css supaya nilainya persis
// sama — bukan diketik ulang dari tabel dokumen.
//
// Memindai .ftl, theme.properties (utility hidup di kc*Class), dan preview
// HTML. Path di-anchor ke __dirname supaya build benar dari CWD mana pun.
module.exports = {
  // TANPA dark mode. Mockup PRAMANA hanya punya mode terang, dan layar masuk
  // sudah berlatar marun gelap dengan sendirinya. Menambahkan varian dark:
  // berarti mengarang tampilan yang belum pernah dirancang.
  content: [
    path.join(__dirname, "login/**/*.ftl"),
    path.join(__dirname, "login/theme.properties"),
    path.join(__dirname, "preview/*.html"),
  ],
  theme: {
    extend: {
      colors: {
        // Palet PRAMANA — docs/teknis/12-design-system.md bagian 1.1 & 1.2.
        // Marun dari warna dasar dadak merak Reog, emas dari bulu meraknya.
        marun: {
          50: "#FDF3F3",
          100: "#FBE5E5",
          200: "#F7D0D0",
          300: "#F0AEAE",
          400: "#E57E7E",
          500: "#D65454",
          600: "#C23838",
          700: "#A32C2C", // tombol utama, teks penting
          800: "#872828",
          900: "#7A1F1F", // latar kepala layar
          950: "#420D0D",
        },
        emas: {
          100: "#FDF6C3",
          300: "#F9D947",
          400: "#F5C518", // aksen utama — dipakai HEMAT, satu titik per layar
          500: "#E5AB0B",
          600: "#C68407",
        },
      },
      fontFamily: {
        // Plus Jakarta Sans dipilih karena dirancang untuk Bahasa Indonesia
        // (12-design-system 2.1). Di-bundle lokal, bukan dari Google Fonts CDN:
        // halaman login harus tetap tampil utuh di jaringan lambat, dan tanpa
        // permintaan ke pihak ketiga.
        sans: ['"Plus Jakarta Sans"', "Inter", "system-ui", "sans-serif"],
      },
    },
  },
  plugins: [],
};
