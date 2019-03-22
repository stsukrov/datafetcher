FROM       alpine:3.3
MAINTAINER Stanislav Tsukrov <stsukrov@amazon.com>

WORKDIR "/data"

RUN apk update && \
    apk add \
      bash \
      'python<3.0' \
      'py-pip<8.2' \
    && \
    rm -rf /var/cache/apk/*

RUN pip install awscli

ADD datafetch.sh /opt/datafetcher/datafetch
ADD uri_parse.sh /opt/datafetcher/uri_parse.sh

ENTRYPOINT ["/bin/bash", "/opt/datafetcher/datafetch"]
CMD []