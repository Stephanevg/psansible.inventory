#Generated at 09/03/2021 13:09:05 by Stephane van Gulick


Class AnsibleInventoryEntry {

    [String]$NodeName
    $GroupMemberShip = [System.Collections.Generic.List[string]]::new()
    

    AnsibleInventoryEntry() {}

    AnsibleInventoryEntry([String]$NodeName) {
        $this.NodeName = $NodeName
    }

    AnsibleInventoryEntry($NodeName, $GroupMemberShip) {
        $this.GroupMemberShip = $GroupMemberShip
        $this.NodeName = $NodeName
    }

    AddToGroup([String]$Group) {
        $this.GroupMemberShip.Add($Group)
    }

    [String]ToString() {
        Return "{0} {1} {2}" -f $this.NodeName, "->", ($this.GroupMemberShip -join ",")
    }

    [Bool]IsInGroup([String]$GroupName) {
        Return ($this.GroupMemberShip.contains($GroupName))
    }


}


Class AnsibleInventoryEntryCollection {
    
    [System.Collections.Generic.List[AnsibleInventoryEntry]] $Entries = [System.Collections.Generic.List[AnsibleInventoryEntry]]::new()

    AnsibleInventoryEntryCollection() {}

    AnsibleInventoryEntryCollection([AnsibleInventoryEntry[]]$Entry) {

            $this.AddEntry($Entry)

    }

    AddEntry($Entry) {
        foreach ($ent in $Entry) {
            $this.Entries.add($ent)
        }
        
    }

    [AnsibleInventoryEntry] GetEntry([String]$NodeName) {
        Return ($this.Entries | ? { $_.NodeName -eq $NodeName })
    }

    [String] ToString() {
        Return "TotalEntries: {0}" -f $this.Entries.Count
    }

    [System.Collections.Generic.List[AnsibleInventoryEntry]] GetEntries() {
        return $this.Entries
    }

    [AnsibleInventoryGrouping[]]CreateGrouping() {
        $Groupings = @{}
        Foreach ($entry in $This.Entries) {

            foreach ($groupName in $entry.GroupMemberShip) {
                If (!($groupings.ContainsKey($groupName))) {
                    $groupings.$GroupName = [System.Collections.Generic.List[String]]::new()

                }

                If (!($groupings.$GroupName.Contains($entry.NodeName))) {
                    $groupings.$GroupName.Add($Entry.NodeName)
                }
            }

        }
        
        $ansgrp = @()
        foreach ($grpkey in $Groupings.Keys) {
            $g = New-AnsibleInventoryGrouping -Name $grpkey -Members $Groupings.$grpkey
            $ansgrp += $g
            $g = $null
        }

        return $ansgrp
    }

}
 
Class AnsibleInventoryGrouping {
    [String]$Name
    $members = [System.Collections.Generic.List[string]]::new()
    [Bool]$HasChildren

    AnsibleInventoryGrouping() {

    }

    AnsibleInventoryGrouping([string]$Name) {
        $this.Name = $Name
    }

    AnsibleInventoryGrouping([String]$Name, [Array]$Members) {
        $this.Name = $Name
        $this.Members = $Members
    }

    AddMember([String[]]$Members) {
        foreach ($member in $members) {
            write-verbose "Adding member $($member)"
            $this.members.add($member)
        }
        
    }

    [array] GetMembers() {
        return $this.members
    }

    [bool]HasMember([string]$MemberName) {
        return $this.members.Contains($MemberName)
              
    }

    [String] ToIni() {
        $string = ""


        if($this.HasChildren){
            $String += "[{0}:{1}]`n" -f $this.Name,"children"
        }else{
            $String += "[{0}]`n" -f $this.Name
        }

        
        foreach ($member in $this.members) {
            $String += "$($member)`n"
        }
        $string += "`n"

        return $String
    }

    [void]SetHasChildren([bool]$HasChildren) {
        $this.HasChildren = $HasChildren
    }
}

