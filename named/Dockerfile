FROM gliderlabs/alpine:latest

RUN apk-install bind
COPY files /

# Note: You must bind the DNS port to the management IP to avoid client error:
# ;; reply from unexpected source: yyy.yyy.yyy.yyy#53, expected xxx.xxx.xxx.xxx#53
#
# For example:
# mgmt_ip=$(ip route get 8.8.8.8 | awk '/src/ {print $NF}')
# docker run -d --name named-test -p ${mgmt_ip}:53:53 -p ${mgmt_ip}:53:53/udp jumanjiman/named
#
EXPOSE 53/tcp
EXPOSE 53/udp

CMD ["/usr/local/sbin/start.sh"]
