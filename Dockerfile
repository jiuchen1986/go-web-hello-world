FROM       alpine:3.11.2

WORKDIR    /demo

COPY       go-web-hello-world ./

EXPOSE     8081

ENTRYPOINT ["/demo/go-web-hello-world"]
