FROM golang:alpine AS builder

WORKDIR /opt/server
COPY ./challenge-files/ .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /go/bin/server
# we do this to prevent the container running as root
RUN echo "nobody:x:65534:65534:Nobody:/:" > /etc_passwd

# We don't need an OS based container, due to a static golang binary, so we
# use the "scratch" image
FROM scratch
COPY --from=builder /go/bin/server /server
COPY --from=builder /etc_passwd /etc/passwd

USER nobody

ENTRYPOINT ["./server"]