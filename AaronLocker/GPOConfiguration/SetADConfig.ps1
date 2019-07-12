<#
    EDITABLE settings for customizations of AD configuration for AaronLocker.
    Also includes common functions for AD support.

    This file is intended to be dot-sourced into other scripts in this directory, and not run directly.
#>

# ######################################################################
#
# EDITABLE section to define default security group names and GPO names
#
# Change the following lines if you are using different names for
# security groups and GPOs for AaronLocker.
#
# ######################################################################

$DefAuditGroupName   = "AppLocker-Audit"
$DefEnforceGroupName = "AppLocker-Enforce"
$DefExemptGroupName  = "AppLocker-Exempt"

$DefAuditGPOName     = "AppLocker-Audit"
$DefEnforceGPOName   = "AppLocker-Enforce"


### Do not edit below this line ###

# ######################################################################
#
# Common routines for AD support
#
# ######################################################################


# DomainIfADJoined returns the AD domain name if computer is AD-joined; otherwise returns an empty string.
function DomainIfADJoined()
{
    $computerDomain = $null # [string]::Empty
    $cs = Get-CimInstance -ClassName CIM_ComputerSystem
    if ($null -ne $cs)
    {
        if ($cs.PartOfDomain)
        {
            $computerDomain = $cs.Domain
        }
    }
    Write-Output $computerDomain
}

# Loads ActiveDirectory module if not already loaded. Returns $true if AD module loaded; $false if not loaded/not available.
function IsActiveDirectoryModuleAvailable()
{
    $ret = $true
    $mod = Get-Module ActiveDirectory
    if ($null -eq $mod)
    {
        Import-Module ActiveDirectory -ErrorAction SilentlyContinue -ErrorVariable impmodAD
        if ($impmodAD.Count -gt 0)
        {
            $ret = $false
        }
    }
    Write-Output $ret
}

# Returns an array of domain controller names
function GetDomainControllerNames()
{
    $DCs = @()
    #$DCs += ($env:LOGONSERVER).Substring(2) # use logon server; skip the leading \\
    #$DCs += (Get-ADDomainController).HostName
    $DCs += ([System.Directoryservices.Activedirectory.Domain]::GetComputerDomain()).DomainControllers.Name

    Write-Output $DCs
}

