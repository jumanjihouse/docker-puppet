FROM alpine:3.2

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

RUN pip install /puppetboard-master.tar.gz

COPY ssl /var/lib/puppet/ssl/

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-n"]
