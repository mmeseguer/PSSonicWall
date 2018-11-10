[![Build status](https://ci.appveyor.com/api/projects/status/5paqak573ldilsft/branch/master?svg=true)](https://ci.appveyor.com/project/Marc42453/pssonicwall/branch/master)
# PSSonicWall

This PowerShell module provides a set of functions to interact with SonicWall appliances using its [SonicOS API](https://www.sonicwall.com/en-us/support/technical-documentation/sonicos-6-5-1-api-reference).

# Prerequisites

First of all you must **activate the SonicOS API** in your SonicWall appliance. SonicOS API was introduced in SonicOS 6.5.1 so if you have a previous version you must **first upgrade your appliance** in order to use this module.

To activate the SonicOS API you can use the GUI or the CLI (instructions taken from the [SonicOS API Reference](https://www.sonicwall.com/SonicWall.com/files/fb/fb551d7e-05cf-4613-a154-2131271ccadb.pdf)).

- GUI method:
    - Navigate to **MANAGE | Network > Appliance | Base Settings**.
    - Scroll to the **SonicOS API** section.
    - Select **Enable SonicOS API**.
    - Click **Accept**.

- CLI method:
```
config(<serial number>)# administration
(config-administration)# sonicos-api
(config-administration)# commit
```

# Connecting and disconnecting to a SonicWall Appliance

The first step for accessing the SonicOS API using PSSonicWall is to connect to the appliance. For that purpose you can use **Connect-SWAppliance**:
```powershell
Connect-SWAppliance -Server 192.168.168.168
```

When you are done with the API interaction you should disconnect your session. To do so you can use **Disconnect-SWAppliance**:
```powershell
Disconnect-SWAppliance
```

# Using Get functions

Once you are connected you can use PSSonicWall to read all the information that SonicOS API can offer. Here's a list of the Get commands currently available:

  
| Function            | Description                |
| :------------------ | -------------------------: |
| Get-SWAccessRule    | Retrieve Access Rules      |
| Get-SWAddressGroup  | Retrieve Address Groups    |
| Get-SWAddressObject | Retrive Address Objects    |
| Get-SWDns           | Retrieve DNS configuration |
| Get-SWInterface     | Retrieve interfaces        |
| Get-SWNatPolicy     | Retrieve NAT Policies      |
| Get-SWRoutePolicy   | Retrieve Routing Policies  |
| Get-SWSchedule      | Retrieve Schedules         |
| Get-SWServiceGroup  | Retrieve Service Groups    |
| Get-SwZone          | Retrieve Zones             |

*If you want to know more about a certain function you can use **Get-Help NameOfTheFuncion** to know more.*
