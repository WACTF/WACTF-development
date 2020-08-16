# Setting up for development

**I’ll start with the bad news.**

gVisor isn’t supported in Docker for Windows or Mac. The **good news** is we have provided a `setup.sh` script (and a Vagrantfile) in the [Automation](Automation) directory that will spin up a suitable Ubuntu testing VM for you. As gVisor is a drop-in replacement for runC, you _should_ be safe to do all your development in a different environment and perform your integration tests in the VM. We are using Ubuntu 18.04 for the following setup.

**Prod version of Docker:**

Use the latest patch level of Docker CE version `19.03` (at the time of writing `19.03.11`). Follow the [Docker instructions](https://docs.docker.com/engine/installation/linux/ubuntu/) (or refer to the `setup.sh` script in the [Automation](Automation) directory).

**Prod version of gVisor**

Use the latest patch level of gVisor version `2020` (at the time of writing `20200522`). Follow the `Install from an apt repository` [instructions here](https://gvisor.dev/docs/user_guide/install/) (or refer to the `setup.sh` script in the [Automation](Automation) directory).

After installing gVisor, you'll need to run `sudo runsc install` which will complete the Docker quickstart install.

**Set gVisor as the default runtime**

Add `"default-runtime": "runsc"` to `/etc/docker/daemon.json` and restart docker `sudo systemctl restart docker`. `daemon.json` should look like this:

```
{
  "runtimes": {
    "runsc": {
      "path": "/usr/bin/runsc"
    }
  },
  "default-runtime": "runsc",
  "dns": ["8.8.8.8"]
}
```

**Prod version of docker-compose:**

Use version `1.26.0`. You can get the correct version of docker-compose by running the following:
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

**Important note**

Get these major and minor versions of Docker/docker-compose/gVisor to ensure that your challenge(s) will work as expected in the game environment. Other versions of Docker _may_ work, but don't be that guy/girl.

**I've never used Docker before though :/**

We have provided some sample Dockerfiles in the [Example-Dockerfiles](Example-Dockerfiles) directory to help get you started. Be mindful though that they might not meet the container hardening requirements listed below. They are a good starting point though.

Now here's some handy commands that will make your docker-dev life better:

|Command|What it does|
|---|---|
| docker-compose up | This starts the Docker containers specified in the [docker-compose](docker-compose.yml) file |
| docker-compose up -d | This does the same as above, but launches in daemon mode so you don't have the "How do I exit VIM???" problem |
| docker-compose stop | This will stop the Docker containers |
| docker-compose rm | This removes the containers, you will want to do this if you are devving things (you won't have to download the base images again) |
| docker-compose build | This will re-build the Docker containers (if you make a change, rm then do this) |

## Autonomy

Your challenge(s) are expected to work out-of-the-box. A game organiser should only need to run `docker-compose up` and your Dockerfile/docker-compose file should execute any startup scripts necessary to bring the challenge to its fully working state.

## Port Ranges

In previous years, WACTF had port ranges for challenges. In K8-land, this is no longer a requirement. Your challenge should run on a non-privileged port (that’s `>1024`) or use the canonical port if the service you are running has one i.e a webserver on port 80. As a side note, there’s no requirement for encryption in transit (like TLS / HTTPS), teams will be encapsulated in their own OpenVPN stream, so avoid this unnecessary complexity.

## Flag Format

The flag format is: `WACTF{FLAG_OF_YOUR_CHOICE}` (obviously nothing that could be considered generally offensive). For challenges that players may be able to `strings` (or similar) the flag when you don't want them to, you can specify your own flag format, ensure this is well documented in the challenge documentation provided with your deliverable.

# Environment & Container Hardening Requirements

There are enforced container restrictions for workloads in our K8 environment. Your challenge container must meet these requirements, or it will not integrate.

## Your container:

1. MUST be built from:
	* [Docker Scratch](https://hub.docker.com/_/scratch) (see [Example-Dockerfiles](Example-Dockerfiles)),
	* A maintained Alpine based image (such as `python:alpine`),
	* The latest Alpine image `alpine:latest`,
	* A maintained image (such as `ubuntu:18.04`) that is run through [DockerSlim](https://dockersl.im) (see below); or,
	* A [Distroless Container](https://github.com/GoogleContainerTools/distroless) (see below).
2. MUST work in the [gVisor](https://gvisor.dev/) runtime.
3. MUST NOT run the challenge as `root` unless:
	* Binding to ports and then dropping privileges (such as Apache/nginx).
4. MUST NOT require any unsupported `docker-compose` keys (such as volume mounts). If you use the supplied `docker-compose` file you will be fine, you can check [here](https://kompose.io/conversion/) for compatibility.
5. MUST NOT permit players to gain `root` privileges within the container.
6. MUST NOT require additional Linux capabilities (such as `NET_ADMIN` or `--privileged` mode).

Depending on the risk posed by your challenge there may be additional hardening measures you need to perform:

### RCE or interactive shell possible?

The developer must take additional defence in depth measures for containers that can result in RCE or an interactive shell. Developers are encouraged to explore:

1. Using [DockerSlim](https://dockersl.im) with the `--include-shell` option and/or `--include-bin` to add binaries to a minified image,
2. [NsJail](https://nsjail.dev/),
3. `chroot` jails, and/or;
4. Removing unnecessary binaries from the image.

## Using DockerSlim

DockerSlim is meant to be used with HTTP(S) API’s/web applications – it might break your console-based application but give it a whirl anyway.

**More bad news**

DockerSlim can’t minify containers in the gVisor runtime [(ref)](https://github.com/docker-slim/docker-slim/issues/160). The workaround at the moment is to edit `/etc/docker/daemon.json` and set the runtime back to runC: `"default-runtime": "runc",`.

**Back to the good news**

DockerSlim works with built images, so you’ll want to `docker-compose build` or `docker-compose up` at least once first. 

To slim an image, use `docker-slim build --target <image-name> --expose <port> --tag <image-name>` where `expose` is the port running the challenge. If you omit the `--tag` switch, the slimmed container will be built with a new name: `<image-name>.slim`. This is a pain because you’ll need to remember to update your docker-compose file to point towards the new `.slim` image. Therefore, I recommend using the `--tag` switch.

In this example, we are using **Exploit 3 from 0x03**:
```
docker images
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
registry.capture.tf/wactf3/exploit-3        latest              5b077e75726e        3 hours ago         8.42MB
```

`docker-slim build --target registry.capture.tf/wactf3/exploit-3 --expose 2812 --tag registry.capture.tf/wactf3/exploit-3`

```
docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED               SIZE
registry.capture.tf/wactf3/exploit-3   latest              991000a55610        7 seconds ago         3.54MB
```

Run the new slim container to test it: `docker-compose up` (if you used `--tag`) or `docker run --rm -p 4300:2812 registry.capture.tf/wactf3/exploit-3` (if you didn't).

## Using a Distroless Container

Similar to Docker Scratch, distroless containers require a [multi-stage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build/) where you first compile/build your challenge and then move it into the minified container. There are several good example Dockerfiles for the supported languages: [Distroless Examples](https://github.com/GoogleContainerTools/distroless/tree/master/examples). The rest of the documentation isn’t amazing.

**Note:** By default, distroless containers run as `root` but contain a `nonroot` and `nobody` uid/gid. You can drop to this user in your Dockerfile [(ref)](https://github.com/GoogleContainerTools/distroless/issues/443).

# What Now?

See: [README-Delivery.md](README-Delivery.md)
