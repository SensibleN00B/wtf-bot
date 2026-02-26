FROM node:22-bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 10001 -s /bin/bash openclaw

RUN npm i -g openclaw@latest

WORKDIR /home/openclaw/app

COPY start.sh /home/openclaw/app/start.sh
RUN chmod +x /home/openclaw/app/start.sh \
  && chown -R openclaw:openclaw /home/openclaw

USER openclaw
ENV HOME=/home/openclaw

EXPOSE 18789

CMD ["/home/openclaw/app/start.sh"]