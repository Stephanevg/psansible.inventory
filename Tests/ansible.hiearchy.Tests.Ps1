#region Header

$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'psansible.inventory'


$Location = Get-Location

Set-Location -Path $Path

ipmo ./psansible.inventory.psm1 -Force

#endregion Header
InModuleScope -ModuleName psansible.inventory -ScriptBlock {
    
    Describe '[AnsibleInventoryHiearchyEntry]-[Constructors]' {
    
        It '[AnsibleInventoryHiearchyEntry]-[Constructor] - Parameterless should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHiearchyEntry]::New() } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryHiearchyEntry]-[Constructor](Parent) should Not Throw' {
    
            # -- Arrange
    
    
            $Parent = 'PaParent'
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHiearchyEntry]::New($Parent) } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryHiearchyEntry]-[Constructor](Parent,Children) should Not Throw' {
    
            # -- Arrange
    
    
            $Parent = 'ParentGroup'
    
    
            $Children = 'ChildgGroup'
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHiearchyEntry]::New($Parent, $Children) } | Should Not Throw 
    
        }# end of it block
    
    
    }# end of Describe block
    Describe '[AnsibleInventoryHiearchyCollection]-[Constructors]' {
    
        It '[AnsibleInventoryHiearchyCollection]-[Constructor] - Parameterless should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHiearchyCollection]::New() } | Should Not Throw 
    
        }# end of it block
    
    
        It '[AnsibleInventoryHiearchyCollection]-[Constructor]([AnsibleInventoryHiearchyEntry[]]Entry) should Not Throw' {
    
            # -- Arrange
    
    
            [AnsibleInventoryHiearchyEntry[]]$Entry = 'plop123'
    
            # -- Act
    
            # -- Assert
    
            { [AnsibleInventoryHiearchyCollection]::New($Entry) } | Should Not Throw 
    
        }# end of it block
    
    
    }# end of Describe block
    Describe '[AnsibleInventoryHiearchyCollection]-[Methods]' {
    
        #Public Method
        It '[AnsibleInventoryHiearchyCollection] --> AddEntry($Entry) :  - should Not Throw' {
    
            # -- Arrange
    
            $Entry = 'plop'
    
            # -- Act
    
            $Instance = [AnsibleInventoryHiearchyCollection]::New()
    
            # -- Assert
    
            { $Instance.AddEntry($Entry) } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHiearchyCollection] --> AddEntry($Entry) :  - should not return a type [void]' {
    
            # -- Arrange
            $Entry = 'plop'
    
            # -- Act
    
            $Instance = [AnsibleInventoryHiearchyCollection]::New()
            # -- Assert
    
            $Instance.AddEntry($Entry) | should be $null
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHiearchyCollection] --> ConvertToIni() : [string] - should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryHiearchyCollection]::New()
    
            # -- Assert
    
            { $Instance.ConvertToIni() } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHiearchyCollection] --> ConvertToIni() : [string] - should return type [string]' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryHiearchyCollection]::New()
            # -- Assert
    
            ($Instance.ConvertToIni()).GetType().Name | should be string
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHiearchyCollection] --> CreateGrouping() : [AnsibleInventoryGrouping[]] - should Not Throw' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryHiearchyCollection]::New()
    
            # -- Assert
    
            { $Instance.CreateGrouping() } | Should Not Throw
    
        } #End It Block
    
        #Public Method
        It '[AnsibleInventoryHiearchyCollection] --> CreateGrouping() : [AnsibleInventoryGrouping[]] - should return type [AnsibleInventoryGrouping[]]' {
    
            # -- Arrange
    
            # -- Act
    
            $Instance = [AnsibleInventoryHiearchyCollection]::New()
            # -- Assert
    
            ($Instance.CreateGrouping()).GetType().Name | should be AnsibleInventoryGrouping[]
    
        } #End It Block
    
    }#EndDescribeBlock
}

Set-Location $Location