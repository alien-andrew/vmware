# Kubernetes Services

## Pre-requisites

[Kubernetes Pods](networking.md)

## Introduction to Services

![type:video](https://www.youtube.com/embed/-ek3Xajmsoo)

## Log-in to the lab

For this chapter, you will need to be logged in to the 
**lab.carcinize.com** host. If you are already logged-in 
to the lab from previous exercise, proceed to: [Create a Pod](networking.md#create-a-pod)

!!! Instructions 

    1. Open a Terminal and SSH into the lab

          - ** Username ** : student
          - ** Hostname ** : lab.carcinize.com
          - ** Password ** : k8svmware
    
          ``` bash
          ssh student@lab.carcinize.com 
          ```

## Create a Service

!!! Instructions
 
    1. Run the following `kubectl` command to create a Service

          ``` bash
          kubectl apply -f ~/k8s/pod1-service.yaml 
          ```

    2. Take a look at the created service
 
          ``` bash
          kubectl describe service pod1-svc
          ```

    Note the following: 

    - **IP**: ClusterIP Address of the Service
    - **Port**: Access port for the ClusterIP 
    - **TargetPort**: Port of the Pod that the service forwards traffic to
    - **Endpoints**: Pods that match the label selector of the service, thus traffic will be forwarded to one of the Endpoints

## Check Reachability to Service

!!! Instructions

    1. Run the curl command from Pod 2 and target the ClusterIP:8080 address. Replace 
    the ClusterIP with the output from [Create a Service](service-networking.md#create-a-service)

          ``` bash
          kubectl exec echoserver-2 -- curl "ClusterIP:8080"
          ```

## Conclusions and Questions

![type:video](https://conclusion-video-pod-networking.com)


## References

* [Kubernetes Networking Model](https://kubernetes.io/docs/concepts/services-networking/)
