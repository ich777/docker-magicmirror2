#!/bin/bash
CUR_V="$(find ${DATA_DIR} -maxdepth 1 -name installedv* | cut -d 'd' -f2)"
LAT_V="$(curl -s https://api.github.com/repos/MichMich/MagicMirror/releases/latest | grep tag_name | cut -d '"' -f4)"
if [ -z $LAT_V ]; then
	echo "---Can't get latest version number, putting server into sleep mode---"
	sleep infinity
fi

if [ -z "$CUR_V" ]; then
	echo "---MagicMirror² not found!---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O $LAT_V.tar.gz https://github.com/MichMich/MagicMirror/archive/$LAT_V.tar.gz ; then
		echo "---Successfully downloaded MagicMirror² $LAT_V!---"
	else
		echo "---Something went wrong, can't download Magic Mirror² $LAT_V, putting server in sleep mode---"
		sleep infinity
	fi
	tar -xvf $LAT_V.tar.gz
	mv ${DATA_DIR}/MagicMirror*/* ${DATA_DIR}/
	rm -R ${DATA_DIR}/MagicMirror*
	rm -R ${DATA_DIR}/$LAT_V.tar.gz
	touch ${DATA_DIR}/installed$LAT_V
elif [ "$LAT_V" != "$CUR_V" ]; then
	echo "---Newer version found, installing!---"
	mkdir -p /tmp/Backup
	cd /tmp/Backup
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O $LAT_V.tar.gz https://github.com/MichMich/MagicMirror/archive/$LAT_V.tar.gz ; then
		echo "---Successfully downloaded MagicMirror² $LAT_V!---"
	else
		echo "---Something went wrong, can't download MagicMirror² $LAT_V, putting server in sleep mode---"
		sleep infinity
	fi
	mv ${DATA_DIR}/config /tmp/Backup/
	mv ${DATA_DIR}/modules /tmp/Backup/
	rm -R ${DATA_DIR}/*
	rm -R ${DATA_DIR}/.*
	mv /tmp/Backup/$LAT_V.tar.gz ${DATA_DIR}
	cd ${DATA_DIR}
	tar -xvf $LAT_V.tar.gz
	mv ${DATA_DIR}/MagicMirror*/* ${DATA_DIR}/
	rm -R ${DATA_DIR}/MagicMirror*
	rm -R ${DATA_DIR}/$LAT_V.tar.gz
	rm -R ${DATA_DIR}/config
	rm -R ${DATA_DIR}/modules
	mv /tmp/Backup/config ${DATA_DIR}/
	mv /tmp/Backup/modules ${DATA_DIR}/
	rm -R /tmp/Backup
	touch ${DATA_DIR}/installed$LAT_V
elif [ "$LAT_V" == "$CUR_V" ]; then
   echo "---MagicMirror² up-to-date---"
else
   echo "---Something went wrong, putting server in sleep mode---"
   sleep infinity
fi

echo "---Preparing Server---"
if [ ! -f ${DATA_DIR}/config/config.js ]; then
	echo "---No configuration file found, installing default---"
	cp /tmp/config.js ${DATA_DIR}/config/config.js
else
	echo "---Configuration file found!---"
fi
if [ ! -d ${DATA_DIR}/.npm ]; then
	echo "---Installing, this can take some time please stand by...---"
	cd ${DATA_DIR}
	npm install
fi
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Server---"
cd ${DATA_DIR}
npm run server