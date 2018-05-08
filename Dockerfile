FROM debian:stable

ENV GRAFANA_VERSION 5.1.0

RUN set -ex \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
      adduser \
      ca-certificates \
      curl \
      libfontconfig \
      openssl \
      unzip \
 && curl -sSfLo /tmp/grafana.deb "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${GRAFANA_VERSION}_amd64.deb" \
 && dpkg -i /tmp/grafana.deb \
 && rm /tmp/grafana.deb \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 3000

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

WORKDIR /usr/share/grafana

ENTRYPOINT ["/usr/sbin/grafana-server"]
CMD [ \
  "--config", \
  "/etc/grafana/grafana.ini", \
  "cfg:default.paths.data=/var/lib/grafana", \
  "cfg:default.paths.logs=/var/log/grafana", \
  "cfg:default.paths.plugins=/var/lib/grafana/plugins" \
]
