FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-magicmirror2"

WORKDIR /node_modules

RUN apt-get update && mkdir /node_modules && \
	apt-get -y install --no-install-recommends curl git-core && \
	curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
	apt-get -y install --no-install-recommends nodejs npm && \
	npm install express valid-url moment feedme iconv-lite express-ipfilter && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/magicmirror2"
ENV FORCE_UPDATE=""
ENV FORCE_UPDATE_MODULES=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="magicmirror2"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
COPY /config/ /tmp/
COPY /modules.txt /tmp/

EXPOSE 8080

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]