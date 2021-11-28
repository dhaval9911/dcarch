#!/bin/bash
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


PKGS=(
'autojump'
'alacritty'
'awesome-terminal-fonts'
'dxvk-bin' # DXVK DirectX to Vulcan
'lightly-git'
'lightlyshaders-git'
'multicolor-sddm-theme'
'nerd-fonts-fira-code'
'nordic-darker-standard-buttons-theme'
'nordic-darker-theme'
'nordic-kde-git'
'nerd-fonts-jetbrains-mono'
'nordic-theme'
'nerd-fonts-ubuntu-mono'
'noto-fonts-emoji'
'papirus-icon-theme'
'ocs-url' # install packages from websites
'sddm-nordic-theme-git'
'ttf-droid'
'ttf-hack'
'ttf-meslo' # Nerdfont package
'ttf-roboto'
)



export PATH=$PATH:~/.local/bin
cp -r $HOME/dcos/dotfiles/* $HOME/.config/
cp -r $HOME/dcos/.zshrc $HOME/
cp -r $HOME/dcos/dotfiles/* $HOME/.config/




#installing desktop environment

function desktop() {
    ADVSEL=$(whiptail --title "Choose Your Desktop Environment To Install" --fb --menu "Choose an option" 15 60 4 \
        "1" "xfce4" \
        "2" "Mate" 3>&1 1>&2 2>&3)
    case $ADVSEL in
        1)
            echo "xfce4"
            pacman -S xfce4 xfce4-goodies --needed --noconfirm
        ;;
        2)
            echo "Mate"
            pacman -S mate mate-extra
            dconf load / < mate-backup
        ;;
    esac
}
desktop


echo -e "\nDone!\n"
exit


