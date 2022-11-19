
# Graduation project ITI




## Mission
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/Picture1.png)


## plan

### A- Infra structure creation using terraform:
        1- craete dedicated project and initialize terraform with it.
        2- create network and vm instance “bastion”.
        3- create GKE with master and 1 worker node.

### B- deploy Jenkins [master and agent] within a dedicated namespace:
	      1- create master and slave deployments inside worker node.
 	      2- configure the agent with master.
	      3- create a pipline to work with my GitHub app repo. To provide build and deploy for each change in the application code.



## Deployment

To deploy this project run

```terraform
  run the following commands :
  terraform init
  terraform apply
```
at the end of infra structure creation you will get 2 gcloud commands:

1- to ssh to bastion
2- to connect to cluster 

after ssh to vm you have to install these tools:
1- docker
2- kubectl

then you can build and push the image to GCR using these instructions:
https://cloud.google.com/container-registry/docs/pushing-and-pulling

after that Deployment stage using kubectl

by getting the external ip and port you can access the app :

```kuebctl 
  kubectl get pods -n app
  kubectl get svc -n app
```
## Project graph

pictures credits :
#### Creditis : https://cloud.google.com/blog/products/devops-sre/guide-to-creating-custom-base-images-for-gcp-with-jenkins-and-packer
   #### https://janpreet.com/tech/2020/12/08/terraform-gcp-k8s.html

![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/Screenshot%20(1483).png)
