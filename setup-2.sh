#!/bin/bash
pressanykey(){
	read -n1 -p "${txtpressanykey}"
}

txtpressanykey="Press any key to continue."
txtusername="Create New User"
archsethostname(){
	hostname=$(whiptail --backtitle "${apptitle}" --title "${txtsethostname}" --inputbox "" 0 0 "archlinux" 3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		echo "echo \"${hostname}\" > /etc/hostname"
		echo "${hostname}" > /etc/hostname
		pressanykey
	fi
}

archsethostname

archusername(){
  username=$(whiptail --backtitle "${apptitle}" --title "${txtusername}" --inputbox "" 0 0  "dcos" 3>&1 1>&2 2>&3)
  if [ $(whoami) = "root" ]; then
         clear
         useradd -m -G wheel,libvirt -s /bin/bash $username
         passwd $username
	 cp -R /root/dcos /home/$username/
         chown -R $username: /home/$username/dcos
  else
	echo "You are already a user proceed with aur installs"
  fi
}
