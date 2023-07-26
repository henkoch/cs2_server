#!/usr/bin/env bash
set -o errexit
set -o pipefail

# This script will download the Ubuntu cloud image for Jammy
#   and then copy in the netplan for nic0 called 'eth0'.

# original: https://gist.github.com/nkabir/71bf64e45013dcd965374fdaec95613d

readonly KVM_IMAGE_DA="/var"
readonly VIRTBUILDER_NAME="ubuntu_jammy_cloudimg_kvm"
readonly KVM_IMAGE_FORMAT="qcow2"

# export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1

readonly CODENAME="jammy"
#readonly CODENAME="{{ os_version }}"
# image file name
#readonly IMG_FR="${CODENAME:?}-server-cloudimg-amd64.img"
readonly IMG_FR="${CODENAME:?}-server-cloudimg-amd64-disk-kvm.img"

# cloud image uri
readonly IMG_URI=https://cloud-images.ubuntu.com/${CODENAME:?}/current/${IMG_FR:?}

# absolute path to cloud image file
readonly IMG_FA="${KVM_IMAGE_DA:?}/${IMG_FR:?}"

# absolute path to virtbuilder file
readonly VB_FA="${KVM_IMAGE_DA:?}/${VIRTBUILDER_NAME:?}.${KVM_IMAGE_FORMAT:?}"

# does img file exist?
[[ -e "${IMG_FA:?}" ]] || {
  curl "${IMG_URI:?}" -o "${IMG_FA:?}"
}

# copy downloaded cloud img to qcow2
cp "${IMG_FA:?}" "${VB_FA:?}"

# bug in cloud image
# https://bugs.launchpad.net/cloud-images/+bug/1573095

#    --ssh-inject "root:file:$HOME/.ssh/id_rsa.pub" \
#    --copy-in build/01-netcfg.yaml:/etc/netplan \
#    --root-password "file:/home/hck/.ssh/base_image.password" \

# generates <name>-vb.qcow2
virt-customize \
    --format "${KVM_IMAGE_FORMAT:?}" \
    --no-network \
    --hostname "${VIRTBUILDER_NAME:?}" \
    --root-password "password:SECRET" \
    --copy-in ./01-netcfg.yaml:/etc/netplan \
    --run-command "sed -i 's/ console=ttyS0//g' /etc/default/grub.d/50-cloudimg-settings.cfg" \
    --run-command "sed -i 's/GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0 console=tty1\"/g' /etc/default/grub" \
    --run-command "update-grub" \
    --run-command "sed -i 's/ibm-p8-kvm-03-guest-02.virt.pnr.lab.eng.rdu2.redhat.com//g' /etc/hosts" \
    --run-command "systemctl mask apt-daily.service apt-daily-upgrade.service" \
    --firstboot-command "netplan generate && netplan apply" \
    --firstboot-command "dpkg-reconfigure openssh-server" \
    --firstboot-command "sync" \
    -a "${VB_FA:?}"

# See: https://github.com/dmacvicar/terraform-provider-libvirt/issues/357
sudo qemu-img resize ${VB_FA:?} 10G