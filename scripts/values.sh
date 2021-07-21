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

echo 'PUBLIC_IP='"${PUBLIC_IP}"'
    PUBLIC_IPV4='"${PUBLIC_IPV4}"'
    PUBLIC_IPV6='"${PUBLIC_IPV6}"'
    PRIVATE_IP='"${PRIVATE_IP}"'
    DISTRO='"${DISTRO}"'
    ' | sudo -E tee conf/pool.conf >/dev/null 2>&1

echo
echo
echo -e "$RED Make sure you double check before hitting enter! Only one shot at these! $COL_RESET"
echo
read -e -p "Enter time zone (e.g. America/New_York) : " TIME
echo -e "$CYAN $TIME $COL_RESET"
read -e -p "Domain Name (no http:// or www. just : example.com or pool.example.com or ${PRIVATE_IP}) : " SERVER_NAME
echo -e "$CYAN $PRIVATE_IP $COL_RESET"
read -e -p "Are you using a subdomain (mycryptopool.example.com?) [y/N] : " SUB_DOMAIN
echo -e "$CYAN $SUB_DOMAIN $COL_RESET"
read -e -p "Enter support email (e.g. admin@example.com) : " EMAIL
echo -e "$CYAN $EMAIL $COL_RESET"
read -e -p "Set Pool to AutoExchange? i.e. mine any coin with BTC address? [y/N] : " BTC
echo -e "$CYAN $BTC $COL_RESET"
read -e -p "Please enter a new location for /site/adminRights this is to customize the Admin Panel entrance url (e.g. myAdminpanel) : " ADMIN_PANEL
echo -e "$CYAN $ADMIN_PANEL $COL_RESET"
read -e -p "Enter the Public IP of the system you will use to access the admin panel, check http://www.whatsmyip.org/ ($PUBLIC_IP) : " PUBLIC
echo -e "$CYAN $PUBLIC $COL_RESET"
read -e -p "Install Fail2ban? [Y/n] : " INSTALL_FAIL2BAN
echo -e "$CYAN $INSTALL_FAIL2BAN $COL_RESET"
read -e -p "Install UFW and configure ports? [Y/n] : " UFW
echo -e "$CYAN $UFW $COL_RESET"
read -e -p "Install LetsEncrypt SSL? IMPORTANT! You MUST have your domain name pointed to this server prior to running the script!! [Y/n]: " SSL_INSTALL
echo -e "$CYAN $SSL_INSTALL $COL_RESET"
