# Installing CSGO servers on libvirt server

* tf apply
* virsh --connect=qemu+ssh://vmadm@homelab1/system list
* virsh --connect=qemu+ssh://vmadm@homelab1/system domifaddr csgo_vm
* update the haproxy.cfg
  * sudo haproxy -c -f haproxy.cfg
  * sudo cp haproxy.cfg /etc/haproxy/haproxy.cfg
  * sudo systemctl restart haproxy
  * systemctl status haproxy
* ssh -i tf-cloud-init -p 6122 ansible@homelab1
* Install and update the CS2 server
* ssh -i tf-cloud-init -p 6222 ansible@homelab1
