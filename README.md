# DCOS
This is Just Another Arch linux Automated Installation Script For the people that don't want to bother installing Arch from scratch in terminal.
The script will be usefull specifically for installing Arch and configuring for pentesting including BlackArch tools and a lightweight desktop environment such as MATE or XFCE4.
I will add one another option to use openbox as the window manager also for those who want their system to use the least amount of RAM while ideal.

Installation Steps:

## Create Arch ISO or Use Image

Download ArchISO from <https://archlinux.org/download/> and put on a USB drive with [Etcher](https://www.balena.io/etcher/), [Ventoy](https://www.ventoy.net/en/index.html), or [Rufus](https://rufus.ie/en/)

## Boot Arch ISO

From initial Prompt type the following commands:

```
pacman -Sy git
git clone https://github.com/dhaval9911/dcos.git
cd dcos
./dcos.sh
```
