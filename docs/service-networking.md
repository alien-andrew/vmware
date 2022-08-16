# Kubernetes Services

## Pre-requisites

[Kubernetes Pods](networking.md)

## Introduction to Services

![type:video](https://www.youtube.com/embed/-ek3Xajmsoo)

## Log-in to the lab

For this chapter, you will need to be logged in to the 
**lab.carcinize.com** host. If you are already logged-in 
to the lab from previous exercise, proceed to: [Create a Service](service-networking.md#create-a-service)

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

    1. Ensure that you have two echoserver Pods running from the previous chapter: 
    [Create a Pod](networking.md)

          ``` bash
          kubectl get pods
          ```

    ** Expected Output **

    ``` bash
    NAME                     READY   STATUS    RESTARTS   AGE
    echoserver-1             1/1     Running   0          10m
    echoserver-2             1/1     Running   0          15m
    ```

    2. Run the curl command from Pod 2 and target the ClusterIP:8080 address. Replace 
    the ClusterIP with the output from [Create a Service](service-networking.md#create-a-service)

          ``` bash
          kubectl exec echoserver-2 -- curl "ClusterIP:8080"
          ```

    3. Do you get a response from the request?

!!! note 

    For services to route traffic to Pods, its selector should match the Pod's labels

## Label the Pod

!!! Instructions

    1. Check the selector of the `pod1-svc`

          ``` bash
          kubectl get svc pod1-svc -ojson | jq ".spec.selector"
          ```

    The selector is "app": "pod1". We can label a Pod using the `kubectl` command or 
    change the Pod manifest yaml file.

    2. Run the following command to label a running Pod

          ``` bash
          kubectl label pod echoserver-1 app=pod1
          ```

    3. Check the Pod labels

          ``` bash
	  kubectl get pods --show-labels
          ```

    4. Obtain the clusterIP of the service and save it in an environment variable for 
    your convenience

          ``` bash
          clusterip=$(kubectl get svc pod1-svc -ojson | jq -r ".spec.clusterIP")
          ```

## Check Reachability to Service (Round 2)

!!! Instructions

    1. Run the curl command from Pod 2 to check for reachability to ClusterIP:8080 address

          ``` bash
          kubectl exec echoserver-2 --  curl "$clusterip:8080"
          ```

    ** Expected Output **

    Note the < echoserver-2 IP > and < ClusterIP > fields

    ``` bash
    client_address= < echoserver-2 IP >
    command=GET
    real path=/
    query=nil
    request_version=1.1
    request_uri=http://< ClusterIP >:8080/
    ```

## Conclusions and Questions

![type:video](https://conclusion-video-pod-networking.com)


## References

* [Kubernetes Networking Model](https://kubernetes.io/docs/concepts/services-networking/)
