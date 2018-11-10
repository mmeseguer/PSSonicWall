function Get-SWDns {
    <#
    .SYNOPSIS
    Retrieve DNS configuration from SonicWall appliance.

    .DESCRIPTION
    This function gets DNS configuration from a SonicWall appliance.

    .EXAMPLE
    Get-SWDns
    Gets the SonicWall appliance DNS configuration.
    #>
    [CmdletBinding()]
    param (

    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'dns'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        # Query for DNS config
        $Resource = $BaseResource
        $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).$BaseResource

        # Return the result
        $Result
    }
}