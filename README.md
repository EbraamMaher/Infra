
# Graduation project ITI




## Mission
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/Picture1.png)


## plan

### I- Infra structure creation using terraform:
        1- craete dedicated project and initialize terraform with it.
        2- create network and vm instance “bastion”.
        3- create GKE with master and 1 worker node.

### II- deploy Jenkins [master and agent] within a dedicated namespace:
	      1- create master and slave deployments inside worker node.
 	      2- configure the agent with master.
	      3- create a pipline to work with my GitHub app repo. To provide build and deploy for each change in the application code.



## detailed steps: 

### infrastructure phase:

```terraform
  run the following commands :
  terraform init
  terraform apply
```
at the end of infra structure creation you will get 2 gcloud commands:

1- to ssh to bastion

2- to connect to cluster 

![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/pictures/3.png)


##### prepare the bastion

###### after ssh to vm you in order to prepare the vm to build and deploy you have to install these tools:

1- install docker  : https://docs.docker.com/engine/install/debian/
2- install keubctl : https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

###### then authenticate your account : 
```gcloud
   gcloud auth login
```

###### then connect to the cluster using the *2nd command printed out* after terraform created all resources.


###### check :
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/pictures/4.png)
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/pictures/5.png)

##### deploy jenkins as a pod in a dedicated namespace : 


```kubectl
	kubectl create ns ns-jenkins
	kubectl apply -f master.yaml  
	keubctl get svc -n ns-jenkins
```

then access jenkins using url : http://external ip :port
to get initial password for jenknis : kubect logs <pod-name> -n ns-jenkins

then install plugins and put credentails for docker hub and gcloud which we will need later
then access jenkins using url : http://external ip :port
to get initial password for jenknis : kubect logs <pod-name> -n ns-jenkins

###### then install plugins and put credentails for docker hub and gcloud which we will need later 

	


###### after that Deployment stage using kubectl

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
