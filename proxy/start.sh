#!/bin/sh

set -e

if [ ! -d "/home/awh4kc/certs" ]; then
  echo "Certificates are missing"
fi

if [ -f "/etc/traefik/traefik-extension.toml" ]; then
  echo "Merging in traefik-extension.toml file into traefik.toml"
  cat /etc/traefik/traefik-extension.toml >> /etc/traefik/traefik.toml
fi

echo "Starting with $@"

exec "/entrypoint.sh" "--api"
