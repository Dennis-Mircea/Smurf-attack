LIST=0 1 2 3 4 5

# Deploy the infrastructure
all: deploy-victim deploy-attacker deploy-stations

.PHONY: build
.PHONY: clean

# Checking if the user is root
root-condition:
	@if ! [ "$(shell id -u)" = 0 ];then \
		echo "You are not root, run this target as root please" ; \
		exit 1 ; \
	fi

# Build infrastructure image
build: root-condition Dockerfile
	docker build . -t machine

# Deploy the victim
deploy-victim: build
	docker run -it -v "$(shell pwd)/tmp:/tmp" \
		--sysctl net.ipv4.icmp_echo_ignore_broadcasts=0 \
		--sysctl net.ipv4.icmp_ratelimit=0 \
		--sysctl net.ipv4.icmp_echo_ignore_all=0 \
		-d --cpus 1 --name victim machine

# Deploy the attacker
deploy-attacker: build
	docker run -it -d --sysctl net.ipv4.icmp_echo_ignore_broadcasts=0 --sysctl net.ipv4.icmp_ratelimit=0 --sysctl net.ipv4.icmp_echo_ignore_all=0  --cpus 1 --name attacker machine

# Deploy the stations that will take down the victim
deploy-stations: build
	for i in $(LIST) ; do \
    	docker run -it -v "$(shell pwd)/tmp:/tmp" --sysctl net.ipv4.icmp_echo_ignore_broadcasts=0 --sysctl net.ipv4.icmp_ratelimit=0 --sysctl net.ipv4.icmp_echo_ignore_all=0  --cpus 1 -d --name station-$$i machine ; \
	done

# Simplify the way we connect to a container
bash-victim: root-condition
	docker exec -it victim /bin/bash

bash-attacker: root-condition
	docker exec -it attacker /bin/bash

bash-station: root-condition
	docker exec -it station-0 /bin/bash

# This target tears down the setup
clean: root-condition
	docker stop $(shell docker ps -aq)
	docker rm   $(shell docker ps -aq)