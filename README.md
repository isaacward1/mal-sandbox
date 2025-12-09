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
- Custom host-only network interface:
    - Name: mal-host-only
    - Mode: host-only ('isolated' on virt-manager)
    - Subnet: 10.0.0.0/30
    - Disable DHCP, IPv6
- Custom NAT network interface:
    - Name: mal-NAT
    - Mode: NAT   
    - Subnet: 10.0.69.0/30
    - Disable DHCP, IPv6


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
- [FakeNet-NG](https://github.com/mandiant/flare-fakenet-ng)

<!--
to add later maybe
- 7zip
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

<br>

## Setup
### Removing interference
1. Follow these [steps](https://github.com/mandiant/flare-vm?tab=readme-ov-file#pre-installation) to disable Tamper Protection and annoying Windows Defender
2. Disable everything in startup

### Network Isolation

Below are firewall rules (ufw) I have applied on the host-level. They (1) block communication with the host system's LAN while allowing outbound traffic to the internet and (2) allow inbound local access to the VM's python http server.

    sudo ufw allow out on {nat-interface} from any to {nat-gateway} comment 'allow to nat-gateway only (for internet access)'
    sudo ufw deny out on {nat-interface} from any to any comment 'isolate mal-nat'
    sudo ufw allow in on {hostonly-interface} from {vm-hostonly-ip} to {hostonly-gateway} port {python http server port} proto tcp comment 'http.server host-only'

**{nat-interface}** --- name of VM's NAT interface<br>
**{nat-gateway}** --- NAT interface's gateway IP<br>
**{hostonly-interface}** --- name of VM's host-only interface<br>
**{vm-hostonly-ip}** --- host IP assigned to VM on host-only network<br>
**{hostonly-gateway}** --- host-only interface's gateway IP

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


### Using Python [http.server](https://docs.python.org/3/library/http.server.html#)

#### Uploading from Host --> VM

1. Run on host to serve malware to VM:
 
        python3 -m http.server --bind {host-only-gateway} {python server port}

2. On VM's browser, navigate to `http://{host-only-gateway}:{python server port}`

#### Downloading from VM --> Host

1. Run on VM to download files to host:

        python3 -m http.server --bind {vm-hostonly-ip} {python server port}

2. On host's browser, navigate to `http://{vm-hostonly-ip}:{python server port}`

### Using scp/OpenSSH (alternative)
...

<br>

## Tips
- When everything is to your liking, take a snapshot so that you can revert to a clean state after detonating malware
- Before executing malicious software, make sure all hypervisor software is up to date with the latest security patches applied

<br>
