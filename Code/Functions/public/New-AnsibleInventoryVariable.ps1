Function New-AnsibleInventoryVariable {
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$Name,

        [Parameter(Mandatory = $true)]
        $Value,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Host", "Group")]
        [AnsibleVarType]$Type,

        [Parameter(Mandatory = $true)]
        $ContainerName




    )
    $var = [AnsibleVar]::New()
    $var.Name = $Name
    $Var.Value = $Value
    $var.VarType = $Type
    $var.ContainerName = $ContainerName
    Return $var

}