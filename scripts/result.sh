#!/bin/bash
############################################################################
# Web:    https://multiply.network
# Source: https://github.com/Multiplity-in-Network/yiimp_install_raspberry
#
# ███╗   ███╗██╗   ██╗██╗  ████████╗██╗██████╗ ██╗     ██╗████████╗██╗   ██╗
# ████╗ ████║██║   ██║██║  ╚══██╔══╝██║██╔══██╗██║     ██║╚══██╔══╝╚██╗ ██╔╝
# ██╔████╔██║██║   ██║██║     ██║   ██║██████╔╝██║     ██║   ██║    ╚████╔╝
# ██║╚██╔╝██║██║   ██║██║     ██║   ██║██╔═══╝ ██║     ██║   ██║     ╚██╔╝
# ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║██║     ███████╗██║   ██║      ██║
# ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚══════╝╚═╝   ╚═╝      ╚═╝
#
#                            ██╗███╗   ██╗
#                            ██║████╗  ██║
#                            ██║██╔██╗ ██║
#                            ██║██║╚██╗██║
#                            ██║██║ ╚████║
#                            ╚═╝╚═╝  ╚═══╝
#
#      ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
#      ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
#      ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
#      ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗
#      ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
#      ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
#
############################################################################

echo
echo
echo
echo -e "$GREEN***************************$COL_RESET"
echo -e "$GREEN YiimP Install Raspberry v1.0 $COL_RESET"
echo -e "$GREEN Finish !!! $COL_RESET"
echo -e "$GREEN***************************$COL_RESET"
echo
echo
echo
echo -e "$CYAN Whew that was fun, just some reminders. $COL_RESET"
echo -e "$RED Your mysql information is saved in ~/.my.cnf. $COL_RESET"
echo
echo -e "$RED Yiimp at : http://"$SERVER_NAME" (https... if SSL enabled)"
echo -e "$RED Yiimp Admin at : http://"$SERVER_NAME"/site/AdminPanel (https... if SSL enabled)"
echo -e "$RED Yiimp phpMyAdmin at : http://"$SERVER_NAME"/phpmyadmin (https... if SSL enabled)"
echo
echo -e "$RED If you want change 'AdminPanel' to access Panel Admin : Edit this file : /var/web/yaamp/modules/site/SiteController.php"
echo -e "$RED Line 11 => change 'AdminPanel' and use the new address"
echo
echo -e "$CYAN Please make sure to change your public keys / wallet addresses in the /var/web/serverconfig.php file. $COL_RESET"
echo -e "$CYAN Please make sure to change your private keys in the /etc/yiimp/keys.php file. $COL_RESET"
echo
echo -e "$CYAN TUTO Youtube : https://www.youtube.com/watch?v=qE0rhfJ1g2k $COL_RESET"
echo -e "$CYAN Xavatar WebSite : https://www.xavatar.com $COL_RESET"
echo
echo
echo -e "$RED***************************************************$COL_RESET"
echo -e "$RED YOU MUST REBOOT NOW  TO FINALIZE INSTALLATION !!! $COL_RESET"
echo -e "$RED***************************************************$COL_RESET"
echo
echo
