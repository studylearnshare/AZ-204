
Connect-AzAccount 

# Resource Group
New-AzResourceGroup -Name "psdemo-rg" -Location "CentralUS"

# credentials
$username = 'demoadmin'
$password = ConvertTo-SecureString 'password123$%^&*' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ($username, $password)


#Create a Windows Virtual Machine
New-AzVM `
    -ResourceGroupName 'psdemo-rg' `
    -Name 'psdemo-win-az' `
    -Image 'Win2019Datacenter' `
    -Credential $WindowsCred `
    -OpenPorts 3389


#Public IP Address
Get-AzPublicIpAddress `
    -ResourceGroupName 'psdemo-rg' `
    -Name 'psdemo-win-az' | Select-Object IpAddress

#Clean up 
Remove-AzResourceGroup -Name 'psdemo-rg'

# option 2

$secret = Get-AzKeyVaultSecret -VaultName "pGroupA-keyvault-1" -Name "WinMachines"

# add rule to open 3389 - optional 1
Get-AzNetworkSecurityGroup -Name pGroupA-machine-1-nsg-1 -ResourceGroupName pGroupA |
Add-AzNetworkSecurityRuleConfig -Name rdp-rule-3389  -Description "Allow RDP" -Access  Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 | Set-AzNetworkSecurityGroup



