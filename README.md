# Based on k0st/zcash

Zcash inside docker

Image is based on the Ubuntu 16.04 base image

## Build

```
docker build -f Dockerfile --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$(id -n -u) -t zcash-cli .
```

## Docker image usage

```
docker run [docker-options] zcash-cli
```

## Examples

Typical basic usage (start zcashd daemon): 

```
docker run -it zcash-cli zcashd
```

Typical usage to perform query:

```
docker run -d --name zcashcont zcash-cli zcashd
docker exec -u zcash zcashcont zcash-cli getbalance
```

### Todo
- [ ] Perform more testing

