# Pod Networking

## Pre-requisites

[Kubernetes Pods](pods.md)

## Introduction to Pod Networking

![type:video](https://www.youtube.com/embed/MWxKY-I3veI)

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

## Create a Pod

!!! Instructions
 
    1. Run the `kubectl` command to create a Pod

          ``` bash
          kubectl apply -f ~/k8s/pod1.yaml 
          ```

    2. Check the Pod Status 

          ``` bash
          kubectl get pod
          ```
   
    3. Wait for the Pod STATUS to indicate **Running**

### Review Network Details

!!! Instructions

    1. Run the following command to query for the Pod's IP Address

          ``` bash
          kubectl get pod -o wide
          ```

    2. You can also use the `jq` command to parse the json output.
    Run the following command to save the PodIP as an environment variable:

          ``` bash
          podip=$(kubectl get po -ojson | jq -r ".status.podIP")
          ```

    3. Check the variable to ensure it has been set:

          ``` bash
          echo $podip
          ```
       
    Output above should match the IP address of the pod from 
    `kubectl get pod -o wide`

### Pod Access using Curl

!!! Instructions

    1. Issue a `curl` command to the Pod IP address
          ``` bash
          curl --connect-timeout 5 $podip 
          ```

    2. Does the curl command return with an output?

!!! note

    In our environment, we are using `kind` which runs 
    Kubernetes in a Docker container. While in most 
    deployments, Pods should be directly reachable from 
    the node it is running on, it does not work the same 
    way in this environment.

## Create a Second Pod

We know that Kubernetes Networking model allows for Pod to Pod 
communication by default. Let's create another Pod to test 
the connection from one Pod to another.

!!! Instructions

    1. Create a second Pod
    
          ``` bash
          kubectl apply -f ~/k8s/pod2.yaml
          ```
 
    2. Start an interactive bash session in the second Pod

          ``` bash
          kubectl exec -it echoserver-2 /bin/bash
          ```

    3. Issue a curl command to the first Pod (echoserver-1)
    Replace `pod1IP` with the address you gathered from 
    [Network Details](networking.md#review-network-details)

          ``` bash
          curl pod1IP:8080
          ```
 
    **Expected Output**

    ``` bash
    CLIENT VALUES:
    client_address= < Pod 2 IP address >
    command=GET
    real path=/
    query=nil
    request_version=1.1
    request_uri=http://< Pod 1 IP address >:8080/
    
    SERVER VALUES:
    server_version=nginx: 1.10.0 - lua: 10001
    
    hEADERS RECEIVED:
    accept=*/*
    host=< Pod 1 IP address >:8080
    user-agent=curl/7.47.0
    bODY:
    -no body in request-
    ```

## Conclusions and Questions

![type:video](https://youtube.com/embed/cT4geQAAZ4E)

* In Kubernetes, all Pods can communicate to all other Pods in the cluster by default
* Should applications be written to talk directly to Pod IP? 
* Should all pods have access to all other pods?

## References

* [Kubernetes Networking Model](https://kubernetes.io/docs/concepts/services-networking/)
* [Kubernetes Network Plugins](plugins.md)
