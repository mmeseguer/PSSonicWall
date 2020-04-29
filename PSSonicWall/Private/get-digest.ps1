#requires -version 6

# provide data object to post back to sonicwall
function Get-SWdigest {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$device,
        [Parameter(Mandatory = $true, Position = 1)]
        [pscredential]$credentials
    )
    
    # Query the sonicwall for the digest info
    $chap_info = get-SWdigestdata -device $device

    # calculate the digest hash
    $hash = new-SWdigesthash -id $chap_info.id -Credential $credentials -challange $chap_info.challenge -algorithm MD5

    
    # Data to be posted to the API endpoint (in json format)
    return [ordered]@{
        "id" = $chap_info.id
        "user" = "admin"
        "digest" = $hash
    } | ConvertTo-Json
}

# Get ID and challange (Digest info)
function get-SWdigestdata {
    param(
        [Parameter(Mandatory=$true,Position=0)]$device
    )
    try {
        $params = @{
            SkipCertificateCheck    = $true
            Method                  = "GET"
            Uri                     = "https://$device/api/sonicos/auth"
            Headers                 = @{
                                        accept  = "application/json"
                                        }
        }
        Invoke-RestMethod @params
    
    } catch {
        return $_.ErrorDetails.Message | ConvertFrom-Json
    }
}

# calculate hash
function new-SWdigesthash {
    param(
        [Parameter(Mandatory = $true)]$id,
        [Parameter(Mandatory = $true)][pscredential]$Credential,
        [Parameter(Mandatory = $true)]$challange,
        [Parameter(Mandatory = $true)]
        [ValidateSet("MD5", "SHA", "SHA1", "SHA-256", "SHA-384", "SHA-512")]
        [String]$algorithm
    )
    # convert Chap ID from hex to a bytes array
    [array]$id   = convertfrom-hex -data $id
    
    # convert password to plain text and to a byte array 
    $plaintext = $($Credential.GetNetworkCredential().Password)
    [array]$pass = [byte[]][char[]]"$plaintext"
    Remove-Variable plaintext

    # Convert Chap challange from hex to a byte array
    [array]$chal = convertfrom-hex -data $challange

    # combine all needed puzzle pieces into one big array
    [array]$comb = $id + $pass + $chal

    # create a algorithm object
    $hashalgorithm = [System.Security.Cryptography.HashAlgorithm]::Create($algorithm)

    # output the hash calculation
    return $hashalgorithm.ComputeHash($comb).ForEach({$_.ToString("x2")})-join ""
}

# Convert hex to byte array
function convertfrom-hex {
    param (
        [string]$data
    )
    $hex_array = for ([int32]$i = 0 ; $i -lt $data.Length; $i += 2 ) {
        $data.Substring($i,2)
    }
    $hex_array.foreach({[byte]"0x$_"})
}