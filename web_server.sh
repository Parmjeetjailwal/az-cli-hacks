#! /bin/bash

# Variables
PREFIX=olivetech

ENV_NAME=dev

SUFFIX=rg

RG_NAME=$PREFIX-$ENV_NAME-$SUFFIX

RG_LOCATION=centralindia

VM_NAME=$PREFIX-vm

ADMIN_USERNAME=OlivetechUser

WIN_VM_IMAGE=Win2019Datacenter

VM_SIZE=Standard_D2s_v3

# LINUX_VM_IMAGE=UbuntuLTS

# Create a resource group.
echo -e "\nResource Group creation in progress...."

az group create --name $RG_NAME --location $RG_LOCATION

echo -e "\nResource Group Created Successfully...."

# Create a Windows virtual machine (Provide admin password when prompted)
az vm create --resource-group $RG_NAME --name $VM_NAME --image $WIN_VM_IMAGE --size $VM_SIZE --public-ip-sku Standard --admin-username $ADMIN_USERNAME

# Create a Linux virtual machine, this creates SSH keys if not present.
# az vm create --resource-group $RG_NAME --name $VM_NAME --image $LINUX_VM_IMAGE --generate-ssh-keys

echo -e "\nVM Created Successfully...."

# Open port 80 to allow web traffic to host
echo -e "\nOpening port 80 to allow web traffic...."

az vm open-port --port 80 --resource-group $RG_NAME --name $VM_NAME

# Use CustomScript extension to install IIS on Windows VM
echo -e "\nExecution of CustomScript Extension in progress...."

az vm extension set --publisher Microsoft.Compute --version 1.8 --name CustomScriptExtension --vm-name $VM_NAME --resource-group $RG_NAME --settings '{"commandToExecute":"powershell.exe Install-WindowsFeature -Name Web-Server"}'

# Use CustomScript extension to install NGINX on linux VM
# az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $VM_NAME --resource-group $RG_NAME --settings '{"commandToExecute":"apt-get -y update && apt-get -y install nginx"}'

# List Private and Public IP Addresses of VM
az vm list-ip-addresses -g $RG_NAME -n $VM_NAME
