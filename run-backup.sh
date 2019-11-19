#!/bin/sh

VOLUME_NAME="personal-server_miniflux-db"
DATE=$(date +"%m_%d_%Y")
LOCAL_PATH="/tmp/backup-docker-volume"
REMOTE_NAME="remote"
REMOTE_FOLDER="backups"

####################################
# Create a backup archive & upload #
####################################

# Tar the docker volume
mkdir -p ${LOCAL_PATH}

docker run --rm -v ${VOLUME_NAME}:/vol -w /vol alpine tar -c . > ${LOCAL_PATH}/backup_${DATE}.tar

# Copy it in MEGA
rclone copy ${LOCAL_PATH}/backup_${DATE}.tar ${REMOTE_NAME}:${REMOTE_FOLDER}


##################################
# Send message with telegram bot #
##################################

# Load .env.telegram variables (TOKEN & CHAT_ID)
export $(egrep -v '^#' .env.telegram | xargs)


# arg1 is TEXT to send
send_message () {
    curl --data-urlencode "text=$1" \
        "https://api.telegram.org/bot${TOKEN}/sendMessage?parse_mode=Markdown&chat_id=${CHAT_ID}"
}


# if previous steps exit code O
if [ $? -eq 0 ]
then
    send_message "🎉 - Backup successfully uploaded
    File size: $(ls -alh ${LOCAL_PATH}/backup_${DATE}.tar | awk '{print $5}')"
else
    send_message "⚠️ - Failed to upload backup" 
fi


#########
# Clean #
#########

# Delete local tar
rm ${LOCAL_PATH}/backup_*

# TODO: Delete old backups

