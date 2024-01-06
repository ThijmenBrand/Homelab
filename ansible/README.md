# Ansible

## Introduction

In this folder are the ansible related things stored. Like docker-compose file of ansible semaphore and the playbooks I use.

## Playbooks

### Deploy-\*-cloud-vm

In order to deploy a vm using ansible, I have done a few things. First I have created a user in proxmox to be able to access the hyperviser.

1. create user: Datacenter > Permissions > Users > Add
2. give him a name, select "Linux PAM standard authentication" and click Add
3. create an API token for the user API Tokens > Add
4. Select the just created used enter an token ID and de-select the "Privilege Seperation" tickbox
5. Note down the Secret because it is only shown once
6. Give the API token the right permissions: Permissions > Add > API Token Permission
7. path: /, API Token: the token just created, Role: Administrator > Add
8. path: /storage/local-zfs, API Token: the token just created, Role: Administrator > Add

Now we have the needed user to perform our scripts

Then I have created an cloud init template using the following steps
_source: [BoringTech - Create proxmox cloud-init template](https://boringtech.net/blog/create-proxmox-cloud-init-templates/)_

```shell
wget <image source>

```

```shell
apt update
apt install -y libguestfs-tools
virt-customize --install qemu-guest-agent -a <image-name>
```

```shell
qm create 9000 --name <template name> --memory 1024 --net0 virtio,bridge=vmbr0
qm importdisk 9000 <image-name> local-zfs

qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lzf:vm-9000-disk-0
qm set 9000 --ide2 local-zfs:cloudinit

qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0

qm resize 9000 scsi0 32G
qm template 9000
rm <image-name>
```

a bash shell file can be found in [cloud-init template]("cloud-init template/create-cloud-init-template.sh")
hmm
