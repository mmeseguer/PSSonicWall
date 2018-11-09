function Disconnect-SWAppliance {
    <#
    .SYNOPSIS
    Disconnect from a previously connected SonicWall appliance.

    .DESCRIPTION
    Disconnects a previously stablished connection from the Connect-SWAppliance function.

    .EXAMPLE
    Disconnect-SWAppliance
    Disconnects from the SonicWall appliance.

    #>
    begin {
        # Declaring resource of the function
        $Resource = 'auth'
        # Declaring used rest method
        $Method = 'delete'
    }
    process{
        # If there's no connection throw error
        if (!$env:SWConnection) {
            Throw 'Cannot disconnect, you are not connected to any SonicWall appliance.'
        }

        # Try to disconnect the session and delete the env variable
        try {
            Invoke-RestMethod -Uri "$($env:SWConnection)$($Resource)" -Method $Method | Out-Null
            Remove-Item env:SWConnection
        }
        # On error just delete the env variable
        Catch {
            Remove-Item env:SWConnection
        }
    }
}