
#region Header

$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'psansible.inventory'

$Location = Get-Location

Set-Location -Path $Path

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

    }#EndDescribeBlock



        # ...
    
    Describe '[AnsibleInventory]-[JSON Export]' {

        # Test that the method throws an error if the output type is invalid
        It '[AnsibleInventory] -->  Export() : - should throw an error if the output type is invalid' {
            # Arrange
            $Instance = [AnsibleInventory]::New()
            $Instance.SetPath($TestDrive)

            # Act & Assert
            { $Instance.Export('invalid') } | Should -Throw
        }
        
        # Test that the method does not throw an error if the output type is empty
        It '[AnsibleInventory] -->  Export() : - should not throw an error if the output type is empty' {
            # Arrange
            $Instance = [AnsibleInventory]::New()
            $Instance.SetPath($TestDrive)

            # Act & Assert
            { $Instance.Export() } | Should -Not -Throw
        }

        # Test that the method does not throw an error if the output type is empty
        It '[AnsibleInventory] -->  Export() : - Outputtype should be ini by default' {
            # Arrange
            $Instance = [AnsibleInventory]::New()
            $Instance.SetPath($TestDrive)

            # Act & Assert
            $Instance.Outputtype | Should -Be "INI"
        }

        # Test that the method does not throws an error if the output type is ini
        It '[AnsibleInventory] -->  Export() : - should not throw an error if the output type is "ini"' {
            # Arrange
            $Instance = New-AnsibleInventory
            $Instance.SetPath($TestDrive)
            $Entry = New-AnsibleInventoryEntry -NodeName "Node1" -Group "Test"
            $Instance.AddInventoryEntry($Entry)
            $Instance.SetOutputType("ini")

            # Act & Assert
            { $Instance.Export() } | Should -not -Throw
        } 

        # Test that the method does not throws an error if the output type is json
        It '[AnsibleInventory] -->  Export() : - should not throw an error if the output type is "json"' {
            # Arrange
            $Instance = New-AnsibleInventory
            $Instance.SetPath($TestDrive)
            $Entry = New-AnsibleInventoryEntry -NodeName "Node1" -Group "Test"
            $Instance.AddInventoryEntry($Entry)
            $Instance.SetOutputType("JSON")

            # Act & Assert
            { $Instance.Export() } | Should -not -Throw
        } 
       

        # Test that the method returns a JSON string if the output type is 'json'
        It '[AnsibleInventory] -->  Export() : - should return correct inventory structure in json' {
            # Arrange
            $Instance = New-AnsibleInventory
            $Instance.SetPath($TestDrive)
            $Entry = New-AnsibleInventoryEntry -NodeName "Node1" -Group "Test"
            $Instance.AddInventoryEntry($Entry)
            $Instance.SetOutputType("JSON")
            $Instance.Export()

            $result = Get-Content (Join-Path -Path $TestDrive -ChildPath 'inventory.json') -Raw | ConvertFrom-Json

            # Assert
            $result.Test.Hosts | Should -Be "Node1"
            $result._meta.Host_vars.length | Should -Be 0
        }

    }
}

Set-Location $Location