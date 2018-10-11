function Get-SWAddressGroup {
    [CmdletBinding()]
    param (
        # Version type for the query
        [ValidateSet('ipv4','ipv6')]
        [string]$IpVersion ='ipv4',
        # Name of the address object
        [string]$Name
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'address-groups'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        # If it's an IP subtype we add the IP version to the resource
        $Resource = "$BaseResource/$IpVersion"

        # Querying for address groups
        $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_groups.$IpVersion

        # Flatting object
        $Result = ConvertFrom-AddressGroup -Object $Result -IpVersion $IpVersion

        # Filter by name if introduced
        if ($Name) {
            $Result = $Result | Where-Object Name -eq $Name
        }

        # Return the results
        $Result
    }
}