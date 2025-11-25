# mal-sandbox-kvm

my VM sanbox setup for static/dynamic analysis of Windows malware. this is mainly for personal reference and lazy documentation, but i thought i'd share
<br><br>
(yes, i am aware that premade malware analysis VMs like remnux and flare-vm exist, but they have a ton of tools i never touch and i thought it was fun to make my own 😅)

<br>

## Hardware
- Windows 10
- 4 vCPUs
- 6 GB Memory
- 40 GB Storage
- NAT Network Interface (Host-only/Isolated if using FakeNet)

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
- [Sysinternals Suite](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite) [1]
- [System Informer](https://github.com/winsiderss/systeminformer)
- [RegShot](https://sourceforge.net/projects/regshot/)
- [FakeNet-NG](https://github.com/mandiant/flare-fakenet-ng) [2]

[1] only TCPView, Procmon, Process Explorer, Autoruns <br>
[2] I don't personally use this, but it is recommended if you do not understand the risks of using bridged/NATed VM interfaces

<br>

## Network Isolation

Below are firewall rules I have applied on both the host/guest machines (using a NATed VM network). They block communication with the host machine's LAN while allowing outbound traffic to the internet. Note that this is generally not recommended and most prefer full network isolation (I like the full experience). These rules are not needed when using host-only/isolated interface + FakeNet.

### Host Firewall Rules (UFW)

    sudo ufw allow out on <vm-interface> from any to <vm-gateway-ip> comment 'allow to internet'
    sudo ufw deny out on <vm-interface> from any to any comment 'isolated'

\* Replace \<vm-interface\> with the name of VM's NAT interface and \<vm-gateway-ip\> with the IP of that interface.

### Guest Firewall Rules (Windows Firewall)

    Windows Firewall Rules Here

<br>

## File Transfer

### Host --> VM
fwefwef

### VM --> Host
wefwefwefwf



<br>
