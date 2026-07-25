# Keycloak 26.7.0 — line pertama dengan passkey "supported" (bukan preview).
# Upgrade dari 24.0.3. Perubahan penting saat naik dari 24:
#   - Base image → 26.7.0
#   - Authenticator SimasHebat di-rebuild untuk 26.7 (jar 2.0.0, Java 17,
#     parsing JSON Jackson + fix email-sync). Lihat repo custom-authenticator.
#   - Keycloak 26 butuh JDK 17+ (image base sudah bawa; authenticator target 17).
#
# CATATAN opsi runtime yang berubah di v26 (di-set di docker-compose, bukan di
# sini): KC_PROXY dihapus/deprecated → pakai KC_PROXY_HEADERS. Hostname v2.
FROM quay.io/keycloak/keycloak:26.7.0

RUN rm -rf /opt/keycloak/providers/*

COPY simashebat-authenticator-2.0.0.jar /opt/keycloak/providers/
COPY themes/modern /opt/keycloak/themes/modern
COPY themes/anomic /opt/keycloak/themes/anomic
# asn-v2: theme login PROD, di-port ke branch ini (dari feat/theme-asn-v2) untuk
# Fase 4 passkey — tambah tombol "Login dengan Passkey" + conditional UI autofill
# di atas base 26.7 (parent=keycloak). Ini juga memvalidasi asn-v2 di KC 26.7
# sebelum upgrade prod.
COPY themes/asn-v2 /opt/keycloak/themes/asn-v2

RUN /opt/keycloak/bin/kc.sh build
