#####################################################
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
#####################################################

# Installing Yiimp
echo
echo
echo -e "$CYAN => Installing Yiimp $COL_RESET"
echo
echo -e "Grabbing yiimp fron Github, building files and setting file structure."
echo
sleep 3


# Generating Random Password for stratum
blckntifypass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

# Compil Blocknotify
cd ~
git clone https://github.com/Kudaraidee/yiimp.git
cd $HOME/yiimp/blocknotify
sudo sed -i 's/tu8tu5/'$blckntifypass'/' blocknotify.cpp
make -j$((`nproc`+1))

# Compil Stratum
cd $HOME/yiimp/stratum/
git submodule init && git submodule update
make -C algos
make -C sha3
make -C iniparser
cd secp256k1 && chmod +x autogen.sh && ./autogen.sh && ./configure --enable-experimental --enable-module-ecdh --with-bignum=no --enable-endomorphism && make
cd $HOME/yiimp/stratum/
if [[ ("$BTC" == "y" || "$BTC" == "Y") ]]; then
sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $HOME/yiimp/stratum/Makefile
fi
make -j$((`nproc`+1))

# Copy Files (Blocknotify,iniparser,Stratum)
cd $HOME/yiimp
sudo sed -i 's/AdminRights/'AdminPanel'/' $HOME/yiimp/web/yaamp/modules/site/SiteController.php
sudo cp -r $HOME/yiimp/web /var/
sudo mkdir -p /var/stratum
cd $HOME/yiimp/stratum
sudo cp -a config.sample/. /var/stratum/config
sudo cp -r stratum /var/stratum
sudo cp -r run.sh /var/stratum
cd $HOME/yiimp
sudo cp -r $HOME/yiimp/bin/. /bin/
sudo cp -r $HOME/yiimp/blocknotify/blocknotify /usr/bin/
sudo cp -r $HOME/yiimp/blocknotify/blocknotify /var/stratum/
sudo mkdir -p /etc/yiimp
sudo mkdir -p /$HOME/backup/
#fixing yiimp
sudo sed -i "s|ROOTDIR=/data/yiimp|ROOTDIR=/var|g" /bin/yiimp
#fixing run.sh
sudo rm -r /var/stratum/config/run.sh
echo '
#!/bin/bash
ulimit -n 10240
ulimit -u 10240
cd /var/stratum
while true; do
./stratum /var/stratum/config/$1
sleep 2
done
exec bash
' | sudo -E tee /var/stratum/config/run.sh >/dev/null 2>&1
sudo chmod +x /var/stratum/config/run.sh

echo -e "$GREEN Done...$COL_RESET"
