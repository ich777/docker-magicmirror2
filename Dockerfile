FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl git-core && \
	curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
	apt-get -y install --no-install-recommends nodejs && \
	npm install express valid-url moment feedme iconv-lite express-ipfilter && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/magicmirror2"
ENV FORCE_UPDATE=""
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

EXPOSE 8080

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]