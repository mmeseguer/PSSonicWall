function ConvertFrom-AddressGroup {
    param (
        # Object to convert
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$Objects,
        # Version type for the query
        [Parameter(Mandatory=$true)]
        [ValidateSet('ipv4','ipv6')]
        [string]$IpVersion
    )
    begin {
        # Set object type
        $Type = 'address_object'
    }
    process {
        # Loop through objects
        ForEach ($Object in $Objects) {
            # Getting the nested properties
            #$NestedProperties = $Object.$Type.$IpVersion.PSObject.BaseObject.Properties.Name
            $NestedProperties = 'Name'
            # Flatting property
            ForEach ($NestedProperty in $NestedProperties) {
                $Object | Add-Member -Name "object_$($NestedProperty)" -Type NoteProperty -Value $Object.$Type.$IpVersion.$NestedProperty
            }

            # Remove nested property
            $Object.PSObject.Properties.Remove($Type)
        }
        Return $Objects
    }
}