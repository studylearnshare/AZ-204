# https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest
# VM Provision using Azure CLI
#https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1

#  login 
az login 

# list of all locations 
az account list-locations -o table

# create a resource group
az group create --name "tGroupA" --location "westus"

az group list -o table

# create network 
az network vnet create --resource-group "tGroupA" --name "tGroupA-vnet-1" --address-prefix "10.1.0.0/16" --subnet-name "tGroupA-subnet-1" --subnet-prefix "10.1.1.0/24"

az network vnet list -o table

# create public ip
az network public-ip create --resource-group "tGroupA" --name "tGroupA-machine-1-pip-1"

# network security group
az network nsg create  --resource-group "tGroupA" --name "tGroupA-machine-1-nsg-1"

az network nsg list -o table

# network interface
az network nic create --name "tGroupA-machine-1-nic-1" --resource-group "tGroupA" --vnet-name "tGroupA-vnet-1" --subnet "tGroupA-subnet-1" --network-security-group "tGroupA-machine-1-nsg-1" --public-ip-address "tGroupA-machine-1-pip-1"

az network nic list -o table

# list virtual machine images
az vm image list -o table

# create keyvault
az keyvault create --name "tGroupA-keyvault-1" --resource-group "tGroupA" --location "westus"

# add key/secret
az keyvault secret set --vault-name "tGroupA-keyvault-1" --name "WinMachines" --value "$123AZ#321qwa#"

$secret = az keyvault secret show --vault-name "tGroupA-keyvault-1" --name "WinMachines" --query value

# create VM
az vm create --resource-group "tGroupA" --location  "westus"  --name "win2019-vm" --nics "tGroupA-machine-1-nic-1" --image "Win2019Datacenter" --admin-username "adminmk" --authentication-type "password" --admin-password $secret

# open port # option 
az vm open-port --resource-group "tGroupA"  --name "win2019-vm" --port "3389"

az vm list-ip-address -name "win2019-vm" o -table