# Instruction to deploy
```shell
git clone git@framagit.org:interhop/hds/cryptpad-docker.git
# update cryptpad source
cd cryptpad-docker
git submodule update --init
cd cryptpad
git checkout 5.1.0
# now build image
cd ..
docker build -t interhop/cryptpad:5.1.0 -f Dockerfile-nginx-alpine . 
cd interhop
docker-compose up -d
```
