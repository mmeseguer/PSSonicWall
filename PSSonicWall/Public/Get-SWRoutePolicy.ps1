function Get-SWRoutePolicy {
    <#
    .SYNOPSIS
    Retrieve Routing Policies from SonicWall appliance.

    .DESCRIPTION
    This function gets the Routing Policies from a SonicWall appliance.

    .PARAMETER IpVersion
    Ip version of the objects to query. You can select ipv4 (default), ipv6 and all.

    .EXAMPLE
    Get-SWRoutePolicy
    Basic usage. Gets all of the ipv4 Routing Policies from a SonicWall appliance.

    .EXAMPLE
    Get-SWRoutePolicy -IpVersion all
    Gets all of the Routing Policies from a SonicWall appliance.
    #>
    [CmdletBinding()]
    param (
        # Version type for the query
        [ValidateSet('ipv4','ipv6','all')]
        [string]$IpVersion ='ipv4'
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'route-policies'

        # Declaring the content type
        $ContentType = 'application/json'

        # Declaring IP Types
        $IpVersions = 'ipv4','ipv6'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        # If we are not querying a certain ip type show it
        if ($IpVersion -ne 'all') {
            $Resource = "$BaseResource/$IpVersion"
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).route_policies.$IpVersion
        }
        # If we are querying all the types loop through them
        else {
            ForEach ($IpVersion in $IpVersions) {
                $Resource = "$BaseResource/$IpVersion"
                $Result += (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).route_policies.$IpVersion
            }
        }
        # Return the result
        $Result
    }
}