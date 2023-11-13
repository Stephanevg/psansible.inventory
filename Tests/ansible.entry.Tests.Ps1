#region Header

$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'psansible.inventory'


$Location = Get-Location

Set-Location -Path $Path

ipmo ./psansible.inventory.psm1 -Force


#endregion Header

InModuleScope -ModuleName psansible.inventory -ScriptBlock {


    
    Describe '[AnsibleInventoryEntry]-[Constructors]' {
    
        It '[AnsibleInventoryEntry]-[Constructor] - Parameterless should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryEntry]::New() } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryEntry]-[Constructor]([String]NodeName) should Not Throw' {
    
            # -- Arrange
    
    
            [String]$NodeName = ''
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryEntry]::New($NodeName) } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryEntry]-[Constructor](NodeName,GroupMemberShip) should Not Throw' {
    
            # -- Arrange
    
    
            $NodeName = ''
    
    
            $GroupMemberShip = ''
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryEntry]::New($NodeName, $GroupMemberShip) } | Should Not Throw 
    
        }# end of it block
    
    
    }# end of Describe block
    Describe '[AnsibleInventoryEntryCollection]-[Constructors]' {
    
        It '[AnsibleInventoryEntryCollection]-[Constructor] - Parameterless should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryEntryCollection]::New() } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryEntryCollection]-[Constructor]([AnsibleInventoryEntry[]]Entry) should Not Throw' {
    
            # -- Arrange
    
    
            [AnsibleInventoryEntry[]]$Entry = @('MyCOmputer')
    
            # -- Act
    
            # -- Assert
    
            { 
                [AnsibleInventoryEntryCollection]::New($Entry) 
            } | Should Not Throw 
    
        }# end of it block
    
    
    }# end of Describe block
    Describe '[AnsibleInventoryEntryCollection]-[Methods]' {
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> AddEntry($Entry) :  - should Not Throw' {
    
            # -- Arrange
    
            $Entry = 'Test'
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
    
            # -- Assert
    
            { $Instance.AddEntry($Entry) } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> AddEntry($Entry) :  - should return [void]' {
    
            # -- Arrange
            $Entry = 'Plop'
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
            # -- Assert
    
            $Instance.AddEntry($Entry) | should be $null
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> GetEntry($NodeName) : [AnsibleInventoryEntry] - should Not Throw' {
    
            # -- Arrange
    
            [String]$NodeName = ''
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
    
            # -- Assert
    
            { $Instance.GetEntry($NodeName) } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> GetEntry($NodeName) : [AnsibleInventoryEntry] - should return type [AnsibleInventoryEntry]' {
    
            # -- Arrange
            [String]$NodeName = 'Node123'
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
            $Instance.AddEntry($NodeName)
            # -- Assert
    
            ($Instance.GetEntry($NodeName)).GetType().Name | should be AnsibleInventoryEntry
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> ToString() : [String] - should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
    
            # -- Assert
    
            { $Instance.ToString() } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> ToString() : [String] - should return type [String]' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
            # -- Assert
    
            ($Instance.ToString()).GetType().Name | should be String
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> GetEntries() : [System.Collections.Generic.List[AnsibleInventoryEntry]] - should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
    
            # -- Assert
    
            { $Instance.GetEntries() } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> GetEntries() : [System.Collections.Generic.List[AnsibleInventoryEntry]] - should return type [System.Collections.Generic.ListAnsibleInventoryEntry]' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
            # -- Assert
    
            ($Instance.GetEntries()).GetType().Name | should be 'List`1' #Is the name of a generic list
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> CreateGrouping() : [AnsibleInventoryGrouping[]] - should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
    
            # -- Assert
    
            { $Instance.CreateGrouping() } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryEntryCollection] --> CreateGrouping() : [AnsibleInventoryGrouping[]] - should return type [AnsibleInventoryGrouping[]]' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryEntryCollection]::New()
            # -- Assert
    
            ($Instance.CreateGrouping()).GetType().Name | should be AnsibleInventoryGrouping[]
    
        } #End It Block
    
    }#EndDescribeBlock
}

Set-Location $Location