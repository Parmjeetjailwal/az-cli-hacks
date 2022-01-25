#! /bin/bash

SUFFIX=<Enter Resource Group Suffix>

PREFIX=<Enter Resource Group Prefix>

RG_NAME=$PREFIX-storage-$SUFFIX

RG_LOCATION=<Enter Resource Group Location>

STORAGE_ACCOUNT_NAME=<Enter storage account name which must be unique across all existing storage account names in Azure>

# Creates Resource Group
az group create --location $RG_LOCATION --name $RG_NAME

echo -e "\nResource Group Created Successfully...." 

echo "\nStorage Account Creation in Progress...."

# Creates Azure Storage Account
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RG_NAME --location $RG_LOCATION --sku "Standard_LRS"

echo "\nStorage Account Created Successfully...." 

# Update service-properties for static website with index.html and error.html documents
az storage blob service-properties update --account-name $STORAGE_ACCOUNT_NAME --static-website --404-document error.html --index-document index.html

echo "\nUploading Files...." 

# Upload Static Content in $web container
az storage blob upload-batch --account-name $STORAGE_ACCOUNT_NAME -s </full/path/to/file> -d '$web'

echo "\nAll files uploded Successfully...."

# Shows Static WebPage URL
az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RG_NAME --query "primaryEndpoints.web" --output table

