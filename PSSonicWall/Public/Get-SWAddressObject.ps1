function Get-SWAddressObject {
    [CmdletBinding()]
    param (
        # Type of address object
        [Parameter(Mandatory=$true)]
        [ValidateSet('host','range','network','mac','fqdn')]
        [string]$Type,
        # Version type for the query
        [ValidateSet('ipv4','ipv6')]
        [string]$IpVersion ='ipv4'
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

        # Building array of ip subtypes
        $IpSubTypes = 'host','range','network'
    }
    process {
        # If it's an IP subtype we add the IP version to the resource
        if ($IpSubtypes -contains $Type) {
            $Resource = "$BaseResource/$IpVersion"
            # Querying for address objects
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_objects.$IpVersion | Where-Object {$_.PSobject.Properties.Name -contains $Type}
            ConvertFrom-AddressObject -Object $Result -Type $Type
        }
        # If not just build the resource with the type
        else {
            $Resource = "$BaseResource/$Type"
            # Querying for address objects
            (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_objects.$Type
        }
    }
}