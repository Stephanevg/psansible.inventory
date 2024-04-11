<#
.SYNOPSIS
Exports an Ansible inventory to a specified directory in the specified format.

.DESCRIPTION
This function exports an Ansible inventory to the specified directory in the specified format. It allows users to customize the output format and directory path.

.PARAMETER Path
Specifies the directory where the Ansible inventory file will be exported. This parameter is mandatory.

.PARAMETER OutputType
Specifies the format of the exported inventory file. Default is "INI". This parameter is optional.

.PARAMETER Inventory
Specifies the Ansible inventory object to be exported. This parameter is mandatory.

.EXAMPLE
Export-AnsibleInventory -Path "C:\Ansible\Inventory" -OutputType "YAML" -Inventory $MyInventory
Exports the Ansible inventory object $MyInventory to the directory "C:\Ansible\Inventory" in YAML format.

#>
Function Export-AnsibleInventory {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$Path,
        [Parameter(Mandatory = $false)]
        [AnsibleInventoryOutputType]$OutputType = "INI",
        [Parameter(Mandatory = $true)]
        [AnsibleInventory]$Inventory
    )

    $Inventory.SetOutputType($OutputType)
    $Inventory.SetPath($Path.FullName)
    $Inventory.Export()

}