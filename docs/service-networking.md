# Introduction to Networking

## Pod Networking

![type:video](https://www.youtube.com/embed/-ek3Xajmsoo)

### Log-in to the lab

!!! Instructions 

    1. Open a Terminal and SSH into the lab

         - ** Username ** : student
         - ** Hostname ** : lab.carcinize.com
         - ** Password ** : k8svmware
    
    ``` bash
    ssh student@lab.carcinize.com 
    ```

### Create a Pod

!!! Instructions
 
    1. Run the `kubectl` command to create a Pod

    ``` bash
    kubectl apply -f ~/k8s/pod.yaml 
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

    2. You can also use the `jq` to parse the json output.
    Run the following command to save the PodIP as an environment variable:
    ``` bash
    podip=$(kubectl get po -ojson | jq -r ".items[].status.podIP")
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

    Does the curl command return with an output?

## Service Networking

Service Network content
