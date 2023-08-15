#!/usr/bin/bash

# This script will install csgo into a libvirt VM.

# https://stackoverflow.com/questions/70508114/terraform-set-a-variable-from-commandline-for-module-variable
# for an overview of variables please see the 'variables.tf' file.
terraform apply -var csgo_client_access_password="WelcomeToMyServer"