#!/bin/bash
#### Description: Install Plymouth boot screen on Debian 6 / 7 / 8
#### Written by: Josh Smith  on September 16, 2016
#### More about Plymouth: https://www.freedesktop.org/wiki/Software/Plymouth/
#### Note: Read the entire script prior to running as there are some 
####		hardware config options.
#### 	   Double-check target monitor size and change if necessary: GRUB_GFXMODE=1024x768×32
####	   Change all instances of apt-get to aptitude if you use aptitude instead of apt.

#### Thanks go to:
#### https://miguelmenendez.pro/en/articles/install-plymouth-debian-graphical-boot-animation-while-boot-shutdown.html

#### License:
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Keep Debian up-to-date
echo "***UPDATING/UPGRADING APT***"
sudo apt-get update && sudo apt-get upgrade


# Install depencencies
echo "***INSTALLING Plymouth***"
sudo apt-get install plymouth plymouth-drm

#Uncomment if lack of firmware error occurs & you wish to install non-free firmware
#sudo apt-get install firmware-linux-nonfree

echo "***Creating Backup***"
cd /etc/initramfs-tools/modules
sudo cp modules modules.bak



while true; do
    read -p "Which video card do you have? (I)ntel / (n)Vidia / (A)TI / (D)on't know `echo $'\n> '`" InAD

    case $InAD in
        [Ii]* ) echo "***You chose Intel***"
		sudo cat <<EOF >> modules
# KMS
  intel_agp
  drm
  i915 modeset=1
EOF
		break;;
        [Nn]* ) echo "***You chose nVidia***"; 
		sudo cat <<EOF >> modules
# KMS
  drm
  nouveau modeset=1
EOF
		break;;
        [Aa]* ) echo "***You chose ATI***";
		sudo cat <<EOF >> modules
# KMS
  drm
  radeon modeset=1
EOF
		break;;
        [Dd]* ) echo "***Verify your video card before proceeding***"; exit;;
        * ) echo "Please answer Intel, nVidia, ATI, or Don't know.";;
    esac
done

while true; do
    read -p "(D)esktop: 1024x768 or (N)etbook: 1024x576 ? `echo $'\n> '`" DN

    case $DN in
        [Dd]* ) echo "***Configuring for desktop***"
		sudo sed -i -e 's/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1024x768x32/g' /etc/default/grub
		sudo sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
		break;;
        [Nn]* ) echo "***Configuring for netbook***";
		sudo sed -i -e 's/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1024x576x32/g' /etc/default/grub
		sudo sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
		break;;
        * ) echo "Please answer Desktop or Netbook.";;
    esac
done

#sudo update-grub2

echo "***Plymouth Themes***"
#/usr/sbin/plymouth-set-default-theme --list
echo "(d)etails
(f)adein
(g)low
(j)oy
(l)ines
s(c)ript
s(o)lar
sp(a)cefun
sp(i)nfinity
spi(n)ner
t(e)xt
t(r)ibar"

while true; do
    read -p "Enter a theme from the list. `echo $'\n> '`" dfgjlcoainer

    case $dfgjlcoainer in
        [Dd]* ) echo "***You chose details***"
		sudo /usr/sbin/plymouth-set-default-theme details
		break;;
        [Ff]* ) echo "***You chose fadein***"; 
		sudo /usr/sbin/plymouth-set-default-theme fade-in
		break;;
        [Gg]* ) echo "***You chose glow***"; 
		sudo /usr/sbin/plymouth-set-default-theme glow
		break;;
        [Jj]* ) echo "***You chose joy***"; 
		sudo /usr/sbin/plymouth-set-default-theme joy
		break;;
        [Ll]* ) echo "***You chose lines***"; 
		sudo /usr/sbin/plymouth-set-default-theme lines
		break;;
        [Cc]* ) echo "***You chose script***"; 
		sudo /usr/sbin/plymouth-set-default-theme script
		break;;
        [Oo]* ) echo "***You chose solar***"; 
		sudo /usr/sbin/plymouth-set-default-theme solar
		break;;
        [Aa]* ) echo "***You chose spacefun***"; 
		sudo /usr/sbin/plymouth-set-default-theme spacefun
		break;;
        [Ii]* ) echo "***You chose spinfinity***"; 
		/usr/sbin/plymouth-set-default-theme spinfinity
		break;;
        [Nn]* ) echo "***You chose spinner***"; 
		sudo /usr/sbin/plymouth-set-default-theme spinner
		break;;
        [Ee]* ) echo "***You chose text***"; 
		sudo /usr/sbin/plymouth-set-default-theme text
		break;;
        [Rr]* ) echo "***You chose tribar***"; 
		sudo /usr/sbin/plymouth-set-default-theme tribar
		break;;
        * ) echo "Please select a Plymouth Theme.";;
    esac
done

sudo update-initramfs -u

echo "Congratulations! Plymouth will be effective upon restart."








