### Docker Stuff

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

### Creating Azure Service Principal for kubernetes cluster

`az account show`: get id
`az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription-id>"`  
use appId for client_id variable and password for client_secret
`az aks get-credentials --resource-group <your-app-name> --name <your-app-name>`  
create kubernetes ~/.kube config file that allows to use kubectl
`kubectl get nodes`
