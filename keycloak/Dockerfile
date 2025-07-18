FROM quay.io/keycloak/keycloak:24.0.3

RUN rm -rf /opt/keycloak/providers/*
RUN rm -rf themes/modern
RUN rm -rf themes/anomic

COPY simashebat-authenticator-1.0.1.jar /opt/keycloak/providers/
COPY themes/modern /opt/keycloak/themes/modern
COPY themes/anomic /opt/keycloak/themes/anomic

# COPY themes/modern/theme.properties /opt/keycloak/themes/modern/theme.properties
# COPY themes/modern/login /opt/keycloak/themes/modern/login
# COPY themes/modern/resources /opt/keycloak/themes/modern/resources

# Pastikan folder resources/css sudah ada dan tailwind.css berada di dalamnya
# Jika perlu, tambahkan perintah berikut sebelum build:
# RUN mkdir -p /opt/keycloak/themes/modern/resources/css

RUN /opt/keycloak/bin/kc.sh build
