
# To migrate to readme.md

import-module psansible.inventory

#Creating Hiearchy

$Arch = @()

$Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_managed_windows" -Children "managedsql","managedWINSRV2012R2STD","ManagedWINSRV2016STD","ManagedWINSRV2019STD","sap"





<#
    Working with Variables
#>


New-AnsibleInventoryVariable -Name "plop" -Type Group -Value "WWW" -ContainerName "ABC"

$AllVariables += $HostVariables

#Grouping individual variables in a Variable Collection

$VariableCollection = New-AnsibleInventoryVariableCollection -Variables $AllVariables 


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





