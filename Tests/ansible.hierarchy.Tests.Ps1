#region Header

$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'psansible.inventory'


Push-Location -Path $Path

ipmo psansible.inventory.psm1 -Force

#endregion Header
InModuleScope -ModuleName psansible.inventory -ScriptBlock {
    
    Describe '[AnsibleInventoryHierarchyEntry]-[Constructors]' {
    
        It '[AnsibleInventoryHierarchyEntry]-[Constructor] - Parameterless should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHierarchyEntry]::New() } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryHierarchyEntry]-[Constructor](Parent) should Not Throw' {
    
            # -- Arrange
    
    
            $Parent = 'PaParent'
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHierarchyEntry]::New($Parent) } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryHierarchyEntry]-[Constructor](Parent,Children) should Not Throw' {
    
            # -- Arrange
    
    
            $Parent = 'ParentGroup'
    
    
            $Children = 'ChildgGroup'
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHierarchyEntry]::New($Parent, $Children) } | Should Not Throw 
    
        }# end of it block
    
    
    }# end of Describe block
    Describe '[AnsibleInventoryHierarchyCollection]-[Constructors]' {
    
        It '[AnsibleInventoryHierarchyCollection]-[Constructor] - Parameterless should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHierarchyCollection]::New() } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryHierarchyCollection]-[Constructor]([AnsibleInventoryHierarchyEntry[]]Entry) should Not Throw' {
    
            # -- Arrange
    
    
            [AnsibleInventoryHierarchyEntry[]]$Entry = 'plop123'
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHierarchyCollection]::New($Entry) } | Should Not Throw 
    
        }# end of it block
    
    
    }# end of Describe block
    Describe '[AnsibleInventoryHierarchyCollection]-[Methods]' {
    
        #Public Method
        It '[AnsibleInventoryHierarchyCollection] --> AddEntry($Entry) :  - should Not Throw' {
    
            # -- Arrange
    
            $Entry = 'plop'
    
            # -- Act
    
            $Instance = [AnsibleInventoryHierarchyCollection]::New()
    
            # -- Assert
    
            { $Instance.AddEntry($Entry) } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHierarchyCollection] --> AddEntry($Entry) :  - should not return a type [void]' {
    
            # -- Arrange
            $Entry = 'plop'
    
            # -- Act
    
            $Instance = [AnsibleInventoryHierarchyCollection]::New()
            # -- Assert
    
            $Instance.AddEntry($Entry) | should be $null
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHierarchyCollection] --> ConvertToIni() : [string] - should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryHierarchyCollection]::New()
    
            # -- Assert
    
            { $Instance.ConvertToIni() } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHierarchyCollection] --> ConvertToIni() : [string] - should return type [string]' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryHierarchyCollection]::New()
            # -- Assert
    
            ($Instance.ConvertToIni()).GetType().Name | should be string
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHierarchyCollection] --> CreateGrouping() : [AnsibleInventoryGrouping[]] - should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryHierarchyCollection]::New()
    
            # -- Assert
    
            { $Instance.CreateGrouping() } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHierarchyCollection] --> CreateGrouping() : [AnsibleInventoryGrouping[]] - should return type [AnsibleInventoryGrouping[]]' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryHierarchyCollection]::New()
            # -- Assert
    
            ($Instance.CreateGrouping()).GetType().Name | should be AnsibleInventoryGrouping[]
    
        } #End It Block
    
    }#EndDescribeBlock
}


