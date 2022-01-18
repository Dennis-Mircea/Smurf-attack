# This is a proof of concept attempt for Smurf Attack on IPv4

This will built the `Dockerfile` from the current directory.

```
sudo docker build . -t machine
```

# Victim machine

We are using the following command to start a machine in detached mode:

```
docker run -it -v "$(shell pwd)/tmp:/tmp" \
		--sysctl net.ipv4.icmp_echo_ignore_broadcasts=0 \
		--sysctl net.ipv4.icmp_ratelimit=0 \
    --sysctl net.ipv4.icmp_echo_ignore_all=0 \
		-d --cpus 1 --name victim machine
```

Then we connect on the victim machine using:

```
sudo docker exec -it victim /bin/bash
```

We noticed that `net.ipv4.icmp_echo_ignore_all` was already disabled.

# Attacker machine

The attacker machine has already the tools necessary to attack the victim with
`hping3` and `nmap` installed we are ready to go:

```
sudo docker run -it -d --name attacker machine
```

Then we connect using:

```
sudo docker exec -it attacker /bin/bash
```

# Stations in the wild

We also need to deploy a couple of stations that would help us attack the victim server:

```
sudo docker run -it -d --name station<num> machine
```

# Automation for the proof of concept

For the sake of easying the setup we also have `Makefile` that would automate the deploy
of the testing infrastructure and the process of building the image. Some useful rules are the
following:

1. `sudo make build` - this would build the docker image that would support our infrastructure

2. `sudo make` - would deploy the containers and also build the image

3. `sudo make clean` - this will stop all the containers and remove them

# Notice

We manage to replicate the misconfiguration on IPv4. But unfortunately we couldn't observe any delay or
CPU increase.