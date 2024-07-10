FROM alpine:edge

RUN echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

ENV GOBIN=/bin

COPY --from=bufbuild/buf:1.34 /usr/local/bin/buf /usr/local/bin/buf

RUN apk update && \
    apk add --no-cache \
    # build/code
    git go bash bash-completion ncurses vim tmux jq yq \
    # network
    bind-tools iputils tcpdump curl nmap tcpflow iftop net-tools mtr netcat-openbsd bridge-utils iperf ngrep \
    # certificates
    ca-certificates openssl \
    # processes/io
    htop atop strace iotop sysstat ltrace ncdu logrotate hdparm pciutils psmisc tree pv \
    # kubernetes
    kubectl minio-client \
    && \
    cp /usr/bin/mcli /usr/bin/mc \
    && \
    go install github.com/nats-io/natscli/nats@latest && \
    go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install github.com/bufbuild/connect-go/cmd/protoc-gen-connect-go@latest
