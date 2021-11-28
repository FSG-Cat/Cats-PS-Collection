# Self-elevate the script if required
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
     if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
      $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
      Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
      Exit
     }
    }
# Main menu, allowing user selection
function Show-Main-Menu
{
     param (
           [string]$Title = 'Feline Lab Aid Toolkit Version 1.0RC2'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' to apply sensible defaults for host 1."
     Write-Host "2: Press '2' to apply sensible defaults for host 2."
     Write-Host "3: Press '3' to configure new IP adresses."
     Write-Host "4: Press '4' to enable ICMP_Echo."
     Write-Host "5: Press '5' to enable firewall."
     Write-Host "6: Press '6' to disable firewall."
     Write-Host "7: Press '7' to list interfaces and select interface to work on."
     Write-Host "q: Press 'q' to quit."
}
#Variable Declarations
#$AdapterIndex = 'IndexHere'
#Functions go here
Function Host_1_Defaults {New-NetIPAddress -InterfaceIndex $AdapterIndex -IPAddress 192.168.1.10 -PrefixLength 24 -DefaultGateway 192.168.1.1
}
Function Host_2_Defaults {New-NetIPAddress -InterfaceIndex $AdapterIndex -IPAddress 192.168.1.11 -PrefixLength 24 -DefaultGateway 192.168.1.1
}
Function Configure_IP {
    Write-Host "Please enter the requested information for Configuration of a new IP address. Interface Selection is done via alternative 5 in the main menu."
    $IPv4_Address = Read-Host "Please Enter the IPv4 Address you desire for the selected interface."
    $CIDR_Notation_PrefixLenght_String = Read-Host "Please Enter the Prefix Lenght for the subnet you want to configure on this interface."
    $IPv4_Default_Gateway = Read-Host "Please Enter the Default Gateway for the selected interface."
    [int]$CIDR_Notation_PrefixLenght = $CIDR_Notation_PrefixLenght_String
    New-NetIPAddress -InterfaceIndex $AdapterIndex -IPAddress $IPv4_Address -PrefixLength $CIDR_Notation_PrefixLenght -DefaultGateway $IPv4_Default_Gateway
    cls
}
Function Enable_Firewall {Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True}
Function Disable_Firewall {Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False}
Function Enable_Allow_ICMP {
New-NetFirewallRule -DisplayName "Allow inbound ICMPv4" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -RemoteAddress LocalSubnet -Action Allow -Profile Domain,Public,Private
New-NetFirewallRule -DisplayName "Allow inbound ICMPv6" -Direction Inbound -Protocol ICMPv6 -IcmpType 8 -RemoteAddress LocalSubnet -Action Allow -Profile Domain,Public,Private
}
#Main menu loop
do
{
     Show-Main-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                Host_1_Defaults
           } '2' {
                Host_2_Defaults
           } '3' {
                cls
                Configure_IP
           } '4' {
                cls
                Enable_Allow_ICMP
           } '5' {
                cls
                Enable_Firewall
           } '6' {
                cls
                Disable_Firewall
           } '7' {
                cls
                Get-NetAdapter
                $AdapterIndex_String = Read-Host "Please select the adapter to work on from the previous list."
                [int]$AdapterIndex = $AdapterIndex_String
           } 'q' {
                return
           }
     }
}
until ($input -eq 'q')
