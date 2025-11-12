# mal-sandbox
my VM sanbox setup for static/dynamic analysis of Windows malware. this is mainly for personal reference and lazy documentation, but i thought i'd share
<br><br>
(yes, i am aware that premade malware analysis VMs like remnux and flare-vm exist, but they have a ton of tools i never touch and i thought it was fun to make my own 😅)

<br>

## Hardware
- Windows 10
- 4 vCPUs
- 8 GB Memory
- 40 GB Storage
- NAT Network Interface (or Host-only/Isolated if using fakenet)

<br>

## Network Isolation
Firewall rules applied on both host/guest machines when using a NATed VM network:

### 1. Host Firewall Rules

#### Linux Host (UFW)

\** Replace \<vm-interface\> with the name of VM's NAT interface
    
    sudo ufw allow out on <vm-interface> from any to 192.168.100.1 comment 'allow to internet'
    sudo ufw deny out on <vm-interface> from any to any comment 'isolated'

#### Windows Host (Windows Firewall)

<br>

### 2. Guest Firewall Rules


<br>

## Analysis Tools
### Static
- [HxD](https://mh-nexus.de/en/hxd/)
- [PEStudio](https://www.winitor.com/download)
- [x64dbg](https://github.com/x64dbg/x64dbg)
- [Ghidra](https://github.com/NationalSecurityAgency/ghidra)
- [CyberChef](https://github.com/gchq/CyberChef)

### Dynamic/Network
- [mitmproxy](https://www.mitmproxy.org/)
- [Wireshark](https://www.wireshark.org/download.html)
- [Sysinternals Suite](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite)
    - TCPView
    - Procmon
    - Process Explorer
    - Autoruns
- [System Informer](https://github.com/winsiderss/systeminformer) (Process Hacker)
- [FakeNet-NG](https://github.com/mandiant/flare-fakenet-ng)

<br>
