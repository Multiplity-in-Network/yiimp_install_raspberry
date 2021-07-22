#!/bin/bash
################################################################################
# Web:    http://multiply.network
# Source: https://github.com/Multiplity-in-Network/yiimp_install_raspberry
# Original Author: crombiecrunch
# Modified by Xavatar
# Modified by Multiplity in Network
#
# Program:
#   Install yiimp on Ubuntu 20.04 running Nginx, MariaDB, and php7.4
#   v0.3 (update Julio, 2021)
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
################################################################################

output() {
  printf "\E[0;33;40m"
  echo $1
  printf "\E[0m"ku
}

displayErr() {
  echo
  echo $1
  echo
  exit 1
}

#Add user group sudo + no password
whoami=$(whoami)
sudo usermod -aG sudo ${whoami}
YIIMP_INSTALL_PATH=$(pwd)
echo '# yiimp
    # It needs passwordless sudo functionality.
    '""''"${whoami}"''""' ALL=(ALL) NOPASSWD:ALL
    ' | sudo -E tee /etc/sudoers.d/${whoami} >/dev/null 2>&1

#Copy needed files
sudo cp ./conf/functions.sh /etc/
sudo cp ./conf/editconf.py /usr/bin/
sudo cp ./utils/screen-scrypt.sh /etc/
sudo chmod +x /usr/bin/editconf.py
sudo chmod +x /etc/screen-scrypt.sh

clear
source /etc/functions.sh
source ./scripts/brand.sh

echo
echo -e "$GREEN************************************************************************$COL_RESET"
echo -e "$GREEN YiimP Install Raspberry v1.0$COL_RESET$CYAN by Multiplity in Network   $COL_RESET"
echo -e "$GREEN Install yiimp on Ubuntu 20.04 running Nginx, MariaDB, and php7.4       $COL_RESET"
echo -e "$GREEN************************************************************************$COL_RESET"
echo
sleep 3

# Update package and Upgrade Ubuntu
source ./scripts/update.sh

# Check prerequisites
source ./scripts/prerequisites.sh

# Get ip values
source ./scripts/getip.sh

# Enter values
source ./scripts/values.sh

# Installing Nginx, Mariadb, PHP
source ./scripts/servers.sh

# Installing other needed files
source ./scripts/extras.sh

# Installing Package to compile crypto currency
source ./scripts/crypto.sh

# Generating Random Passwords
source ./scripts/password.sh

# Test Email
source ./scripts/email.sh

# Installing Fail2Ban & UFW
source ./scripts/fail2ban.sh

# Installing PhpMyAdmin
source ./scripts/phpmyadmin.sh

# Installing Yiimp
source ./scripts/yiimp.sh

# Update Timezone
source ./scripts/timezone.sh

# Config Database
source ./scripts/conf_database.sh

# Config Server
source ./scripts/conf_server.sh

# Load Database
source ./scripts/load_database.sh

# Final Directory permissions
source ./scripts/files.sh

# Restart all services
source ./scripts/services.sh

# Show resume
source ./scripts/result.sh
