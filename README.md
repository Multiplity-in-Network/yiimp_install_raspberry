# yiimp_install_raspberry

Site : http://multiply.network

Discord : https://discord.gg/7GdfjBxd

Official Yiimp (used in this script for Yiimp Installation): https://github.com/tpruvot/yiimp

Original Yiimp Installer : https://github.com/xavatar/yiimp_install_scrypt

TUTO Youtube (16.04 / 18.04 - Without SSL) : https://www.youtube.com/watch?v=qE0rhfJ1g2k

***********************************

###### This script has an interactive beginning and will ask for the following information :

- Server Name (no http:// or www !!!!! Example : crypto.com OR pool.crypto.com OR 80.41.52.63)
- Are you using a subdomain (mypoolx11.crypto.com)
- Enter support email
- Set stratum to AutoExchange
- Your Public IP for admin access (Put your PERSONNAL IP, NOT IP of your VPS)
- Install Fail2ban
- Install UFW and configure ports
- Install LetsEncrypt SSL

***********************************

## Install script for yiimp on Ubuntu Server 20.04 on Raspberry Pi 4

1- USE THIS SCRIPT ON FRESH INSTALL UBUNTU Server 20.04 !

2- Run this script with a user other than root, if you only have the root user you can create one with the following
lines (pool it's just an example...)

```bash
sudo adduser pool
sudo adduser pool sudo
su - pool
exit 
su - pool
```

3- Make sure you have git installed and download this script

```bash
sudo apt -y install git
git clone https://github.com/Multiplity-in-Network/yiimp_install_raspberry.git
cd yiimp_install_raspberry/
```

4- DO NOT RUN THE NEXT SCRIPT AS ROOT or SUDO

```bash
bash install.sh
```

- At the end, you MUST REBOOT to finalize installation...

Finish !

- Go http://xxx.xxx.xxx.xxx or https://xxx.xxx.xxx.xxx (if you have chosen LetsEncrypt SSL). Enjoy !
- Go http://xxx.xxx.xxx.xxx/site/myadmin or https://xxx.xxx.xxx.xxx/site/myadmin to access Panel Admin

If you are issue after installation (nginx,mariadb... not found), use this script : bash install-debug.sh (watch the log
during installation)

###### :bangbang: **YOU MUST UPDATE THE FOLLOWING FILES :**

- **/var/web/serverconfig.php :** update this file to include your public ip (line = YAAMP_ADMIN_IP) to access the admin
  panel (Put your PERSONNAL IP, NOT IP of your VPS). update with public keys from exchanges. update with other
  information specific to your server..
- **/etc/yiimp/keys.php :** update with secrect keys from the exchanges (not mandatory)
- **If you want change 'AdminPanel' to access Panel Admin :** Edit this file "
  /var/web/yaamp/modules/site/SiteController.php" and Line 11 => change 'AdminPanel'

###### :bangbang: **IMPORTANT** :

- The configuration of yiimp and coin require a minimum of knowledge in linux
- Your mysql information (login/Password) is saved in **~/.my.cnf**

***********************************


**This install script will get you 95% ready to go with yiimp. There are a few things you need to do after the main
install is finished.**

While I did add some server security to the script, it is every server owners responsibility to fully secure their own
servers. After the installation you will still need to customize your serverconfig.php file to your liking, add your API
keys, and build/add your coins to the control panel.

There will be several wallets already in yiimp. These have nothing to do with the installation script and are from the
database import from the yiimp github.

If you need further assistance we have a small but growing discord channel at https://discord.gg/7GdfjBxd

If this helped you or you feel giving please **DONATE** :

- BTC : bc1qpkqml0yaqt95ygypasn778ua6f9gxnhl2eterz
- BCH : qpkvqcwkv4g284rvheqxuj30e9d2h8mpyst88sk7pk
- ETH : 0xF2e337b1c4d27B3A26Aff68ec5189aCe37abc95f : (Ethereum, BSC, Matic, Heco)
- TRX : TATGXTdbZLA7sauco5VBaY3tpL361FP6Cr
