#!/bin/bash

#####################################################
# Option Based Script to Pick what OS to install on #
#####################################################

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Docker Installation"
TITLE="Chose your Operating System"
MENU="Choose one of the following options:"

OPTIONS=(1 "Alpine Linux"
         2 "Debian"
         3 "CentOS"
         4 "macOS" 
         5 "openSUSE")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            sh ./Alpine/alpine-docker.sh
            ;;
        2)
           sh ./Debian/debian-docker.sh
            ;;
        3)
            sh ./CentOS/centos-docker.sh
            ;;
        4)
            sh ./macOS/macos-docker.sh
            ;;
        5)
            sh ./openSUSE/opensuse-docker.sh
            ;;
esac