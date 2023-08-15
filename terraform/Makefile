all:
	terraform apply


base:
	sudo ./virt-cloud-builder.sh

clean:
	- terraform destroy -auto-approve
	- virsh destroy csgo_vm
	- virsh undefine csgo_vm
	- virsh vol-delete csgo_commoninit.iso
	- sleep 5 && sudo rm /var/lib/libvirt/images/commoninit.iso
