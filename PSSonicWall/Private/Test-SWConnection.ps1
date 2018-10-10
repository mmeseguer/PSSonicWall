# Tests if current SonicWall connection is valid
Function Test-SWConnection {
    # If an existing connection exists we test it
    if ($env:SWConnection) {
        Try {
            # Make a dummy request
            Invoke-RestMethod -Uri "$($env:SWConnection)config/pending" -Method Get -ContentType 'application/json' | Out-Null
        }
        Catch {
            # If we cannot connect to the previously established connection throw an error
            Throw 'Your previous connection is disconnected. Use Connect-SWAppliance to connect again.'
        }
    }
    # If there's no connection string throw an error
    else {
        Throw 'You are not connected to any SonicWall Appliance. Use Connect-SWAppliance to connect.'
    }
}