FROM quay.io/keycloak/keycloak:24.0.3

RUN rm -rf /opt/keycloak/providers/*

COPY simashebat-authenticator-1.0.1.jar /opt/keycloak/providers/
# COPY themes/modern /opt/keycloak/themes/modern
# COPY themes/anomic /opt/keycloak/themes/anomic

# Pastikan folder resources/css sudah ada dan tailwind.css berada di dalamnya
# Jika perlu, tambahkan perintah berikut sebelum build:
# RUN mkdir -p /opt/keycloak/themes/modern/resources/css

RUN /opt/keycloak/bin/kc.sh build
