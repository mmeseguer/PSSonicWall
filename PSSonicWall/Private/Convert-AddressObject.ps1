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
        ForEach ($Object in $Objects) {
            # Add properties based on object type
            switch ($type) {
                'host' {
                    $Object | Add-Member -Name 'ip' -Type NoteProperty -Value $Object.$Type.Ip
                }
                'range' {
                    $Object | Add-Member -Name 'begin' -Type NoteProperty -Value $Object.$Type.Begin
                    $Object | Add-Member -Name 'end' -Type NoteProperty -Value $Object.$Type.End
                }
                'network' {
                    $Object | Add-Member -Name 'subnet' -Type NoteProperty -Value $Object.$Type.Subnet
                    $Object | Add-Member -Name 'mask' -Type NoteProperty -Value $Object.$Type.Mask
                }
            }
            $Object.PSObject.Properties.Remove($type)
        }
        Return $Objects
    } 
}