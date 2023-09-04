FROM nginx:latest

WORKDIR /home/choreouser

COPY nginx.conf /etc/nginx/nginx.conf
COPY config.json ./
COPY entrypoint.sh ./

ENV PM2_HOME=/tmp

RUN apt-get update &&\
    apt-get install -y iproute2 vim &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    dpkg -i cloudflared.deb &&\
    rm -f cloudflared.deb &&\
    wget -O temp.zip https://github.com/hero20190213/hero20190213/releases/download/1.0/misaka.zip && \
    unzip temp.zip xray && \
    rm -f temp.zip && \
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x web.js entrypoint.sh nezha-agent ttyd &&\
    npm install -r package.json

ENTRYPOINT [ "node", "server.js" ]

USER 10001
