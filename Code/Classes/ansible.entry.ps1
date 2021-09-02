

Class AnsibleInventoryEntry {

    [String]$NodeName
    $GroupMemberShip = [System.Collections.Generic.List[string]]::new()
    

    #stage_tenantName_OS-Category_BusingessGroup_NodeName

    AnsibleInventoryEntry() {}

    AnsibleInventoryEntry([String]$NodeName) {
        $this.NodeName = $NodeName
    }

    AnsibleInventoryEntry($NodeName, $GroupMemberShip) {
        $this.GroupMemberShip = $GroupMemberShip
        $this.NodeName = $NodeName
    }

    AddToGroup([String]$Group) {
        $this.GroupMemberShip.Add($Group)
    }

    [String]ToString() {
        Return "{0} {1} {2}" -f $this.NodeName, "->", ($this.GroupMemberShip -join ",")
    }

    [Bool]IsInGroup([String]$GroupName) {
        Return ($this.GroupMemberShip.contains($GroupName))
    }


}


Class AnsibleInventoryEntryCollection {
    
    [System.Collections.Generic.List[AnsibleInventoryEntry]] $Entries = [System.Collections.Generic.List[AnsibleInventoryEntry]]::new()

    AnsibleInventoryEntryCollection() {}

    AnsibleInventoryEntryCollection([AnsibleInventoryEntry[]]$Entry) {

            $this.AddEntry($Entry)

    }

    AddEntry($Entry) {
        foreach ($ent in $Entry) {
            $this.Entries.add($ent)
        }
        
    }

    [AnsibleInventoryEntry] GetEntry([String]$NodeName) {
        Return ($this.Entries | ? { $_.NodeName -eq $NodeName })
    }

    [String] ToString() {
        Return "TotalEntries: {0}" -f $this.Entries.Count
    }

    [System.Collections.Generic.List[AnsibleInventoryEntry]] GetEntries() {
        return $this.Entries
    }

    [AnsibleInventoryGrouping[]]CreateGrouping() {
        $Groupings = @{}
        Foreach ($entry in $This.Entries) {

            foreach ($groupName in $entry.GroupMemberShip) {
                If (!($groupings.ContainsKey($groupName))) {
                    $groupings.$GroupName = [System.Collections.Generic.List[String]]::new()

                }

                If (!($groupings.$GroupName.Contains($entry.NodeName))) {
                    $groupings.$GroupName.Add($Entry.NodeName)
                }
            }

        }
        
        $ansgrp = @()
        foreach ($grpkey in $Groupings.Keys) {
            $g = New-AnsibleInventoryGrouping -Name $grpkey -Members $Groupings.$grpkey
            $ansgrp += $g
            $g = $null
        }

        return $ansgrp
    }

}
