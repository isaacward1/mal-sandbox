# my-mal-sandbox
My personal sanbox setup for analysis of Windows x86-64 malware. This is mainly for personal reference and lazy documentation, but I thought I'd share anyways

(and yes, I am aware that premade RE/malware analysis VMs like [REMnux](https://remnux.org/) and [FLARE-VM](https://github.com/mandiant/flare-vm) exist, but I thought it was fun to make my own 😅)

<br>

## Replication
### Creating the VM Image
**Note:** The following is intended for those using KVM/QEMU. If you use another hypervisor (VMware, VirtualBox, etc.), you can create a similar guest VM using the hardware configurations shown [below](https://github.com/isaacward1/my-mal-sandbox/blob/main/README.md#system).<br>

This is the XML config file for my KVM/QEMU VM 👉 [mal-win11.xml](mal-win11.xml). To create an identical guest VM: 

    sudo virsh define mal-win11.xml

### Installing Tools
Chocolately

<br>

## System
- Windows 11
- 4 vCPUs (1 socket, 2 cores, 2 threads)
- 6 GB Memory
- 50 GB Storage
- Custom NAT network interface:
    - Name: Isolated-NAT
    - Mode: NAT   
    - Subnet: 10.0.0.0/30
    - Disable DHCP
    - Disable IPv6
- Host-only network interface

<br>

## Analysis Tools
### Static/Code
- [PEStudio](https://www.winitor.com/download)
- [x64dbg](https://github.com/x64dbg/x64dbg)
- [Ghidra](https://github.com/NationalSecurityAgency/ghidra)
- [CyberChef](https://github.com/gchq/CyberChef)
- [FLOSS](https://github.com/mandiant/flare-floss)

### Dynamic/Behavioural
- [mitmproxy](https://www.mitmproxy.org/)
- [Wireshark](https://www.wireshark.org/download.html)
- [Sysinternals Suite](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite) [1]
- [System Informer](https://github.com/winsiderss/systeminformer)
- [RegShot](https://sourceforge.net/projects/regshot/)
- [FakeNet-NG](https://github.com/mandiant/flare-fakenet-ng) [2]

<!--
to play with later ig
- Volatility3
- [ImHex](https://github.com/WerWolv/ImHex)
- [Detect it Easy](https://github.com/horsicq/DIE-engine/releases)
- [YARA](https://github.com/VirusTotal/yara)
- [CAPA](https://github.com/mandiant/capa/releases)
- [API Monitor](http://www.rohitab.com/apimonitor)
- Python + RE libraries
- IDA Free
- Radare2/Cutter
- Binary Ninja
- Malcat
-->

[1] TCPView, Procmon, Process Explorer, Autoruns, and Strings <br>
[2] I don't personally use this, but it is recommended if you do not understand the risks of using bridged/NATed VM interfaces

<br>

## Setup
### Removing interference
1. Follow these [steps](https://github.com/mandiant/flare-vm?tab=readme-ov-file#pre-installation) to disable Tamper Protection and annoying Windows Defender


### Network Isolation

Below are firewall rules I have applied on both the host/guest machines (using a NATed VM network). They block communication with the host machine's LAN while allowing outbound traffic to the internet. Note that this is generally not recommended and most prefer full network isolation (I like the full experience). These rules are not needed when using host-only/isolated interface + FakeNet.

### Host Firewall Rules (UFW)

    sudo ufw allow out on <vm-interface> from any to <vm-gateway-ip> comment 'allow to internet'
    sudo ufw deny out on <vm-interface> from any to any comment 'isolated'

\* Replace \<vm-interface\> with the name of VM's NAT interface and \<vm-gateway-ip\> with the IP of that interface.

### Guest Firewall Rules (Windows Firewall)

    Windows Firewall Rules Here

<br>

## File Transfer

Observing past VM escapes it is clear that we do not want:
- Shared clipboard
- Shared folders (read/write)
- Drag-and-drop
- USB Redirection

Instead we want
- possibly a lightweight vm or container that is dedicated to uploading and downloading files.
- Shared read-only folder

### Host --> VM
...

### VM --> Host
...

<br>

## Tips
- When everything is to your liking, take a snapshot so that you can revert to a clean state after detonating malware.
- Make sure all qemu and kvm 

<br>
