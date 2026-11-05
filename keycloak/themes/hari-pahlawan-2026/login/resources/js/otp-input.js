/**
 * otp-input.js — segmented (kotak-kotak) OTP input.
 * -----------------------------------------------------------------------------
 * Kotak-kotak (.asn-otp-cell) sudah dirender STATIS di HTML/FTL, jadi tetap
 * terlihat & bisa diketik walau JS gagal load. Script ini hanya meng-ENHANCE:
 * - sinkron isi kotak ke real input (hidden, name="otp"/"totp") yang dikirim ke
 *   Keycloak,
 * - auto-advance, backspace, panah, dan paste 6 digit sekaligus.
 *
 * Markup yang diharapkan:
 *   <input type="hidden" id="otp" name="otp" />
 *   <div class="asn-otp" data-otp-target="otp" data-otp-autofocus>
 *     <input class="asn-otp-cell" ... /> x6
 *   </div>
 */
(function () {
  function initOtp(container) {
    var targetId = container.getAttribute("data-otp-target");
    var target = targetId ? document.getElementById(targetId) : null;
    if (!target) return;

    var cells = Array.prototype.slice.call(
      container.querySelectorAll(".asn-otp-cell")
    );
    if (!cells.length) return;

    function sync() {
      target.value = cells
        .map(function (c) {
          return c.value;
        })
        .join("");
    }

    function focusCell(idx) {
      if (idx >= 0 && idx < cells.length) cells[idx].focus();
    }

    cells.forEach(function (cell, idx) {
      cell.addEventListener("input", function (e) {
        var v = e.target.value.replace(/[^0-9]/g, "");
        e.target.value = v.slice(-1);
        sync();
        if (e.target.value && idx < cells.length - 1) focusCell(idx + 1);
      });

      cell.addEventListener("keydown", function (e) {
        if (e.key === "Backspace") {
          if (!cell.value && idx > 0) {
            focusCell(idx - 1);
            cells[idx - 1].value = "";
            sync();
            e.preventDefault();
          }
        } else if (e.key === "ArrowLeft") {
          focusCell(idx - 1);
          e.preventDefault();
        } else if (e.key === "ArrowRight") {
          focusCell(idx + 1);
          e.preventDefault();
        }
      });

      cell.addEventListener("paste", function (e) {
        e.preventDefault();
        var data = (e.clipboardData || window.clipboardData).getData("text") || "";
        var digits = data.replace(/[^0-9]/g, "").slice(0, cells.length);
        for (var j = 0; j < digits.length; j++) cells[j].value = digits[j];
        sync();
        focusCell(Math.min(digits.length, cells.length - 1));
      });

      cell.addEventListener("focus", function () {
        cell.select();
      });
    });

    // Re-fill kalau real input sudah ada nilainya (error re-render)
    if (target.value) {
      var pre = target.value.replace(/[^0-9]/g, "").slice(0, cells.length);
      for (var k = 0; k < pre.length; k++) cells[k].value = pre[k];
    }

    if (container.hasAttribute("data-otp-autofocus")) focusCell(0);
  }

  function initAll() {
    var nodes = document.querySelectorAll(".asn-otp");
    Array.prototype.forEach.call(nodes, initOtp);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initAll);
  } else {
    initAll();
  }
})();
