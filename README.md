# csgo_server

## Introduction

### Purpose

Hold the scripts for deploying a private CS GO server.

* libvirt/kvm

### References

* [SteamCMD Error Codes](https://github.com/GameServerManagers/LinuxGSM-Docs/blob/master/steamcmd/errors.md)
* [Dedicated Servers List](https://developer.valvesoftware.com/wiki/Dedicated_Servers_List)

### installation debugging

* ssh -i tf-cloud-init ansible@192.168.122.122
* systemctl status cloud-final
* sudo journalctl -u cloud-final
* sudo /var/log/cloud-init-output.log
/var/log/cloud-init.log
/var/lib/cloud/data/result.json

### Ansible

* --inventory-file

* ansible localhost -a "apt update" -u ansible --become

### Install csgo server

* [](https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive/Dedicated_Servers)
* [](https://developer.valvesoftware.com/wiki/SteamCMD)
* [](https://www.hostinger.com/tutorials/how-to-make-a-csgo-server)* [](https://www.linode.com/docs/guides/launch-a-counter-strike-global-offensive-server-on-ubuntu-18-04/)

* [Counter-Strike: Global Offensive - Dedicated Servers](https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive/Dedicated_Servers)
* [](https://medium.com/@oritromax/installing-a-cs-go-dedicated-server-in-ubuntu-ed37377b06d1)
* https://developer.valvesoftware.com/wiki/Source_Dedicated_Server

* export LD_LIBRARY_PATH=/usr/lib32:/data/steam/csgo/bin
* /data/steam/csgo/srcds_linux --version

* /data/steam/csgo/srcds_linux -game csgo -usercon -net_port_try 1 -tickrate 128 -nobots +game_type 0 +game_mode 1 +mapgroup mg_active +map de_mirage

## Troubleshooting

### installation troubleshooting

#### ln: failed to create symbolic link '/home/steam/.steam/root': No such file or directory

* sudo -i
* su - steam
* mkdir /home/steam/.steam
* /usr/games/steamcmd +force_install_dir /data/csgo/ +login anonymous +app_update 740 validate +quit

```text
/usr/games/steamcmd +force_install_dir /data/csgo/ +login anonymous +app_update 740 validate +quit
ln: failed to create symbolic link '/home/steam/.steam/root': No such file or directory
ln: failed to create symbolic link '/home/steam/.steam/steam': No such file or directory
Redirecting stderr to '/home/steam/Steam/logs/stderr.txt'
[  0%] Checking for available updates...
[----] Verifying installation...
Steam Console Client (c) Valve Corporation - version 1689642531
-- type 'quit' to exit --
Loading Steam API...dlmopen steamservice.so failed: steamservice.so: cannot open shared object file: No such file or directory
OK

Connecting anonymously to Steam Public...OK
Waiting for client config...OK
Waiting for user info...OK
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
Error! App '740' state is 0x202 after update job.
```

#### Loading Steam API...dlmopen steamservice.so failed: steamservice.so: cannot open shared object file: No such file or directory

https://forum.scssoft.com/viewtopic.php?t=319994


#### Error! App '740' state is 0x202 after update job.

sudo mkfs -t ext4 /dev/vdb1
