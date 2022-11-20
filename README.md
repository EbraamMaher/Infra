
# Webapp deployment on Kubernetes using CICD Jenkins pipeline through GCP

## Graduation project ITI




## Mission
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/Picture1.png)

	

## The big picture


#### pictures Creditis : https://cloud.google.com/blog/products/devops-sre/guide-to-creating-custom-base-images-for-gcp-with-jenkins-and-packer
   #### https://janpreet.com/tech/2020/12/08/terraform-gcp-k8s.html

![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/Screenshot%20(1483).png)


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

###### then connect to the cluster using the **2nd command printed out** after terraform created all resources.


##### check :
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/pictures/4.png)
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/pictures/5.png)


##### deploy jenkins as a pod in a dedicated namespace : 

##### Jenkins Master
```kubectl
	kubectl create ns ns-jenkins
	kubectl apply -f master.yaml  
	keubctl get svc -n ns-jenkins
```

###### then access jenkins using url : http://external ip :port

##### check :
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/pictures/6.png)


to get initial password for jenknis : 

```kubectl
	kubect logs <pod-name> -n ns-jenkins
```

then install plugins and put credentails for *docker hub* and *GCP* which we will need later

###### now access jenkins using url : **http://external_ip:port**

*note*: to get initial password for jenknis : kubect logs <pod-name> -n ns-jenkins

###### then install plugins and put credentails for docker hub and gcloud which we will need later 

	
##### Jenkins Agent

we now need to create and build agent **noting that** it needs many tools like gcloud , docker,kubernetes "helm if needed " and ssh

so,now we have to login to docker hub **since we need to push agent image to allow GKE to pull it when deploying the agent**

then build the image and push it to docker hub 
```kubectl 
	kubectl apply -f slave.yaml  
	kubectl exec -it <pod-name> bash -n ns-jenkins
```
	
now we can configure the agnet

**Note** : have to check that ssh is running using this command 
```linux
	service ssh status

and if not running start it : 
     service ssh start
  or /etc/init.d/ssh start
```
also we may have issue with docker.sock and can solve it by changing permission for **/var/run/docke.sock**

##### check :
![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/pictures/7.png)
	

### Application phase [build and deploy]:

	##### now we can build our pipline and configure github with jenkins to trigger the process with each push on app repo **https://github.com/EbraamMaher/web-app/tree/main**




![App Screenshot](https://github.com/EbraamMaher/Infra/blob/master/pictures/app2.gif)
	
