Function Import-AnsibleInventoryHiearchy {
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )

    If (($Path.Exists) -and ($path.Extension -eq '.csv')) {
        $rawData = import-csv -Path $Path.FullName -Delimiter ';'
        $Arch = @()
        Foreach ($Line in $rawData) {
            $Arch += New-AnsibleInventoryHiearchyEntry -ParentName $Line.Parent -Children ($Line.Children -split ",")
        }

        return $Arch
    }
    else {
        throw "either the file does not exists, or it is not a .csv file."
    }
}