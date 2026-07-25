const path = require("path");

/** @type {import('tailwindcss').Config} */
// Config khusus theme asn-v2. Memindai .ftl DAN theme.properties karena
// banyak utility class hidup di properties (kc*Class) yang di-render base form.
// Path di-anchor ke __dirname supaya build benar dari CWD mana pun (root repo,
// dir keycloak/, atau dir theme ini sendiri).
module.exports = {
  darkMode: "class",
  content: [
    path.join(__dirname, "login/**/*.ftl"),
    path.join(__dirname, "login/theme.properties"),
    path.join(__dirname, "preview/**/*.html"),
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
