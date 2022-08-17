# Kubernetes Services

## Pre-requisites

* [Pod Networking](networking.md)

## Introduction to Services

![type:video](https://www.youtube.com/embed/3yiyMfYo_n8)

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

## Check Reachability by Service Name

Even better than IP address (unknown until after creation), you can use 
the domain name of the Service (Service name in the manifest)!

!!! Instructions

    1. Run the curl command from Pod 2 to check for reachability to pod1-svc:8080 

          ``` bash
          kubectl exec echoserver-2 -- curl pod1-svc:8080
          ```

## NodePort Service

!!! Instructions

    1. Delete the `pod1-svc` 
          ``` bash
          kubectl delete svc pod1-svc
          ```

    2. Create a NodePort type service from the provided manifest
          ``` bash
          kubectl apply -f ~/k8s/node-service.yaml
          ```

    3. Get the details for the new service

          ``` bash
          kubectl describe svc node-svc
          ```

    4. Create a deployment which will be served by the `node-svc`
          ``` bash
          kubectl apply -f ~/k8s/pod-deployment.yaml
          ```

## Testing Reachability

Unfortunately our `kind` Kubernetes cluster is not so 
kind when it comes to showcasing a typical network setup. 

We will 'login' to the real Kubernetes in Docker host then 
issue the curl command to the node port. 

!!! Instructions

    1. Log-in to the `kind-control-plane` Docker container
          ``` bash
          docker exec -it kind-control-plane /bin/bash
          ```

    2. Issue the `curl` command to `localhost` on port `30001`
          ``` bash
          curl localhost:30001
          ```
    ** Expected Output **
    
    ``` bash
    You've hit pod-deployment-xxx-yyy
    ```

## Conclusions and Questions

![type:video](https://conclusion-video-pod-networking.com)

* Services are used as a stable 'frontend' for Pods (even for Databases)
* Pods must have labels corresponding to Service's selectors
* Service type ClusterIP is for intra-cluster traffic
* Service type NodePort is for external traffic

## References

* [Kubernetes Networking Model](https://kubernetes.io/docs/concepts/services-networking/)
