#!/bin/bash

CSGO_BASE_DIR="/data/steam/csgo_app"
CSGO_SCRIPTS_DIR="/data/steam/csgo_git_repo/csgo_scripts"

export LD_LIBRARY_PATH="${CSGO_BASE_DIR}:${CSGO_BASE_DIR}/bin"

# avoid the error:
#  Failed to open libtier0.so (/data/steam/csgo_app/bin/libgcc_s.so.1: version `GCC_7.0.0' not found (required by /lib/i386-linux-gnu/libstdc++.so.6))
if [ -f ${CSGO_BASE_DIR}/bin/libgcc_s.so.1 ]
then
  echo "III removing ${CSGO_BASE_DIR}/bin/libgcc_s.so.1"
  mv ${CSGO_BASE_DIR}/bin/libgcc_s.so.1 ${CSGO_BASE_DIR}/bin/libgcc_s.so.1.bck
fi

# -condebug Logs all console output into the console.log text file. 
# -console  Starts the game with the developer console enabled. Same as having con_enable enabled. 
# -forever 	When you get to the end of the maplist, start over from the top
# -game 	Sets game or mod directory to load the game from. 
#             Usually is set by default if not user specified. Default is "-defaultgamedir"'s setting.
#             If -defaultgamedir is not set, "hl2" is used. 
# -gamestatsloggingtofile 	Enables game stats logging out to a file, gamestats.log. Passing this parameter automatically forces -gamestatslogging. 
# -maxplayers 	Set the maximum players allowed to join the server.
#                  This does the same as the maxplayers convar, the maximum you can set it to is limited by the game/mod 
# -nobots 	Allows Counter-Strike server hosts to force bots disabled to enforce CPU limits.
# -replay 	Increases maxplayers by 1 at startup and automatically executes replay.cfg for the server. 
# -uselogdir 	Logs various data to logs/(mapname)/*
# -usercon 	Enable RCON for Counter-Strike: Global Offensive servers
# -usetcp 	Disable TCP support
#             !!! Does this realy disable TCP?


# +maxplayers <number> 	Specifies how many player slots the server can contain (Old, but still works). 
# +sv_cheats <0/1> 	When set to 1, starts the game with cheats enabled. 
# +sv_lan <0/1> 	When set to 1, launches the game in LAN mode. Useful to stop players from joining your game from the Internet. 


# logs files: ~/csgo_app/csgo/logs

# gamemode_casual_server.cfg
cp ${CSGO_SCRIPTS_DIR}/autoexec.cfg ${CSGO_BASE_DIR}/csgo/cfg/
cp ${CSGO_SCRIPTS_DIR}/server.cfg ${CSGO_BASE_DIR}/csgo/cfg/
cp ${CSGO_SCRIPTS_DIR}/gamemodes_server.txt ${CSGO_BASE_DIR}/csgo/

# https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive/Game_Modes
#
CASUAL="-maxplayers 20 -nobots +game_type 0 +game_mode 0 +mapgroup mg_active +map de_nuke"
# https://counterstrike.fandom.com/wiki/Hostage_Rescue
HOSTAGE_RESCUE="-maxplayers 20 -nobots +game_type 0 +game_mode 0 +map cs_office"
# The above became arms-race, maybe due to the npbots?
# HOSTAGE_RESCUE="-maxplayers 20 +game_type 4 +game_mode 0 +map cs_office"
#  +mapgroup mg_hostage
ARMS_RACE="-maxplayers 20 -nobots +game_type 0 +game_mode 0 +map cs_office"
DANGER_ZONE="-maxplayers 12 -nobots  +game_type 6 +game_mode 0 +map dz_blacksite"
# https://csspy.com/guides/how-to-start-a-private-danger-zone-server-in-csgo/
#  alias "pracsirocco" "game_mode 0;game_type 6;map dz_sirocco"
#  alias "praccounty" "game_mode 0;game_type 6;map dz_county"
# source: https://steamcommunity.com/app/730/discussions/0/1743353798885446785/
# don't forget edit "maplist" and "mapcycle" => "dz_blacksite \n dz_sirocco"
# TODO why did it start looking for cs_italy????e
# game_type 6; game_mode 0; changelevel dz_blacksite; sv_dz_team_count 2; sv_dz_jointeam_allowed 1; sv_dz_autojointeam 0; sv_dz_player_spawn_armor 1

# set to casual mode
${CSGO_BASE_DIR}/srcds_linux -game csgo -usercon -uselogdir -condebug -net_port_try 1 -tickrate 128 ${HOSTAGE_RESCUE}