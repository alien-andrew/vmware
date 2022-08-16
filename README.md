# vmware
VMware Presentation for Kubernetes Networking

## Build

Build Instructions:
1. Build the docker image with the following command from the `vmware` directory: 
```bash
docker build -t username/vmware:v1 .
```

## Run

Hosting Workbook Instructions:
1. Run the following docker command to host the lab workbook:
```bash
docker run -d -p 80:8000 username/vmware:v1
```


