# Instruction to deploy

## Clone the repos

```shell
git clone git@framagit.org:interhop/hds/cryptpad-docker.git
```

## Build the image

```shell
# update cryptpad source
cd cryptpad-docker
docker build -t interhop/cryptpad:latest -f Dockerfile-nginx-alpine . 
```

## Edit environment variables

```shell
cd interhop
cp env-example env-prod
# MODIFY the values :
CPAD_MAIN_DOMAIN 
CPAD_SANDBOX_DOMAIN
DATA_PATH # where the data will be persisted
CPAD_TRUSTED_PROXY # the ip cidr of the proxy
```

## Copy configs

```shell
mkdir -p <DATA_PATH>/data/customize/
cp application_config.js <DATA_PATH>/data/customize/
cp config.js <DATA_PATH>/data/
# replace example.org / sandbox.example.org in both files
chown -R 4001:4001 <DATA_PATH>
```

##  Start up cryptpad

The owner has to be changed after first startup:

```shell
docker-compose up -d
docker-compose down
chown -R 4001:4001 <DATA_PATH>
docker-compose up -d
```

## On the proxy server

- copy `nginx-cryptpad-reverse-proxy.conf` in site-available and link it to site-enabled
- edit with the ip of the application server
- run `certbot --nginx -d example.org -d sandbox.example.org`
- `nginx -t`
- `systemctl reload nginx`


# Instruction to upgrade

```shell
git pull
docker build -t interhop/cryptpad:latest -f Dockerfile-nginx-alpine . 
docker-compose down
docker compose --env-file env-prod up -d
```
