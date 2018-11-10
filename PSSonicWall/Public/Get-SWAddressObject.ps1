function Get-SWAddressObject {
    <#
    .SYNOPSIS
    Retrieve Address Objects from SonicWall appliance.

    .DESCRIPTION
    This function gets Address Objects from a Sonicwall appliance.
    It can use an object piped from Get-SWAddressGroup to get the detail from the address objects of an address group.

    .PARAMETER Type
    Address Object type. It can be 'host','range','network','mac' or 'fqdn'.

    .PARAMETER IpVersion
    Ip version of the objects to query. You can select ipv4 (default) and ipv6.

    .PARAMETER Name
    Name of the object to query.

    .PARAMETER RelatedObject
    Object retrieved by Get-SWAddressGroup.

    .EXAMPLE
    Get-SWAddressObject -Type host
    Retrieve all the 'host' Address Objects.

    .EXAMPLE
    Get-SWAddressObject -Name test
    Retrieves 'test' Address Object.

    .EXAMPLE
    Get-SWAddressGroup -Name test | Get-SWAddressObject
    Retrieve the Address Objects contained in 'test Address Group.

    #>
    [CmdletBinding()]
    param (
        # Type of address object
        [Parameter(Mandatory=$true,ParameterSetName='byType')]
        [ValidateSet('host','range','network','mac','fqdn')]
        [string]$Type,
        # Version type for the query
        [ValidateSet('ipv4','ipv6')]
        [string]$IpVersion ='ipv4',
        # Name of the object
        [Parameter(Mandatory=$true,ParameterSetName='byName')]
        [string]$Name,
        # Use pipelined object
        [Parameter(Mandatory=$true,ValueFromPipeline,ParameterSetName='byInputObject')]
        [PSCustomObject]$RelatedObject
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'get'

        # Declaring the base resource
        $BaseResource = 'address-objects'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection

        # Building array of ip subtypes
        $IpSubTypes = 'host','range','network'
    }
    process {
        switch ($PSCmdlet.ParameterSetName){
            'byType' {
                # If it's an IP subtype we add the IP version to the resource
                if ($IpSubtypes -contains $Type) {
                    $Resource = "$BaseResource/$IpVersion"
                    # Querying for address objects
                    $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_objects.$IpVersion | Where-Object {$_.PSobject.Properties.Name -contains $Type}
                }
                # If not just build the resource with the type
                else {
                    $Resource = "$BaseResource/$Type"
                    # Querying for address objects
                    $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_objects.$Type
                }
                # Filter by name if introduced
                if ($Name) {
                    $Result = $Result | Where-Object Name -eq $Name
                }
                # Return the results
                $Result
            }
            'byName' {
                # Declaration of the Address Object types
                $ObjectTypes = @('ipv4','ipv6','mac','fqdn')
                # Loop through the types
                foreach ($ObjectType in $ObjectTypes) {
                    # Build of the resource
                    $Resource = "$BaseResource/$ObjectType/name/$Name"
                    # Try to make the request. If it works we exit the loop, if it fails it means that it doesn't exist in this $ObjectType, so we continue.
                    Try {
                        $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_object.$ObjectType
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
            'byInputObject' {
                # Getting the name of the object
                $IpVersion = $RelatedObject.address_object.PSObject.Properties.Name
                $Names = $RelatedObject.address_object.$IpVersion.name
                # Loop through Names names
                foreach ($Name in $Names) {
                    # Declaration of the Address Object types
                    $ObjectTypes = @('ipv4','ipv6','mac','fqdn')
                    # Loop through the types
                    foreach ($ObjectType in $ObjectTypes) {
                        # Build of the resource
                        $Resource = "$BaseResource/$ObjectType/name/$Name"
                        # Try to make the request. If it works we exit the loop, if it fails it means that it doesn't exist in this $ObjectType, so we continue.
                        Try {
                            $Result = (Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType).address_object.$ObjectType
                            $Result
                            Break
                        }
                        Catch {
                            Continue
                        }
                    }
                }
            }
        }
    }
}