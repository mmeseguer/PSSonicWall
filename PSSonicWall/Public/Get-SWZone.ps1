function Get-SWZone {
    [CmdletBinding()]
    param (
        # Name of the zone
        [string]$Name
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'zones'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        # If a $Name exists limit the search to it
        if ($Name) {
            $Resource = "$BaseResource/name/$Name"
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).zone
        }
        # If there are no parameters query for all service groups
        else {
            $Resource = $BaseResource
            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).$BaseResource
        }
        # Return the result
        $Result
    }
}