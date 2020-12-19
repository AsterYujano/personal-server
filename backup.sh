#!/usr/bin/env bash
# back-up script

echo " "
echo "[🚀] Start back-up script"

DATE=$(date +"%y-%m-%d_%H_%M_%S")

REMOTE_NAME="remote"
REMOTE_FOLDER="backups"

BACKUP_PATH="/tmp/backup"
BW_FILE_NAME=backup_bw-data_${DATE}.tar
MINIFLUX_FILE_NAME=backup_miniflux_postgres_${DATE}.tar

VOLUME_NAME="personal-server_miniflux-db"

#########################
# Backup bitwarden data #
#########################

echo "[>] Start back-up bitwarden"
echo "  [+] Tar the folder"
mkdir -p ${BACKUP_PATH}

tar -zcf ${BACKUP_PATH}/${BW_FILE_NAME} bw-data
# -z : Compress archive using gzip program in Linux or Unix
# -c : Create archive on Linux
# -v : Verbose i.e display progress while creating archive
# -f : Archive File name

echo "  [+] Copy in Mega"
rclone copy ${BACKUP_PATH}/${BW_FILE_NAME} ${REMOTE_NAME}:${REMOTE_FOLDER}

############################
# Miniflux backup postgres #
############################

echo "[>] Start back-up miniflux"
echo "  [+] Export & tar the docker miniflux db volume"
docker run --rm -v ${VOLUME_NAME}:/vol -w /vol alpine tar -c . > ${BACKUP_PATH}/${MINIFLUX_FILE_NAME}

echo "  [+] Copy in Mega"
rclone copy ${BACKUP_PATH}/${MINIFLUX_FILE_NAME} ${REMOTE_NAME}:${REMOTE_FOLDER}

############
# clean-up #
############

echo "[🚮] Delete local tar"
rm ${BACKUP_PATH}/backup_*

##########################################
# Delete online backups older than 7days #
##########################################

echo "[🚮] Delete online backups older than 7days"
rclone delete --min-age 7d ${REMOTE_NAME}:${REMOTE_FOLDER}

