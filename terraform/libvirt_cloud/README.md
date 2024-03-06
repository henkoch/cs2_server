# Installing CSGO servers on libvirt server

PLEASE NOTE the client would not connect to the Server, possibly a problem with the haproxy configuration?

* tf apply
* virsh --connect=qemu+ssh://vmadm@homelab1/system list
* virsh --connect=qemu+ssh://vmadm@homelab1/system domifaddr csgo_vm
* update the haproxy.cfg
  * sudo haproxy -c -f haproxy.cfg
  * sudo cp haproxy.cfg /etc/haproxy/haproxy.cfg
  * sudo systemctl restart haproxy
  * systemctl status haproxy
* Change the VM to have the CPU stuff copied from the host CPU
* ssh -i tf-cloud-init -p 6122 ansible@homelab1
* Install and update the CS2 server
* ssh -i tf-cloud-init -p 6222 ansible@homelab1

#### installing the CS2 game

* ssh -i tf-cloud-init -p 6122 ansible@homelab1
* sudo -i
* su - steam
* rsync -az vmadm@homelab1:/hdd1/cs2/* /data/steam/csgo_app
* sudo chown steam:steam -R /data/steam/csgo_app
* export LD_LIBRARY_PATH=/usr/lib/games/linux32
* /usr/lib/games/steam/steamcmd +force_install_dir ~/csgo_app/ +login STEAM_ACCOUNT_NAME STEAM_ACCOUNT_PASSWORD +app_update 730 validate +quit
* copy in the private_ setting and run script
* ~/csgo_git_repo/csgo_scripts/private_run_cs2_server.sh
