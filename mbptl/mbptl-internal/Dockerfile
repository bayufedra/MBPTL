FROM ubuntu:22.04

RUN apt-get update && apt-get install -y socat && rm -rf /var/lib/apt/lists/*

COPY main /
COPY flag.txt /

RUN chmod 555 /main && chown nobody:nogroup /main /flag.txt

USER nobody

EXPOSE 31337

ENTRYPOINT ["socat", "tcp-l:31337,reuseaddr,fork", "exec:/main"]
