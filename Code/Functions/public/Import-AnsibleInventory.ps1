Function Import-AnsibleInventory {
    [CmdletBinding()]
    Param(
        [System.IO.DirectoryInfo]$Path
    )

    $inv = [AnsibleInventory]::New($Path)

    REturn $Inv
}
