FROM debian:10-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TIMEZONE=Asia/Shanghai
ENV wstunnel_version=2.0
ARG wstunnel_url=https://github.com/erebe/wstunnel/releases/download/${wstunnel_version}/wstunnel_linux_x64
ARG s6url=https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz
ENV DEV_DEPS \
        openssh-server \
        curl \
        nginx \
        vim \
        gpg gpg-agent

RUN set -eux \
  ; sed -i 's/\(.*\)\(security\|deb\).debian.org\(.*\)main/\1ftp.cn.debian.org\3main contrib non-free/g' /etc/apt/sources.list \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
 		apt-transport-https \
		ca-certificates \
		xz-utils \
		$DEV_DEPS \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
  ; curl --fail --silent -L ${s6url} | \
    tar xzvf - -C / \
  ; mkdir -p /var/run/sshd \
  \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  \ curl ${wstunnel_url} > /usr/local/bin/wstunnel \
    ; chmod a+x /usr/local/bin/wstunnel

COPY services.d /etc/services.d
COPY nginx.default.conf /etc/nginx/conf.d/default.conf
WORKDIR /srv

VOLUME [ "/srv", "/root/.vscode-server" ]
EXPOSE 80

ENTRYPOINT [ "/init" ]
