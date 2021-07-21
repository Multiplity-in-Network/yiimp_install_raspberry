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

# Final Directory permissions
echo
echo
echo -e "$CYAN => Final Directory permissions $COL_RESET"
echo
sleep 3

whoami=$(whoami)
sudo usermod -aG www-data $whoami
sudo usermod -a -G www-data $whoami

sudo find /var/web -type d -exec chmod 775 {} +
sudo find /var/web -type f -exec chmod 664 {} +
sudo chgrp www-data /var/web -R
sudo chmod g+w /var/web -R

sudo mkdir /var/log/yiimp
sudo touch /var/log/yiimp/debug.log
sudo chgrp www-data /var/log/yiimp -R
sudo chmod 775 /var/log/yiimp -R

sudo chgrp www-data /var/stratum -R
sudo chmod 775 /var/stratum

sudo mkdir -p /var/yiimp/sauv
sudo chgrp www-data /var/yiimp -R
sudo chmod 775 /var/yiimp -R

#Add to contrab screen-scrypt
(
  crontab -l 2>/dev/null
  echo "@reboot sleep 20 && /etc/screen-scrypt.sh"
) | crontab -

#fix error screen main "service"
sudo sed -i 's/service $webserver start/sudo service $webserver start/g' /var/web/yaamp/modules/thread/CronjobController.php
sudo sed -i 's/service nginx stop/sudo service nginx stop/g' /var/web/yaamp/modules/thread/CronjobController.php

#fix error screen main "backup sql frontend"
sudo sed -i "s|/root/backup|/var/yiimp/sauv|g" /var/web/yaamp/core/backend/system.php
sudo sed -i '14d' /var/web/yaamp/defaultconfig.php

#Misc
sudo mv $HOME/yiimp/ $HOME/yiimp-install-only-do-not-run-commands-from-this-folder
sudo rm -rf /var/log/nginx/*