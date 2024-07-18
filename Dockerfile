FROM alpine:edge

RUN echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

ENV GOBIN=/bin

COPY --from=bufbuild/buf:1.34 /usr/local/bin/buf /usr/local/bin/buf
COPY --from=arigaio/atlas:0.25.0-distroless /atlas /usr/local/bin/atlas

RUN <<EOF
apk add --no-cache --virtual .build-deps build-base mariadb-dev
# build/code
apk add --no-cache git go bash bash-completion ncurses vim tmux gcc python3-dev musl-dev jq yq py-pip
# network
apk add --no-cache bind-tools iputils tcpdump curl nmap tcpflow iftop net-tools mtr netcat-openbsd bridge-utils iperf ngrep
# certificates
apk add --no-cache ca-certificates openssl
# processes/io
apk add --no-cache htop atop strace iotop sysstat ltrace ncdu logrotate hdparm pciutils psmisc tree pv
# kubernetes
apk add --no-cache kubectl minio-client
cp /usr/bin/mcli /usr/bin/mc

# Go dep
go install github.com/nats-io/natscli/nats@latest; \
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest; \
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest; \
go install github.com/bufbuild/connect-go/cmd/protoc-gen-connect-go@latest; \

# Libraries
pip install --break-system-packages mysql-connector-python; \

# Remove build deps to reduce size
apk del .build-deps
EOF
