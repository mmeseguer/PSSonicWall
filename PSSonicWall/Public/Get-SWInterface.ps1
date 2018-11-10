function Get-SWInterface {
    <#
    .SYNOPSIS
    Retrieve interfaces from SonicWall appliance.

    .DESCRIPTION
    This function gets the interfaces and its configuration from a SonicWall appliance.

    .PARAMETER Name
    Name of the object to query.

    .EXAMPLE
    Get-SWInterface
    Basic usage. Gets all the interfaces from a SonicWall appliance.

    .EXAMPLE
    Get-SWInterface -Name X0
    Gets the interface X0.
    #>
    [CmdletBinding()]
    param (
        # Name of the interface
        [string]$Name
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'interfaces'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection

        # Declaring the IP version
        $IpVersion = 'ipv4'
    }
    process {
        # If a $Name exists limit the search to it
        if ($Name) {
            $Resource = "$BaseResource/$IpVersion/name/$Name"
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).interface.$IpVersion
        }
        # If there are no parameters query for all interfaces
        else {
            $Resource = "$BaseResource/$IpVersion"
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).$BaseResource.$IpVersion
        }
        # Return the result
        $Result
    }
}