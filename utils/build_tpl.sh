#!/bin/bash

imageURL=https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
imageName="jammy-server-cloudimg-amd64.img"
volumeName="local-zfs"
virtualMachineId="9000"
templateName="jammy-tpl"
tmp_cores="2"
tmp_memory="2048"
rootPasswd="Letmein123"
cpuTypeRequired="kvm64"

apt update
apt install libguestfs-tools -y
rm *.img
wget -O $imageName $imageURL
qm destroy $virtualMachineId
virt-customize -a $imageName --install qemu-guest-agent
virt-customize -a $imageName --root-password password:$rootPasswd
qm create $virtualMachineId --name $templateName --memory $tmp_memory --cores $tmp_cores --net0 virtio,bridge=vmbr0 --scsi0 
qm importdisk $virtualMachineId $imageName $volumeName
qm set $virtualMachineId --scsihw virtio-scsi-pci --virtio0 $volumeName:vm-$virtualMachineId-disk-0
qm set $virtualMachineId --boot c --bootdisk virtio0
qm set $virtualMachineId --ide2 $volumeName:cloudinit
qm set $virtualMachineId --serial0 socket --vga serial0
qm set $virtualMachineId --ipconfig0 ip=dhcp
qm set $virtualMachineId --cpu cputype=$cpuTypeRequired
qm template $virtualMachineId