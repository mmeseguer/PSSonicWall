function Get-SWAccessRule {
    <#
    .SYNOPSIS
    Retrieve Access Rules from SonicWall appliance.

    .DESCRIPTION
    This function gets Access Rules from a SonicWall appliance.

    .PARAMETER IpVersion
    Ip version of the objects to query. You can select ipv4 (default), ipv6 and all.

    .EXAMPLE
    Get-SWAccessRule
    Basic usage. Prints all ipv4 Access Rules from the connected SonicWall appliance.

    .EXAMPLE
    Get-SWAccessRule -IpVersion ipv6
    Prints all ipv6 Access Rules from the connected SonicWall appliance.

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
        $BaseResource = 'access-rules'

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
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).access_rules.$IpVersion
        }
        # If we are querying all the types loop through them
        else {
            ForEach ($IpVersion in $IpVersions) {
                $Resource = "$BaseResource/$IpVersion"
                $Result += (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).access_rules.$IpVersion
            }
        }
        # Return the result
        $Result
    }
}