function Get-SWPendingChange {
    <#
    .SYNOPSIS
    Retrieve pending changes from SonicWall Appliance.

    .DESCRIPTION
    This function gets the changes in the staging area from a SonicWall appliance.

    .EXAMPLE
    Get-SWPendingChange
    Gets all the changes in the staging area pending of commit.

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
        $BaseResource = 'config'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        # Query for pending changes
        $Resource = "$BaseResource/pending"
        $Result = Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType

        # Return the result
        $Result
    }
}