#!/bin/bash

## OpenMediaVault - ASUS Tinkerboard ARMBIAN Stretch ##
## Doni Kuswaryadi - MIZUTECH ##

# OMV Repository
cat <<EOF >> /etc/apt/sources.list.d/openmediavault.list
deb https://packages.openmediavault.org/public arrakis main
deb https://downloads.sourceforge.net/project/openmediavault/packages arrakis main
## Uncomment the following line to add software from the proposed repository.
deb https://packages.openmediavault.org/public arrakis-proposed main
deb https://downloads.sourceforge.net/project/openmediavault/packages arrakis-proposed main
## This software is not part of OpenMediaVault, but is offered by third-party
## developers as a service to OpenMediaVault users.
deb https://packages.openmediavault.org/public arrakis partner
deb https://downloads.sourceforge.net/project/openmediavault/packages arrakis partner
EOF

# Installation of OMV
export LANG=C
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
wget -O - packages.openmediavault.org/public/archive.key | apt-key add
apt-get update
apt-get --allow-unauthenticated install openmediavault-keyring
apt-get update
apt-get --yes --auto-remove --show-upgraded \
    --allow-downgrades --allow-change-held-packages \
    --no-install-recommends \
    --option Dpkg::Options::="--force-confdef" \
    --option DPkg::Options::="--force-confold" \
    install postfix openmediavault
omv-initsystem

# Fixing some Issues
sed -i 's/def remove(wr, selfref=ref(self))/def remove(wr, selfref=ref(self), _atomic_removal=_remove_dead_weakref)/g' /usr/lib/python3.5/weakref.py
sed -i 's/_remove_dead_weakref(d, wr.key)/_atomic_removal(d, wr.key)/g' /usr/lib/python3.5/weakref.py

# Installing OMV-Extra Plugins
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master/install | bash

