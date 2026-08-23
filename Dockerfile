FROM alpine:3.22

RUN apk add --no-cache \
    git \
    curl \
    build-base \
    openssl-dev \
    zlib-dev \
    linux-headers

WORKDIR /opt

RUN git clone --depth 1 https://github.com/TelegramMessenger/MTProxy.git MTProxy \
    && cd MTProxy \
    && make

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 443

CMD ["/start.sh"]
