
$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (get-item $TestsPath).Parent

$path = Join-Path -Path $RootFolder.FullName -ChildPath 'Code/Classes'


Push-Location -Path $Path

. .\ansible.variables.ps1

$FakeInventory = @"
[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
"@
Describe '[AnsibleVar]-[Constructors]' {

    It '[AnsibleVar]-[Constructor] - Parameterless should Not Throw' {

        # -- Arrange

        # -- Act

        # -- Assert

        { [AnsibleVar]::New() } | Should Not Throw 

    }# end of it block


    It '[AnsibleVar]-[Constructor]([String]Name,[Object]Value) should Not Throw' {

        # -- Arrange


        [String]$Name = ''


        [Object]$Value = ''

        # -- Act

        # -- Assert

        { [AnsibleVar]::New($Name, $Value) } | Should Not Throw 

    }# end of it block


    It '[AnsibleVar]-[Constructor]([String]Name,[Object]Value,[AnsibleVarType]VarType) should Not Throw' {

        # -- Arrange


        [String]$Name = 'myvar'


        [Object]$Value = 'myvalue'


        [AnsibleVarType]$VarType = 'Group'

        # -- Act

        # -- Assert

        { [AnsibleVar]::New($Name, $Value, $VarType) } | Should Not Throw 

    }# end of it block


    It '[AnsibleVar]-[Constructor]([String]Name,[Object]Value,[AnsibleVarType]VarType,[String]ContainerName) should Not Throw' {

        # -- Arrange


        [String]$Name = 'hello'


        [Object]$Value = 'nothelo'


        [AnsibleVarType]$VarType = 'host'


        [String]$ContainerName = 'server123'

        # -- Act

        # -- Assert

        { [AnsibleVar]::New($Name, $Value, $VarType, $ContainerName) } | Should Not Throw 

    }# end of it block


}# end of Describe block
Describe '[AnsibleVariableCollection]-[Constructors]' {

    It '[AnsibleVariableCollection]-[Constructor] - Parameterless should Not Throw' {

        # -- Arrange

        # -- Act

        # -- Assert

        { [AnsibleVariableCollection]::New() } | Should Not Throw 

    }# end of it block


    It '[AnsibleVariableCollection]-[Constructor]([AnsibleVar[]]Variables) should Not Throw' {

        # -- Arrange

        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'host')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'host')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'host')

        # -- Act

        # -- Assert

        { [AnsibleVariableCollection]::New($vars) } | Should Not Throw 

    }# end of it block


}# end of Describe block
Describe '[AnsibleVariableCollection]-[Methods]' {

    #Public Method
    It '[AnsibleVariableCollection] --> AddVariable($Variable) :  - should Not Throw' {

        # -- Arrange

        [AnsibleVar]$Variable = [AnsibleVar]::New('var1', 'val1', 'host')

        # -- Act

        $Instance = [AnsibleVariableCollection]::New()

        # -- Assert

        { $Instance.AddVariable($Variable) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> AddVariable($Variable) :  - should return void' {

        # -- Arrange
        [AnsibleVar]$Variable =  [AnsibleVar]$Variable = [AnsibleVar]::New('var1', 'val1', 'host')

        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        # -- Assert

        $Instance.AddVariable($Variable) | should be $null

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> SetVariables($Variables) :  - should Not Throw' {

        # -- Arrange

        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'host')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'host')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'host')

        # -- Act

        $Instance = [AnsibleVariableCollection]::New()

        # -- Assert

        { $Instance.SetVariables($vars) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> SetVariables($Variables) :  - should return type []' {

        # -- Arrange
        $Variables = @()
        $Variables += [AnsibleVar]::New('var1', 'val1', 'host')
        $Variables += [AnsibleVar]::New('var2', 'val2', 'host')
        

        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        # -- Assert

        $Instance.SetVariables($Variables) | should be $null

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetGrouping() : [Object] - should Not Throw' {

        # -- Arrange

        # -- Act

        $Instance = [AnsibleVariableCollection]::New()

        # -- Assert

        { $Instance.GetGrouping() } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetGrouping() : [GroupInfo] - should return type [GroupInfo]' {

        # -- Arrange
        $Variables = @()
        $Variables += [AnsibleVar]::New('var1', 'val1', 'host')
        $Variables += [AnsibleVar]::New('var2', 'val2', 'host')
        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        $Instance.SetVariables($Variables)
        # -- Assert

        ($Instance.GetGrouping()).GetType().Name | should be GroupInfo

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> SetPath($Path) :  - should Not Throw' {

        # -- Arrange

        $InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'Inventory'
        New-Item -ItemType Directory -Path $InventoryFolder

        $InventoryFile = Join-Path -Path $InventoryFolder -ChildPath "inventory.ini"
        Out-File -FilePath $InventoryFile -Force -InputObject $FakeInventory 

        [System.Io.DirectoryInfo]$Path = $InventoryFolder

        # -- Act

        $Instance = [AnsibleVariableCollection]::New()

        # -- Assert

        { $Instance.SetPath($Path) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> SetPath($Path) :  - should return void' {

        # -- Arrange
        $InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'Inventory'


        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        # -- Assert

        $Instance.SetPath($InventoryFolder) | should be $Null

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> Export() :  - should Not Throw' {

        # -- Arrange
        $InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'Inventory'
        $Variables = @()
        $Variables += [AnsibleVar]::New('var1', 'val1', 'host')
        $Variables += [AnsibleVar]::New('var2', 'val2', 'host')
        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        $Instance.SetVariables($Variables)
        $Instance.SetPath($InventoryFolder)
        # -- Assert

        { 
            $Instance.Export() 
        } | Should Not Throw

        #TODO
            #Add tests to validate the contents that gets created

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> Export() :  - should be void' {

        # -- Arrange
        $InventoryFolder = Join-Path -Path $TestDrive -ChildPath 'Inventory'
        $Variables = @()
        $Variables += [AnsibleVar]::New('var1', 'val1', 'host')
        $Variables += [AnsibleVar]::New('var2', 'val2', 'host')
        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        $Instance.SetVariables($Variables)
        $Instance.SetPath($InventoryFolder)

        # -- Assert

        $Instance.Export() | should be $null

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetGroupVariables() : [AnsibleVar[]] - should Not Throw' {

        # -- Arrange

        # -- Act

        $Instance = [AnsibleVariableCollection]::New()

        # -- Assert

        { $Instance.GetGroupVariables() } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetGroupVariables() : [AnsibleVar[]] - should return type [AnsibleVar[]]' {

        # -- Arrange
        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'Group')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'Group')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'Group')
        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        $Instance.AddVariable($vars)
        # -- Assert

        ($Instance.GetGroupVariables()).GetType().Name | should be AnsibleVar[]

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetHostVariables() : [AnsibleVar[]] - should Not Throw' {

        # -- Arrange
        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'host')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'host')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'host')
        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        $Instance.AddVariable($vars)


        # -- Assert

        { $Instance.GetHostVariables() } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetHostVariables() : [AnsibleVar[]] - should return type [AnsibleVar[]]' {

        # -- Arrange
        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'host')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'host')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'host')
        # -- Act

        $Instance = [AnsibleVariableCollection]::New()
        $Instance.AddVariable($vars)
        # -- Assert

        ($Instance.GetHostVariables()).GetType().Name | should be AnsibleVar[]

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetVariable($Name) : [AnsibleVar[]] - should Not Throw' {

        # -- Arrange

        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'host')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'host')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'host')
        # -- Act

        [String]$Name = 'var1'

        $Instance = [AnsibleVariableCollection]::New()
        $Instance.AddVariable($vars)


        # -- Assert

        { $Instance.GetVariable($Name) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetVariable($Name) : [AnsibleVar[]] - should return type [AnsibleVar[]]' {

        # -- Arrange
        [String]$Name = 'var1'

        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'host')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'host')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'host')
        # -- Act

        [String]$Name = 'var1'

        $Instance = [AnsibleVariableCollection]::New()
        $Instance.AddVariable($vars)
        # -- Assert

        ($Instance.GetVariable($Name)).GetType().Name | should be AnsibleVar[]

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetVariableFromContainer($ContainerName) : [AnsibleVar[]] - should Not Throw' {

        # -- Arrange

        $ContainerName = 'node2'
        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'host','node1')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'host','node2')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'host','node1')
        # -- Act


        $Instance = [AnsibleVariableCollection]::New()
        $Instance.AddVariable($vars)
        # -- Act

        $Instance = [AnsibleVariableCollection]::New()

        # -- Assert

        { $Instance.GetVariableFromContainer($ContainerName) } | Should Not Throw

    } #End It Block

    #Public Method
    It '[AnsibleVariableCollection] --> GetVariableFromContainer($ContainerName) : [AnsibleVar[]] - should return type [AnsibleVar[]]' {

        # -- Arrange

        $ContainerName = 'node2'

        $vars = @()
        $Vars += [AnsibleVar]::New('var1', 'val1', 'host','node1')
        $Vars += [AnsibleVar]::New('var2', 'val2', 'host','node2')
        $Vars += [AnsibleVar]::New('var3', 'val3', 'host','node1')
        # -- Act


        $Instance = [AnsibleVariableCollection]::New()
        $Instance.AddVariable($vars)

        # -- Assert

        ($Instance.GetVariableFromContainer($ContainerName)).GetType().Name | should be AnsibleVar[]

    } #End It Block

}#EndDescribeBlock

