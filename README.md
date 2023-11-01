# Examples
This repository contains example code that shows you how to do common things in sandbox environments using Jumppad.

## Container
Create a single container.

## Containers
Create multiple containers with a dependency between them.

## Database
Create a postgres database and populate it with data.
Then query that data using a remote exec.

## Work in progress
The following examples are still being worked on, or work has not yet started.

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