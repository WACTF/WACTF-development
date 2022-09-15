# WACTF Infrastructure

cont.

## Kubernetes & Docker

K8s is made up of a control plane and several “nodes”. Nodes can be physical hardware but in the cloud they're more often VMs. The control plane also runs on nodes, typically a few in a fault tolerant manner. The control plane runs several privileged processes to manage the cluster’s state. The other nodes run the workloads (pods) in a combined-computing model. They are rarely interacted with directly, rather the control plane is used to address the cluster as a single system. Think of it like a supercomputer and adding more nodes increases the CPU/RAM/Storage available to the machine as a whole.

### To understand container escapes is to understand the landscape

From a game integrity perspective, container escapes are one of the worst things that could happen during WACTF. If a player is able to execute commands on the Docker host (the node they’re residing on) from within a container that would likely be game ending. This section hopes to provide a high-level understanding of the container landscape so developers can better understand the restrictions we have in place to help mitigate against container escapes.

Over the years the container landscape has changed both rapidly and considerably. What you think “Docker” does is more likely what `containerd` and `runc` do. This is important to understand when trying to grasp container escapes like [CVE-2019-5736](https://nvd.nist.gov/vuln/detail/CVE-2019-5736).

Docker is responsible for providing the “nice” experience you get when working with containers. It helps you parse Dockerfiles, pull in containers from the Internet, and provides a CLI and API for interacting with those things. Containerd is the API that sits between Docker and runC. It’s still considered quite high-level and is responsible for managing the lifecycle of containers. A diagram from the containerd website is included below that shows how it sits between the container engines (like Docker) and the container runtimes (like runC). Lastly, you have the runtime. By default, Docker uses `runc` (they were the original developers of it). This is where the magic happens.

![containerd.io architecture map](https://containerd.io/img/architecture.png "containerd.io architecture map")

The runtime is responsible for providing the “sandbox” that runs your workload. It’s an “OS container” or “lightweight virtualisation” platform that determines how to handle syscalls from containers. runC makes heavy use of existing security controls available to Linux such as namespaces, seccomp, and capabilities to do this. Hence, “Docker container escape vulnerabilities”, are actually “runC escape vulnerabilities”.

Let's look at an example; CVE-2019-5736. [This blog](https://unit42.paloaltonetworks.com/breaking-docker-via-runc-explaining-cve-2019-5736/) does a good job of explaining the vulnerability. The tl;dr is: when needing to execute a binary within a container (such as when `docker exec` is run), runC would spawn the `runc init` subprocess in the container and then the `execve` syscall to overwrite itself with the required binary. Researchers found that at the time of the `execve` call the `/proc/self/exe` path (which symlinks to the binary that is currently executing) within the container becomes a symlink to the runC binary on the host! An attacker with root access in the container can use this symlink to overwrite the runC binary on the host and the next time runC is called it’s gg.

## "Containers aren't a security boundary" - everyone, every year

In a nutshell:

>runC uses the host’s kernel (and the security controls it supports) to build sandboxed environments to run untrusted code (containers). 

Compare this to virtual machines where the kernel of the guest OS is used to run the untrusted code and the shortfalls are clear. This is where [gVisor](https://gvisor.dev/) comes in. It’s a security focussed container runtime designed to be a drop-in replacement for `runc` (the binary is even called `runsc`). gVisor aims to be an emulated Linux kernel that operates in user space. It’s made up of a few components such as “Sentry” and “Gofer” that operate independently as shown in this diagram:

![gVisor architecture](https://gvisor.dev/assets/images/2019-11-18-security-basics-figure1.png "gVisor architecture")

Think of gVisor like a shadow kernel that operates on-top of the host’s kernel to provide defence-in-depth. The gVisor kernel supports a whitelisted set of Linux syscalls to ensure it can run most workloads while keeping the attack surface to the host at a minimum. There’s more at the [blog here](https://gvisor.dev/blog/2019/11/18/gvisor-security-basics-part-1/).

>gVisor is not quite a VM, but perhaps it's the next best thing.

There are several other runtime technologies built for security in the container ecosystem. For WACTF, [Kata Containers](https://katacontainers.io/) were also considered, and perhaps one year we will use them. Kata Containers are marketed as “micro-VMs” that behave like containers within Docker/K8s. Ultimately though, the integration of Kata Containers means developers may need to change their workflow to build with them, and the complexity to deploy them on cloud computing where we may not have complete control over the host leaves them out of reach for now.

## Putting that all together

At WACTF, we use gVisor as part of our defence-in-depth strategy to help mitigate against container escape vulnerabilities. Your challenges MUST operate in a gVisor runtime environment. You can find information on installing and specifying gVisor as the Docker runtime in the [README-Setup.md](README-Setup.md).
