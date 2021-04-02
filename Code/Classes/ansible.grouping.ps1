 
Class AnsibleInventoryGrouping {
    [String]$Name
    $members = [System.Collections.Generic.List[string]]::new()
    [Bool]$HasChildren

    AnsibleInventoryGrouping() {

    }

    AnsibleInventoryGrouping([string]$Name) {
        $this.Name = $Name
    }

    AnsibleInventoryGrouping([String]$Name, [Array]$Members) {
        $this.Name = $Name
        $this.Members = $Members
    }

    AddMember([String[]]$Members) {
        foreach ($member in $members) {
            write-verbose "Adding member $($member)"
            $this.members.add($member)
        }
        
    }

    [array] GetMembers() {
        return $this.members
    }

    [bool]HasMember([string]$MemberName) {
        return $this.members.Contains($MemberName)
              
    }

    [String] ToIni() {
        $string = ""


        if($this.HasChildren){
            $String += "[{0}:{1}]`n" -f $this.Name,"children"
        }else{
            $String += "[{0}]`n" -f $this.Name
        }

        
        foreach ($member in $this.members) {
            $String += "$($member)`n"
        }
        $string += "`n"

        return $String
    }

    [void]SetHasChildren([bool]$HasChildren) {
        $this.HasChildren = $HasChildren
    }
}

Class AnsibleInventoryGroupingCollection {
    
    [System.Collections.Generic.List[AnsibleInventoryGrouping]]$Groups = [System.Collections.Generic.List[AnsibleInventoryGrouping]]::new()

    AnsibleInventoryGroupingCollection() {
        
    }

    AnsibleInventoryGroupingCollection($Groups) {
        $this.AddGrouping($Groups)
    }

    AddGrouping($Grouping) {
        foreach ($group in $grouping) {
            if($this.Groups){

                $GroupAlreadyExisting = $this.groups | ? {$_.Name -eq $group.Name}
                    

                if(($GroupAlreadyExisting) -and (!($GroupAlreadyExisting.hasChildren))){
    
                    #Group is NOT an arch group, and group is already present. adding members to the group.
    
                    
                    Foreach($member in $group.members){
    
                        $GroupAlreadyExisting.AddMember($member)
                    }
                }else{
    
                    #New group (not the first one)
                    $this.Groups.Add($group)
                }
            }else{
                #New and first group
                $this.Groups.Add($group)
            }
        }
        
    }

    [String]GetGroupNames() {
        return ($This.Groups.Name -join ",")
    }

    [String]ToString() {
        Return $This.Groups.Name -join ","
    }

    [string]ConvertToIni() {
        $String = ""
        Foreach ($group in $this.Groups) {
            $String += $Group.ToIni()
        }

        return $String
    }
}
