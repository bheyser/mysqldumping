#!/bin/bash

MYSQL_CMD="/usr/bin/mysql -uroot"
MYSQLDUMP_CMD="/usr/bin/mysqldump --opt -Q --skip-lock-tables -uroot"
MD5SUM_CMD="/usr/bin/md5sum"
DUMPS_DIR="dumps"

echo "root password:"
read -s ROOTPW

WORKDIR=$(pwd)

if [ -d ${WORKDIR}/${DUMPS_DIR} ]; then
	echo "Directory for Dumps exists: ${WORKDIR}/${DUMPS_DIR}"
else
	echo "Create Directory for Dumps: ${WORKDIR}/${DUMPS_DIR}"
	mkdir -p ${WORKDIR}/${DUMPS_DIR}
fi

for DATABASE in $(echo "SHOW DATABASES;" | ${MYSQL_CMD} -p${ROOTPW}); do
	if [ "${DATABASE}" != "Database" ]; then

		echo "Create Database Dump ${DATABASE}.sql"
		${MYSQLDUMP_CMD} -p${ROOTPW} ${DATABASE} > ${WORKDIR}/${DUMPS_DIR}/${DATABASE}.sql

		echo "Create Checksum File ${DATABASE}.md5"
		${MD5SUM_CMD} ${WORKDIR}/${DUMPS_DIR}/${DATABASE}.sql > ${WORKDIR}/${DUMPS_DIR}/${DATABASE}.md5
		${MD5SUM_CMD} -c ${WORKDIR}/${DUMPS_DIR}/${DATABASE}.md5

	fi
done


