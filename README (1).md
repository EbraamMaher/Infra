
# Graduation project ITI









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
## Screenshots

![App Screenshot](Screenshot (1483).png)
