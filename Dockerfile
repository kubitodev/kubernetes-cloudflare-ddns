FROM alpine:3.15.3

RUN apk add --no-cache bash curl

COPY sync.sh /

RUN chmod +x /sync.sh

ENTRYPOINT ["/sync.sh"]
