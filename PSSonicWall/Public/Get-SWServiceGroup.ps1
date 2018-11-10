function Get-SWServiceGroup {
    <#
    .SYNOPSIS
    Retrieve Service Groups from SonicWall appliance.

    .DESCRIPTION
    This function gets the Service Groups from a SonicWall appliance.

    .PARAMETER Name
    Name of the object to query.

    .EXAMPLE
    Get-SWServiceGroup
    Basic usage. Gets all the Service Groups from a SonicWall appliance.

    .EXAMPLE
    Get-SWServiceGroup -Name test
    Gets the Service Group named 'test'
    #>
    [CmdletBinding()]
    param (
        # Name of the service group
        [string]$Name
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'service-groups'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        # If a $Name exists limit the search to it
        if ($Name) {
            $Resource = "$BaseResource/name/$Name"
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).service_group
        }
        # If there are no parameters query for all service groups
        else {
            $Resource = $BaseResource
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).service_groups
        }
        # Return the result
        $Result
    }
}