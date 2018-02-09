# docker-aircontrol-client
Docker solution for AirControl2 client GUI. Helps creating various containers for different AirControl2 servers. "Only" 842MB...

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

Build and open your new AirControl profile:
```
./mywisp.sh
```

More and well commented options inside Makefile (some in Catalan; I'll soon translate it).

**NOTE:** this solution uses host's `xpra` and `make` applications to connect to container and open the AC2 client app. You must have it installed to make it work. For Debian/Ubuntu:
```
sudo apt install xpra build-essential
```

**Note 2:** By default, this solution uses your default `$HOME/.ssh/id_rsa{,pub}` SSH key file. The public one is inserted into the container's `authorized_keys` and the private one is used to connect password-less to the container. You can override the key files with make environments. Take a look into Makefile.
