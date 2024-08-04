To change default kernel on boot

The conf files are in /boot/loader/entries/

sudo bootctl set-default your-kernel.conf

Or to use the last kernel you selected on last boot

sudo bootctl set-default @saved
