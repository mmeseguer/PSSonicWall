function ConvertFrom-AddressObject {
    param (
        # Object to convert
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$Objects,
        # Type of object
        [Parameter(Mandatory=$true)]
        [ValidateSet('host','range','network')]
        [string]$Type
    )
    process {
        # Loop through objects
        ForEach ($Object in $Objects) {
            # Getting the nested properties in $Type
            $NestedProperties = $Object.$Type.PSObject.Properties.Name

            # Flatting property $Type
            ForEach ($NestedProperty in $NestedProperties) {
                $Object | Add-Member -Name $NestedProperty -Type NoteProperty -Value $Object.$Type.$NestedProperty
            }

            # Remove nested property
            $Object.PSObject.Properties.Remove($type)
        }
        Return $Objects
    }
}