Class AnsibleInventoryGroupingCollection {
    
    [System.Collections.Generic.List[AnsibleInventoryGrouping]]$Groups = [System.Collections.Generic.List[AnsibleInventoryGrouping]]::new()

    AnsibleInventoryGroupingCollection() {
        
    }

    AnsibleInventoryGroupingCollection($Groups) {
        $this.AddGrouping($Groups)
    }

    AddGrouping($Grouping) {
        foreach ($group in $grouping) {
            if($this.Groups){

                $GroupAlreadyExisting = $this.groups | ? {$_.Name -eq $group.Name}
                    

                if(($GroupAlreadyExisting) -and (!($GroupAlreadyExisting.hasChildren))){
    
                    #Group is NOT an arch group, and group is already present. adding members to the group.
    
                    
                    Foreach($member in $group.members){
    
                        $GroupAlreadyExisting.AddMember($member)
                    }
                }else{
    
                    #New group (not the first one)
                    $this.Groups.Add($group)
                }
            }else{
                #New and first group
                $this.Groups.Add($group)
            }
        }
        
    }

    [String]GetGroupNames() {
        return ($This.Groups.Name -join ",")
    }

    [String]ToString() {
        Return $This.Groups.Name -join ","
    }

    [string]ConvertToIni() {
        $String = ""
        Foreach ($group in $this.Groups) {
            $String += $Group.ToIni()
        }

        return $String
    }
}

Class AnsibleInventoryHiearchyEntry {
    $Parent
   [System.Collections.Generic.List[String]]$Children = [System.Collections.Generic.List[String]]::new()

   AnsibleInventoryHiearchyEntry(){}

   AnsibleInventoryHiearchyEntry($Parent) {
       $This.Parent = $Parent
   }

   AnsibleInventoryHiearchyEntry($Parent, $Children) {

       $this.Parent = $Parent
       $this.AddChild($Children)
   
   }

   [void] AddChild([string[]]$children) {
       foreach ($child in $children) {

           $this.Children.Add($Child)
       }
   }

   [Bool] HasChild([string]$Child) {
       return $this.Children.Contains($Child)
   }

   [String] ConvertToIni() {
       $FullString = ""
       
       $FullString += "[$($this.Parent):children]`n"
       Foreach ($Child in $this.children) {
           $FullString += "$($Child)`n"
       }

       $FullString += "`n"
       

       Return $FullString
   }

   [String] ToString() {
       Return  "{0} -> {1}" -f $this.Parent, ($this.Children -join ",")
   }
}

