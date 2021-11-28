#!/bin/bash

   bash setup-0.sh
   arch-chroot /mnt /root/dcos/setup-1.sh
   arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/dcos/setup-2.sh
#    arch-chroot /mnt /root/ArchTitus/3-post-setup.sh
