# Demo Tasks

<br/>

## Task 0: Install a ubuntu 16.04 server 64-bit

> **Steps:**

>   - Install virtualbox on laptop from laptop
>   - Download iso image from [http://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-amd64.iso](http://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-amd64.iso "ubuntu-16.04-server-amd64")
>   - Create VM with NAT network, 4G MEM, and 2 CPU using the image above
>   - Set port forward from host machine to the VM
>     - 2222 -> 22
>     - 8080 -> 80
>     - 8081 -> 8081
>     - 8082 -> 8082
>     - 31080 -> 31080
>     - 31081 -> 31081
>   - Start VM and login to
>   - Add current user to `sudoers` and grant the ability for the user running `sudo` without password
>     - `sudo su -`
>     - `chmod u+w /etc/sudoers`
>     - add `account_name ALL=(ALL:ALL) ALL` under `root ALL=(ALL:ALL) ALL` in `/etc/sudoers`
>     - change `%sudo ALL=(ALL:ALL) ALL` to `%sudo ALL=(ALL:ALL) NOPASSWD:ALL`
>     - `chmod u-w /etc/sudoers`

<br/>

## Task 1: Update system

> **Steps:**

> - Set proxy if need
>   - `export http_proxy=proxy_url`
>   - `export https_proxy=proxy_url`
> - Check current kernel
>   - `uname -r`, got `4.4.0-142-generic`
> - Upgrade the system
>   - `apt update`
>   - `apt upgrade -y`
>   - `reboot`
> - Check upgraded kernel
>   - `uname -a`, got `4.4.0-170-generic`

> **Optional Steps**:

> - Take a snapshot of current VM
> - Get latest kernel packages in mainline
>   - `mkdir /root/kernel-mainline;cd /root/kernel-mainline`
>   - `wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4.207/linux-headers-4.4.207-0404207_4.4.207-0404207.201912210540_all.deb`
>   - `wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4.207/linux-headers-4.4.207-0404207-generic_4.4.207-0404207.201912210540_amd64.deb`
>   - `wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4.207/linux-image-unsigned-4.4.207-0404207-generic_4.4.207-0404207.201912210540_amd64.deb`
>   - `wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4.207/linux-modules-4.4.207-0404207-generic_4.4.207-0404207.201912210540_amd64.deb`
> - Install packages for kernel
>   - `dpkg -i -R .`
>   - `reboot`
> - Check upgraded kernel
>   - `uname -r`, got `4.4.207-0404207-generic`

<br/>

## Task 2: Install gitlab-ce version in the host

> **Steps:**

> - Install gitlab-ce
>   - `curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash`
>   - `EXTERNAL_URL="http://127.0.0.1" apt-get install gitlab-ce -y`
> - Set initial credentials
>   - open `http://127.0.0.1:8080` in host machine browser
>   - set password
>   - log in as `root` user

> **Optional Steps:**

> - Disable some unnecessary components by editing `/etc/gitlab/gitlab.rb`
>   - `monitoring_role['enable'] = false`
>   - `prometheus['enable'] = false`
>   - `node_exporter['enable'] = false`
>   - `redis_exporter['enable'] = false`
>   - `postgres_exporter['enable'] = false`
>   - `grafana['enable'] = false`
>   - `alertmanager['enable'] = false`
> - Make the changes effect
>   - `gitlab-ctl reconfigure`
> - Verify gitlab is running
>   - open `http://127.0.0.1:8080` in host machine browser and log in

<br/>

## Task 3: Create a demo group/project in gitlab

> **Steps:**

> - Create group `demo` and project `go-web-hello-world` under the group `demo` in gitlab via GUI
> - Install golang
>   - `apt-get install -y golang-go`, this will install golang 1.6
>   - `mkdir -p /root/go/src /root/go/bin /root/go/pkg`
>   - `echo "export GOPATH=/root/go/" >> /root/.bashrc`
>   - `source /root/.bashrc`
> - Install git if need
>   - `apt-get install -y git`
>   - `git config --global user.name "Your Name"`
>   - `git config --global user.email "Your Email Addr"`
> - Clone `demo/go-web-hello-world` project to local
>   - cd `/root/go/src`
>   - `git clone http://127.0.0.1/demo/go-web-hello-world.git`
> - Create a go APP
>   - cd `/root/go/src/go-web-hello-world`
>   - edit a `main.go` with following codes


    package main

    import (
        "fmt"
        "net/http"
    )

    func main() {
        http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
            fmt.Fprintln(w, "Go Web Hello World!")
        })

        http.ListenAndServe(":8081", nil)
    }


