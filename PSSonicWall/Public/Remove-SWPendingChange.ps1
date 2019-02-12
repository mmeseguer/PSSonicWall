function Remove-SWPendingChange {
    <#
    .SYNOPSIS
    Removes pending changes from SonicWall Appliance.

    .DESCRIPTION
    This function removes the changes in the staging area from a SonicWall appliance.

    .EXAMPLE
    Remove-SWPendingChange
    Remove all the changes in the staging area pending of commit.

    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param (
    )

    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'delete'

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

        if ($PSCmdlet.ShouldProcess('Delete current changes in staging area.')) {
            $Result = Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType
        }
        # Return the result
        $Result
    }
}