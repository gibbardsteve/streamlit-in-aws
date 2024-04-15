# Terraform

This terraform assumes that the AWS account has been bootstrapped with a domain in route 53.
You can bootstrap a domain using the repository [terraform-bootstrap]

The terraform then builds the necessary components to make a service running on Fargate accessible.

## Main Components

### Network

Currently using the default vpc and subnets. TODO: create public and private subnets.

### Route 53

Used to define a DNS lookup for the domain name. An alias is created to pass all requests to the public facing application load balancer.

### Certifcate Manager

Used to create an SSL certificate for the domain name (wildcard for subdomains). The terraform will validate the certficate using DNS and create a CNAME entry in Route 53.

### Security Groups

A security group is attached to the public facing applcation load balancer. This allows traffic on port 80 (http) and redirects to 443 (https).  Traffic received on 443 is sent to the backend service in Fargate.

A security group is attached to the running service to allow traffic on port 80 to be mapped to the port that is accessible in the running container.

### Application Load Balancer

The load balancer terminates public traffic (using https) and then forwards to the backend service running in Fargate.

### Elastic Container Service

#### Cluster

A cluster that can dynamically allocate resources from FARGATE and FARGATE_SPOT. Note: Dynamic allocation based on traffic increase/decrease is TODO.

#### Service

A service attached to the cluster defines refers to an associated task definition (for resource requirements) and specifies the number of instances of the application to be run. Network configuration also maps the service to the application load balancer, subnets and security groups.

#### Task Definition

The task definition defines the os, memory and cpu requirements of the resources and the container image associated with the application to be run.

#### Task

A task is a running instance of the application defined in the task definition.

### Cloudwatch Logs

A log group is created to stream logs from the running container.