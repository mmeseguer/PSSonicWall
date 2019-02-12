function Write-SWPendingChange {
    <#
    .SYNOPSIS
    Apply's pending changes from SonicWall Appliance.

    .DESCRIPTION
    This function apply's the changes in the staging area from a SonicWall appliance.

    .EXAMPLE
    Write-SWPendingChange
    Apply all the changes in the staging area pending of commit.

    #>
    [CmdletBinding()]
    param (
    )

    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'post'

        # Declaring the base resource
        $BaseResource = 'config'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection

        # Building full resource
        $Resource = "$BaseResource/pending"
    }
    process {
        # Query for pending changes
        $Result = Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType

        # Return the result
        $Result
    }
}