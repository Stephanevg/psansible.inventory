Function New-AnsibleInventoryGrouping {
    Param(
        [Parameter(Mandatory = $true)]
        [String]$Name,
        $Members,
        [Switch]$HasChildren

    )

    $Grouping = [AnsibleInventoryGrouping]::New($Name)
    If ($Members) {
        $Grouping.AddMember($Members)
    }

    If ($HasChildren) {
        $Grouping.SetHasChildren($True)
    }

    Return $Grouping
}