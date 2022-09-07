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
        if($this.Path.Name.EndsWith(".ini")){
            [System.IO.DirectoryInfo]$group_vars_folder = join-Path -Path $this.Path.Parent -ChildPath "group_vars"
            [System.IO.DirectoryInfo]$hosts_vars_folder = join-Path -Path $this.Path.Parent -ChildPath "hosts_vars"
        }else{

        
        [System.IO.DirectoryInfo]$group_vars_folder = join-Path -Path $this.Path.Directory -ChildPath "group_vars"
        [System.IO.DirectoryInfo]$hosts_vars_folder = join-Path -Path $this.Path.Directory -ChildPath "hosts_vars"
        }
        

        
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
            $this.VariableCollection.AddVariable($var)
        }
        
    }

    [Object]GetGroups() {

        return $this.GroupCollection.Groups
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

    [object] ToJson(){
        
        #This method returns a json representation of the contained inventory.

        $this.CreateGroupings()
        $Json_hash = [ordered]@{"_meta"=@{"hostvars"=@{}};"all"=@{};"ungrouped"=@{}}
        
        #Creating the Groups and groupings
        foreach($grouping in $This.GroupCollection.Groups){
            $json_hash."all".$($grouping.Name) = [ordered]@{"hosts"=@();"vars"=@()}
            #Fetching group vars
            $vars = $this.VariableCollection.GetVariablesFromContainer($grouping.name)
            if($vars){
                if(!$json_hash."all".$($grouping.Name)."vars"){
                    $json_hash."all".$($grouping.Name)."vars" = @{}
                }
                foreach($var in $vars){

                    $json_hash."all".$($grouping.Name)."vars".$($var.Name) = $var.value
                }
            }
        }

        #Hostvars
        $AllGroupedHostVariables = $This.VariableCollection.GetHostVariables() | Group-object ContainerName

        foreach($GroupedhostVariables in $AllGroupedHostVariables){
            if(!$Json_hash._meta.hostvars.$($GroupedhostVariables.name)){
                $Json_hash._meta.hostvars.$($GroupedhostVariables.name) = @{}
            }
            foreach($grp in $GroupedhostVariables.group){
                $Json_hash._meta.hostvars.$($GroupedhostVariables.name)."$($grp.Name)" = $grp.Value
            }

        }

        #Hosts / children
        if($grouping.HasChildren){
            $json_hash."all".$($grouping.Name)."children" = $grouping.members
    
        }else{
            $json_hash."all".$($grouping.Name)."hosts" = $grouping.members
        }

        #Returning Json representation of the ansible inventory
        return $Json_hash | ConvertTo-Json -Depth 7
        
    }
}
