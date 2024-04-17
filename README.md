# psansible.inventory
Ansible inventory helpers

## Build Status

[![Build status](https://ci.appveyor.com/api/projects/status/vl2w4727lq0qhgr7?svg=true)](https://ci.appveyor.com/project/bateskevin/psansible-inventory)

## main functionality

__psansible.inventory__ simplifies the management of __static__ inventories by allowing the automation of every component that an inventory is composed of.

__psansible.inventory__ allows to work with objects rather than with plain text / regexe's, and enable's complex scenarios around the automation of ansible inventories.


Currently, the following scenarios are supported:

- Inventory file *import/manage/export*
- Inventory structure *import/manage/export*
- Inventory entries *(Read/edit/write)*
- Inventory groups *(Read/edit/write)*
- Hierarchy definitions *(Read/edit/write)*
- group vars *(Read/edit/write)*
- host vars *(Read/edit/write)*

> psansible.inventory enabled what dynamic inventories offers, but for static inventories (and does it in an easy, standard proefficient way).



## installation

> First and formost you will need to install powershell. See the [following](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1) aricle to install it on linux.
Once installed, call `pwsh` from any shell to start it.

Once installed, you can download the module as following. (internet connection needed)

```powershell

install-module -Name psansible.inventory

```

If downloading from the internet is not option, you can download the module locally, and copy / paste it manually

## import an existing inventory

```powershell

Import-AnsibleInventory -Path '/user/etc/inventory.ini'

```

## Create a new inventory (from scrach)

```powershell

New-AnsibleInventory

#return

EntryCollection    : TotalEntries: 0
Hierarchy           : AnsibleInventoryHierarchyCollection
VariableCollection : AnsibleVariableCollection
GroupCollection    : 
Path               : 

```

## Creating an ansible inventory entry

In the following example, we are creating a new inventory entry for a server called ```server123``` which is member of the groups ```HR_Servers``` and ```PW_01```.

```powershell

New-AnsibleInventoryEntry -NodeName "server123" -Group "HR_Servers","PW_01"

#return

GroupMemberShip    NodeName
---------------    --------
{HR_Servers PW_01} server123

```

## Creating new variables

The following example shows how to create a host variable

```powershell

New-AnsibleInventoryVariable -Name "myvar" -value "123" -Type Host  -ContainerName "server123"

#Returns

Name  Value VarType ContainerName
----  ----- ------- -------------
myvar 123      Host server123

```
The following example shows how to create a group variable

```powershell

New-AnsibleInventoryVariable -Name "mydata" -value "456" -Type Group  -ContainerName "HR_Servers"

#Returns

Name   Value VarType ContainerName
----   ----- ------- -------------
mydata 456     Group HR_Servers
```

## Working with Hierarchy definitions

The following example shows how to create a simple Hierarchy. Both `HR_Servers` and `MK_Servers` are child groups of `prod`.

```powershell

New-AnsibleInventoryHierarchyEntry -ParentName "prod" -Children "HR_Servers","MK_Servers"


Children                 Parent
--------                 ------
{HR_Servers, MK_Servers} prod
```

## Exporting the inventory

The most simplest way of generating an inventory would be as followed.

Export Inventory to ini:

```powershell

$Inventory = New-AnsibleInventory
Export-AnsibleInventory -Inventory $Inventory -OutputType INI -Path './Inventories/Windows/'

```

Export Inventory to json:

```powershell

$Inventory = New-AnsibleInventory
Export-AnsibleInventory -Inventory $Inventory -OutputType json -Path './Inventories/Windows/'

```
