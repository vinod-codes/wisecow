FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       fortune-mod cowsay netcat-openbsd ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY wisecow.sh /usr/local/bin/wisecow.sh
RUN chmod +x /usr/local/bin/wisecow.sh

EXPOSE 4499

CMD ["/usr/local/bin/wisecow.sh"]


