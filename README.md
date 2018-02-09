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

**NOTE:** it uses host's `xpra` application to connect to container and open the AC2 client app. You must have it installed to make it work:
```
apt install xpra
```

**Note 2:** By default, uses your default `$HOME/.ssh/id_rsa{,pub}` SSH key file. The public one is inserted into the container and the private one is used to connect passwordless to the container. You can override the keyfiles with make environments. Take a look into Makefile.
