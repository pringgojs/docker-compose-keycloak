// passwordVisibility.js — toggle show/hide password.
// Self-contained agar tidak bergantung resolusi resource parent theme.
//
// TANPA FONTAWESOME. Skrip ini tetap memakai kontrak yang sama seperti
// sebelumnya (menukar className elemen <i> dengan nilai atribut data-icon-show /
// data-icon-hide), hanya saja nilainya kini class mask milik theme ini —
// "ikon-mata" dan "ikon-mata-coret" (lihat theme.properties + input.css), yang
// menggambar SVG Lucide eye / eye-off lewat CSS mask-image. Karena mekanismenya
// identik, tidak ada perubahan logika yang diperlukan di sini.
document.querySelectorAll("[data-password-toggle]").forEach(function (button) {
  button.addEventListener("click", function () {
    var controls = button.getAttribute("aria-controls");
    var input = controls ? document.getElementById(controls) : null;
    if (!input) return;

    var icon = button.querySelector("i");
    var showIcon = button.getAttribute("data-icon-show");
    var hideIcon = button.getAttribute("data-icon-hide");
    var showLabel = button.getAttribute("data-label-show");
    var hideLabel = button.getAttribute("data-label-hide");

    var isHidden = input.type === "password";
    input.type = isHidden ? "text" : "password";

    if (icon && showIcon && hideIcon) {
      icon.className = isHidden ? hideIcon : showIcon;
    }
    button.setAttribute("aria-label", isHidden ? hideLabel : showLabel);
  });
});
