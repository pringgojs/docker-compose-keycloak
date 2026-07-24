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
COPY themes/asn /opt/keycloak/themes/asn

RUN /opt/keycloak/bin/kc.sh build
