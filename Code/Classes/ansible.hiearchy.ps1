
Class AnsibleInventoryHiearchyEntry {
    $Parent
   [System.Collections.Generic.List[String]]$Children = [System.Collections.Generic.List[String]]::new()

   AnsibleInventoryHiearchyEntry(){}

   AnsibleInventoryHiearchyEntry($Parent) {
       $This.Parent = $Parent
   }

   AnsibleInventoryHiearchyEntry($Parent, $Children) {

       $this.Parent = $Parent
       $this.AddChild($Children)
   
   }

   [void] AddChild([string[]]$children) {
       foreach ($child in $children) {

           $this.Children.Add($Child)
       }
   }

   [Bool] HasChild([string]$Child) {
       return $this.Children.Contains($Child)
   }

   [String] ConvertToIni() {
       $FullString = ""
       
       $FullString += "[$($this.Parent):children]`n"
       Foreach ($Child in $this.children) {
           $FullString += "$($Child)`n"
       }

       $FullString += "`n"
       

       Return $FullString
   }

   [String] ToString() {
       Return  "{0} -> {1}" -f $this.Parent, ($this.Children -join ",")
   }
}

Class AnsibleInventoryHiearchyCollection {

   $Entries = [System.Collections.Generic.List[AnsibleInventoryHiearchyEntry[]]]::new()

   AnsibleInventoryHiearchyCollection() {
       
   }

   
   AnsibleInventoryHiearchyCollection([AnsibleInventoryHiearchyEntry[]]$Entry) {
       $this.Entries.Add($Entry)
   }

   AddEntry($Entry) {
       foreach ($ent in $Entry) {
           $this.Entries.add($ent)
       }
       
   }


   [string]ConvertToIni() {
       $String = ""
       Foreach ($arch in $this.Entries) {
           $String += $arch.ConvertToIni()
       }

       return $String
   }


   [AnsibleInventoryGrouping[]]CreateGrouping() {
       $Groupings = @{}
       

       $ansgrp = @()
       #Working on parent elements
       Foreach($archelement in $this.Entries){
           $g = New-AnsibleInventoryGrouping -Name $archelement.parent -Members $archelement.children -HasChildren
           $ansgrp += $g
           $g = $null
       }

       #Working on the children
      
       Foreach ($entry in $This.Entries) {

           foreach($child in $entry.Children){

               If(!($ansgrp.Name.contains($child))){
   
                   $g = New-AnsibleInventoryGrouping -Name $child
                   $ansgrp += $g
                   $g = $null
               }
           }
       }


       return $ansgrp
   }

}