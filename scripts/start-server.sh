#!/bin/bash
CUR_V="$(find ${DATA_DIR} -maxdepth 1 -name installedv* | cut -d 'd' -f2)"
LAT_V="$(curl -s https://api.github.com/repos/MichMich/MagicMirror/releases/latest | grep tag_name | cut -d '"' -f4)"
if [ -z $LAT_V ]; then
	echo "---Can't get latest version number, putting server into sleep mode---"
	sleep infinity
fi

if [ "${FORCE_UPDATE}" == "true" ]; then
	echo "---Force Update enabled!---"
	if [ -z "$CUR_V" ]; then
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
		if [ ! -f ${DATA_DIR}/modules/modules.txt ]; then
			cp /tmp/modules.txt ${DATA_DIR}/modules/modules.txt
		fi
	else
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
		if [ ! -f ${DATA_DIR}/modules/modules.txt ]; then
			cp /tmp/modules.txt ${DATA_DIR}/modules/modules.txt
		fi
	fi
else
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
		if [ ! -f ${DATA_DIR}/modules/modules.txt ]; then
			cp /tmp/modules.txt ${DATA_DIR}/modules/modules.txt
		fi
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
		if [ ! -f ${DATA_DIR}/modules/modules.txt ]; then
			cp /tmp/modules.txt ${DATA_DIR}/modules/modules.txt
		fi
	elif [ "$LAT_V" == "$CUR_V" ]; then
		echo "---MagicMirror² up-to-date---"
	else
		echo "---Something went wrong, putting server in sleep mode---"
		sleep infinity
	fi
fi

echo "---Looking for new modules to install---"
modules=${DATA_DIR}/modules/modules.txt
if [ ! -d ${DATA_DIR}/.npm ]; then
	echo "---Updating all modules---"
	grep -v '^\s*$\|^#\|^\s*\#' < $modules | {
	while read -r line
	do
		if [ ! -d ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")" ]; then
			if [[ $line = \Y* ]]; then
				cd ${DATA_DIR}/modules
				git clone ${line//Y /}
				cd ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")"
				npm install
			else
				cd ${DATA_DIR}/modules
				git clone ${line//N /}
			fi
		else
			if [[ $line = \Y* ]]; then
				cd ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")"
				git pull ${line//Y /}
				npm install
			else
				cd ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")"
				git pull ${line//N /}
			fi
		fi
	done; }
	echo "---Installing, this can take some time please stand by...---"
	cd ${DATA_DIR}
	npm install
elif [ "${FORCE_UPDATE_MODULES}" == "true" ]; then
	echo "---Force Update Modules enabled!---"
	grep -v '^\s*$\|^#\|^\s*\#' < $modules | {
	while read -r line
	do
		if [ ! -d ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")" ]; then
			if [[ $line = \Y* ]]; then
				cd ${DATA_DIR}/modules
				git clone ${line//Y /}
				cd ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")"
				npm install
			else
				cd ${DATA_DIR}/modules
				git clone ${line//N /}
			fi
		else
			if [[ $line = \Y* ]]; then
				cd ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")"
				git pull ${line//Y /}
				npm install
			else
				cd ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")"
				git pull ${line//N /}
			fi
		fi
	done; }
else
	grep -v '^\s*$\|^#\|^\s*\#' < $modules | {
	while read -r line
	do
		if [ ! -d ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")" ]; then
			if [[ $line = \Y* ]]; then
				cd ${DATA_DIR}/modules
				git clone ${line//Y /}
				cd ${DATA_DIR}/modules/"$(echo "$(echo ${line##*/} | cut -d '.' -f1)")"
				npm install
			else
				cd ${DATA_DIR}/modules
				git clone ${line//N /}
			fi
		else
			echo "Module '$(echo "$(echo ${line##*/} | cut -d '.' -f1)")' found!"
		fi
	done; }
fi

echo "---Preparing Server---"
if [ ! -f ${DATA_DIR}/config/config.js ]; then
	echo "---No configuration file found, installing default---"
	cp /tmp/config.js ${DATA_DIR}/config/config.js
else
	echo "---Configuration file found!---"
fi
echo "---Please wait, permissions are set, this can take some time...---"
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Server---"
cd ${DATA_DIR}
npm run server