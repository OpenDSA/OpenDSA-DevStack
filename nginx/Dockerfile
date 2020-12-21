FROM nginx:1.17.9

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY opendsa_server.crt /etc/nginx/certs/opendsa_server.crt
COPY opendsa_server.key /etc/nginx/certs/opendsa_server.key
COPY codeworkout_server.crt /etc/nginx/certs/codeworkout_server.crt
COPY codeworkout_server.key /etc/nginx/certs/codeworkout_server.key
