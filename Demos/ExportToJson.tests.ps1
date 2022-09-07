# To migrate to readme.md

import-module ../psansible.inventory/psansible.inventory.psm1 -Force


# Creating a new inventory

$Inventory = New-AnsibleInventory

#Creating Hiearchy

$Arch = @()

$Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_prod_servers" -Children "all_hr_servers","all_marketing_servers","all_database_servers"
$Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_database_servers" -Children "all_mongodb_servers","all_postgres_servers"
$Arch

$Inventory.AddHiearchy($Arch)



#Creating servers and groups
$Servers = @()
$Servers+= "woop1"
$Servers+= "woop2"
$Servers+= "woop3"
$Servers+= "woop4"

$hrservers = @()
$hrservers+= "woop5"
$hrservers+= "woop6"
$hrservers+= "woop7"
$hrservers+= "woop8"

Foreach($ser in $servers){
    $entry = New-AnsibleInventoryEntry -NodeName $ser -Group "all_mongodb_servers"
    $Inventory.AddInventoryEntry($entry)
}


Foreach($ser in $hrservers){
    $entry = New-AnsibleInventoryEntry -NodeName $ser -Group "all_hr_servers"
    $Inventory.AddInventoryEntry($entry)
}

$E = New-AnsibleInventoryEntry -NodeName "IamAlone" -Group "" 
$Inventory.AddInventoryEntry($E)
#Creating and Adding variables to PsAnsibleInventory

$vars = @()
$vars += New-AnsibleInventoryVariable -Name "plop" -Type Group -Value "WWW" -ContainerName "ABC"
$vars += New-AnsibleInventoryVariable -Name "maintenance_time" -Type Host -Value "sunday" -ContainerName "server123"
$vars += New-AnsibleInventoryVariable -Name "stage" -Value "prod" -ContainerName "all_prod_servers" -Type Group
$vars += New-AnsibleInventoryVariable -Name "wsus_server" -Value "http://plop.com" -ContainerName "all_prod_servers" -Type Group
$vars += New-AnsibleInventoryVariable -Name "wsus_server" -Value "http://plop.child.com" -ContainerName "all_hr_servers" -Type Group
$vars += New-AnsibleInventoryVariable -Name "Building" -Value "HR_01" -ContainerName "all_hr_servers" -Type Group
$vars += New-AnsibleInventoryVariable -Name "maintenance_time" -Type Host -Value "sunday" -ContainerName "woop5"
$vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "tempadmin" -ContainerName "woop5"
$vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop1"
$vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop2"
$vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop3"
$vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop4"
$vars += New-AnsibleInventoryVariable -Type Group -Name "entity" -Value "os.services.windows.2019" -ContainerName "woop4"


$Inventory.AddVariable($vars) 

#Creating Hiearchy

#all -> children


$Inventory.ToJson()


