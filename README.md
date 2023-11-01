# Examples

This repository contains example code that shows you how to do common things in sandbox environments using Jumppad.

## Container

The container folder contains multiple examples that use containers.

### Minimal
The first example is a minimal one that only spins up a single Nginx container and exposes the http port on the host.

```shell
jumppad up container/minimal
curl localhost
```

### Expanded
The second example is more advanced and creates an Ubuntu container and mounts a MOTD (message of the day) file into the container.
It then executes a change password command in the ubuntu container, so that you can then log in to the container and see the motd.

```shell
jumppad up container/expanded
docker exec -ti ubuntu.container.jumppad.dev login -f root
```

## Containers

Create multiple containers with a dependency between them.

```shell
jumppad up containers
```

## Database

Create a postgres database and populate it with data.
Then query that data using a remote exec.

```shell
jumppad up database
```

## Work in progress

> [!WARNING]
> The following examples are still being worked on, or work has not yet started.

### Certificates

Generate a CA and leaf cert that are then used in a webserver.

### Kubernetes

Create a Kubernetes cluster, then install a helm chart on it. 
Then create a Kubernetes deployment through YAML config, that depends on the helm chart being available, and expose a Kubernets service using an ingress resource.

### Modules

Create and use a module from disk and from github.

### Nomad

Create a Nomad cluster, then deploy a Nomad job on it and expose the service using an ingress resource.

### Random

Generate random values and use them in a container.

### Templates

Show template resource, file function, template_file function, then show how to use the generated template.

### Terraform

Use Terraform to provision a container and then use the Terraform output to configure another container.

### HTTP

Make an HTTP request and use the response to configure a container.