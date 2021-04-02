Function New-AnsibleInventoryHiearchyEntry {
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$ParentName,

        [Parameter(Mandatory = $false)]
        [Array]$Children

    )

    $h = [AnsibleInventoryHiearchyEntry]::New($ParentName)

    If ($Children) {
        $h.AddChild($Children)
    }

    Return $h

}