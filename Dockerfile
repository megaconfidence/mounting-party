FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    ca-certificates fuse curl jq python3 python3-pip ffmpeg

RUN pip3 install copyparty --break-system-packages

RUN curl -sSL \
    https://raw.githubusercontent.com/tigrisdata/tigrisfs/refs/heads/main/install.sh | bash

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 4000
CMD ["/startup.sh"]
