function Get-SWAddressObject {
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
                    if ($Result) {
                        $Result = ConvertFrom-AddressObject -Object $Result -Type $Type
                    }
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
                        # Flatten object if it's an IP subtype
                        $IpSubTypes | ForEach-Object {
                            If ($Result.PSObject.Properties.Name -contains $_) {
                                $Result = ConvertFrom-AddressObject -Object $Result -Type $_
                            }
                        }
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
                $Names = $RelatedObject.object_Name
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
                            # Flatten object if it's an IP subtype
                            $IpSubTypes | ForEach-Object {
                                If ($Result.PSObject.Properties.Name -contains $_) {
                                    $Result = ConvertFrom-AddressObject -Object $Result -Type $_
                                }
                            }
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