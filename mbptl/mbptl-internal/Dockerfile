# Dockerfile.ubuntu16
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# install only what's needed
RUN apt-get update \
 && apt-get install -y --no-install-recommends socat \
 && apt-get clean \
 && apt-get purge -y --auto-remove build-essential \
 && rm -rf /var/lib/apt/lists/* /var/cache/apt /usr/share/doc/* /usr/share/man/* 

# copy your challenge binary
COPY main /main
COPY flag.txt /flag.txt
RUN chmod 755 /main && chown nobody:nogroup /main /flag.txt

# run as nobody by default (changeable)
USER nobody:nogroup

EXPOSE 31337

# run socat to exec /main for each incoming connection
ENTRYPOINT ["socat","tcp-l:31337,reuseaddr,fork","exec:/main"]
