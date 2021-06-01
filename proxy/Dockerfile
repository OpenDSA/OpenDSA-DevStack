FROM traefik:v2.3
COPY start.sh /start.sh
ENTRYPOINT [ "/start.sh" ]
COPY traefik.toml /etc/traefik/traefik.toml
COPY certificate.toml /etc/traefik/configuration/certificate.toml
