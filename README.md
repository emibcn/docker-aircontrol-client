# docker-aircontrol-client
Docker solution for AirControl2 client GUI. Helps creating various containers for different AirControl2 servers.

## Usage
Download repo:
```
git clone https://github.com/emibcn/docker-aircontrol-client.git
cd docker-aircontrol-client
```

Create a new container with customized options:
```
make VERSION=latest NAME=mywisp do-exec
```

Open your new AirControl profile:
```
./mywisp.sh
```

More and well commented options inside Makefile (some in Catalan; I'll soon translate it).