> - Build the go APP
>   - cd `/root/go/src/go-web-hello-world`
>   - `go build .`
> - Check-in code to repo
>   - `git add main.go`
>   - `git add go-web-hello-world`
>   - `git commit -m "hello world"`
>   - `git push`
> - Verify code in repo
>   - open `http://127.0.0.1:8080/demo/go-web-hello-world` in host machine browser


<br/>

## Tasks 4: Build the app and expose ($ go run) the service to 8081 port

> **Steps:**

> - Build and run the APP
>   - cd `/root/go/src/go-web-hello-world`
>   - `go build .`
>   - `go run main.go` or `./go-web-hello-world`
>   - open `http://127.0.0.1:8081` in host machine browser, got `Go Web Hello World!`


<br/>


## Tasks 5: Install docker

> **Steps:**

> - Check old packages for docker
>   - `apt list --installed docker docker-engine docker.io containerd runc docker-ce docker-ce-cli containerd.io`, got nothing
> - Install docker with docker-ce-18.06 (***For my tests on deprecated APIs***)
>   - `curl -fsSL https://get.docker.com | VERSION=18.06 bash`, got docker version output as below:


    Client:
      Version:           18.06.3-ce
      API version:       1.38
      Go version:        go1.10.3
      Git commit:        d7080c1
      Built:             Wed Feb 20 02:27:18 2019
      OS/Arch:           linux/amd64
      Experimental:      false

    Server:
      Engine:
        Version:          18.06.3-ce
        API version:      1.38 (minimum version 1.12)
        Go version:       go1.10.3
        Git commit:       d7080c1
        Built:            Wed Feb 20 02:26:20 2019
        OS/Arch:          linux/amd64
        Experimental:     false


> - Check docker service status
>   - `systemctl status docker`


<br/>


## Task 6: Run the APP in container

> **Steps:**

> - Rebuild the go APP with `CGO_ENABLED=0`
>   - check [https://forums.docker.com/t/standard-init-linux-go-195-exec-user-process-caused-no-such-file-or-directory/43777](https://forums.docker.com/t/standard-init-linux-go-195-exec-user-process-caused-no-such-file-or-directory/43777)
>   - cd `/root/go/src/go-web-hello-world`
>   - `CGO_ENABLED=0 go build .`
>   - `git add go-web-hello-world`
>   - `git commit -m "rebuild binary with CGO disabled"`
>   - `git push`
> - Edit Dockerfile
>   - cd `/root/go/src/go-web-hello-world`
>   - edit `Dockerfile` as below:


    FROM       alpine:3.11.2

    WORKDIR    /demo

    COPY       go-web-hello-world ./

    EXPOSE     8081

    ENTRYPOINT ["/demo/go-web-hello-world"]

> - Build local image
>   - cd `/root/go/src/go-web-hello-world`
>   - `docker build -t go-web-hello-world .`
> - Run go APP in a container
>   - `docker run --name go-web --rm -d -p 8082:8081 go-web-hello-world`, got an error that port 8082 has been occupied
>   - `netstat -peanut | grep 8082`, got the process of `sidekiq` from gitlab
>   - edit `/etc/gitlab/gitlab.rb`, set `sidekiq['listen_port'] = 18082`
>   - `gitlab-ctl reconfigure`
>   - `docker run --name go-web --rm -d -p 8082:8081 go-web-hello-world`
>   - open `http://127.0.0.1:8082` in host machine browser, got `Go Web Hello World!`
> - Check in the Dockerfile
>   - cd `/root/go/src/go-web-hello-world`
>   - `git add Dockerfile`
>   - `git commit -m "dockerfile"`
>   - `git push`


<br/>


## Task 7: Push image to dockerhub

> **Steps:**

> - `docker tag go-web-hello-world docker.io/jiuchen1986/go-web-hello-world:v1`
> - `docker login`
> - `docker push`
> - Check pushed images on the website


<br/>


## Task 8: Document the procedure in a MarkDown file
**Skip**