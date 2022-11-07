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
