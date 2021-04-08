
# To migrate to readme.md

import-module psansible.inventory


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


#Fetching variabl

$VariableCollection.GetGroupVariables()
$VariableCollection.GetHostVariables()

#Showing Grouping

$VariableCollection.GetGrouping()

$VariableCollection.GetVariable('wsusServer')
$VariableCollection.GetVariableFromContainer('Node0055620.Node-005.dev.woop.net')

#Adding the Variables to the Inventory

$Inventory.SetVariableCollection($VariableCollection)


#Exporting the data
$Inventory.SetPath('./Inventories/Windows/')
#$Inventory.SetPath("D:\Code\esc-ans-win-inv-dev-test\")
$Inventory.Export()





