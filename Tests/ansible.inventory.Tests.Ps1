
#region Header

$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'Code/Classes'


Push-Location -Path $Path

. .\ansible.grouping.ps1
. .\ansible.entry.ps1
. .\ansible.hiearchy.ps1
. .\ansible.inventory.ps1
. .\ansible.variables.ps1



#endregion Header

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
            [AnsibleInventory]::New($p) 
        } | Should Not Throw 

    }# end of it block


    It '[AnsibleInventory]-[Constructor](Entries,Hiearchy) should Not Throw' {

        # -- Arrange


        $Entries = ''


        $Hiearchy = ''

        # -- Act

        # -- Assert

        { [AnsibleInventory]::New($Entries, $Hiearchy) } | Should Not Throw 

    }# end of it block


}# end of Describe block
Describe '[AnsibleInventory]-[Methods]' {

    #Public Method
    It '[AnsibleInventory] --> AddHiearchy($Hiearchy) :  - should Not Throw' {

        # -- Arrange

        $Hiearchy = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()

        # -- Assert

        { $Instance.AddHiearchy($Hiearchy) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> AddHiearchy($Hiearchy) :  - should return type []' {

        # -- Arrange
        $Hiearchy = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.AddHiearchy($Hiearchy)).GetType().Name | should be 

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> AddInventoryEntry($Entries) :  - should Not Throw' {

        # -- Arrange

        [AnsibleInventoryEntry[]]$Entries = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()

        # -- Assert

        { $Instance.AddInventoryEntry($Entries) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> AddInventoryEntry($Entries) :  - should return type []' {

        # -- Arrange
        [AnsibleInventoryEntry[]]$Entries = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.AddInventoryEntry($Entries)).GetType().Name | should be 

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

        [AnsibleInventoryGrouping]$Grouping = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()

        # -- Assert

        { $Instance.AddGrouping($Grouping) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> AddGrouping($Grouping) :  - should return type []' {

        # -- Arrange
        [AnsibleInventoryGrouping]$Grouping = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.AddGrouping($Grouping)).GetType().Name | should be 

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> AddVariable($Variable) :  - should Not Throw' {

        # -- Arrange

        [object]$Variable = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()

        # -- Assert

        { $Instance.AddVariable($Variable) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> AddVariable($Variable) :  - should return type []' {

        # -- Arrange
        [object]$Variable = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.AddVariable($Variable)).GetType().Name | should be 

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
    It '[AnsibleInventory] --> GetGroups() : [Object] - should return type [Object]' {

        # -- Arrange

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.GetGroups()).GetType().Name | should be Object

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

        [AnsibleVariableCollection]$VariableCollection = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()

        # -- Assert

        { $Instance.SetVariableCollection($VariableCollection) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> SetVariableCollection($VariableCollection) :  - should return type []' {

        # -- Arrange
        [AnsibleVariableCollection]$VariableCollection = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.SetVariableCollection($VariableCollection)).GetType().Name | should be 

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
    It '[AnsibleInventory] --> SetGroupingCollection($GroupingCollection) :  - should return type []' {

        # -- Arrange
        [AnsibleInventoryGroupingCollection]$GroupingCollection = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.SetGroupingCollection($GroupingCollection)).GetType().Name | should be 

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> SetPath($Path) :  - should Not Throw' {

        # -- Arrange

        [System.IO.DirectoryInfo]$Path = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()

        # -- Assert

        { $Instance.SetPath($Path) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> SetPath($Path) :  - should return type []' {

        # -- Arrange
        [System.IO.DirectoryInfo]$Path = ''

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.SetPath($Path)).GetType().Name | should be 

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> Export() :  - should Not Throw' {

        # -- Arrange

        # -- Act

        $Instance = [AnsibleInventory]::New()

        # -- Assert

        { $Instance.Export() } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> Export() :  - should return type []' {

        # -- Arrange

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.Export()).GetType().Name | should be 

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
    It '[AnsibleInventory] --> GetEntries() : [System.Collections.Generic.List[AnsibleInventoryEntry]] - should return type [System.Collections.Generic.ListAnsibleInventoryEntry]' {

        # -- Arrange

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.GetEntries()).GetType().Name | should be System.Collections.Generic.ListAnsibleInventoryEntry

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> CreateGroupings() :  - should Not Throw' {

        # -- Arrange

        # -- Act

        $Instance = [AnsibleInventory]::New()

        # -- Assert

        { $Instance.CreateGroupings() } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleInventory] --> CreateGroupings() :  - should return type []' {

        # -- Arrange

        # -- Act

        $Instance = [AnsibleInventory]::New()
        # -- Assert

        ($Instance.CreateGroupings()).GetType().Name | should be 

    } #End It Block

}#EndDescribeBlock

