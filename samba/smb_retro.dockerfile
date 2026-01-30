FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

# --- CAMBIO CRÍTICO AQUÍ ---
# 1. Cambiamos los repositorios a archive.debian.org (porque Buster es EOL)
# 2. Desactivamos la comprobación de fecha de validez (Check-Valid-Until=false) porque los certificados son viejos.
RUN echo "deb http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security/ buster/updates main" >> /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get -o Acquire::Check-Valid-Until=false install -y --no-install-recommends \
    samba \
    samba-common-bin \
    smbclient \
    tini \
    iproute2 \
    tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/log/samba /var/run/samba /var/lib/samba

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 137/udp 138/udp 139 445

VOLUME ["/etc/samba", "/var/lib/samba", "/var/log/samba"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD smbstatus > /dev/null || exit 1

ENTRYPOINT ["/entrypoint.sh", "/usr/bin/tini", "--"]

CMD ["/bin/sh", "-c", "nmbd -D && smbd -F --no-process-group --log-stdout"]