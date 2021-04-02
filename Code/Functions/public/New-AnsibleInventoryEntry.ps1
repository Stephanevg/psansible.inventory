Function New-AnsibleInventoryEntry {
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory = $true)]
        [String]$NodeName,
        [String[]]$Group
    )

    $Entry = [AnsibleInventoryEntry]::new()
    $Entry.NodeName = $NodeName

    if ($group) {

        $Entry.AddToGroup($Group)
    }

    return $Entry
}