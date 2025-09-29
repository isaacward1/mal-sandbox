# mal-sandbox
my sanbox setup for static/dynamic analysis of Windows malware. this is mainly for personal reference and lazy documentation, but i figured i'd share
<br><br>
yes, i am aware that premade malware analysis VMs like [remnux](https://remnux.org/) and [flare-vm](https://github.com/mandiant/flare-vm) exist, but they have a ton of tools i never touch and i thought it was fun to make my own 😄

<br>

## VM Hardware
- Windows 10
- 4 vCPUs
- 8 GB Memory
- 40 GB Storage
- NAT Network Interface (or Host-only/Isolated if using [fakenet](https://github.com/mandiant/flare-fakenet-ng))

<br>

## Network Isolation
Firewall rules applied on both host/guest machines when using a NATed VM network:

### 1. Host Firewall Rules

#### Linux Host (via UFW)

\** Replace \<vm-interface\> with the name of VM's NAT interface

    sudo ufw deny out on <vm-interface> from any to 192.168.0.0/16 comment 'deny to local #1'
    sudo ufw deny out on <vm-interface> from any to 172.16.0.0/12 comment 'deny to local #2'
    sudo ufw deny out on <vm-interface> from any to 10.0.0.0/8 comment 'deny to local #3'
    sudo ufw allow out on <vm-interface> from any to 192.168.100.1 comment 'allow to internet'

#### Windows Host (via Windows Firewall)

    sudo ufw deny out on <vm-interface> from any to 192.168.0.0/16 comment 'deny to local #1'
    sudo ufw deny out on <vm-interface> from any to 172.16.0.0/12 comment 'deny to local #2'
    sudo ufw deny out on <vm-interface> from any to 10.0.0.0/8 comment 'deny to local #3'
    sudo ufw allow out on <vm-interface> from any to 192.168.100.1 comment 'allow to internet'

<br>

### 2. Guest Firewall Rules


<br>

## Tools
- CyberChef
- Sysinternals Suite
- i

<br>
