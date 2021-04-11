FROM python:3-alpine3.13
LABEL author="Patrick Sullivan <sublime@vt.edu>"

RUN apk add --no-cache bash git make curl vim

WORKDIR /devstack

CMD [ "python", "reposInstaller.py" ]
# CMD ["bash"]
