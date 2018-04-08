FROM alpine:3.7

RUN apk upgrade --update-cache && apk add \
    ca-certificates \
    nginx \
    py-pip \
    supervisor \
    uwsgi \
    uwsgi-python \
    && \
    rm -fr /var/cache/apk

# All worker processes run as user "foo".
RUN adduser -D foo

COPY files /

RUN pip install /puppetboard-4362f80db61b7ec5b360dfc055523eedb0d55413.tar.gz

COPY ssl /var/lib/puppet/ssl/

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-n"]
