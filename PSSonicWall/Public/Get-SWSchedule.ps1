function Get-SWSchedule {
    <#
    .SYNOPSIS
    Retrieve Schedules from SonicWall appliance.

    .DESCRIPTION
    This function gets the Schedules from a SonicWall appliance.

    .PARAMETER Name
    Name of the object to query.

    .EXAMPLE
    Get-SWSchedule
    Basic usage. Gets all the schedules from a SonicWall appliance.

    .EXAMPLE
    Get-SWSchedule -Name test
    Gets the schedule named 'test'
    #>
    [CmdletBinding()]
    param (
        # Name of the schedule
        [string]$Name
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'schedules'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection

    }
    process {
        # If a $Name exists limit the search to it
        if ($Name) {
            $Resource = "$BaseResource/name/$Name"
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).schedule
        }
        # If there are no parameters query for all interfaces
        else {
            $Resource = "$BaseResource"
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).$BaseResource
        }
        # Return the result
        $Result
    }
}