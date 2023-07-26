all:
	terraform apply


base:
	sudo ./virt-cloud-builder.sh

clean:
	- terraform destroy -auto-approve
	- virsh destroy csgo_vm
	- virsh undefine csgo_vm
	- sudo rm /var/lib/libvirt/images/commoninit.iso
