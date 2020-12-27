FROM alpine:edge

LABEL maintainer="ClementTOCHE"
LABEL version="1.0.0"
LABEL description="Certbot Agent"

ARG PCS_TLS_GID

RUN if [ -z "${PCS_TLS_GID}" ]; \
        then addgroup -g 2022 tls; \
    else \
        addgroup -g ${PCS_TLS_GID} tls; \
    fi

#RUN sed -i 's/v3.12/edge/' /etc/apk/repositories

# Upgrade the system
RUN apk update
RUN apk upgrade
RUN apk add \
    certbot \
    curl \
    bind-tools

# Utility scripts
COPY inputs/pcs-logger /usr/sbin/
RUN chown root:root /usr/sbin/pcs-logger
RUN chmod 755 /usr/sbin/pcs-logger

# Certbot script
RUN mkdir /etc/certbot/
COPY inputs/auth-hook.sh /etc/certbot/
COPY inputs/clean-hook.sh /etc/certbot/
RUN chown root:root /etc/certbot/auth-hook.sh /etc/certbot/clean-hook.sh
RUN chmod 755 /etc/certbot/auth-hook.sh /etc/certbot/clean-hook.sh

# Entry script
COPY inputs/entry.sh /entry.sh
RUN chown root:root /entry.sh
RUN chmod 760 /entry.sh

ENTRYPOINT ["/entry.sh"]

VOLUME ["/etc/letsencrypt/"]