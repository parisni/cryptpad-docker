# Instruction to deploy

## Clone the repos

```shell
git clone git@framagit.org:interhop/hds/cryptpad-docker.git
# update cryptpad source
cd cryptpad-docker
```

## Build the image

```shell
git submodule update --init
cd cryptpad
git checkout 5.1.0
# now build image
cd ..
docker build -t interhop/cryptpad:5.1.0 -f Dockerfile-nginx-alpine . 
```

## Edit environment variables

```shell
cd interhop
vim .env
# modify the values :
CPAD_MAIN_DOMAIN 
CPAD_SANDBOX_DOMAIN
DATA_PATH # where the data will be persisted
CPAD_TRUSTED_PROXY # the ip cidr of the proxy
```


## Copy configs

```shell
mkdir -p <DATA_PATH>
cp application_config.js <DATA_PATH>/customize/
cp config.js <DATA_PATH>/data/
chown -R 4001:4001 <DATA_PATH>
```



##  Start up cryptpad

```shell
docker-compose up -d
```

## On the proxy server

- copy `nginx-cryptpad-reverse-proxy.conf` in site-available and link it to site-enabled
- edit with the ip of the application server
- run `certbot --nginx -d example.org -d sandbox.example.org`
- `nginx -t`
- `systemctl reload nginx`


# Instruction to upgrade

```
git pull
git submodule update --init
```

- `build the image` with the new tag (see above)
- edit the version in `.env`
- run `docker compose down`
- run `docker compose up -d`
