# mal-sandbox
My personal sanbox setup for analysis of Windows x86-64 malware. This is mainly for personal reference and half-assed documentation 🤷‍♂️

<br>

## Replication
### Creating the Image

> [!NOTE]
> The following is intended for libvirt-based virtualization. If you use another VM manager or hypervisor (VMware, VirtualBox, etc.), you can still create a similar guest VM using the hardware configurations shown [below](https://github.com/isaacward1/my-mal-sandbox/blob/main/README.md#system).
<br>


These are the libvirt XML files for replicating my KVM/QEMU VM and networks:
- [mal-win10.xml](mal-win10.xml)
- [mal-NAT.xml](mal-NAT.xml)
- [mal-host-only.xml](mal-host-only.xml)
    
To create an identical guest VM: 

    sudo virsh define mal-win10.xml
    sudo virsh net-define mal-NAT.xml
    sudo virsh net-define mal-host-only.xml

### Installing VirtIO
1. Download the latest [virtio-win](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso) driver
2. Follow these [instructions](https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers#Using_the_ISO)

### Installing Tools
Tools are installed via Chocolately packages (review [setup.ps1](setup.ps1)), but can be installed manually via [links below](https://github.com/isaacward1/mal-sandbox/blob/main/README.md#analysis-tools)

<br>

## System
- Windows 10
- 4 vCPUs (1 socket, 2 cores, 2 threads)
- 6 GB Memory
- 50 GB Storage
- Custom host-only network interface:
    - Name: mal-host-only
    - Mode: host-only
    - Subnet: 10.0.0.0/30
    - Disable DHCP, IPv6
- Custom NAT network interface:
    - Name: mal-NAT
    - Mode: NAT   
    - Subnet: 10.69.69.0/30
    - Disable DHCP, IPv6

<br>

## Analysis Tools
### Static
- [PEStudio](https://www.winitor.com/download)
- [ImHex](https://github.com/WerWolv/ImHex)
- [Ghidra](https://github.com/NationalSecurityAgency/ghidra)
- [CyberChef](https://github.com/gchq/CyberChef)
- [FLOSS](https://github.com/mandiant/flare-floss)
- [Detect it Easy](https://github.com/horsicq/DIE-engine/releases)
- [CAPA](https://github.com/mandiant/capa/releases)
- [YARA](https://github.com/VirusTotal/yara)

### Dynamic
- [x64dbg](https://github.com/x64dbg/x64dbg)
- [Wireshark](https://www.wireshark.org/download.html)
- [mitmproxy](https://www.mitmproxy.org/)
- [Sysinternals Suite](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite) (TCPView, Procmon, Autoruns, Strings)
- [System Informer](https://github.com/winsiderss/systeminformer)
- [RegShot](https://sourceforge.net/projects/regshot/)
- [FakeNet](https://github.com/mandiant/flare-fakenet-ng)

### Other
- [disable-defender.exe](https://github.com/pgkt04/defender-control/releases/tag/v1.5)
- [VSCode](https://code.visualstudio.com/)
- [Python](https://www.python.org/downloads/) (v3.14)
- [Temurin JDK](https://adoptium.net/temurin/releases) (v21.0)
- [UPX](https://github.com/upx/upx)
- [7-Zip](https://www.7-zip.org/)

<!--
- IDA Free
- Malcat
- Binary Ninja
- Volatility3
- Cutter
-->

<br>

## Setup
### Removing interference
1. Follow these [steps](https://github.com/mandiant/flare-vm?tab=readme-ov-file#pre-installation) to disable Tamper Protection and annoying Windows Defender
2. Disable everything in startup

### Network Isolation

Below are firewall rules (ufw) I have applied on the host-level. They (1) block communication with the host system's LAN while allowing outbound traffic to the internet and (2) allow inbound local access to the host's python http server. Replace all variable values to align with desired setup.

    var1="<NAT-interface>" # name of VM's NAT bridge
    var2="<NAT-gateway-ip>" # NAT interface's gateway IP
    var3="<host-only-interface>" # name of VM's host-only brige
    var4="<host-only-gateway-ip>" # host-only interface's gateway IP
    var5="<host-only-ip-on-vm>" # host IP assigned to VM on host-only network
    var6="<python http.server port>" # python http.server port
    
    sudo ufw allow out on $var1 from any to $var2 comment '(mal) allow to NAT-gateway only (for internet access)'
    sudo ufw deny out on $var1 from any to any comment '(mal) Isolate mal-NAT'
    sudo ufw allow in on $var3 from $var5 to $var4 port $var6 proto tcp comment '(mal) allow to host python http.server'
    sudo ufw deny out on $var3 from any to any comment '(mal) Isolate mal-host-only'

<br>

## File Transfer

### Using Python [http.server](https://docs.python.org/3/library/http.server.html#)

#### Uploading from Host --> VM

1. Run on host to serve malware to VM:
 
        python3 -m http.server --bind <host-only-gateway> <python server port>

2. On VM's browser, navigate to `http://<host-only-gateway>:<python server port>`

#### Downloading from VM --> Host

1. Run on VM to download files to host:

        python3 -m http.server --bind <vm-hostonly-ip> <python server port>

2. On host's browser, navigate to `http://<vm-hostonly-ip>:<python server port>`

### Alternatives
- Hardened scp/OpenSSH
- Dedicated lightweight VM or container for uploading and downloading files to/from VM
- Read-only shared folder
- Downloading malware onto VM from online DBs (temporary internet)

<br>

## Tips
- After setup and tweaking, create a snapshot so that you can revert to a clean state after detonating malware.
- Avoid using shared clipboard, shared folders (read/write), Drag-and-drop, and USB storage passthrough/redirection. These are common vectors for VM escape.
- Before executing malware, make sure all hypervisor software is up to date with the latest security patches applied.
- Ignore everything above. Just use [FLARE-VM](https://github.com/mandiant/flare-vm) or [REMnux](https://remnux.org/).

<br>
