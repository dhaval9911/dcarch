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

# Add parallel downloading now to the system we installed 
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
'alacritty'
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
'curl'
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
'snapper'
'spectacle'
'sddm'
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
'xdg-user-dirs'
'zeroconf-ioslave'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

#
# determine processor type and install microcode
# 
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
echo "installing graphics drivers"
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

# pressanykey(){
# 	read -n1 -p "${txtpressanykey}"
# }
# 
# apptitle="--------- DCOS ----------"
# txtsethostname="Set Hostname For Your System"
# txtpressanykey="Press any key to continue."
# archsethostname(){
# 	hostname=$(whiptail --backtitle "${apptitle}" --title "${txtsethostname}" --inputbox "" 0 0 "dcos" 3>&1 1>&2 2>&3)
# 	if [ "$?" = "0" ]; then
# 		clear
# 		echo "echo \"${hostname}\" > /etc/hostname"
# 		echo "${hostname}" > /etc/hostname
# 		pressanykey
# 	fi
# }
# 
# archsethostname
# 
# txtusername="Create New User"
# enterpassword="Create Password"
# archusername(){
#   username=$(whiptail --backtitle "${apptitle}" --title "${txtusername}" --inputbox "" 0 0   3>&1 1>&2 2>&3)
#   if [ $(whoami) = "root" ]; then
#          clear
#          useradd -m -G wheel -s /bin/bash $username
#          whiptail --title "${apptitle}" --msgbox "Press Enter to Create Password" 8 45
#          passwd $username
# 	 cp -R /root/dcos /home/$username/
#          chown -R $username: /home/$username/dcos
#   else
# 	echo "You are already a user proceed with aur installs"
#   fi
# }
# 
# archusername 

echo -e "\nDone!\n"
if ! source install.conf; then
	read -p "Please enter username:" username
echo "username=$username" >> ${HOME}/ArchTitus/install.conf
fi
if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel,libvirt -s /bin/bash $username 
	passwd $username
	cp -R /root/ArchTitus /home/$username/
    chown -R $username: /home/$username/ArchTitus
	read -p "Please name your machine:" nameofmachine
	echo $nameofmachine > /etc/hostname
else
	echo "You are already a user proceed with aur installs"
fi


echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. 
# However I will leave this up to you.

echo "CLONING: YAY"
cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ${HOME}/yay
makepkg -si --noconfirm
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
touch "$HOME/.cache/zshhistory"
echo -e "\nDone!\n"
