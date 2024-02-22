# Troubleshooting

* [Source Dedicated Server Linux](https://steamcommunity.com/discussions/forum/14/)

## Testing out sub steps

### Testing out the ansible script

* ssh -i tf-cloud-init ansible@VM_IP_ADDR
* cd csgo_server/ansible_playbook && ansible-playbook --extra-vars "csgo_client_access_password=CheatersWillBeKicked" --extra-vars "csgo_server_rcon_password=SuperSecret" --extra-vars "one_for_local_zero_for_global=1" --extra-vars "server_name=You-Really-Need-To-Change-This" --extra-vars "steam_server_token=EMPTY" -v steam_client.yaml

## Troubleshooting subjects

### Trying out various releases

#### trying out in debian

* cd ~/
* mkdir ~/csgo_app
* export LD_LIBRARY_PATH=/home/steam/steamcmd/linux32
* ~/steamcmd/steamcmd.sh +force_install_dir ~/csgo_app/ +login anonymous +app_update 740 validate +quit
* export LD_LIBRARY_PATH=/home/steam/csgo_app/bin
* /home/steam/csgo_app/srcds_linux -game csgo -usercon -net_port_try 1 -tickrate 128 -nobots +game_type 0 +game_mode 1 +mapgroup mg_active +map de_mirage

This error occurs when the /home/steam/steamcmd/linux32 is in the LD_LIBRARY_PATH

```text
LD_LIBRARY_PATH=/home/steam/bin:/home/steam/steamcmd/linux32:/home/steam/csgo_app/bin
Failed to open libtier0.so (/home/steam/steamcmd/linux32/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /home/steam/csgo_app/bin/libtier0.so))
```

#### trying out linuxgsm

./csgoserver start

```text
mapfile -t current_ips < <(ip -o -4 addr | awk '{print $4}' | grep -oe '\([0-9]\{1,3\}\.\?\)\{4\}' | sort -u | grep -v 127.0.0)
mapfile -t current_ips < <(ip -o -4 addr | awk '{print $4}' | grep -oe '\([0-9]\{1,3\}\.\?\)\{4\}' | sort -u | grep -v 127.0.0)
[  OK  ] Starting csgoserver: Applying steamclient.so sdk64 hardlink fix: Counter-Strike: Global Offensive
[  OK  ] Starting csgoserver: Applying steamclient.so sdk32 link fix: Counter-Strike: Global Offensive
[  OK  ] Starting csgoserver: Applying 730 steam_appid.txt fix: Counter-Strike: Global Offensive
[  OK  ] Starting csgoserver: Applying botprofile.db fix: Counter-Strike: Global Offensive
[  OK  ] Starting csgoserver: Applying valve.rc fix: Counter-Strike: Global Offensive
[ INFO ] Starting csgoserver: Applying libgcc_s.so.1 move away fix: Counter-Strike: Global Offensiverenamed '/data/steam/LinuxGSM/serverfiles/bin/libgcc_s.so.1' -> '/data/steam/LinuxGSM/serverfiles/bin/libgcc_s.so.1.bck'
[  OK  ] Starting csgoserver: Applying libgcc_s.so.1 move away fix: Counter-Strike: Global Offensive
[  OK  ] Starting csgoserver: LinuxGSM
```

```text
=================================
Was the install successful? [Y/n] Y 

Downloading Counter-Strike: Global Offensive Configs
=================================
default configs from https://github.com/GameServerManagers/Game-Server-Configs
fetching GitHub server.cfg...OK
copying server.cfg config file.
'/data/steam/LinuxGSM/lgsm/config-default/config-game/server.cfg' -> '/data/steam/LinuxGSM/serverfiles/csgo/cfg/csgoserver.cfg'
changing hostname.
changing rcon/admin password.

Config File Locations
=================================
Game Server Config File: /data/steam/LinuxGSM/serverfiles/csgo/cfg/csgoserver.cfg
LinuxGSM Config: /data/steam/LinuxGSM/lgsm/config-lgsm/csgoserver
Documentation: https://docs.linuxgsm.com/configuration/game-server-config

Game Server Login Token
=================================
GSLT is required to run a public Counter-Strike: Global Offensive server
Get more info and a token here:
https://docs.linuxgsm.com/steamcmd/gslt

Enter token below (Can be blank).
GSLT TOKEN: 
The GSLT can be changed by editing /data/steam/LinuxGSM/lgsm/config-lgsm/csgoserver/csgoserver.cfg.


LinuxGSM Stats
=================================
Assist LinuxGSM development by sending anonymous stats to developers.
More info: https://docs.linuxgsm.com/configuration/linuxgsm-stats
The following info will be sent:
* game server
* distro
* game server resource usage
* server hardware info
Allow anonymous usage statistics? [Y/n] Y
Information! Stats setting is now enabled in common.cfg.

=================================
Install Complete!

To start server type:
./csgoserver start
```

```text
 ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 08:46 pts/0    00:00:00 bash
root        8640       1  0 09:07 pts/0    00:00:00 su - steam
steam       8641    8640  0 09:07 pts/0    00:00:00 -bash
steam      11311       1  0 09:27 ?        00:00:00 tmux -L csgoserver new-session -d -x 80 -y 23 -s csgoserver  ./srcds_run -game csgo -usercon -strictportbind -ip 0.0.0.0 -port 27015 +clien
steam      11312   11311  0 09:27 pts/1    00:00:00 /bin/sh ./srcds_run -game csgo -usercon -strictportbind -ip 0.0.0.0 -port 27015 +clientport 27005 +tv_port 27020 +sv_setsteamaccount -tickr
steam      11319   11312  2 09:27 pts/1    00:00:15 ./srcds_linux -game csgo -usercon -strictportbind -ip 0.0.0.0 -port 27015 +clientport 27005 +tv_port 27020 +sv_setsteamaccount -tickrate 64
steam      11321   11311  0 09:27 ?        00:00:00 cat
steam      11357    8641  0 09:37 pts/0    00:00:00 ps -ef
```

./lgsm/modules/fix_csgo.sh

### installation troubleshooting

#### installation debugging

* ssh -i tf-cloud-init ansible@192.168.122.122
* systemctl status cloud-final
* sudo journalctl -u cloud-final
* sudo cat /var/log/cloud-init-output.log
* sudo cat /var/log/cloud-init.log
* sudo cat /var/lib/cloud/data/result.json

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

[[dedicated server] steamservice.so cannot open shared object](https://forum.scssoft.com/viewtopic.php?t=319994)

#### Error! App '740' state is 0x202 after update job

sudo mkfs -t ext4 /dev/vdb1

#### steamcmd.sh: line 39:    58 Segmentation fault      (core dumped) $DEBUGGER "$STEAMEXE" "$@"

/tmp/dumps/crash_20230801121516_22.dmp

* apt install minidump-2-core.32

* /usr/local/bin/minidump --all /tmp/dumps/crash_20230801094131_21.dmp
  * possibly part of pypykatz
  * apt install python3-pip
  * pip3 install pypykatz

cat /data/steam/Steam/logs/stderr.txt

```text
crash_20230801094131_21.dmp[183]: Uploading dump (out-of-process)
/tmp/dumps/crash_20230801094131_21.dmp
crash_20230801094131_21.dmp[183]: Finished uploading minidump (out-of-process): success = no
crash_20230801094131_21.dmp[183]: error: libcurl.so: cannot open shared object file: No such file or directory
crash_20230801094131_21.dmp[183]: file ''/tmp/dumps/crash_20230801094131_21.dmp'', upload no: ''libcurl.so: cannot open shared object file: No such file or directory''
```

```text
Update state (0x81) verifying update, progress: 99.53 (34535831534 / 34699459197)
 Update state (0x81) verifying update, progress: 99.56 (34546317294 / 34699459197)
 Update state (0x81) verifying update, progress: 99.60 (34560997358 / 34699459197)
 Update state (0x81) verifying update, progress: 99.65 (34576904744 / 34699459197)
 Update state (0x81) verifying update, progress: 99.70 (34596563259 / 34699459197)
 Update state (0x81) verifying update, progress: 99.71 (34598660411 / 34699459197)
 Update state (0x81) verifying update, progress: 99.77 (34619904179 / 34699459197)
 Update state (0x81) verifying update, progress: 99.78 (34621424515 / 34699459197)
 Update state (0x81) verifying update, progress: 99.89 (34659695813 / 34699459197)
 Update state (0x81) verifying update, progress: 99.97 (34689055941 / 34699459197)
 Update state (0x81) verifying update, progress: 99.99 (34695807912 / 34699459197)
 Update state (0x101) committing, progress: 15.44 (5357537653 / 34699459197)
 Update state (0x101) committing, progress: 91.36 (31702446881 / 34699459197)
 Update state (0x101) committing, progress: 91.39 (31712308455 / 34699459197)
 Update state (0x101) committing, progress: 91.39 (31712415049 / 34699459197)
 Update state (0x101) committing, progress: 100.00 (34699459197 / 34699459197)
 Update state (0x101) committing, progress: 100.00 (34699459197 / 34699459197)
Success! App '740' fully installed.
/data/steam/.local/share/Steam/steamcmd/steamcmd.sh: line 39:    58 Segmentation fault      (core dumped) $DEBUGGER "$STEAMEXE" "$@"
```

```text
Update state (0x81) verifying update, progress: 96.98 (33651213103 / 34699459197)
 Update state (0x81) verifying update, progress: 97.22 (33734344275 / 34699459197)
 Update state (0x81) verifying update, progress: 97.59 (33861840145 / 34699459197)
 Update state (0x81) verifying update, progress: 97.98 (33997528055 / 34699459197)
 Update state (0x81) verifying update, progress: 98.33 (34121473267 / 34699459197)
 Update state (0x81) verifying update, progress: 98.53 (34188384017 / 34699459197)
 Update state (0x81) verifying update, progress: 98.76 (34267822417 / 34699459197)
 Update state (0x81) verifying update, progress: 99.01 (34357561513 / 34699459197)
 Update state (0x81) verifying update, progress: 99.13 (34397408433 / 34699459197)
 Update state (0x81) verifying update, progress: 99.34 (34469624284 / 34699459197)
 Update state (0x81) verifying update, progress: 99.66 (34582500408 / 34699459197)
 Update state (0x81) verifying update, progress: 99.87 (34653865328 / 34699459197)
 Update state (0x81) verifying update, progress: 99.98 (34691992899 / 34699459197)
Success! App '740' fully installed.
/data/steam/.local/share/Steam/steamcmd/steamcmd.sh: line 39:   375 Segmentation fault      (core dumped) $DEBUGGER "$STEAMEXE" "$@"
```

```text
 Update state (0x5) verifying install, progress: 99.38 (34483809272 / 34699459197)
 Update state (0x5) verifying install, progress: 99.47 (34514232768 / 34699459197)
 Update state (0x1) running, progress: 0.00 (0 / 0)
Success! App '740' fully installed.
/data/steam/.local/share/Steam/steamcmd/steamcmd.sh: line 39:  1156 Segmentation fault      (core dumped) $DEBUGGER "$STEAMEXE" "$@"
```

#### libcurl.so missing

apt install libcurl4-gnutls-dev:i386

See:

* [Unable to locate libcurl.so (ubuntu)](https://github.com/CurtTilmes/raku-libcurl/issues/12)
* [How to install 32-bit libcurl on 64-bit Ubuntu 16?](https://askubuntu.com/questions/1007533/how-to-install-32-bit-libcurl-on-64-bit-ubuntu-16)

cat /data/steam/Steam/logs/stderr.txt

```text
crash_20230801094131_21.dmp[183]: Uploading dump (out-of-process)
/tmp/dumps/crash_20230801094131_21.dmp
crash_20230801094131_21.dmp[183]: Finished uploading minidump (out-of-process): success = no
crash_20230801094131_21.dmp[183]: error: libcurl.so: cannot open shared object file: No such file or directory
crash_20230801094131_21.dmp[183]: file ''/tmp/dumps/crash_20230801094131_21.dmp'', upload no: ''libcurl.so: cannot open shared object file: No such file or directory''
```

#### Failed to open libtier0.so (/data/steam/csgo_app/bin/libgcc_s.so.1: version `GCC_7.0.0' not found (required by /lib/i386-linux-gnu/libstdc++.so.6))

Fix: `mv ./csgo_app/bin/libgcc_s.so.1 ./csgo_app/bin/libgcc_s.so.1.bck`

as per [linunxgsm fix_csgo.sh](https://github.com/GameServerManagers/LinuxGSM/blob/master/lgsm/modules/fix_csgo.sh)

```text
export LD_LIBRARY_PATH=/data/steam/csgo_app/bin/:/data/steam/.local/share/Steam/steamcmd/linux32
steam@990dfd271ac3:~$ /data/steam/csgo_app/srcds_linux --version
LD_LIBRARY_PATH=/data/steam/bin:/data/steam/csgo_app/bin/:/data/steam/.local/share/Steam/steamcmd/linux32
Failed to open libtier0.so (/data/steam/.local/share/Steam/steamcmd/linux32/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /data/steam/csgo_app/bin/libtier0.so))

trings /data/steam/.local/share/Steam/steamcmd/linux32/libstdc++.so.6 | grep CXXAB
CXXABI_1.3
CXXABI_1.3.1
CXXABI_1.3.2
CXXABI_1.3.3
CXXABI_1.3.4
CXXABI_1.3.5
CXXABI_1.3.6
CXXABI_1.3.7
CXXABI_TM_1

strings /data/steam/csgo_app/bin/libtier0.so | grep CXXAB
CXXABI_1.3.8
CXXABI_1.3
```

apt install file binutils

```text
 strings /lib/i386-linux-gnu/libstdc++.so.6.0.30 | grep  GCC
GCC_4.2.0
GCC_7.0.0
GCC_3.3
GCC_3.4
GCC_3.0
steam@990dfd271ac3:~$ strings /data/steam/csgo_app/bin/libgcc_s.so.1 | grep GCC
GCC_3.0
GCC_3.3
GCC_3.3.1
GCC_3.4
GCC_3.4.2
GCC_4.0.0
GCC_4.2.0
GCC_4.3.0
GCC_4.4.0
GCC_4.5.0
GCC: (crosstool-NG 1.12.2) 4.5.3
GCC_4.0.0
GCC_3.3.1
GCC_4.4.0
GCC_4.5.0
GCC_4.2.0
GCC_4.3.0
GCC_3.0
GCC_3.4
GCC_3.3
GCC_3.4.2
```

```text
${CSGO_BASE_DIR}/srcds_linux 
LD_LIBRARY_PATH=/data/steam/bin:/usr/lib32:/data/steam/csgo_app/bin
Failed to open libtier0.so (/data/steam/csgo_app/bin/libgcc_s.so.1: version `GCC_7.0.0' not found (required by /lib/i386-linux-gnu/libstdc++.so.6))
steam@99993f7f96c0:~$ ldd ${CSGO_BASE_DIR}/srcds_linux 
        linux-gate.so.1 (0xf7fb1000)
        libdl.so.2 => /lib/i386-linux-gnu/libdl.so.2 (0xf7fa4000)
        libpthread.so.0 => /lib/i386-linux-gnu/libpthread.so.0 (0xf7f9f000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xf7d6a000)
        /lib/ld-linux.so.2 (0xf7fb3000)
```

mv /lib/i386-linux-gnu/libstdc++.so.6 /lib/i386-linux-gnu/libstdc++.so.6.org

```text
Failed to open libtier0.so (/data/steam/.local/share/Steam/steamcmd/linux32/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /data/steam/csgo_app/bin/libtier0.so))
```

Failed to open libtier0.so (//home/steam/csgo_app/bin/libgcc_s.so.1: version `GCC_7.0.0' not found (required by /lib32/libstdc++.so.6))

* I think /lib32/libstdc++.so.6 is looking for a version of /home/steam/csgo_app/bin/libgcc_s.so.1 that has the GCC_7.0.0
* or /home/steam/csgo_app/bin/libtier0.so is looking for a version of /home/steam/steamcmd/linux32/libstdc++.so.6 that has the CXXABI_1.3.8
  * /home/steam/steamcmd/linux32/libstdc++.so.6 only have up to CXXABI_1.3.7

* strings /home/steam/csgo_app/bin/libtier0.so | grep GCC
  * both
    * GCC: (SteamRT 5.4.0-7.really.6+steamrt1.2+srt2) 5.4.1 20160803
    * GCC: (SteamRT/Linaro 4.6.3-1ubuntu5+steamrt1.2+srt2) 4.6.3
* strings /home/steam/csgo_app/bin/libgcc_s.so.1 | grep GCC
  * both
    * GCC: (crosstool-NG 1.12.2) 4.5.3
    * GCC_3.0
    * GCC_3.3
    * GCC_3.3.1
    * GCC_3.4
    * GCC_3.4.2
    * GCC_4.0.0
    * GCC_4.2.0
    * GCC_4.3.0
    * GCC_4.4.0
    * GCC_4.5.0
* strings /lib32/libstdc++.so.6 | grep GCC
  * new
    * GCC_7.0.0
    * GCC_4.2.0
    * GCC_3.4
    * GCC_3.3
    * GCC_3.0
  * old - /usr/lib32/libstdc++.so.6
    * GCC_4.2.0
    * GCC_3.4
    * GCC_3.3
    * GCC_3.0

* export LD_LIBRARY_PATH=/home/steam/csgo_app/bin:/home/steam/steamcmd/linux32
* /home/steam/csgo_app/srcds_linux -game csgo -usercon -net_port_try 1 -tickrate 128 -nobots +game_type 0 +game_mode 1 +mapgroup mg_active +map de_mirage

This error occurs on both bookworm and bullseye

```text
LD_LIBRARY_PATH=/home/steam/bin:/home/steam/csgo_app/bin:/home/steam/steamcmd/linux32
Failed to open libtier0.so (/home/steam/steamcmd/linux32/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /home/steam/csgo_app/bin/libtier0.so))
```

#### dlopen failed trying to load: /data/steam/.steam/sdk32/steamclient.so

```text
dlopen failed trying to load:
/data/steam/.steam/sdk32/steamclient.so
```

### CSGO server troubleshooting

```text
#GameTypes: missing mapgroupsSP entry for game type/mode (custom/custom).
#GameTypes: missing mapgroupsSP entry for game type/mode (cooperative/cooperative).
#GameTypes: missing mapgroupsSP entry for game type/mode (cooperative/coopmission).
#GameTypes: missing gameModes entry for game type mapgroups.
#GameTypes: empty gameModes entry for game type mapgroups.
Failed to load gamerulescvars.txt, game rules cvars might not be reported to management tools.
Maxplayers is deprecated, set it in gamemodes_server.txt.example or use -maxplayers_override instead.
ConVarRef room_type doesn't point to an existing ConVar
bot_coopmission_dz_engagement_limit - missing cvar specified in bspconvar_whitelist.txt
sv_camera_fly_enabled - missing cvar specified in bspconvar_whitelist.txt
SDR_LISTEN_PORT is set, but not SDR_CERT/SDR_PRIVATE_KEY.
```

#### in rescue mode, I didn't get to choose sides

#### How do I set the number rounds in rescue mode?

#### Public server not visible

add to autoexec.cfg: `sv_tags "my_unique_tag"`

you can then search for the tag and find your server that way.

* [CS:GO Not showing up in server/community list](https://forums.alliedmods.net/showthread.php?t=237814)
* [How to Setup CS:GO Dedicated Server on Microsoft Azure](https://edi.wang/post/2022/6/16/how-to-setup-csgo-dedicated-server-on-microsoft-azure)

```text
Calling BreakpadMiniDumpSystemInit
Setting breakpad minidump AppID = 740
Logging into Steam gameserver account with logon token '23FE72D3xxxxxxxxxxxxxxxxxxxxxxxx'
Initialized low level socket/threading support.
SDR_LISTEN_PORT is set, but not SDR_CERT/SDR_PRIVATE_KEY.
Set SteamNetworkingSockets P2P_STUN_ServerList to '' as per SteamNetworkingSocketsSerialized
SteamDatagramServer_Init succeeded
Connection to Steam servers successful.
   Public IP is 40.113.83.58.
Assigned persistent gameserver Steam ID [G:1:9490790].
Gameserver logged on to Steam, assigned identity steamid:85568392929530214
Set SteamNetworkingSockets P2P_STUN_ServerList to '162.254.196.83:3478' as per SteamNetworkingSocketsSerialized
VAC secure mode is activated.
GC Connection established for server version 1569, instance idx 1
```

#### an unhandled exception occurred while templating

```text
TASK [Generate autoexec.cfg from Template] *************************************
fatal: [localhost]: FAILED! => {"changed": false, "msg": "AnsibleError: 
  An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: An unhandled exception occurred while templating '{{server_name}}'. Error was a <class 'ansible.errors.AnsibleError'>, 
  original message: recursive loop detected in template string: {{server_name}}"}
```

### X display troubleshooting

#### X Error of failed request:  BadAccess (attempt to access private resource denied)

setting the DISPLAY to ':2' to fix the issue.

it is because I used the  `--network host` so it was conflicting with the host...

```text
scripts csgosl:0.1.2
DDD DISPLAY :1
_XSERVTransSocketUNIXCreateListener: ...SocketCreateListener() failed
_XSERVTransMakeAllCOTSServerListeners: server already running
(EE) 
Fatal server error:
(EE) Cannot establish any listening sockets - Make sure an X server isn't already running(EE) 
[WARN] The VNC server will NOT ask for a password.
Failed to read: session.ignoreBorder
Setting default value
Failed to read: session.forcePseudoTransparency
Setting default value
Failed to read: session.colorsPerChannel
Setting default value
Failed to read: session.doubleClickInterval
Setting default value
Failed to read: session.tabPadding

...
01/09/2023 15:39:54 Xinerama: Use -noxwarppointer to force XTEST.
01/09/2023 15:39:54 Xinerama: sub-screen[0]  1920x1080+0+0
01/09/2023 15:39:54 Xinerama: sub-screen[1]  2560x1440+1920+0
01/09/2023 15:39:54 blackout rect: 1920x360+0+1080: x=0-1920 y=1080-1439
01/09/2023 15:39:54 

X11 MIT Shared Memory Attach failed:
  Is your DISPLAY=:1 on a remote machine?
  Suggestion, use: x11vnc -display :0 ... for local display :0

caught X11 error:
01/09/2023 15:39:54 deleted 1 tile_row polling images.
X Error of failed request:  BadAccess (attempt to access private resource denied)
  Major opcode of failed request:  130 (MIT-SHM)
  Minor opcode of failed request:  1 (X_ShmAttach)
  Serial number of failed request:  56
  Current serial number in output stream:  59
```

#### Unknown command

```text
./csgo/console.log:Unknown command "mp_winlimit"
```

#### Error response from daemon: manifest for elastic/filebeat:latest not found: manifest unknown: manifest

specifying a version works: `docker pull elastic/filebeat:8.9.2`

```text
docker pull elastic/filebeat
Using default tag: latest
Error response from daemon: manifest for elastic/filebeat:latest not found: manifest unknown: manifest unknown
```

### Troubleshooting ELK

docker logs filebeat 2>&1 | jq '.message'

#### max virtual memory areas vm.max_map_count [65530] is too low

[max-virtual-memory-areas-vm-max-map-count](https://stackoverflow.com/questions/66444027/max-virtual-memory-areas-vm-max-map-count-65530-is-too-low-increase-to-at-lea)

```json
elasticsearch    | {"@timestamp":"2023-09-18T15:09:18.368Z", "log.level":"ERROR", "message":"node validation exception\n[1] bootstrap checks failed. You must address the points described in the following [1] lines before starting Elasticsearch.\nbootstrap check failure [1] of [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]", "ecs.version": "1.2.0","service.name":"ES_ECS","event.dataset":"elasticsearch.server","process.thread.name":"main","log.logger":"org.elasticsearch.bootstrap.Elasticsearch","elasticsearch.node.name":"a022b85dcbb0","elasticsearch.cluster.name":"docker-cluster"}
```

#### received plaintext http traffic on an https channel, closing connection

* [Using ElasticSerach 8 via Docker without certificate](https://discuss.elastic.co/t/using-elasticserach-8-via-docker-without-certificate/303617)

```json
{"@timestamp":"2023-09-18T15:19:22.311Z", "log.level": "WARN", "message":"received plaintext http traffic on an https channel, closing connection Netty4HttpChannel{localAddress=/172.21.0.5:9200, remoteAddress=/172.21.0.4:37800}", "ecs.version": "1.2.0","service.name":"ES_ECS","event.dataset":"elasticsearch.server","process.thread.name":"elasticsearch[b53ce83b838f][transport_worker][T#5]","log.logger":"org.elasticsearch.http.netty4.Netty4HttpServerTransport","elasticsearch.cluster.uuid":"TcIkJJDTSnGz1UoB8LdUYQ","elasticsearch.node.id":"3ncEZVmqRDSYEAoSkByzpg","elasticsearch.node.name":"b53ce83b838f","elasticsearch.cluster.name":"docker-cluster"}
```

#### ERROR: Elasticsearch exited unexpectedly, with exit code 137

`docker-compose up elasticsearch`

[Elasticsearch multi-node cluster one node always fails with docker compose](https://stackoverflow.com/questions/62006956/elasticsearch-multi-node-cluster-one-node-always-fails-with-docker-compose)

#### Error! App '730' state is 0x402 after update job

maybe due to loosing the connection with download server.

Solution, re-run the command?

```text
Update state (0x61) downloading, progress: 38.46 (14022978153 / 36460775173)
 Update state (0x61) downloading, progress: 38.50 (14037708217 / 36460775173)
 Update state (0x61) downloading, progress: 38.52 (14045048249 / 36460775173)
 Update state (0x461) stopping, progress: 38.52 (14045048249 / 36460775173)
Error! App '730' state is 0x402 after update job.
CWorkThreadPool::~CWorkThreadPool: work complete queue not empty, 3 items discarded.
CWorkThreadPool::~CWorkThreadPool: work processing queue not empty: 35 items discarded.
```

```text
Update state (0x61) downloading, progress: 77.30 (28183930414 / 36460775173)
 Update state (0x61) downloading, progress: 77.33 (28196237150 / 36460775173)
 Update state (0x61) downloading, progress: 77.37 (28208578751 / 36460775173)
 Update state (0x461) stopping, progress: 77.39 (28215806799 / 36460775173)
Error! App '730' state is 0x402 after update job.
CWorkThreadPool::~CWorkThreadPool: work complete queue not empty, 3 items discarded.
CWorkThreadPool::~CWorkThreadPool: work processing queue not empty: 32 items discarded.
crash_20231001095737_62.dmp[419]: Uploading dump (out-of-process)
/tmp/dumps/crash_20231001095737_62.dmp

/data/steam/.local/share/Steam/steamcmd/steamcmd.sh: line 39:   356 Segmentation fault      (core dumped) $DEBUGGER "$STEAMEXE" "$@"
steam@a4dacf1f72cf:~/csgo_app$ crash_20231001095737_62.dmp[419]: Finished uploading minidump (out-of-process): success = yes

crash_20231001095737_62.dmp[419]: response: CrashID=bp-8f9cde4a-9a05-4c17-88c6-4439f2231001

crash_20231001095737_62.dmp[419]: file ''/tmp/dumps/crash_20231001095737_62.dmp'', upload yes: ''CrashID=bp-8f9cde4a-9a05-4c17-88c6-4439f2231001''
```

#### failed to dlopen "/data/steam/csgo_app/game/bin/linuxsteamrt64/librendersystemvulkan.so" error=libxcb.so.1: cannot open shared object file: No such file or directory

```text
Loaded /data/steam/csgo_app/game/bin/linuxsteamrt64/liblocalize.so, got 0x5585b7991db0
Loaded /data/steam/csgo_app/game/bin/linuxsteamrt64/librendersystemvulkan.so, got (nil)
 failed to dlopen "/data/steam/csgo_app/game/bin/linuxsteamrt64/librendersystemvulkan.so" error=libxcb.so.1: cannot open shared object file: No such file or directory
Loaded librendersystemvulkan.so, got (nil)
 failed to dlopen "librendersystemvulkan.so" error=libxcb.so.1: cannot open shared object file: No such file or directory
/data/steam/csgo_git_repo/csgo_scripts/run_cs2_server.sh: line 70:   587 Segmentation fault      (core dumped) ${CSGO_BASE_DIR}/bin/linuxsteamrt64/cs2 -game csgo --dedicated -usercon -uselogdir -condebug -net_port_try 1 -tickrate 128 ${HOSTAGE_RESCUE}
s
```

### cs2

#### Failed to initialize Steamworks SDK for gameserver.  Failed to load module '/data/steam/.steam/sdk64/steamclient.so'

Fix:

* export LD_LIBRARY_PATH=/usr/lib/games/linux64
* ~/csgo_app/game/bin/linuxsteamrt64/cs2 -dedicated +map de_dust2

Failed:

export LD_LIBRARY_PATH=/data/steam/csgo_app/bin
linuxsteamrt64/cs2 -dedicated +map de_dust2

strace -f -o ~/cs2.trc csgo_app/game/bin/linuxsteamrt64/cs2 -dedicated +map de_dust2

```text
Event System loaded 50 events from file: vpk:/data/steam/csgo_app/game/csgo/pak01.vpk:resource/game.gameevents.
Event System loaded 152 events from file: vpk:/data/steam/csgo_app/game/csgo/pak01.vpk:./resource/mod.gameevents.
CEntitySystem::BuildEntityNetworking (parallel build of server) took 41.571 msecs for 211 out of 289 classes
CHostStateMgr::QueueNewRequest( Idle (console), 1 )
Source2Init OK
HostStateRequest::Start(HSR_IDLE):  loop(console) id(1) addons() desc(Idle (console))
SwitchToLoop console requested:  id [1] addons []
Host activate: Idle (console)
Loading map "de_dust2"
CHostStateMgr::QueueNewRequest( Loading (de_dust2), 2 )
HostStateRequest::Start(HSR_GAME):  loop(levelload) id(2) addons() desc(Loading (de_dust2))
SwitchToLoop levelload requested:  id [2] addons []
SV:  Level loading started for 'de_dust2'
CL:  CLoopModeLevelLoad::MaybeSwitchToGameLoop switching to "game" loopmode with addons ()
SwitchToLoop game requested:  id [2] addons []
SteamGameServer_Init()
dlopen failed trying to load:
steamclient.so
with error:
steamclient.so: wrong ELF class: ELFCLASS32
dlopen failed trying to load:
/data/steam/.steam/sdk64/steamclient.so
with error:
/data/steam/.steam/sdk64/steamclient.so: cannot open shared object file: No such file or directory
[S_API] SteamAPI_Init(): Failed to load module '/data/steam/.steam/sdk64/steamclient.so'
Failed to initialize Steamworks SDK for gameserver.  Failed to load module '/data/steam/.steam/sdk64/steamclient.so'
sv_steamauth.cpp 198 Activate():
Failed to initialize Steamworks SDK for gameserver.  Failed to load module '/data/steam/.steam/sdk64/steamclient.so'

```

#### core dumped - Failed to initialize Steamworks SDK for gameserver.  Failed to load module '/data/steam/.steam/sdk64/steamclient.so'

fix:

* steamcmd +force_install_dir ~/csgo_app/ +login anonymous +app_update 730 validate +quit
* export LD_LIBRARY_PATH=/data/steam/.local/share/Steam/steamcmd/linux64

```text
CHostStateMgr::QueueNewRequest( Idle (console), 1 )
Source2Init OK
HostStateRequest::Start(HSR_IDLE):  loop(console) id(1) addons() desc(Idle (console))
SwitchToLoop console requested:  id [1] addons []
Host activate: Idle (console)
Loading map "de_dust2"
CHostStateMgr::QueueNewRequest( Loading (de_dust2), 2 )
HostStateRequest::Start(HSR_GAME):  loop(levelload) id(2) addons() desc(Loading (de_dust2))
SwitchToLoop levelload requested:  id [2] addons []
SV:  Level loading started for 'de_dust2'
CL:  CLoopModeLevelLoad::MaybeSwitchToGameLoop switching to "game" loopmode with addons ()
SwitchToLoop game requested:  id [2] addons []
SteamGameServer_Init()
dlopen failed trying to load:
steamclient.so
with error:
steamclient.so: cannot open shared object file: No such file or directory
dlopen failed trying to load:
/data/steam/.steam/sdk64/steamclient.so
with error:
/data/steam/.steam/sdk64/steamclient.so: cannot open shared object file: No such file or directory
[S_API] SteamAPI_Init(): Failed to load module '/data/steam/.steam/sdk64/steamclient.so'
Failed to initialize Steamworks SDK for gameserver.  Failed to load module '/data/steam/.steam/sdk64/steamclient.so'
sv_steamauth.cpp 198 Activate():
Failed to initialize Steamworks SDK for gameserver.  Failed to load module '/data/steam/.steam/sdk64/steamclient.so'

Segmentation fault (core dumped)
```

#### strange non update end

```text
 Update state (0x5) verifying install, progress: 91.88 (31887640407 / 34705746562)
 Update state (0x5) verifying install, progress: 93.55 (32466967373 / 34705746562)
 Update state (0x5) verifying install, progress: 94.80 (32899697416 / 34705746562)
 Update state (0x5) verifying install, progress: 96.50 (33492379428 / 34705746562)
 Update state (0x5) verifying install, progress: 99.09 (34390762622 / 34705746562)
 Update state (0x61) downloading, progress: 19.84 (79402 / 400136)
Success! App '740' fully installed.
```

```text
 Update state (0x5) verifying install, progress: 91.88 (31887640407 / 34705746562)
 Update state (0x5) verifying install, progress: 93.55 (32466967373 / 34705746562)
 Update state (0x5) verifying install, progress: 94.80 (32899697416 / 34705746562)
 Update state (0x5) verifying install, progress: 96.50 (33492379428 / 34705746562)
 Update state (0x5) verifying install, progress: 99.09 (34390762622 / 34705746562)
 Update state (0x61) downloading, progress: 19.84 (79402 / 400136)
Success! App '740' fully installed.
```

```text
Connecting anonymously to Steam Public...OK
Waiting for client config...OK
Waiting for user info...OK
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x5) verifying install, progress: 1.42 (491913771 / 34705746562)
 Update state (0x5) verifying install, progress: 3.94 (1368476424 / 34705746562)
...
 Update state (0x5) verifying install, progress: 83.54 (28993093749 / 34705746562)
 Update state (0x5) verifying install, progress: 85.95 (29829262174 / 34705746562)
 Update state (0x5) verifying install, progress: 88.43 (30691138212 / 34705746562)
 Update state (0x5) verifying install, progress: 90.98 (31576119765 / 34705746562)
 Update state (0x5) verifying install, progress: 93.57 (32474881585 / 34705746562)
 Update state (0x5) verifying install, progress: 95.47 (33132393823 / 34705746562)
 Update state (0x5) verifying install, progress: 97.62 (33879661846 / 34705746562)
 Update state (0x5) verifying install, progress: 99.92 (34679027061 / 34705746562)
Success! App '740' fully installed.
```

#### full process

```text

Connecting anonymously to Steam Public...OK
Waiting for client config...OK
Waiting for user info...OK
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x61) downloading, progress: 0.00 (45144 / 34705746562)
 Update state (0x61) downloading, progress: 0.04 (14815969 / 34705746562)
 Update state (0x61) downloading, progress: 0.13 (45841484 / 34705746562)
 Update state (0x61) downloading, progress: 0.22 (77958252 / 34705746562)
 Update state (0x61) downloading, progress: 0.30 (105243982 / 34705746562)
 ...
 Update state (0x61) downloading, progress: 99.66 (34589459383 / 34705746562)
 Update state (0x61) downloading, progress: 99.75 (34620116384 / 34705746562)
 Update state (0x61) downloading, progress: 99.83 (34647497638 / 34705746562)
 Update state (0x61) downloading, progress: 99.89 (34668098693 / 34705746562)
 Update state (0x61) downloading, progress: 99.97 (34696262258 / 34705746562)
 Update state (0x81) verifying update, progress: 0.34 (117817799 / 34705746562)
 Update state (0x81) verifying update, progress: 2.67 (925761585 / 34705746562)
 Update state (0x81) verifying update, progress: 4.94 (1715218452 / 34705746562)
 Update state (0x81) verifying update, progress: 7.25 (2515131314 / 34705746562)
 Update state (0x81) verifying update, progress: 9.16 (3178191409 / 34705746562)
 Update state (0x81) verifying update, progress: 11.12 (3860121818 / 34705746562)
 Update state (0x81) verifying update, progress: 13.42 (4658091596 / 34705746562)
 Update state (0x81) verifying update, progress: 15.60 (5412811434 / 34705746562)
 Update state (0x81) verifying update, progress: 18.02 (6255004506 / 34705746562)
 Update state (0x81) verifying update, progress: 20.37 (7070588706 / 34705746562)
 Update state (0x81) verifying update, progress: 22.69 (7876318098 / 34705746562)
 Update state (0x81) verifying update, progress: 24.98 (8671013339 / 34705746562)
 Update state (0x81) verifying update, progress: 27.19 (9435212380 / 34705746562)
 Update state (0x81) verifying update, progress: 29.52 (10246504194 / 34705746562)
 Update state (0x81) verifying update, progress: 31.82 (11042047859 / 34705746562)
 Update state (0x81) verifying update, progress: 34.21 (11872114765 / 34705746562)
 Update state (0x81) verifying update, progress: 35.85 (12441549096 / 34705746562)
 Update state (0x81) verifying update, progress: 37.22 (12918364785 / 34705746562)
 Update state (0x81) verifying update, progress: 39.17 (13593478205 / 34705746562)
 Update state (0x81) verifying update, progress: 41.18 (14290735391 / 34705746562)
 Update state (0x81) verifying update, progress: 43.35 (15045468169 / 34705746562)
 Update state (0x81) verifying update, progress: 45.65 (15842789821 / 34705746562)
 Update state (0x81) verifying update, progress: 48.03 (16667967957 / 34705746562)
 Update state (0x81) verifying update, progress: 50.20 (17423502137 / 34705746562)
 Update state (0x81) verifying update, progress: 52.56 (18239983034 / 34705746562)
 Update state (0x81) verifying update, progress: 54.88 (19048144754 / 34705746562)
 Update state (0x81) verifying update, progress: 56.67 (19667229539 / 34705746562)
 Update state (0x81) verifying update, progress: 58.88 (20434066000 / 34705746562)
 Update state (0x81) verifying update, progress: 60.78 (21095786200 / 34705746562)
 Update state (0x81) verifying update, progress: 62.83 (21804997506 / 34705746562)
 Update state (0x81) verifying update, progress: 65.17 (22616198493 / 34705746562)
 Update state (0x81) verifying update, progress: 67.56 (23447681871 / 34705746562)
 Update state (0x81) verifying update, progress: 69.90 (24259393254 / 34705746562)
 Update state (0x81) verifying update, progress: 72.22 (25063678248 / 34705746562)
 Update state (0x81) verifying update, progress: 74.45 (25836841613 / 34705746562)
 Update state (0x81) verifying update, progress: 76.61 (26588983760 / 34705746562)
 Update state (0x81) verifying update, progress: 78.90 (27382414000 / 34705746562)
 Update state (0x81) verifying update, progress: 81.20 (28181235021 / 34705746562)
 Update state (0x81) verifying update, progress: 83.33 (28921932809 / 34705746562)
 Update state (0x81) verifying update, progress: 85.71 (29746417302 / 34705746562)
 Update state (0x81) verifying update, progress: 88.06 (30563463007 / 34705746562)
 Update state (0x81) verifying update, progress: 90.26 (31326482436 / 34705746562)
 Update state (0x81) verifying update, progress: 92.48 (32097493824 / 34705746562)
 Update state (0x81) verifying update, progress: 94.43 (32773849201 / 34705746562)
 Update state (0x81) verifying update, progress: 95.78 (33240314426 / 34705746562)
 Update state (0x81) verifying update, progress: 97.83 (33951467972 / 34705746562)
 Update state (0x101) committing, progress: 20.51 (7119863557 / 34705746562)
Success! App '740' fully installed.
```

#### Your server needs to be restarted in order to receive the latest update

* [](https://steamcommunity.com/discussions/forum/13/1696043806570333687/)
* did a complede delete and then re-install of csgo, and it gave the same error
* [Issue](https://steamcommunity.com/discussions/forum/14/6367585250000001877/)

```text
GC Connection established for server version 1575, instance idx 1
MasterRequestRestart
Your server needs to be restarted in order to receive the latest update.
MasterRequestRestart
Your server needs to be restarted in order to receive the latest update.
Host state 5 at Sat Oct 14 21:35:43 2023
```

#### CS2 client unable to login to password protected server via UI

See: [CS2 how to set a password on a self-hosted CS2 server, that clients can log in to](https://steamcommunity.com/discussions/forum/14/6367585698107819940/)

workaround; use the console: `connect 192.168.8.194:27015; password ServerPassword`

* Enable the console
* Find the address of the server via the global server browser
* view the server info and copy the Address
* close the server UI
* open the console
* type 'connect '
* right click mouse and pase in the adress
* type '; password'
* type the server password
* press enter
* you should now be connected to the server

#### CS2

LD_LIBRARY_PATH=/home/steam/steamcmd/linux32
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

* docker run -it  --network host --volume ${HOME}/Downloads/cs2_app:/data/steam/csgo_app --volume `pwd`/csgo_scripts:/data/steam/csgo_git_repo/csgo_scripts cs2_server:0.2.3 bash
* su steam
* export LD_LIBRARY_PATH=/home/steam/steamcmd/linux32
* steamcmd +quit
* ~/csgo_git_repo/csgo_scripts/run_cs2_server.sh

This also works:

* docker run -it  --network host --volume ${HOME}/Downloads/cs2_app:/data/steam/csgo_app --volume `pwd`/csgo_scripts:/data/steam/csgo_git_repo/csgo_scripts cs2_server:0.2.3 bash
* su - steam
* export LD_LIBRARY_PATH=/home/steam/steamcmd/linux32
* steamcmd +quit
* ~/csgo_git_repo/csgo_scripts/run_cs2_server.sh

This works:

* docker run -it  --network host --volume ${HOME}/Downloads/cs2_app:/data/steam/csgo_app --volume `pwd`/csgo_scripts:/data/steam/csgo_git_repo/csgo_scripts cs2_server:0.2.3 bash
* su - steam
* export LD_LIBRARY_PATH=/home/steam/steamcmd/linux32
* steamcmd +force_install_dir ~/csgo_app/ +login STEAM_LOGIN STEAM_PASSWORD +app_update 730 validate +quit
* ~/csgo_git_repo/csgo_scripts/run_cs2_server.sh

```text
cs2-ds           | Unknown command 'sv_setsteamaccount'!
cs2-ds           | L 10/17/2023 - 15:43:18: server_cvar: "sv_password" "***PROTECTED***"
cs2-ds           | exec: couldn't exec '{*}cfg/banned_user.cfg', unable to read file
cs2-ds           | exec: couldn't exec '{*}cfg/banned_ip.cfg', unable to read file
cs2-ds           | III Executed cs2_server_settings Config!
cs2-ds           | HostStateRequest::Start(HSR_GAME):  loop(levelload) id(2) addons() desc(Loading (cs_office))
cs2-ds           | SwitchToLoop levelload requested:  id [2] addons []
cs2-ds           | SV:  Level loading started for 'cs_office'
cs2-ds           | CL:  CLoopModeLevelLoad::MaybeSwitchToGameLoop switching to "game" loopmode with addons ()
cs2-ds           | SwitchToLoop game requested:  id [2] addons []
cs2-ds           | SteamGameServer_Init()
cs2-ds           | Failed to initialize Steamworks SDK for gameserver.  Failed to load module '/root/.steam/sdk64/steamclient.so'
cs2-ds           | dlopen failed trying to load:
cs2-ds           | /root/.steam/sdk64/steamclient.so
cs2-ds           | with error:
cs2-ds           | /root/.steam/sdk64/steamclient.so: cannot open shared object file: No such file or directory
cs2-ds           | [S_API] SteamAPI_Init(): Failed to load module '/root/.steam/sdk64/steamclient.so'
cs2-ds           |  0 Failed to initialize Steamworks SDK for gameserver.  Failed to load module '/root/.steam/sdk64/steamclient.so'
cs2-ds           | 
cs2-ds           | /data/steam/csgo_git_repo/csgo_scripts/run_cs2_server.sh: line 81:     9 Segmentation fault      (core dumped) /data/steam/csgo_app/game/bin/linuxsteamrt64/cs2 -dedicated -usercon -uselogdir -condebug -secure -nobots +log on ${HOSTAGE_RESCUE} +exec cs2_server_settings.cfg
```

#### Action failed with '[index_not_green_timeout] Timeout waiting for the status of the [.kibana_ingest_8.10.1_001] index to become 'green'

Turns out it was elasticsearch that had the problem (I notices kibana mentionen a porblem connecting to elasticsearch)

```text
{"@timestamp":"2023-10-18T12:51:57.657Z", "log.level": "WARN", "message":"high disk watermark [90%] exceeded on [GWhTPhtIQOmzC-m6yiOO5Q][1c7d3a882e12][/usr/share/elasticsearch/data] free: 18.6gb[8.2%], shards will be relocated away from this node; currently relocating away shards totalling [0] bytes; the node is expected to continue to exceed the high disk watermark when these relocations are complete", "ecs.version": "1.2.0","service.name":"ES_ECS","event.dataset":"elasticsearch.server","process.thread.name":"elasticsearch[1c7d3a882e12][masterService#updateTask][T#2]","log.logger":"org.elasticsearch.cluster.routing.allocation.DiskThresholdMonitor","elasticsearch.cluster.uuid":"3cy5qpNuRh2QCyfS7ImCPg","elasticsearch.node.id":"GWhTPhtIQOmzC-m6yiOO5Q","elasticsearch.node.name":"1c7d3a882e12","elasticsearch.cluster.name":"docker-cluster"}
```

```text
[2023-10-18T12:43:42.891+00:00][INFO ][savedobjects-service] [.kibana_task_manager] CREATE_NEW_TARGET -> CREATE_NEW_TARGET. took: 76011ms.
[2023-10-18T12:43:42.893+00:00][ERROR][savedobjects-service] [.kibana_ingest] Action failed with '[index_not_green_timeout] Timeout waiting for the status of the [.kibana_ingest_8.10.1_001] index to become 'green' Refer to https://www.elastic.co/guide/en/kibana/8.10/resolve-migrations-failures.html#_repeated_time_out_requests_that_eventually_fail for information on how to resolve the issue.'. Retrying attempt 5 in 32 seconds.
```

#### crash_20231020080431_125.dmp[145]: error: libcurl.so: cannot open shared object file: No such file or directory

```text
OK
Waiting for client config...OK
Waiting for user info...OK
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x1) running, progress: 0.00 (0 / 0)
 Update state (0x61) downloading, progress: 2.03 (13496883 / 665872418)
 Update state (0x61) downloading, progress: 37.49 (249656563 / 665872418)
 Update state (0x61) downloading, progress: 67.98 (452640248 / 665872418)
 Update state (0x61) downloading, progress: 69.24 (461028856 / 665872418)
 Update state (0x61) downloading, progress: 70.76 (471166099 / 665872418)
 Update state (0x61) downloading, progress: 72.16 (480492643 / 665872418)
 Update state (0x61) downloading, progress: 75.52 (502856830 / 665872418)
 Update state (0x61) downloading, progress: 81.10 (539993338 / 665872418)
 Update state (0x61) downloading, progress: 83.20 (553980707 / 665872418)
 Update state (0x61) downloading, progress: 87.62 (583466754 / 665872418)
 Update state (0x61) downloading, progress: 93.29 (621215490 / 665872418)
 Update state (0x61) downloading, progress: 98.74 (657497858 / 665872418)
 Update state (0x81) verifying update, progress: 96.90 (645260730 / 665872418)
dlmopen steamservice.so failed: steamservice.so: cannot open shared object file: No such file or directory
Success! App '730' fully installed.
crash_20231020080431_125.dmp[145]: Uploading dump (out-of-process)
/tmp/dumps/crash_20231020080431_125.dmp

crash_20231020080431_125.dmp[145]: Finished uploading minidump (out-of-process): success = no

crash_20231020080431_125.dmp[145]: error: libcurl.so: cannot open shared object file: No such file or directory

crash_20231020080431_125.dmp[145]: file ''/tmp/dumps/crash_20231020080431_125.dmp'', upload no: ''libcurl.so: cannot open shared object file: No such file or directory''

Segmentation fault (core dumped)
```

#### 02/20 17:34:35 [InputService] exec: couldn't exec '{*}cfg/cs2_server_settings.cfg', unable to read file

```text
02/20 17:34:35 [InputService] exec: couldn't exec '{*}cfg/cs2_server_settings.cfg', unable to read file
02/20 17:34:36 [InputService] exec: couldn't exec '{*}cfg/csgosl/execonmapchange.cfg', unable to read file

```