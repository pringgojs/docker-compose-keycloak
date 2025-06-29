FROM quay.io/keycloak/keycloak:24.0.3

COPY simashebat-authenticator-1.0.1.jar /opt/keycloak/providers/

RUN /opt/keycloak/bin/kc.sh build
