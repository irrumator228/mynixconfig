#!/bin/sh
for PKG_NAME in slstatus st dwm dmenu
do
	cd /home/talp/$PKG_NAME/
	git diff HEAD > /home/talp/$PKG_NAME.diff
	mv /home/talp/$PKG_NAME.diff /etc/nixos/patches/$PKG_NAME.diff
done
nixos-rebuild switch
