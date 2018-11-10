function Get-SWAddressGroup {
    <#
    .SYNOPSIS
    Retrieve Address Groups from SonicWall appliance.

    .DESCRIPTION
    This function gets Address Groups from a Sonicwall appliance.
    The result from this function can be piped to Get-SWAddressObject to get the detail from the address objects of an address group.

    .PARAMETER IpVersion
    Ip version of the objects to query. You can select ipv4 (default), ipv6 and all.

    .PARAMETER Name
    Name of the object to query.

    .EXAMPLE
    Get-SwAddressGroup
    Basic usage. Retrieves all the ipv4 Address Groups.

    .EXAMPLE
    Get-SwAddressGroup -IpVersion all
    Retrieves all the Address Groups.

    .EXAMPLE
    Get-SwAddressGroup -Name test
    Retrieves 'test' Address Group.

    #>
    [CmdletBinding()]
    param (
        # Version type for the query
        [Parameter(ParameterSetName='byIpVersion')]
        [ValidateSet('ipv4','ipv6','all')]
        [string]$IpVersion='ipv4',
        # Name of the address object
        [Parameter(Mandatory=$true,ParameterSetName='byName')]
        [string]$Name
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'address-groups'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection
    }
    process {
        switch ($PSCmdlet.ParameterSetName){
            'byIpVersion' {
                # Build the $IpVersions variable to loop through versions if no $IpVersion configured
                If ($IpVersion -eq 'all') {
                    $IpVersions = @('ipv4','ipv6')
                }
                else {
                    $IpVersions = $IpVersion
                }
                # Loop through $IpVersions
                foreach ($IpVersion in $IpVersions) {
                    # Build the resource
                    $Resource = "$BaseResource/$IpVersion"
                    # Query for address groups
                    $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_groups.$IpVersion
                    $Result
                }
            }
            'byName' {
                # Declaration of the IP versions
                $IpVersions = @('ipv4','ipv6')

                # Loop through the types
                foreach ($IpVersion in $IpVersions) {
                    # Build of the resource
                    $Resource = "$BaseResource/$IpVersion/name/$Name"
                    # Try to make the request. If it works we exit the loop, if it fails it means that it doesn't exist in this $ObjectType, so we continue.
                    Try {
                        $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_group.$IpVersion
                        Break
                    }
                    Catch {
                        Continue
                    }
                }
                # If the loop ended without a result we Throw an error
                if (!$Result) {
                    Throw "Object '$Name' not found."
                }
                # Return the results
                $Result
            }
        }
    }
}