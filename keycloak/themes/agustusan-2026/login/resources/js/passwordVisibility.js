// passwordVisibility.js — toggle show/hide password.
// Self-contained agar tidak bergantung resolusi resource parent theme.
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
