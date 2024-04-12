
#region Header

$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'psansible.inventory'

$Location = Get-Location

Set-Location -Path $Path

ipmo ./psansible.inventory.psm1 -Force

#endregion Header

InModuleScope -ModuleName psansible.inventory -ScriptBlock {
   
    Describe '[AnsibleInventory]-[Export-AnsibleInventory]' {

        #BeforeAll {
        #    # Set up test drive
        #    $TestDrive = New-Item -ItemType Directory -Path $env:TEMP -Name "AnsibleInventoryTests"
        #    $Location = Get-Location
        #    Set-Location $TestDrive
        #}
#
        #AfterAll {
        #    # Clean up test drive
        #    Remove-Item -Path $TestDrive.FullName -Recurse -Force
        #    Set-Location $Location
        #}
        
        It '[AnsibleInventory] -->  Export-AnsibleInventory : - should throw an error when outputtype is invalid' {
            # Arrange
            $Instance = New-AnsibleInventory
            $Instance.SetPath($TestDrive)

            # Act & Assert
            { Export-AnsibleInventory -Path $TestDrive -OutputType 'invalid' -Inventory $Instance} | Should -Throw
        }

        It '[AnsibleInventory] -->  Export-AnsibleInventory : - should throw an error when outputtype is empty' {
            # Arrange
            $Instance = New-AnsibleInventory
            $Instance.SetPath($TestDrive)

            # Act & Assert
            { Export-AnsibleInventory -Path $TestDrive -OutputType "" -Inventory $Instance } | Should -Throw
        }

        It '[AnsibleInventory] -->  Export-AnsibleInventory : - should not throw an error when outputtype is ini' {
            # Arrange
            $Instance = New-AnsibleInventory
            $Instance.SetPath($TestDrive)
            $Entry = New-AnsibleInventoryEntry -NodeName "Node1" -Group "Test"
            $Instance.AddInventoryEntry($Entry)

            # Act & Assert
            { Export-AnsibleInventory -Path $TestDrive -OutputType "INI" -Inventory $Instance} | Should -Not -Throw
        }

        It '[AnsibleInventory] -->  Export-AnsibleInventory : - should not throw an error when outputtype is json' {
            # Arrange
            $Instance = New-AnsibleInventory
            $Instance.SetPath($TestDrive)
            $Entry = New-AnsibleInventoryEntry -NodeName "Node1" -Group "Test"
            $Instance.AddInventoryEntry($Entry)

            # Act & Assert
            { Export-AnsibleInventory -Path $TestDrive -OutputType "JSON" -Inventory $Instance} | Should -Not -Throw
        }

        It '[AnsibleInventory] -->  Export-AnsibleInventory : - should return correct inventory structure in json' {
            # Arrange
            $Instance = New-AnsibleInventory
            $Instance.SetPath($TestDrive)
            $Entry = New-AnsibleInventoryEntry -NodeName "Node1" -Group "Test"
            $Instance.AddInventoryEntry($Entry)

            # Act
            Export-AnsibleInventory -Path $TestDrive -OutputType "JSON" -Inventory $Instance

            # Assert
            $result = Get-Content (Join-Path -Path $TestDrive -ChildPath 'inventory.json') -Raw | ConvertFrom-Json
            $result.Test.Hosts | Should -Be "Node1"
            $result._meta.Host_vars.length | Should -Be 0
        }
    }
}

Set-Location $Location