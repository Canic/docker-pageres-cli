FROM node:20

ENV     PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
        PUPPETEER_EXECUTABLE_PATH="/usr/bin/google-chrome-stable"

RUN     set -x && apt-get update \
        && apt-get install -y wget gnupg rsync \
        && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
        && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
        && apt-get update \
        && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
            --no-install-recommends \
        && groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
        && mkdir -p /home/pptruser/Downloads \
        && chown -R pptruser:pptruser /home/pptruser \
        && mkdir /data \
        && chown -R pptruser:pptruser /data \
        && apt-get autoremove -y && apt-get -y autoclean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/*


# install pageres-cli
RUN npm install -g pageres-cli && \
	ln -s /opt/node/bin/pageres /usr/bin/pageres

USER node

# set WORKDIR for easy result extraction
WORKDIR /data

CMD ["--help"]

ENTRYPOINT [ "pageres" ]

# build: docker build -t screenwork/pageres-cli .
# run: docker run --rm --mount type=bind,source="$(pwd)/data",destination=/data screenwork/pageres-cli pageres [ www.screenwork.de 800x600 1024x768 1600x900 1920x1080 ]


# docker run --rm -v ${PWD}:/data screenwork/pageres-cli [ https://www.screenwork.de/ 800x600 1024x768 1600x900 1920x1080 ]