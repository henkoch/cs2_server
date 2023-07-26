# csgo_server

## Introduction

### Purpose

Hold the scripts for deploying a private CS GO server.

* libvirt/kvm

### installation debugging

* ssh -i tf-cloud-init ansible@192.168.122.122
* systemctl status cloud-final
* sudo journalctl -u cloud-final
* sudo /var/log/cloud-init-output.log
/var/log/cloud-init.log
/var/lib/cloud/data/result.json