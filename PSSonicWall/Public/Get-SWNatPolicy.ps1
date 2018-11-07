function Get-SWNatPolicy {
    [CmdletBinding()]
    param (
        # Version type for the query
        [ValidateSet('ipv4','ipv6','nat64','all')]
        [string]$IpVersion ='ipv4'
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'nat-policies'

        # Declaring the content type
        $ContentType = 'application/json'

        # Declaring IP Types
        $IpVersions = 'ipv4','ipv6','nat64'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        # If we are not querying a certain ip type show it
        if ($IpVersion -ne 'all') {
            $Resource = "$BaseResource/$IpVersion"
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).nat_policies.$IpVersion
        }
        # If we are querying all the types loop through them 
        else {
            ForEach ($IpVersion in $IpVersions) {
                $Resource = "$BaseResource/$IpVersion"
                $Result += (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).nat_policies.$IpVersion
            }
        }
        # Return the result
        $Result
    }
}