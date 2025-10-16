FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/games:/usr/local/games:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       fortune-mod fortunes-min cowsay netcat-openbsd ca-certificates dos2unix \
    && rm -rf /var/lib/apt/lists/*

COPY wisecow.sh /usr/local/bin/wisecow.sh
RUN dos2unix /usr/local/bin/wisecow.sh \
    && chmod +x /usr/local/bin/wisecow.sh

EXPOSE 4499

CMD ["/usr/local/bin/wisecow.sh"]


