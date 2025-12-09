Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass

# =========== change these variables to match your desired setup =========== #
$hostonly_mac = "xx:xx:xx:xx:xx:xx" # MAC address of your host-only interface
$hostonly_ip = "172.16.69.2" # IP you want VM to have on the host-only network
$hostonly_gateway = "172.16.69.1" # gateway IP of host-only interface 
$hostonly_subnet = 30 # subnet prefix length for host-only adapter

$nat_mac = "xx:xx:xx:xx:xx:xx" # MAC address of your NAT interface
$nat_ip = "192.168.100.2" # IP you want VM to have on the NAT network
$nat_gateway = "192.168.100.1" # gateway IP of NAT interface 
$nat_subnet = 30 # subnet prefix length for NAT adapter
# ========================================================================= #

# configuring host-only adapter
$hostonly_mac=$hostonly_mac.ToUpper().Replace(":", "-")
$hostonly_adpt_idx = (Get-NetAdapter | select ifIndex, MacAddress | Where-Object {$_.MacAddress -eq $hostonly_mac}).ifIndex
New-NetIPAddress -InterfaceIndex $hostonly_adpt_idx -IPAddress $hostonly_ip -PrefixLength $hostonly_subnet -DefaultGateway $hostonly_gateway
Set-DnsClientServerAddress -InterfaceIndex $hostonly_adpt_idx -ServerAddresses $hostonly_gateway

# configuring NAT adapter
$nat_mac=$nat_mac.ToUpper().Replace(":", "-")
$nat_adpt_idx = (Get-NetAdapter | select ifIndex, MacAddress | Where-Object {$_.MacAddress -eq $nat_mac}).ifIndex
New-NetIPAddress -InterfaceIndex $nat_adpt_idx -IPAddress $nat_ip -PrefixLength $nat_subnet -DefaultGateway $nat_gateway
Set-DnsClientServerAddress -InterfaceIndex $nat_adpt_idx -ServerAddresses $nat_gateway

# python http server config
$path_to_python = (Get-Command python).source
$http_server_port = 8888 # change to desired server port

# allow guest to access python server
New-NetFirewallRule -DisplayName "allow_in_host_to_vm_pyhttp" -Enabled True -Action Allow -Direction Inbound -LocalAddress $hostonly_ip -LocalPort $http_server_port -Protocol TCP -RemoteAddress $hostonly_gateway -Profile Any -Program $path_to_python

# disabling redundant rule created by fakenet
Set-NetFirewallRule -DisplayName "inbound from internet = block" -Enabled False


