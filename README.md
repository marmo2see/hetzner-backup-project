# Hetzner Backup and Restoration Project

## Project Overview

This project demonstrates a method for creating a transferable backup image of a Hetzner Cloud Server and restoring it outside the Hetzner environment.

The primary restoration environment used in this project was a local VirtualBox Linux virtual machine.

The original server was running Ubuntu 24.04 with WordPress.

## Project Goal

The goal was to:

1. Create a downloadable image of the complete Hetzner server disk.
2. Transfer the image to a local computer.
3. Restore the image outside Hetzner.
4. Boot the restored system in VirtualBox.
5. Verify that the WordPress environment still works.

## Chosen Solution

We considered Hetzner Backups and Snapshots, dd, FSArchiver, tar, and specialized or commercial backup software.

We selected dd combined with gzip because it creates a complete image of the server disk.

The process was:

Hetzner Server
->
dd + gzip
->
Downloadable Disk Image
->
Local Computer
->
VirtualBox VDI
->
Restored Ubuntu Server
->
Apache + MySQL + WordPress

## Backup Procedure

The main system disk was identified as:

/dev/sda

The complete disk image was created using:

ssh -o IdentitiesOnly=no root@wordpress.multinomial.se "dd if=/dev/sda bs=64M status=progress | gzip -1" > ~/hetzner-backup/hetzner-sda.img.gz

The compressed image was then decompressed to obtain:

hetzner-sda.img

The raw image was inspected to verify that the original disk partition structure was preserved.

## VirtualBox Restoration

The raw image was converted to a VirtualBox VDI disk using VBoxManage.

The resulting disk was:

D:\hetzner-sda.vdi

A separate VirtualBox virtual machine named Hetzner Backup Test was created, and the VDI disk was attached to it.

## Troubleshooting

### SSH Authentication

The first SSH connection failed because the project SSH key was not loaded into the SSH agent.

The key was loaded into the agent and the connection then worked.

### Disk Space

The first VDI conversion attempt failed because the Windows C: drive did not have enough free storage.

The conversion was moved to the D: drive.

### Filesystem Errors

The restored Ubuntu system reported filesystem and journal consistency problems during boot.

The VM was started through GRUB recovery mode and the restored root filesystem was repaired with:

fsck -f /dev/sda1

After the repair, the filesystem was checked again and the VM was restarted.

## Verification

Apache was verified as active.

MySQL was verified as active.

The WordPress installation and wp-config.php were present.

The WordPress database was present, including its tables and data.

The restored local VM was tested using curl with the domain explicitly resolved to 127.0.0.1.

The restored server returned:

HTTP/1.1 200 OK

The WordPress page title was also verified as:

Website

## Result

The project successfully demonstrated that the Hetzner server could be represented as a transferable disk image, transferred to a local computer, converted for VirtualBox, and restored as a functioning Linux environment outside Hetzner.

## Possible Improvements

Future improvements could include:

- Automating the backup process.
- Automating backup integrity checks.
- Automating post-restore verification.
- Documenting required storage space before image conversion.
- Improving filesystem-consistency handling for images created from running systems.

## Technologies

- Hetzner Cloud
- Ubuntu 24.04
- SSH
- dd
- gzip
- fsck
- VirtualBox
- VBoxManage
- Apache
- MySQL
- WordPress
- Git
- GitHub
