function New-SWAddressObject {
    <#
    .SYNOPSIS
    Creates a new Address Object in a SonicWall appliance.

    .DESCRIPTION
    This function creates a new Address Object in a Sonicwall appliance.

    .PARAMETER Host
    Switch to indicate the creation of an Address Object of type Host.

    .PARAMETER Ip
    Ip address of a host Address Object.

    .PARAMETER Range
    Switch to indicate the creation of an Address Object of type Range.

    .PARAMETER Begin
    Starter IP Address of a range Address Object.

    .PARAMETER End
    Ending IP Address of a range Address Object.

    .PARAMETER Network
    Switch to indicate the creation of an Address Object of type Network.

    .PARAMETER Subnet
    Subnet IP of the network Address Object.

    .PARAMETER Mask
    Subnet Mask of the network Address Object.

    .PARAMETER Mac
    Switch to indicate the creation of an Address Object of type Mac.

    .PARAMETER MacAddress
    MAC Address of the MAC Address Object.

    .PARAMETER MultiHomed
    Boolean to indicate that the MAC Address Object is Multihomed (Defaults to $true).

    .PARAMETER Fqdn
    Switch to indicate the creation of an Address Object of type FQDN.

    .PARAMETER Hostname
    Hostname of the FQDN.

    .PARAMETER DnsTtl
    Time in seconds of the DNS TTL (Min. 120, Max. 86400)

    .PARAMETER IpVersion
    Ip version of the Address Object to create. You can select ipv4 and ipv6.

    .PARAMETER Name
    Name of the Address Object to be created.

    .PARAMETER Zone
    Zone of the Address Object to be created.

    .EXAMPLE
    New-SWAddressObject -Host -Ip 192.168.168.168 -IpVersion ipv4 -Zone LAN -Name HostObject
    Create a Host address object.

    .EXAMPLE
    New-SWAddressObject -Network -Subnet 192.168.168.0 -Mask 255.255.255.0 -IpVersion ipv4 -Name NetworkObject -Zone LAN
    Create a Network address object.

    .EXAMPLE
    New-SWAddressObject -Range -Begin 192.168.168.168 -End 192.168.168.200 -IpVersion ipv4 -Name RangeObject -Zone LAN
    Create a Range address object.

    .EXAMPLE
    New-SWAddressObject -Mac -MacAddress 00-14-22-01-23-45 -Name MacObject -Zone LAN
    Create a MAC address object.

    .EXAMPLE
    New-SWAddressObject -Fqdn -Hostname sobrebits.com -Name Sobrebits -Zone WAN
    Create a FQDN address object.

    .EXAMPLE
    Get-SWAddressObject -Name test
    Retrieves 'test' Address Object.

    .EXAMPLE
    Get-SWAddressGroup -Name test | Get-SWAddressObject
    Retrieve the Address Objects contained in 'test Address Group.

    #>
    [CmdletBinding()]
    param (
        # Host parameters
        [Parameter(Mandatory=$true,ParameterSetName='byHost')]
        [switch]$Host,
        [Parameter(Mandatory=$true,ParameterSetName='byHost')]
        [IpAddress]$Ip,

        # Range parameters
        [Parameter(Mandatory=$true,ParameterSetName='byRange')]
        [switch]$Range,
        [Parameter(Mandatory=$true,ParameterSetName='byRange')]
        [IpAddress]$Begin,
        [Parameter(Mandatory=$true,ParameterSetName='byRange')]
        [IpAddress]$End,

        # Network parameters
        [Parameter(Mandatory=$true,ParameterSetName='byNetwork')]
        [switch]$Network,
        [Parameter(Mandatory=$true,ParameterSetName='byNetwork')]
        [IpAddress]$Subnet,
        [Parameter(Mandatory=$true,ParameterSetName='byNetwork')]
        [string]$Mask,

        # Mac parameters
        [Parameter(Mandatory=$true,ParameterSetName='byMac')]
        [switch]$Mac,
        [Parameter(Mandatory=$true,ParameterSetName='byMac')]
        [ValidatePattern('^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$')]
        [string]$MacAddress,
        [Parameter(ParameterSetName='byMac')]
        [bool]$MultiHomed=$true,
        # Fqdn parameters
        [Parameter(Mandatory=$true,ParameterSetName='byFqdn')]
        [switch]$Fqdn,
        [Parameter(Mandatory=$true,ParameterSetName='byFqdn')]
        [string]$Hostname,
        [Parameter(ParameterSetName='byFqdn')]
        [ValidateRange(120,86400)]
        [int16]$DnsTtl,

        # IP version type for the new object
        [Parameter(Mandatory=$true,ParameterSetName='byHost')]
        [Parameter(Mandatory=$true,ParameterSetName='byRange')]
        [Parameter(Mandatory=$true,ParameterSetName='byNetwork')]
        [ValidateSet('ipv4','ipv6')]
        [string]$IpVersion,

        # Common parameters
        # Name of the object
        [Parameter(Mandatory=$true)]
        [string]$Name,

        # Zone of the object
        [Parameter(Mandatory=$true)]
        [string]$Zone
    )
    begin {
        # Testing if a connection to SonicWall exists
        Test-SWConnection

        # Declaring used rest method
        $Method = 'post'

        # Declaring the base resource
        $BaseResource = 'address-objects'

        # Declaring the content type
        $ContentType = 'application/json'

        # Getting the base URL of our connection
        $SWBaseUrl = $env:SWConnection

    }
    process {
        switch ($PSCmdlet.ParameterSetName){
            'byHost' {
                # Building the full resource
                $Resource = "$BaseResource/$IpVersion"

                # If its a host build the object with it's required parameters
                $Object = @{
                    address_object = @{
                        $IpVersion = @{
                            name = $Name
                            host = @{
                                ip = $Ip
                            }
                            zone = $Zone
                        }
                    }
                }
                $Object = $Object | ConvertTo-Json -Depth 3

                # Create the object
                $Result = Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType -Body $Object
                $Result
            }
            'byRange' {
                # Building the full resource
                $Resource = "$BaseResource/$IpVersion"

                # If its a range build the object with it's required parameters
                $Object = @{
                    address_object = @{
                        $IpVersion = @{
                            name = $Name
                            range = @{
                                begin = $Begin
                                end = $End
                            }
                            zone = $Zone
                        }
                    }
                }
                $Object = $Object | ConvertTo-Json -Depth 3

                # Create the object
                $Result = Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType -Body $Object
                $Result
            }
            'byNetwork' {
                # Building the full resource
                $Resource = "$BaseResource/$IpVersion"

                # If its a network build the object with it's required parameters
                $Object = @{
                    address_object = @{
                        $IpVersion = @{
                            name = $Name
                            network = @{
                                subnet = $Subnet
                                mask = $Mask
                            }
                            zone = $Zone
                        }
                    }
                }
                $Object = $Object | ConvertTo-Json -Depth 3

                # Create the object
                $Result = Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType -Body $Object
                $Result
            }
            'byMac' {
                # Building the full resource
                $Resource = "$BaseResource/mac"

                # If its a MAC address build the object with it's required parameters
                $Object = @{
                    address_object = @{
                        mac = @{
                            name = $Name
                            address = $MacAddress
                            zone = $Zone
                            multi_homed = $MultiHomed
                        }
                    }
                }
                $Object = $Object | ConvertTo-Json -Depth 3

                # Create the object
                $Result = Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType -Body $Object
                $Result
            }
            'byFqdn' {
                # Building the full resource
                $Resource = "$BaseResource/fqdn"

                # If its an FQDN build the object with it's required parameters
                if ($DnsTtl) {
                    # If there's a DNS TTL use it
                    $Object = @{
                        address_object = @{
                            fqdn = @{
                                name = $Name
                                domain = $Hostname
                                zone = $Zone
                                dns_ttl = $DnsTtl
                            }
                        }
                    }
                }
                else {
                    # Else do not specify it
                    $Object = @{
                        address_object = @{
                            fqdn = @{
                                name = $Name
                                domain = $Hostname
                                zone = $Zone
                            }
                        }
                    }                    
                }
                $Object = $Object | ConvertTo-Json -Depth 3

                # Create the object
                $Result = Invoke-RestMethod -Uri "$SWBaseUrl$Resource" -Method $Method -ContentType $ContentType -Body $Object
                $Result
            }
        }
    }
}