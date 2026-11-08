# Keycloak 26.7.0 — line pertama dengan passkey "supported" (bukan preview).
# Upgrade dari 24.0.3. Perubahan penting saat naik dari 24:
#   - Base image → 26.7.0
#   - Authenticator SimasHebat jar 2.3.0 (Java 17): API BARU (v1/external) +
#     Jackson email-sync + passkey conditional UI + skip OTP. Lihat repo
#     custom-authenticator. (2.0.0 = API LAMA mati; 2.1.0 = tanpa passkey UI.)
#   - Keycloak 26 butuh JDK 17+ (image base sudah bawa; authenticator target 17).
#
# CATATAN opsi runtime yang berubah di v26 (di-set di docker-compose, bukan di
# sini): KC_PROXY dihapus/deprecated → pakai KC_PROXY_HEADERS. Hostname v2.
# 26.7.2 (28 Okt 2026): menambal CVE-2026-18963 (CVSS 9.1) — alur "Lupa
# password" dapat dilompati tanpa token email, sehingga siapa pun dapat
# mengganti password akun mana pun di realm yang mengaktifkan fitur itu
# (ponorogo-citizen). Juga CVE-2026-15571 (penautan akun lewat klien OIDC).
# 26.8.1 (4 Nov 2026): menambal CVE-2026-94000 — admin yang hanya memegang
# manage-users dapat menjadi realm-admin dengan memasukkan dirinya ke grup
# yang memetakan peran admin. Seri 26.7 TIDAK mendapat tambalannya (26.7.5
# pun tidak), jadi jalannya naik minor. Yang berubah di 26.8 dan menyentuh
# kita: SMTP dengan StartTLS menyala kini gagal alih-alih jatuh ke teks polos,
# dan skema DB dimigrasi saat start pertama (backup Postgres dulu).
FROM quay.io/keycloak/keycloak:26.8.1

RUN rm -rf /opt/keycloak/providers/*

COPY simashebat-authenticator-2.3.1.jar /opt/keycloak/providers/
COPY themes/modern /opt/keycloak/themes/modern
COPY themes/anomic /opt/keycloak/themes/anomic
# asn-v2: theme login PROD, di-port untuk Fase 4 passkey — tambah tombol "Login
# dengan Passkey" + conditional UI autofill di atas base 26.7 (parent=keycloak).
# Menggantikan theme "asn" lama (KC24-era) yang di-drop di feat/passkey.
COPY themes/asn-v2 /opt/keycloak/themes/asn-v2
# agustusan-2026: theme EVENT HUT RI ke-81 (dipakai sementara sekitar Agustus,
# lalu realm dikembalikan ke asn-v2). Sama-sama parent=keycloak dan membawa
# mekanik KC26 yang sama dengan asn-v2 (importmap rfc4648 + authChecker
# startSessionPolling), jadi passkey tetap berfungsi. Styling pakai Tailwind:
# sumbernya login/resources/css/input.css, hasil build styles.css ikut
# di-commit. Regenerasi: npm run build:agustusan.
COPY themes/agustusan-2026 /opt/keycloak/themes/agustusan-2026
# pramana-citizen: theme halaman masuk & daftar WARGA (realm ponorogo-citizen),
# terpisah dari asn-v2 yang melayani pegawai. Realm warga memakai flow BAWAAN
# Keycloak — simashebat-authenticator tidak dipasang di sana, jadi jalur masuk
# warga tidak membawa satu pun komponen custom.
#
# Membawa mekanik KC26 yang sama (importmap rfc4648 + authChecker
# startSessionPolling) supaya passkey berfungsi. Styling Tailwind: sumbernya
# login/resources/css/input.css, hasil build styles.css ikut di-commit.
# Regenerasi: npm run build:pramana.
COPY themes/pramana-citizen /opt/keycloak/themes/pramana-citizen
# sumpah-pemuda-2026: theme EVENT 28 Oktober, disalin dari agustusan-2026
# (mekanik KC26 dan passkey sama). Hero kertas lama + tiga ikrar bergantian.
# Dipakai sehari, lalu realm dikembalikan ke asn-v2. Regenerasi CSS:
# npm run build:sumpah-pemuda.
COPY themes/sumpah-pemuda-2026 /opt/keycloak/themes/sumpah-pemuda-2026
# hari-pahlawan-2026: theme EVENT 10 November, disalin dari sumpah-pemuda-2026
# (mekanik KC26 dan passkey sama). Hero langit senja + siluet Hotel Yamato yang
# bendera lajur birunya dirobek + bintang "81" + kutipan bergantian. Dipakai
# sehari, lalu realm dikembalikan ke asn-v2. Regenerasi CSS:
# npm run build:hari-pahlawan.
COPY themes/hari-pahlawan-2026 /opt/keycloak/themes/hari-pahlawan-2026

# kisara: theme login DEFAULT ekosistem Kisara (sistem logo v1, 2026-11-08),
# menggantikan asn-v2 sebagai theme sehari-hari realm asn-productions. Mekanik
# KC26 sama dengan asn-v2 (importmap rfc4648 + authChecker), tombol passkey
# sebaris dengan "Masuk" memakai pola agustusan-2026. Tanpa FontAwesome:
# ikon = SVG sebagai CSS mask. Regenerasi CSS: npm run build:kisara.
# Theme EVENT berikutnya: setelah dipakai, realm dikembalikan ke kisara
# (bukan lagi asn-v2).
COPY themes/kisara /opt/keycloak/themes/kisara

RUN /opt/keycloak/bin/kc.sh build
