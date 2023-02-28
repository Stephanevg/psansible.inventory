Function New-AnsibleInventoryHierarchyEntry {
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$ParentName,

        [Parameter(Mandatory = $false)]
        [Array]$Children

    )

    $h = [AnsibleInventoryHierarchyEntry]::New($ParentName)

    If ($Children) {
        $h.AddChild($Children)
    }

    Return $h

}