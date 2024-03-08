# Installing on Azure

* cd ~/csgo_server/ansible_playbook/
* ansible-playbook --extra-vars "cs2_client_access_password=cs2_client_access_password" --extra-vars "cs2_server_rcon_password=cs2_server_rcon_password" --extra-vars "one_for_local_zero_for_global=0" --extra-vars "server_name=cs_server_name" --extra-vars "steam_server_token=steam_server_token" -v steam_client.yaml

## Installation instructions

### Installing CS2

* ssh as ansible
* verify the /data is mounted
* sudo -i
* su - steam
* export LD_LIBRARY_PATH=/usr/lib/games/linux32
* time /usr/lib/games/steam/steamcmd +force_install_dir ~/csgo_app/ +login STEAM_USER_NAME STEAM_PASSWORD +app_update 730 validate +quit
* time /usr/lib/games/steam/steamcmd +force_install_dir ~/csgo_app/ +login STEAM_USER_NAME STEAM_PASSWORD +app_update 730 validate +quit
  * this time it will ask for the 'Steam Guard code:' the code will be e-mailed to the steam user e-mail address.

### Installing the telemetry server

* ssh as ansible
* cd csgo_XX/ansible_playbook/files
* TODO configure the prometheus configuration file
* docker compose up
* TODO set-up grafana, including downloading the 1860 dashboard

## TODO

* copy the filebeat file to etc: sudo cp csgo_server/ansible_playbook/files/filebeat.docker.yml /etc/filebeat/filebeat.yml
* figure out why the /data dir hasn't been mounted
* find out what requires the VM to be rebooted
* wait for the VM IPs to become available
