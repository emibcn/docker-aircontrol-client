
IMAGE_NAME = aircontrol-gui

# You can define NAME and VERSION env vars to create a differently named container
NAME := $(IMAGE_NAME)
VERSION := latest
name:
	echo $(NAME):$(VERSION)

# Claus SSH
ID_RSA := $(HOME)/.ssh/id_rsa
ID_RSA_PUB := $(HOME)/.ssh/id_rsa.pub
id_rsa.pub: $(ID_RSA_PUB)
	cp -parv $(ID_RSA_PUB) id_rsa.pub

# Dades persistents
data:
	docker volume inspect $(NAME)-data > /dev/null 2>&1 || docker volume create --name $(NAME)-data

# Construcció
build: id_rsa.pub data Dockerfile
	docker build --rm --tag $(IMAGE_NAME):$(VERSION) .

# Facilitador
OPTS = NAME=$(NAME) VERSION=$(VERSION) ID_RSA=$(ID_RSA) ID_RSA_PUB=$(ID_RSA_PUB)
$(NAME).sh:
	echo "#!/bin/bash" > $(NAME).sh
	echo "make $(OPTS) \"\$${@}\"" >> $(NAME).sh
	chmod +x $(NAME).sh

do-exec: $(NAME).sh

#############
##   RUN   ##
#############
RUN_DEPS = do-exec data
RUN_OPTS = --name $(NAME) -v $(NAME)-data:/home/developer $(IMAGE_NAME):$(VERSION)

# Crear i engegar el container
run: stop-silent $(RUN_DEPS)
	docker run -d --rm $(RUN_OPTS)

# Run only if it is not already running
run-ensure: $(RUN_DEPS)
	docker container inspect $(NAME) > /dev/null 2>&1 || docker run -d --rm $(RUN_OPTS)

# DEBUG: crear-lo però sense eliminar-lo després que s'aturi
run-no-rm: stop-silent $(RUN_DEPS)
	docker run -d $(RUN_OPTS)

# Engegar-lo en primer pla (foreground)
run-fg: stop-silent $(RUN_DEPS)
	docker run -ti --rm $(RUN_OPTS)

# Engegar-lo executant bash en comptes d'sshd
run-debug: stop-silent $(RUN_DEPS)
	docker run -ti --rm $(RUN_OPTS) /bin/bash

#############
##  /RUN   ##
#############

# Aturar
stop:
	docker stop $(NAME)

# Aturar sense missatge d'error ni fallida
stop-silent:
	docker stop $(NAME) 2> /dev/null || true

# Eliminar
rm:
	docker rm $(NAME)

rm-force: stop-silent
	docker rm -f $(NAME)

# Entrar al contenidor engegat
enter:
	docker exec -ti $(NAME) bash

# Veure els logs del contenidor en directe
logs: log
log:
	docker logs -f $(NAME)

# Agafa la IP del contenidor engegat
getip:
	docker container inspect $(NAME) -f "{{ .NetworkSettings.Networks.bridge.IPAddress }}" 

# Fa SSH cap al contenidor engegat
connect: run-ensure
	ssh -o "StrictHostKeyChecking=no" -o "ControlMaster=no" -i $(ID_RSA) developer@$(shell make -s $(OPTS) getip)

connect-debug: run-ensure
	ssh -vvv -o "StrictHostKeyChecking=no" -o "ControlMaster=no" -i $(ID_RSA) developer@$(shell make -s $(OPTS) getip)

# Engega l'aplicació AirControl fent SSH amb XPRA cap al contenidor
# S'assegura de tenir el contenidor engegat
launch: run-ensure /usr/bin/xpra
	sleep 3
	xpra start ssh:developer@$(shell make -s $(OPTS) getip) --daemon=no --ssh="ssh -o 'StrictHostKeyChecking=no' -o 'ControlMaster=no' -i $(ID_RSA)" --start='/opt/Ubiquiti/AirControl2/airControl2Client'


#launch: run-ensure /usr/bin/xpra
#	sleep 3
#	xpra start ssh:developer@$(shell make -s $(OPTS) getip) --daemon=no --ssh="ssh -o 'StrictHostKeyChecking=no' -i $(ID_RSA)" --start=YOUR_FANCY_APP

.PHONY : all
.DEFAULT_GOAL := all
all: build launch
