<!--
    MIT License

    Copyright (c) 2018 Rémi Ducceschi

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE
-->

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/remileduc/debian_config_perso/blob/master/LICENSE)

Debian config
=============

Files for my personal debian config, so I don't have to recreate them each time...

### Table of contents

[Installation](#installation)

[Copy config files](#copy-config-files)

[Home encryption](#home-encryption)
- [Create keyfile](#create-keyfile)
- [Add the keyfile as a key](#add-the-keyfile-as-a-key)
- [Change crypttab](#change-crypttab)
- [Key slots management](#key-slots-management)

[OpenDNS](#opendns)

[Samba](#samba)

Installation
------------

Partitions:
- efi = 100 Mio (unused) with boot flag, FAT32
- /boot = 400 Mio
- / = 50 Gio, ENCRYPTED
- /mount/persistent = size of RAM, ENCRYPTED, `defaults,nodev,noexec,nosuid,noatime,nodiratime`
- /home = everything else, ENCRYPTED
- no swap

Copy config files
-----------------

Copy all the files to their destination. Some files are hidden...

To update Grub, you'll need to run `update-grub`.

Home encryption
---------------

Follow instructions here (listed below): https://debian-facile.org/viewtopic.php?id=9101

Everything should be run in root.

### Create keyfile

This keyfile holds the keypass to open the home partition

```bash
dd if=/dev/random of=/root/sda4_keyfile bs=4096 count=1
chmod a-rwx,u=r /root/sda4_keyfile
```

### Add the keyfile as a key

We add the generated keyfile as a key to open Home. Here, the UUID used is the UUID of the Home partition (/dev/sda4), not the encrypted partition (/dev/mapper/sda4_crypt). Use `blkid` to fetch the UUID.

```bash
cryptsetup luksAddKey /dev/disk/by-uuid/c4295a74-5c31-475b-aa57-b9fa4c2de36e /root/sda4_keyfile
```

### Change crypttab

We tell to the file `/etc/crypttab` to automatically fetch the keyfile (same rules as earlier for the UUID):

```bash
sda4_crypt UUID=c4295a74-5c31-475b-aa57-b9fa4c2de36e /root/sda4_keyfile luks,discard
```

Then, reboot and pray...

### Key slots management

Add key
```bash
cryptsetup luksAddKey /dev/sdb1 /root/file # use file as a key
cryptsetup luksAddKey /dev/sdb1 # will ask for a passphrase
```

Delete key
```bash
cryptsetup luksKillSlot /dev/sdb1 2 # 2 is the key slot to remove
```

Change key
```bash
cryptsetup luksChangeKey /dev/sdb1 -S 2 # 2 is the key slot to remove
```

Show infos
```bash
cryptsetup luksDump /dev/sdb1
```

OpenDNS
-------

Edit the file `/etc/dhcp/dhclient.conf` and put the following lines:

```
prepend domain-name-servers 208.67.220.220,208.67.222.222;
prepend dhcp6.name-servers 2620:0:ccd::2,2620:0:ccc::2;
```

Samba
-----

Install the package `samba`.

Add the current user as a samba user:

```bash
smbpasswd -a sid
```

Create a shared folder and create some links (not root!)

```bash
cd ~
mkdir shared && cd shared
ln -s ../Documents Documents
ln -s ../Images Pictures
ln -s ../Musique Music
ln -s ../Vidéos/ Videos
```

Edit samba config file `/etc/samba/smb.conf`:

```
# In [global] section:
allow insecure wide links = yes

# At the end of the file, create a new section:
[shared]
follow symlinks = yes
wide links = yes
path = /home/sid/shared
available = yes
valid users = sid
read only = no
browsable = yes
public = yes
writable = yes
```

Restart the service `smbd` and connect to `\\IP\Share`.
