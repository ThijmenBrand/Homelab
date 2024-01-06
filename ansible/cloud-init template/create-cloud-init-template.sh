#!/bin/bash

imageSource=$1
templateId=$2
templateName=$3

if [ -z "$imageSource" ] | [ -z "$templateId"] | [ -z "$templateId"]; then
    echo "please fill in package source and template id"
    exit 1
fi

imageName="tmp-template"

wget -O $imageName $imageSource

virt-customize --install qemu-guest-agent -a $imageName

qm create $templateId --name $templateName --memory 2048 --net0 virtio,bridge=vmbr0
qm importdisk $templateId $imageName local-zfs

qm set $templateId --scsihw virtio-scsi-pci --scsi0 local-lzf:vm-$templateId-disk-0
qm set $templateId --ide2 local-zfs:cloudinit

qm set $templateId --boot c --bootdisk scsi0
qm set $templateId --serial0 socket --vga serial0

qm resize $templateId scsi0 32G
qm template $templateId
rm $imageName
