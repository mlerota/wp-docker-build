# WordPress build on Docker for Kubernetes

This build is based upon [Ubuntu 18.04](https://www.ubuntu.com/) core docker image and PHP 7.2 packages from official apt
repository. The build is using WordPress Bedrock [build](https://github.com/mlerota/wordpress-kubernetes) repo for building
WordPress. The philosophy behind Bedrock is that it's good for Kubernetes deployments because it is inspired by the
[Twelve-Factor App](http://12factor.net/) methodology and it's good for development of WordPress. 

## Features

* Clean 
* Not complicated
* Amazon AWS ELB service example 
* Kubernetes deployment example 
* Jenkinsfile for automated builds with Jenkins

## Requirements

* kubectl - [Install](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* Jenkins 
* Docker on Jenkins machine - "apt-get install docker.io" is OK
* Kubernetes cluster

## Installation

1. Before deployment, create a secret dot_env file for WP/MySQL connection and execute: 

  `kubectl create secret generic yoursecretname --from-file=./dot_env`

2. Create two Jenkins pipelines. One from [WP code build](https://github.com/mlerota/wordpress-kubernetes),
   second for Docker image build (this repo)

3. Change servername in nginx/site.conf from WP code build

4. Change registry from Jenkinsfile to point to your docker repo

5. Give Jenkins permissions to execute docker `usermod -a -G docker jenkins`

6. Configure Jenkins to have permission to execute other jobs. You will see this when you start the build.

7. Configure Jenkins (Manage, Configure system) Shell executable: /bin/bash

8. Add your credentials for Docker hub in Jenkins

## Deploys

1. Check aws-elb-service.yml and change arn and remove/change loadBalancerSourceRanges

2. Check wp-deployment.yml and change the image

3. Deploy Kubernetes pods `kubectl apply -f wp-deployment.yml`

4. Deploy AWS ELB ingress `kubectl apply -f aws-elb-service.yml`

