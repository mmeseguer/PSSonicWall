function Get-SWAddressObject {
    [CmdletBinding()]
    param (
        # SonicWall Appliance IP or FQDN
        [Parameter(Mandatory=$true)]
        [ValidateSet('ipv4','ipv6','mac','fqdn')]
        [string[]]$Type
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'address-objects'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        # Loop through the types
        foreach ($SubType in $Type) {
            # Building the resource
            $Resource = "$BaseResource/$Subtype"

            # Querying for address objects
            (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_objects.$SubType
        }
    }
}