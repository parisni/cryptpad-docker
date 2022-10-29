```shell
git clone git@framagit.org:interhop/hds/cryptpad-docker.git
cd cryptpad-docker
git submodule update --init
cd cryptpad
git checkout 5.1.0
cd ..
docker build -t interhop/cryptpad:latest .
cd interhop
docker-compose up -d
```
