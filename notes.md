# Useful commands

```
docker run -it openquantumsafe/oqs-ossl3
docker cp artifacts/* <CONTAINER>:/
docker build -t oqscertchecker .
sudo docker run --rm -v ${pwd}/input:/input -v ${pwd}/output:/output oqscertchecker
```