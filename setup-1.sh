#!/usr/bin/env bash

#-----------------------------------
# ██████╗  ██████╗ ██████╗ ███████╗
# ██╔══██╗██╔════╝██╔═══██╗██╔════╝
# ██║  ██║██║     ██║   ██║███████╗
# ██║  ██║██║     ██║   ██║╚════██║
# ██████╔╝╚██████╗╚██████╔╝███████║
# ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝
#-----------------------------------

echo "--------------------------------------"
echo "-----    Setting Up The Network  -----"
echo "--------------------------------------"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager
echo "-------------------------------------------------"
echo "---Setting up mirrorlist  for optimal download ----"
echo "-------------------------------------------------"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[  $TOTALMEM -gt 8000000 ]]; then
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf
fi


echo "-------------------------------------------------"
echo "  Setup Language to EN_India and set locale      "
echo "-------------------------------------------------"
sed -i 's/^#en_IN.UTF-8 UTF-8/en_IN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone  Asia/Kolkata        
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_IN.UTF-8" LC_TIME="en_IN.UTF-8"

# Set keymaps
localectl --no-ask-password set-keymap us

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

echo -e "\nInstalling Base System\n"

PKGS=(
'mesa' # Essential Xorg First
'xorg'
'xorg-server'
'xorg-apps'
'xorg-drivers'
'xorg-xkill'
'xorg-xinit'
'xterm'
'alsa-plugins' # audio plugins
'arc-gtk-theme'
'alsa-utils' # audio utils
'ark' # compression
'autoconf' # build
'automake' # build
'base'
'bash-completion'
'bind'
'binutils'
'bison'
'bluedevil'
'bluez'
'bluez-libs'
'bluez-utils'
'breeze'
'breeze-gtk'
'bridge-utils'
'btrfs-progs'
'celluloid' # video players
'cmatrix'
'cronie'
'cups'
'dialog'
'dosfstools'
'dtc'
'efibootmgr' # EFI boot
'exfat-utils'
'extra-cmake-modules'
'filelight'
'flex'
'fuse2'
'fuse3'
'fuseiso'
'gcc'
'git'
'gparted' # partition management
'gptfdisk'
'grub'
'grub-customizer'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
'gwenview'
'haveged'
'htop'
'iptables-nft'
'jdk-openjdk' # Java 17
'libdvdcss'
'layer-shell-qt'
'libtool'
'linux'
'linux-firmware'
'linux-headers'
'lsof'
'lzop'
'm4'
'make'
'nano'
'neofetch'
'networkmanager'
'ntfs-3g'
'ntp'
'openbsd-netcat'
'openssh'
'os-prober'
'p7zip'
'pacman-contrib'
'patch'
'picom'
'pkgconf'
'powerline-fonts'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'python-notify2'
'python-psutil'
'python-pyqt5'
'python-pip'
'rsync'
'sddm'
'sddm-kcm'
'snapper'
'spectacle'
'steam'
'sudo'
'swtpm'
'synergy'
'systemsettings'
'terminus-font'
'traceroute'
'ufw'
'unrar'
'unzip'
'usbutils'
'vim'
'wget'
'which'
'xdg-desktop-portal-kde'
'xdg-user-dirs'
'zeroconf-ioslave'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
)
