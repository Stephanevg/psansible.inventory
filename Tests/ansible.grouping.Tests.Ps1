#region Header

$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'psansible.inventory'


Push-Location -Path $Path

ipmo ./psansible.inventory.psm1 -Force


#endregion Header

InModuleScope -ModuleName psansible.inventory -ScriptBlock {


    Describe '[AnsibleInventoryGrouping]-[Constructors]' {

        It '[AnsibleInventoryGrouping]-[Constructor] - Parameterless should Not Throw' {

            # -- Arrange

            # -- Act

            # -- Assert

            { [AnsibleInventoryGrouping]::New() } | Should Not Throw 

        }# end of it block


        It '[AnsibleInventoryGrouping]-[Constructor]([string]Name) should Not Throw' {

            # -- Arrange


            [string]$Name = ''

            # -- Act

            # -- Assert

            { [AnsibleInventoryGrouping]::New($Name) } | Should Not Throw 

        }# end of it block


        It '[AnsibleInventoryGrouping]-[Constructor]([String]Name,[Array]Members) should Not Throw' {

            # -- Arrange


            [String]$Name = ''


            [Array]$Members = ''

            # -- Act

            # -- Assert

            { [AnsibleInventoryGrouping]::New($Name, $Members) } | Should Not Throw 

        }# end of it block


    }# end of Describe block
    Describe '[AnsibleInventoryGroupingCollection]-[Constructors]' {

        It '[AnsibleInventoryGroupingCollection]-[Constructor] - Parameterless should Not Throw' {

            # -- Arrange

            # -- Act

            # -- Assert

            { [AnsibleInventoryGroupingCollection]::New() } | Should Not Throw 

        }# end of it block


        It '[AnsibleInventoryGroupingCollection]-[Constructor](Groups) should Not Throw' {

            # -- Arrange


            $Groups = 'GroupA'

            # -- Act

            # -- Assert

            { [AnsibleInventoryGroupingCollection]::New($Groups) } | Should Not Throw 

        }# end of it block


    }# end of Describe block
    Describe '[AnsibleInventoryGroupingCollection]-[Methods]' {

        #Public Method
        It '[AnsibleInventoryGroupingCollection] --> AddGrouping($Grouping) :  - should Not Throw' {

            # -- Arrange

            $Grouping = 'Woopa'

            # -- Act

            $Instance = [AnsibleInventoryGroupingCollection]::New()

            # -- Assert

            { $Instance.AddGrouping($Grouping) } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventoryGroupingCollection] --> AddGrouping($Grouping) :  - should return void' {

            # -- Arrange
            $Grouping = 'Test'

            # -- Act

            $Instance = [AnsibleInventoryGroupingCollection]::New()
            # -- Assert

            $Instance.AddGrouping($Grouping) | should be $null

        } #End It Block

        #Public Method
        It '[AnsibleInventoryGroupingCollection] --> GetGroupNames() : [String] - should Not Throw' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventoryGroupingCollection]::New()

            # -- Assert

            { $Instance.GetGroupNames() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventoryGroupingCollection] --> GetGroupNames() : [String] - should return type [String]' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventoryGroupingCollection]::New()
            # -- Assert

            ($Instance.GetGroupNames()).GetType().Name | should be String

        } #End It Block

        #Public Method
        It '[AnsibleInventoryGroupingCollection] --> ToString() : [String] - should Not Throw' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventoryGroupingCollection]::New()

            # -- Assert

            { $Instance.ToString() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventoryGroupingCollection] --> ToString() : [String] - should return type [String]' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventoryGroupingCollection]::New()
            # -- Assert

            ($Instance.ToString()).GetType().Name | should be String

        } #End It Block

        #Public Method
        It '[AnsibleInventoryGroupingCollection] --> ConvertToIni() : [string] - should Not Throw' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventoryGroupingCollection]::New()

            # -- Assert

            { $Instance.ConvertToIni() } | Should Not Throw

        } #End It Block

        #Public Method
        It '[AnsibleInventoryGroupingCollection] --> ConvertToIni() : [string] - should return type [string]' {

            # -- Arrange

            # -- Act

            $Instance = [AnsibleInventoryGroupingCollection]::New()
            # -- Assert

            ($Instance.ConvertToIni()).GetType().Name | should be string

        } #End It Block

    }#EndDescribeBlock

}
