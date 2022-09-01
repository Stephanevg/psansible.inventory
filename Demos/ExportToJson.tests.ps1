# To migrate to readme.md

import-module ../psansible.inventory/psansible.inventory.psm1 -Force


# Creating a new inventory

$Inventory = New-AnsibleInventory
$Inventory

#Creating Hiearchy

$Arch = @()

$Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_prod_servers" -Children "all_hr_servers","all_marketing_servers","all_database_servers"
$Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_database_servers" -Children "all_mongodb_servers","all_postgres_servers"
$Arch

$Inventory.AddHiearchy($Arch)

<#
    Working with Variables
#>

$vars = @()
$vars += New-AnsibleInventoryVariable -Name "plop" -Type Group -Value "WWW" -ContainerName "ABC"
$vars += New-AnsibleInventoryVariable -Name "maintenance_time" -Type Host -Value "sunday" -ContainerName "server123"
$vars

#Adding a variable to an PsAnsibleInventory

$Inventory.AddVariable($vars) 

$Inventory

$Inventory.ExportToJson()


