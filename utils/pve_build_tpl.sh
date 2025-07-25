#!/bin/bash

imageURL=https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
imageName="jammy-server-cloudimg-amd64.img"
volumeName="local-zfs"
vmid="9000"
templateName="jammy-tpl"
tmp_cores="2"
tmp_memory="2048"
rootPasswd="P@ssw0rd"
cpuTypeRequired="kvm64"

apt update && apt install libguestfs-tools -y
wget -O $imageName $imageURL
qm destroy $vmid
virt-customize -a $imageName --install qemu-guest-agent,openssh-server
virt-customize -a $imageName --run-command 'useradd -m k0ng -p "$rootPasswd"'
virt-customize -a $imageName --root-password password:$rootPasswd
qm create $vmid --name $templateName --memory $tmp_memory --cores $tmp_cores --net0 virtio,bridge=vmbr0
qm importdisk $vmid $imageName $volumeName
qm set $vmid --scsihw virtio-scsi-pci --virtio0 $volumeName:vm-$vmid-disk-0
qm set $vmid --boot c --bootdisk virtio0
qm set $vmid --ide2 $volumeName:cloudinit
qm set $vmid --serial0 socket --vga serial0
qm set $vmid --ipconfig0 ip=dhcp
qm set $vmid --cpu cputype=$cpuTypeRequired
qm template $vmid
rm -f $imageName