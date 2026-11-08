const path = require("path");

/** @type {import('tailwindcss').Config} */
// Theme "kisara" — login default ekosistem Kisara (sistem logo v1, 2026-11-08).
// Memindai .ftl, theme.properties (kc*Class hidup di sana) dan preview/*.html,
// supaya preview memakai CSS yang SAMA PERSIS dengan yang dideploy.
module.exports = {
  darkMode: "class",
  content: [
    path.join(__dirname, "login/**/*.ftl"),
    path.join(__dirname, "login/theme.properties"),
    path.join(__dirname, "preview/**/*.html"),
  ],
  theme: {
    extend: {
      colors: {
        // Empat warna merak Kisara (docs/brand/kisara-logo).
        ks: {
          blue: "#1f6fb2",
          teal: "#0f8b8d",
          green: "#2f9e6b",
          gold: "#e0a82e",
          accent: "#0f8b8d",
          "accent-dark": "#0b6d6f",
          "accent-soft": "#e7f5f4",
        },
      },
      fontFamily: {
        sans: ["Inter", "system-ui", "-apple-system", "Segoe UI", "sans-serif"],
      },
    },
  },
  plugins: [],
};
