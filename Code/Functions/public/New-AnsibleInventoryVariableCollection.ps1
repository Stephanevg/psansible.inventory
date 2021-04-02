Function New-AnsibleInventoryVariableCollection {
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory = $False)]
        $Variables
    )
    If ($Variables) {
        $collection = [AnsibleVariableCollection]::New($Variables)
    }
    else {
        $Collection = [AnsibleVariableCollection]::New()
    }

    Return $collection
    
}