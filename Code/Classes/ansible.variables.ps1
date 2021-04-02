
Enum AnsibleVarType {
    Group
    Host
}

Class AnsibleVar {
    [String]$Name
    [object]$Value
    [AnsibleVarType]$VarType
    [String]$ContainerName

    AnsibleVar() {}

    AnsibleVar([String]$Name, [Object]$Value) {
        $this.Name = $Name
        $This.Value = $Value
    }

    AnsibleVar([String]$Name, [Object]$Value, [AnsibleVarType]$VarType) {
        $this.Name = $Name
        $This.Value = $Value
        $this.SetVarType($VarType)
    }

    AnsibleVar([String]$Name, [Object]$Value, [AnsibleVarType]$VarType, [String]$ContainerName) {
        $this.Name = $Name
        $This.Value = $Value
        $this.SetVarType($VarType)
        $this.SetContainerName($ContainerName)
    }

    SetVarType([AnsibleVarType]$VarType) {
        $this.VarType = $VarType
    }

    SetContainerName([String]$ContainerName) {
        $this.ContainerName = $ContainerName
    }

    [string] ToString() {
        return "[{0}] {1}:{2}" -f $this.ContainerName, $this.Name, $this.Value
    }
}

Class AnsibleVariableCollection {
    [AnsibleVar[]]$Variables
    [System.IO.DirectoryInfo]$Path

    AnsibleVariableCollection() {}

    AnsibleVariableCollection([AnsibleVar[]]$Variables) {
        $this.SetVariables($Variables)
    }

    AddVariable([AnsibleVar]$Variable) {
        $this.Variables += $Variable
    }

    SetVariables([AnsibleVar[]]$Variables) {
        $This.Variables = $Variables
    }

    [Object]GetGrouping() {
        Return $This.Variables | Group-Object -Property 'ContainerName'
    }

    SetPath([System.Io.DirectoryInfo]$Path) {
        $This.Path = $Path
        $this.Path.Refresh()
        
    }

    Export() {
        
        If (!($this.Path.Exists)) {
            $this.Path.Create()
            $this.path.Refresh()
        }
        If ($this.Path.Exists) {
            #Exporting Group_vars

            [System.Io.DirectoryInfo]$GroupVarsFolder = join-Path -Path $This.Path.FullName -ChildPath "group_vars"
            
            If (!($GroupVarsFolder.Exists)) {
                $Null = New-Item -Path $GroupVarsFolder.FullName -ItemType Directory
            }


            [System.Io.DirectoryInfo]$HostVarsFolder = join-Path -Path $This.Path.FullName -ChildPath "host_vars"

            If (!($HostVarsFolder.Exists)) {
                $Null = New-Item -Path $HostVarsFolder.FullName -ItemType Directory
            }

            

            Foreach ($gvar in $this.GetGroupVariables() | Group-Object ContainerName) {
                $GroupVarFile = $Null
                [System.IO.FileInfo]$GroupVarFile = Join-Path -Path $GroupVarsFolder.FullName -ChildPath ($gvar.Name + ".yml")
                
                If (!($GroupVarFile.Exists)) {
                    $Null = New-Item -ItemType File -Path $GroupVarFile.FullName
                }

                $gvar.Group | ConvertTo-Yaml -OutFile $GroupVarFile.FullName -Force

                <#
                
                $GroupVarData = ""
                $GroupVarData += "---`n"

                foreach($gv in $gvar.Group){
                    $GroupVarData += $gv.Name + ": " + $gv.Value + "`n"
                }

                Set-Content -Path $GroupVarFile.FullName -Value $GroupVarData -Force -Encoding utf8NoBOM
                #>



            }

            Foreach ($hvar in $this.GetHostVariables() | Group-Object ContainerName) {
                $HostVarFile = $Null
                [System.IO.FileInfo]$HostVarFile = Join-Path -Path $HostVarsFolder.FullName -ChildPath ($hvar.Name + ".yml")
                
                If (!($HostVarFile.Exists)) {
                    $Null = New-Item -ItemType File -Path $HostVarFile.FullName
                }

                $hvar.Group | ConvertTo-Yaml -OutFile $HostVarFile.FullName -Force
                <#
                
                $HostVarData = ""
                $HostVarData += "---`n"

                foreach($hv in $hvar.Group){
                    $HostVarData += $hv.Name + ": " + $hv.Value + "`n"
                }

                 Set-Content -Path $HostVarFile.FullName -Value $HostVarData -Force -Encoding utf8NoBOM # Should be created without bom
                #>

                <#
                https://stackoverflow.com/questions/5596982/using-powershell-to-write-a-file-in-utf-8-without-the-bom
                    $MyRawString = Get-Content -Raw $MyPath
                    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
                    [System.IO.File]::WriteAllLines($MyPath, $MyRawString, $Utf8NoBomEncoding)
                #>

               
            }


        }
        else {
            Throw "Error: $($this.Path.FullNAme) Does not exists"
        }
    }

    [AnsibleVar[]]GetGroupVariables() {
        $AllGroupVariables = @()
        $AllGroupVariables = $This.Variables | ? { $_.VarType -eq 'Group' }
        Return $AllGroupVariables
    }

    [AnsibleVar[]]GetHostVariables() {
        $AllGroupVariables = @()
        $AllGroupVariables = $This.Variables | ? { $_.VarType -eq 'Host' }
        Return $AllGroupVariables
    }

    [AnsibleVar[]]GetVariable([String]$Name) {
        $TempVars = @()
        $TempVars = $This.Variables | ? { $_.Name -eq $Name } | Sort-Object ContainerName
        Return $TempVars
    }

    [AnsibleVar[]] GetVariableFromContainer($ContainerName) {
        $TempVars = @()
        $TempVars = $This.Variables | ? { $_.ContainerName -eq $ContainerName }
        Return $TempVars
    }
}
