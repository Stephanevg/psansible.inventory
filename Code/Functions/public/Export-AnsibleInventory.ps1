Function Export-AnsibleInventory {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$Path,
        [Parameter(Mandatory = $true)]
        [string]$OutputType = "INI",
        [Parameter(Mandatory = $true)]
        [AnsibleInventory]$Inventory
    )

    $Inventory.SetOutputType($OutputType)
    $Inventory.SetPath($Path.FullName)
    $Inventory.Export()

}