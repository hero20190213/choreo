FROM nginx:latest
EXPOSE 80
WORKDIR /home/choreouser
USER  10001
ENV PM2_HOME=/tmp
COPY nginx.conf /etc/nginx/nginx.conf
COPY config.json /home/choreouser/
COPY entrypoint.sh /home/choreouser/

RUN apt-get update  && \
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared.deb && \
    rm -f cloudflared.deb && \
    wget -O temp.zip https://github.com/hero20190213/hero20190213/releases/download/1.0/misaka.zip && \
    unzip temp.zip xray && \
    rm -f temp.zip && \
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod -v 755 xray entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
