FROM gliderlabs/alpine:latest

RUN apk-install \
    ca-certificates \
    nginx \
    py-pip \
    supervisor \
    uwsgi \
    uwsgi-python \
    ;

# All worker processes run as user "foo".
RUN adduser -D foo

COPY files /

RUN pip install puppetboard

COPY ssl /var/lib/puppet/ssl/

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-n"]