Class AnsibleInventoryHiearchyCollection {

   $Entries = [System.Collections.Generic.List[AnsibleInventoryHiearchyEntry[]]]::new()

   AnsibleInventoryHiearchyCollection() {
       
   }

   
   AnsibleInventoryHiearchyCollection([AnsibleInventoryHiearchyEntry[]]$Entry) {
       $this.Entries.Add($Entry)
   }

   AddEntry($Entry) {
       foreach ($ent in $Entry) {
           $this.Entries.add($ent)
       }
       
   }


   [string]ConvertToIni() {
       $String = ""
       Foreach ($arch in $this.Entries) {
           $String += $arch.ConvertToIni()
       }

       return $String
   }


   [AnsibleInventoryGrouping[]]CreateGrouping() {
       $Groupings = @{}
       

       $ansgrp = @()
       #Working on parent elements
       Foreach($archelement in $this.Entries){
           $g = New-AnsibleInventoryGrouping -Name $archelement.parent -Members $archelement.children -HasChildren
           $ansgrp += $g
           $g = $null
       }

       #Working on the children
      
       Foreach ($entry in $This.Entries) {

           foreach($child in $entry.Children){

               If(!($ansgrp.Name.contains($child))){
   
                   $g = New-AnsibleInventoryGrouping -Name $child
                   $ansgrp += $g
                   $g = $null
               }
           }
       }


       return $ansgrp
   }

}
Class AnsibleInventory {
    [AnsibleInventoryEntryCollection]$EntryCollection = [AnsibleInventoryEntryCollection]::New()
    [AnsibleInventoryHiearchyCollection] $Hiearchy = [AnsibleInventoryHiearchyCollection]::New()
    
    [AnsibleVariableCollection]$VariableCollection = [AnsibleVariableCollection]::New()
    [System.IO.DirectoryInfo]$Path
    [AnsibleInventoryGroupingCollection]$GroupCollection = [AnsibleInventoryGroupingCollection]::New()

    AnsibleInventory() {

    }

    AnsibleInventory([System.IO.DirectoryInfo]$p) {

        

        If($p.Extension -eq '.ini'){
            
            [System.IO.FileInfo]$p = [System.IO.FileInfo]$p.FullName
        }

        If (!($p.Exists)) {
            Throw "File $($p.FullName) does not exists"
        }

        if($p.Extension -eq ".ini"){
            #Is file
            $this.SetPath($p.FullName)

        }else{
            #Is directory
            $invFile = gci -Path $p.FullName -Filter "*inventory.ini"

            if(!($invFile.Exists)){
                Throw "File $($invFile.FullName) does not exists"
            }
            $this.SetPath($invFile.FullName)
        }

       
       
    
        #$IniContentRaw = Get-Content -Path $Path.FullName -Raw
        #$IniContent = $IniContentRaw -split '\r?\n'
        $IniContent = Get-Content -Path $this.Path.FullName 
    
        #As members are added only when an empty string is found, the file MUST end with an empty line. If not the case, I add one.
        If ($IniContent[-1] -ne "") {
            $IniContent += ""
        }
     
        $AllRecords = [System.Collections.Generic.List[PSCustomObject]]::new()
        $AllEntries = @{}
        $record = $null
        $GroupName = $null
        switch -Regex ($IniContent) {
            '\[([^:\]]+)' {
                $record = [PSCustomObject]@{
                    Name        = $matches[1]
                    HasChildren = $false
                    Members     = [System.Collections.Generic.List[string]]::new()
                }
                $GroupName = $matches[1]
            }
            ':children' { $record.HasChildren = $true }
            '^[a-z0-9\._]+$' { 
                $record.Members.Add($_)
                if ($record.HasChildren -eq $false) {

                    If (!($AllEntries.ContainsKey($_))) {
                        $AllEntries.$_ = [System.Collections.Generic.List[string]]::new()
                    }
                    $AllEntries.$_.add($GroupName)
                }
            }
            '^$' {
                $AllRecords.Add($record)
            }
        }
    
        Foreach ($Item in $AllRecords) {
            If ($null -eq $Item) {
                continue
            }
            If ($Item.HasChildren) {
                $arch = New-AnsibleInventoryHiearchyEntry -ParentName $Item.Name -Children $Item.Members
                $this.AddHiearchy($arch)
                $arch = $null
            }
            else {
                $Grouping = New-AnsibleInventoryGrouping -Name $item.Name -Members $Item.Members
                $this.AddGrouping($Grouping)
                $Grouping = $null

            }
        }

        Foreach ($KeyEntry in $AllEntries.Keys) {
            $Entry = New-AnsibleInventoryEntry -NodeName $KeyEntry
            foreach ($grp in $AllEntries.$KeyEntry) {

                $Entry.AddToGroup($grp)
            }
            $this.AddInventoryEntry($Entry)
            $Entry = $null
        }
        

        #Getting variables

        [System.IO.DirectoryInfo]$group_vars_folder = join-Path -Path $this.Path.Directory -ChildPath "group_vars"
        [System.IO.DirectoryInfo]$hosts_vars_folder = join-Path -Path $this.Path.Directory -ChildPath "hosts_vars"

        

        
        If ($group_vars_folder.Exists) {
            $GroupVarFiles = Get-ChildItem -path $group_vars_folder.FullName


            Foreach ($groupvarfile in $GroupVarFiles) {

                $ContainerName = $groupvarfile.BaseName
                <#
                
                $GroupVarFileContent = get-content -Path $groupvarfile.FullName
                switch -Regex ($GroupVarFileContent){
                    "---"{
                        continue
                    }
                    "^(?<VariableName>.+):\s?(?<VariableValue>.+)"{
                        $var = New-AnsibleInventoryVariable -Type Group -ContainerName $ContainerName -Name $matches.VariableName -Value $matches.VariableValue
                        $this.VariableCollection.AddVariable($var)
                        $var = $null
                    }
                }
                #>
                
                $data = ConvertFrom-Yaml -Yaml (gc $groupvarfile.FullName -raw ) | sort name
                foreach ($key in $data.keys ) {
                    $var = New-AnsibleInventoryVariable -Type Group -ContainerName $ContainerName -Name $Key -Value $data.$key
                    $this.VariableCollection.AddVariable($var)
                    $var = $null
                }
                
                $data = $null
                       
            }
        }

        If ($hosts_vars_folder.Exists) {

            $hostVarFiles = Get-ChildItem -path $hosts_vars_folder.FullName

            Foreach ($Hostvarfile in $hostVarFiles) {

                $ContainerName = $Hostvarfile.BaseName
                
                <#
                $HostvarfileFileContent = get-content -Path $Hostvarfile.FullName
                
                switch -Regex ($HostvarfileFileContent){
                    "---"{
                        continue
                    }
                    "^(?<VariableName>.+):\s?(?<VariableValue>.+)"{
                        $var = New-AnsibleInventoryVariable -Type Host -ContainerName $ContainerName -Name $matches.variableName -Value $matches.VariableValue
                        $this.VariableCollection.AddVariable($var)
                        $var = $null
                    }
                }
                #>

                $data = ConvertFrom-Yaml -Yaml (gc $Hostvarfile.FullName -raw ) | sort name
                foreach ($key in $data.keys ) {
                    $var = New-AnsibleInventoryVariable -Type host -ContainerName $ContainerName -Name $Key -Value $data.$key
                    $this.VariableCollection.AddVariable($var)
                    $var = $null
                }

                $Data = $null
            }
        }

        

    }

    AnsibleInventory($Entries, $Hiearchy) {
        
        $this.AddInventoryEntry($Entries)
        $this.Hiearchy.AddEntry($Hiearchy)

    }

    AddHiearchy($Hiearchy) {
        $this.Hiearchy.AddEntry($Hiearchy)
       
    }

    AddInventoryEntry([AnsibleInventoryEntry[]]$Entries) {
        Foreach ($ent in $entries) {

            $This.EntryCollection.addEntry($entries)
        }
    }

    [String]ConvertArchToInI() {

        $FullString = ""
        Foreach ($hier in $this.Hiearchy.Entries) {
            $FullString += "[$($hier.Parent):children]`n"
            Foreach ($Child in $hier.children) {
                $FullString += "$($Child)`n"
            }

            $FullString += "`n"
        }

        Return $FullString
    }

    AddGrouping($Grouping) {
        $this.GroupCollection.AddGrouping($Grouping)
    }

    AddVariable([object]$Variable){
        #Will change to AnsibleInventoryItem once class is there.
        Foreach($var in $Variable){
            $this.VariableCollection.AddVariable($Variable)
        }
        
    }

    [Object]GetGroups() {

        return $this.Groups
    }

    [String]ConvertGroupsToIni() {
 
        return $this.GroupCollection.ConvertToIni()

    }

    [string]ConvertToIni() {
        #$All = $this.ConvertArchToInI() Not needed anymore, as arch tree is generated in groupCollection. All child groups (even empty ones)
        # will be created
        $All += $this.ConvertGroupsToIni()
        Return $All
    }

    SetVariableCollection([AnsibleVariableCollection]$VariableCollection) {
        $This.VariableCollection = $VariableCollection
    }

    SetGroupingCollection([AnsibleInventoryGroupingCollection]$GroupingCollection) {
        $this.GroupCollection = $GroupingCollection
    }

    SetPath([System.IO.DirectoryInfo]$Path) {
        $this.Path = $Path
        If ($this.VariableCollection) {
            $this.VariableCollection.SetPath($Path)
        }
    }

    Export() {

        $this.CreateGroupings()

        If (!($this.Path.Exists)) {
            $this.path.Create()
            $this.Path.Refresh()
        }


        
        [System.IO.FileInfo]$InventoryFile = Join-Path -Path $This.Path.FullName -ChildPath "inventory.ini"
                
        If (!($InventoryFile.Exists)) {
            $Null = New-Item -ItemType File -Path $InventoryFile.FullName -Force
            $InventoryFile.Refresh()
        }

        $IniContent = $this.ConvertToIni()
        Set-Content -Path $InventoryFile.FullName -Value $IniContent -Force -Encoding utf8NoBOM #utf8NoBOM is Only available on PS7

        if ($this.VariableCollection) {
            $This.VariableCollection.Export()
        }
    }

    [System.Collections.Generic.List[AnsibleInventoryEntry]] GetEntries() {
        return $this.EntryCollection.GetEntries()
    }

    CreateGroupings(){
        $AllGroups = @()
        $AllGroups += $this.Hiearchy.CreateGrouping()
        $AllGroups += $this.EntryCollection.CreateGrouping()
        $GroupingCollection = [AnsibleInventoryGroupingCollection]::new()
        foreach($grp in $AllGroups){
            $GroupingCollection.AddGrouping($grp)
        }
        $this.SetGroupingCollection($GroupingCollection)
    }
}

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

    AddVariable([AnsibleVar[]]$Variable) {
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
        $AllGroupVariables = [AnsibleVar[]]@()
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
Function Import-AnsibleInventory {
    [CmdletBinding()]
    Param(
        [System.IO.DirectoryInfo]$Path
    )

    $inv = [AnsibleInventory]::New($Path)

    REturn $Inv
}
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
Function New-AnsibleInventory {

    return [AnsibleInventory]::New()
}
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
Function New-AnsibleInventoryGroupingCollection {
    [CmldetBinding()]
    Param(

    )
    return [AnsibleInventoryGroupingCollection]::New()
}
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
#Post Content
