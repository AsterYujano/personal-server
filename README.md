# personal-server

## Todo

- rclone using docker container
- cron
- delete old files more than 5 or 1 month

## Services

Fill .env 

Run `docker-compose up -d` 


## Backup database volume

Install rclone: `curl https://rclone.org/install.sh | sudo bash`

Configure it: `rclone config`

test it works: `rclone ls backups`

make the script executable `chmod +x run-backup.sh`

`./run-backup.sh` to test the script works


More help: https://rclone.org/docs/

### cron

Create a cron with `crontab - e`

```
0 12 * * 0 <PATH/TO>/run-back.sh 2>var/log/scripts/report-error.log
```

## Telegram messages

Create your bot with the _botfather_ and `https://api.telegram.org/bot<TOKEN>/getUpdates` to fill the `.env.telegram` file with correct variables.

## Deprecated:

Create the traefik network `docker network create web`

