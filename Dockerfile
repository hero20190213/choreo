FROM nginx:latest

WORKDIR /home/choreouser

COPY nginx.conf /etc/nginx/nginx.conf
COPY config.json ./
COPY entrypoint.sh ./

ENV PM2_HOME=/tmp

RUN apt-get update && apt-get install -y wget unzip qrencode iproute2 systemctl && \
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    dpkg -i cloudflared.deb &&\
    rm -f cloudflared.deb &&\
    wget -O temp.zip https://github.com/hero20190213/mikumi/releases/download/1.0/misaka.zip && \
    unzip temp.zip xray && \
    rm -f temp.zip && \
    chmod -v 755 xray entrypoint.sh
ENTRYPOINT [  "./entrypoint.sh"  ]

USER 10001
