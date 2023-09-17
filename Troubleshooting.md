# Troubleshooting

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
