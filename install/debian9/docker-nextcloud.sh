docker pull mariadb:10
docker pull wonderfall/nextcloud

mkdir -p /home/data/docker/nextcloud
mkdir -p /home/data/docker/nextcloud/{db,data,config,apps,themes}

docker run -d --name db_nextcloud --restart=always \
       -v /home/data/docker/nextcloud/db:/var/lib/mysql \
       -e MYSQL_ROOT_PASSWORD=supersecretpassword \
       -e MYSQL_DATABASE=nextcloud -e MYSQL_USER=nextcloud \
       -e MYSQL_PASSWORD=supersecretpassword \
       mariadb:10

sleep 3

docker run -d --name nextcloud --restart=always \
       --link db_nextcloud:db_nextcloud \
       -v /home/data/docker/nextcloud/data:/data \
       -v /home/data/docker/nextcloud/config:/config \
       -v /home/data/docker/nextcloud/apps:/apps2 \
       -v /home/data/docker/nextcloud/themes:/nextcloud/themes \
           -p 8888:8888 \
       -e UID=1000 -e GID=1000 \
       -e UPLOAD_MAX_SIZE=10G \
       -e APC_SHM_SIZE=128M \
       -e OPCACHE_MEM_SIZE=128 \
       -e CRON_PERIOD=15m \
       -e TZ=Etc/UTC \
       -e ADMIN_USER=mrrobot \
       -e ADMIN_PASSWORD=supercomplicatedpassword \
       -e DOMAIN=cloud.example.com \
       -e DB_TYPE=mysql \
       -e DB_NAME=nextcloud \
       -e DB_USER=nextcloud \
       -e DB_PASSWORD=supersecretpassword \
       -e DB_HOST=db_nextcloud \
       wonderfall/nextcloud

