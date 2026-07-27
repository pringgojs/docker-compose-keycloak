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
FROM quay.io/keycloak/keycloak:26.7.0

RUN rm -rf /opt/keycloak/providers/*

COPY simashebat-authenticator-2.3.1.jar /opt/keycloak/providers/
COPY themes/modern /opt/keycloak/themes/modern
COPY themes/anomic /opt/keycloak/themes/anomic
# asn-v2: theme login PROD, di-port untuk Fase 4 passkey — tambah tombol "Login
# dengan Passkey" + conditional UI autofill di atas base 26.7 (parent=keycloak).
# Menggantikan theme "asn" lama (KC24-era) yang di-drop di feat/passkey.
COPY themes/asn-v2 /opt/keycloak/themes/asn-v2
# agustusan-2026: theme EVENT kemerdekaan HUT RI ke-81 (dipakai sementara periode
# Agustus, toggle via realm loginTheme). parent=keycloak, CSS sendiri + auto dark
# mode + passkey (importmap/authChecker sama asn-v2).
COPY themes/agustusan-2026/login /opt/keycloak/themes/agustusan-2026/login

RUN /opt/keycloak/bin/kc.sh build
