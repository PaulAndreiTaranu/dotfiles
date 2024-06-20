### Docker Stuff

## Docker push to private container registry
`docker login --username user --password pass [SERVER]`
`docker image tag rhel-httpd:latest registry-host:5000/myadmin/rhel-httpd:latest`
`docker image push registry-host:5000/myadmin/rhel-httpd:latest`

## General

format json logs: `docker image inspect hello-world | jq '.[].Config.Env'`
build images: `docker build -t <image-name> --file <path-to-Dockerfile> ./`

### Terraform

`terraform init`
`terraform apply`
`terraform destroy`

### Azure + Terraform

`az login`
`az aks get-versions --location uksouth --output table`: get available versions of Kubernetes  
use azurerm provider for terraform https://github.com/hashicorp/terraform-provider-azurerm  
start creating terraform files: providers.tf resource-group.tf variables.tf

## Creating Azure Service Principal for kubernetes cluster

`az account show`: get id
`az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription-id>"`  
use appId for client_id variable and password for client_secret
`az aks get-credentials --resource-group <your-app-name> --name <your-app-name>`  
create kubernetes ~/.kube config file that allows to use kubectl

### Kubernetes
`kubectl apply -f manifest_file.yaml`: Sends the file to the API server
`kubectl get pods -o wide`
`kubectl describe pod pod_name`: Formatted overview of object like pod or deploy
`kubectl exec pod_name -- command`: Execute commands inside first pod container
`kubectl exec -it pod_name -- command`: Connect terminal to first pod container terminal

