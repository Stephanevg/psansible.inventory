
#region Header

$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'psansible.inventory'


Push-Location -Path $Path

ipmo ./psansible.inventory.psm1 -Force


#endregion Header

InModuleScope -ModuleName psansible.inventory -ScriptBlock {


    $FakeInventory = @"
[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
"@

    Describe '[AnsibleInventory]-[Constructors]' {

        It '[AnsibleInventory]-[Constructor] - Parameterless should Not Throw' {

            # -- Arrange

            # -- Act

            # -- Assert

            { [AnsibleInventory]::New() } | Should Not Throw 

        }# end of it block


        It '[AnsibleInventory]-[Constructor]([System.IO.DirectoryInfo]p) should Not Throw' {

            # -- Arrange

            $InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'Inventory'
            New-Item -ItemType Directory -Path $InventoryFolder

            $InventoryFile = Join-Path -Path $InventoryFolder -ChildPath "inventory.ini"
            Out-File -FilePath $InventoryFile -Force -InputObject $FakeInventory 

            [System.IO.DirectoryInfo]$p = $InventoryFile

            # -- Act

            # -- Assert

            { 
                $Instance = [AnsibleInventory]::New()
                $Instance.SetPath($InventoryFile)
             
            } | Should Not Throw 

        }# end of it block


        It '[AnsibleInventory]-[Constructor](Entries,Hiearchy) should Not Throw' {

            # -- Arrange


            $Entries = ''


            $Hiearchy = ''

            # -- Act

            # -- Assert

            { 
                [AnsibleInventory]::New($Entries, $Hiearchy) 
            } | Should Not Throw 

        }# end of it block


    }# end of Describe block
    Describe '[AnsibleInventory]-[Methods]' {

        #Public Method
        It '[AnsibleInventory] --> AddHiearchy($Hiearchy) :  - should Not Throw' {

            # -- Arrange

            $Hiearchy = [AnsibleInventoryHiearchyEntry]::New("Parent", "Child")

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.AddHiearchy($Hiearchy) } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> AddHiearchy($Hiearchy) :  - should return type void' {

            # -- Arrange
            $Hiearchy = ''

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            $Instance.AddHiearchy($Hiearchy) | should be $null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> AddInventoryEntry($Entries) :  - should Not Throw' {

            # -- Arrange

        


            [AnsibleInventoryEntry[]]$Entries = 'Plop'

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.AddInventoryEntry($Entries) } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> AddInventoryEntry($Entries) :  - should return type void' {

            # -- Arrange
            [AnsibleInventoryEntry[]]$Entries = 'plop'

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            $Instance.AddInventoryEntry($Entries) | should be $null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> ConvertArchToInI() : [String] - should Not Throw' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.ConvertArchToInI() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> ConvertArchToInI() : [String] - should return type [String]' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            ($Instance.ConvertArchToInI()).GetType().Name | should be String

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> AddGrouping($Grouping) :  - should Not Throw' {

            # -- Arrange

        

            [AnsibleInventoryGrouping]$Grouping = [AnsibleInventoryGrouping]::new("group1", "server1")

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.AddGrouping($Grouping) } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> AddGrouping($Grouping) :  - should return void' {

            # -- Arrange
            [AnsibleInventoryGrouping]$Grouping = [AnsibleInventoryGrouping]::new("group1", "server1")

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            $Instance.AddGrouping($Grouping) | should be $null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> AddVariable($Variable) :  - should Not Throw' {

            # -- Arrange

            $Variable = [AnsibleVar]::New('var1', 'val1', 'host')

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.AddVariable($Variable) } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> AddVariable($Variable) :  - should return void' {

            # -- Arrange
            $Variable = [AnsibleVar]::New('var1', 'val1', 'host')

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            $Instance.AddVariable($Variable) | should be $null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> GetGroups() : [Object] - should Not Throw' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.GetGroups() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> GetGroups() : [Object] - should return type [List1]' {

            # -- Arrange


        
            $InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'Inventory'
            New-Item -ItemType Directory -Path $InventoryFolder -ErrorAction SilentlyContinue
            New-Item -ItemType Directory -Path "$InventoryFolder/group_vars" -ErrorAction SilentlyContinue
            New-Item -ItemType Directory -Path "$InventoryFolder/host_vars" -ErrorAction SilentlyContinue

            $InventoryFile = Join-Path -Path $InventoryFolder -ChildPath "inventory.ini"
            Out-File -FilePath $InventoryFile -Force -InputObject $FakeInventory 



            # -- Act

            $Instance = [AnsibleInventory]::New($InventoryFolder)
            $Instance.SetPath($InventoryFolder)
            $Instance.CreateGroupings()
            # -- Assert

            ($Instance.GetGroups()).GetType().Name | should be 'List`1'

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> ConvertGroupsToIni() : [String] - should Not Throw' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.ConvertGroupsToIni() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> ConvertGroupsToIni() : [String] - should return type [String]' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            ($Instance.ConvertGroupsToIni()).GetType().Name | should be String

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> ConvertToIni() : [string] - should Not Throw' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.ConvertToIni() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> ConvertToIni() : [string] - should return type [string]' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            ($Instance.ConvertToIni()).GetType().Name | should be string

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> SetVariableCollection($VariableCollection) :  - should Not Throw' {

            # -- Arrange

            $vars = @()
            $Vars += [AnsibleVar]::New('var1', 'val1', 'host')
            $Vars += [AnsibleVar]::New('var2', 'val2', 'host')
            $Vars += [AnsibleVar]::New('var3', 'val3', 'host')

            $VariableCollection = [AnsibleVariableCollection]::New($vars)

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.SetVariableCollection($VariableCollection) } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> SetVariableCollection($VariableCollection) :  - should return type void' {

            # -- Arrange
            $vars = @()
            $Vars += [AnsibleVar]::New('var1', 'val1', 'host')
            $Vars += [AnsibleVar]::New('var2', 'val2', 'host')
            $Vars += [AnsibleVar]::New('var3', 'val3', 'host')

            $VariableCollection = [AnsibleVariableCollection]::New($vars)

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            $Instance.SetVariableCollection($VariableCollection) | should be $null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> SetGroupingCollection($GroupingCollection) :  - should Not Throw' {

            # -- Arrange

            [AnsibleInventoryGroupingCollection]$GroupingCollection = ''

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.SetGroupingCollection($GroupingCollection) } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> SetGroupingCollection($GroupingCollection) :  - should return void' {

            # -- Arrange
            [AnsibleInventoryGroupingCollection]$GroupingCollection = ''

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            $Instance.SetGroupingCollection($GroupingCollection) | should be $Null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> SetPath($Path) :  - should Not Throw' {

            # -- Arrange

        

            [System.IO.DirectoryInfo]$InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'Inventory'
            New-Item -ItemType Directory -Path $InventoryFolder.FullName -ErrorAction SilentlyContinue

            $InventoryFile = Join-Path -Path $InventoryFolder -ChildPath "inventory.ini"
            Out-File -FilePath $InventoryFile -Force -InputObject $FakeInventory 

            # -- Act

            $Instance = [AnsibleInventory]::New($InventoryFolder)

            # -- Assert

            { $Instance.SetPath($InventoryFolder) } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> SetPath($Path) :  - should return type []' {

            # -- Arrange
            [System.IO.DirectoryInfo]$InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'Inventory'
            New-Item -ItemType Directory -Path $InventoryFolder.FullName -ErrorAction SilentlyContinue

            $InventoryFile = Join-Path -Path $InventoryFolder -ChildPath "inventory.ini"
            Out-File -FilePath $InventoryFile -Force -InputObject $FakeInventory 

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            $Instance.SetPath($InventoryFile) | should be $Null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> Export() :  - should Not Throw' {

            # -- Arrange

            [System.IO.DirectoryInfo]$InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'InventoryTest'
            New-Item -ItemType Directory -Path $InventoryFolder.FullName -ErrorAction SilentlyContinue

            $InventoryFile = Join-Path -Path $InventoryFolder -ChildPath "inventory.ini"
            Out-File -FilePath $InventoryFile -Force -InputObject $FakeInventory 

            $Instance = [AnsibleInventory]::New()
            $entry = [AnsibleInventoryEntry]::New("Node1", "plop")
            $Instance.AddInventoryEntry($entry)
            $Instance.SetPath($InventoryFolder)
            # -- Act


            # -- Assert

            { $Instance.Export() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> Export() :  - should return type []' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            $entry = [AnsibleInventoryEntry]::New("Node1", "plop")
            $Instance.AddInventoryEntry($entry)
            $Instance.SetPath($TestDrive)
            # -- Assert

            $Instance.Export() | should be $null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> GetEntries() : [System.Collections.Generic.List[AnsibleInventoryEntry]] - should Not Throw' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()

            # -- Assert

            { $Instance.GetEntries() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> GetEntries() : [System.Collections.Generic.List[AnsibleInventoryEntry]] - should return type [List`1]' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            ($Instance.GetEntries()).GetType().Name | should -Be 'List`1'
        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> CreateGroupings() :  - should Not Throw and create the groupings' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            $entry = [AnsibleInventoryEntry]::New("Node1", "plop")
            $Instance.AddInventoryEntry($entry)
            $Instance.SetPath($TestDrive)

            # -- Assert

            { $Instance.CreateGroupings() } | Should Not Throw
            $Instance.GroupCollection | Should -Not -BeNullOrEmpty

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> CreateGroupings() :  - should return void' {

            #TODO
            #Add test were we actually test if the grouping gets created...

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            $entry = [AnsibleInventoryEntry]::New("Node1", "plop")
            $Instance.AddInventoryEntry($entry)
            $Instance.SetPath($TestDrive)
            # -- Assert

            $Instance.CreateGroupings() | should be $null

        } #End It Block

        #Public Method
        It '[AnsibleInventory] --> ToJson() : [string] - should return type [string]' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert

            ($Instance.ToJson()).GetType().Name | should be string

        } #End It Block

        It '[AnsibleInventory] --> ToJson() : [string] - should return valid JSON object' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventory]::New()
            # -- Assert
            $Json = $Instance.ToJson()
            $JsonObject = $Json | convertFrom-json
            $JsonKeys = $JsonObject | get-member -MemberType NoteProperty | select-object Name

            $JsonKeys.Name.contains("all") | should -Be $True
            $JsonKeys.Name.contains("_meta") | should -Be $True
            $JsonKeys.Name.contains("ungrouped") | should -Be $True

        } #End It Block

        It '[AnsibleInventory] --> ToJson() : [string] - JSON should contain correct data' {

            # -- Arrange

            $Inventory = New-AnsibleInventory
            # -- Act

            #Creating Hiearchy
            $Arch = @()
            $Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_prod_servers" -Children "all_hr_servers","all_marketing_servers","all_database_servers"
            $Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_database_servers" -Children "all_mongodb_servers","all_postgres_servers"
            $Inventory.AddHiearchy($Arch)

            
            #Creating servers and groups
            $Servers = @()
            $Servers+= "woop1"
            $Servers+= "woop2"
            $Servers+= "woop3"
            $Servers+= "woop4"
            
            $hrservers = @()
            $hrservers+= "woop5"
            $hrservers+= "woop6"
            $hrservers+= "woop7"
            $hrservers+= "woop8"
            
            Foreach($ser in $servers){
                $entry = New-AnsibleInventoryEntry -NodeName $ser -Group "all_mongodb_servers"
                $Inventory.AddInventoryEntry($entry)
            }
            
            
            Foreach($ser in $hrservers){
                $entry = New-AnsibleInventoryEntry -NodeName $ser -Group "all_hr_servers"
                $Inventory.AddInventoryEntry($entry)
            }
            
            $E = New-AnsibleInventoryEntry -NodeName "IamAlone" -Group "" 
            $Inventory.AddInventoryEntry($E)
            
            #Creating and Adding variables to PsAnsibleInventory
            
            $vars = @()
            $vars += New-AnsibleInventoryVariable -Name "plop" -Type Group -Value "WWW" -ContainerName "ABC"
            $vars += New-AnsibleInventoryVariable -Name "maintenance_time" -Type Host -Value "sunday" -ContainerName "server123"
            $vars += New-AnsibleInventoryVariable -Name "stage" -Value "prod" -ContainerName "all_prod_servers" -Type Group
            $vars += New-AnsibleInventoryVariable -Name "wsus_server" -Value "http://plop.com" -ContainerName "all_prod_servers" -Type Group
            $vars += New-AnsibleInventoryVariable -Name "wsus_server" -Value "http://plop.child.com" -ContainerName "all_hr_servers" -Type Group
            $vars += New-AnsibleInventoryVariable -Name "Building" -Value "HR_01" -ContainerName "all_hr_servers" -Type Group
            $vars += New-AnsibleInventoryVariable -Name "maintenance_time" -Type Host -Value "sunday" -ContainerName "woop5"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "tempadmin" -ContainerName "woop5"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop1"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop2"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop3"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop4"
            $vars += New-AnsibleInventoryVariable -Type Group -Name "entity" -Value "os.services.windows.2019" -ContainerName "woop4"
            
            # -- Assert

            $Inventory.AddVariable($vars) 

            $jobj = $Inventory.ToJson() | ConvertFrom-Json
            
            $jobj._meta.hostvars."woop5".maintenance_time | should -be "sunday"
            $jobj._meta.hostvars."woop3".state | should -be "fullmanaged"

            $jobj.all.all_hr_servers.hosts.Count | should -be 4
            $jobj.all.all_hr_servers.vars.wsus_server | should -be "http://plop.child.com"
        } #End It Block
        
    }#EndDescribeBlock

    Describe '[AnsibleInventory] - [Methods] - [ToJson]' {
        #Specific section to test the data that is returned by ToJson is accurate

        #Preparing test data

        $Inventory = New-AnsibleInventory
            # -- Act

            #Creating Hiearchy
            $Arch = @()
            $Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_prod_servers" -Children "all_hr_servers","all_marketing_servers","all_database_servers"
            $Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_database_servers" -Children "all_mongodb_servers","all_postgres_servers"
            $Inventory.AddHiearchy($Arch)

            
            #Creating servers and groups
            $Servers = @()
            $Servers+= "woop1"
            $Servers+= "woop2"
            $Servers+= "woop3"
            $Servers+= "woop4"
            
            $hrservers = @()
            $hrservers+= "woop5"
            $hrservers+= "woop6"
            $hrservers+= "woop7"
            $hrservers+= "woop8"
            
            Foreach($ser in $servers){
                $entry = New-AnsibleInventoryEntry -NodeName $ser -Group "all_mongodb_servers"
                $Inventory.AddInventoryEntry($entry)
            }
            
            
            Foreach($ser in $hrservers){
                $entry = New-AnsibleInventoryEntry -NodeName $ser -Group "all_hr_servers"
                $Inventory.AddInventoryEntry($entry)
            }
            
            $E = New-AnsibleInventoryEntry -NodeName "IamAlone" -Group "" 
            $Inventory.AddInventoryEntry($E)
            
            #Creating and Adding variables to PsAnsibleInventory
            
            $vars = @()
            $vars += New-AnsibleInventoryVariable -Name "plop" -Type Group -Value "WWW" -ContainerName "ABC"
            $vars += New-AnsibleInventoryVariable -Name "maintenance_time" -Type Host -Value "sunday" -ContainerName "server123"
            $vars += New-AnsibleInventoryVariable -Name "stage" -Value "prod" -ContainerName "all_prod_servers" -Type Group
            $vars += New-AnsibleInventoryVariable -Name "wsus_server" -Value "http://plop.com" -ContainerName "all_prod_servers" -Type Group
            $vars += New-AnsibleInventoryVariable -Name "wsus_server" -Value "http://plop.child.com" -ContainerName "all_hr_servers" -Type Group
            $vars += New-AnsibleInventoryVariable -Name "Building" -Value "HR_01" -ContainerName "all_hr_servers" -Type Group
            $vars += New-AnsibleInventoryVariable -Name "maintenance_time" -Type Host -Value "sunday" -ContainerName "woop5"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "tempadmin" -ContainerName "woop5"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop1"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop2"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop3"
            $vars += New-AnsibleInventoryVariable -Name "state" -Type Host -Value "fullmanaged" -ContainerName "woop4"
            $vars += New-AnsibleInventoryVariable -Type Group -Name "entity" -Value "os.services.windows.2019" -ContainerName "woop4"
            
            # -- Assert

            $Inventory.AddVariable($vars) 

            $jobj = $Inventory.ToJson() | ConvertFrom-Json

        It '[AnsibleInventory] --> ToJson() : [string] - JSON should contain "_meta" section with correct data' {

            # -- Arrange
            $jobj._meta | should -not -BeNullOrEmpty

        } #End It Block

        It '[AnsibleInventory] --> ToJson() : [string] - JSON should contain "_meta.hostvars" section with correct data' {

            
            $jobj._meta.hostvars."woop5".maintenance_time | should -be "sunday"
            $jobj._meta.hostvars."woop3".state | should -be "fullmanaged"

            $jobj.all.all_hr_servers.hosts.Count | should -be 4
            $jobj.all.all_hr_servers.vars.wsus_server | should -be "http://plop.child.com"
        } #End It Block

        It '[AnsibleInventory] --> ToJson() : [string] - JSON should contain "all" section with nodes and vars' {

            $jobj.all.all_hr_servers.hosts.Count | should -be 4
            $jobj.all.all_hr_servers.hosts.contains("woop7")
            $jobj.all.all_hr_servers.vars.wsus_server | should -be "http://plop.child.com"
        } #End It Block
        

    }
}

