FROM quay.io/keycloak/keycloak:24.0.3

RUN rm -rf /opt/keycloak/providers/*

COPY simashebat-authenticator-1.0.1.jar /opt/keycloak/providers/
COPY themes/modern /opt/keycloak/themes/modern

RUN /opt/keycloak/bin/kc.sh build
