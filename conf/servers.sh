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

# Installing Nginx
echo
echo
echo -e "$CYAN => Installing Nginx server : $COL_RESET"
echo
sleep 3

if [ -f /usr/sbin/apache2 ]; then
  echo -e "Removing apache..."
  sudo apt-get -y purge apache2 apache2-*
  sudo apt-get -y --purge autoremove
fi

sudo apt -y install nginx
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl start nginx.service
sudo systemctl enable nginx.service
sudo systemctl start cron.service
sudo systemctl enable cron.service
sleep 5
sudo systemctl status nginx | sed -n "1,3p"
sleep 15
echo
echo -e "$GREEN Done...$COL_RESET"


# Making Nginx a bit hard
echo 'map $http_user_agent $blockedagent {
default         0;
~*malicious     1;
~*bot           1;
~*backdoor      1;
~*crawler       1;
~*bandit        1;
}
' | sudo -E tee /etc/nginx/blockuseragents.rules >/dev/null 2>&1


# Installing Mariadb
echo
echo
echo -e "$CYAN => Installing Mariadb Server : $COL_RESET"
echo
sleep 3

# Create random password
rootpasswd=$(openssl rand -base64 12)
export DEBIAN_FRONTEND="noninteractive"
sudo apt -y install mariadb-server
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
sleep 5
sudo systemctl status mariadb | sed -n "1,3p"
sleep 15
echo
echo -e "$GREEN Done...$COL_RESET"


# Installing Installing php7.4
echo
echo
echo -e "$CYAN => Installing php7.4 : $COL_RESET"
echo
sleep 3

if [ ! -f /etc/apt/sources.list.d/ondrej-php-bionic.list ]; then
  sudo add-apt-repository -y ppa:ondrej/php
fi

sudo apt -y update

sudo apt -y install php7.4-fpm php7.4-opcache php7.4 php7.4-common php7.4-gd php7.4-mysql php7.4-imap php7.4-cli \
php7.4-cgi php7.4-curl php7.4-intl php7.4-zip php7.4-mbstring  mcrypt php7.4-sqlite3 php7.4-tidy php7.4-xmlrpc \
php7.4-xsl php7.4-dev php7.4-pspell php7.4-memcache php7.4-memcached memcached php-imagick imagemagick php-pear \
libpsl-dev libnghttp2-dev libmagickwand-dev libmcrypt-dev gcc make autoconf libc-dev pkg-config librecode-dev libruby
# php-gettext

sudo pecl channel-update pecl.php.net
printf "\n" | sudo pecl install mcrypt
printf "\n" | sudo pecl install imagick

wget https://github.com/php/pecl-text-recode/archive/master.zip -O recode.zip
unzip recode.zip
cd pecl-text-recode-master
phpize
sudo ./configure
sudo make
sudo make install
cd ../

sudo bash -c "echo extension=mcrypt.so > /etc/php/7.4/mods-available/mcrypt.ini"
sudo bash -c "echo extension=imagick.so > /etc/php/7.4/mods-available/imagick.ini"
sudo bash -c "echo extension=recode.so > /etc/php/7.4/mods-available/recode.ini"
sudo ln -s /etc/php/7.4/mods-available/mcrypt.ini /etc/php/7.4/fpm/conf.d/20-mcrypt.ini
sudo ln -s /etc/php/7.4/mods-available/imagick.ini /etc/php/7.4/fpm/conf.d/20-imagick.ini
sudo ln -s /etc/php/7.4/mods-available/recode.ini /etc/php/7.4/fpm/conf.d/20-recode.ini
sudo ln -s /etc/php/7.4/mods-available/mcrypt.ini /etc/php/7.4/cli/conf.d/20-mcrypt.ini
sudo ln -s /etc/php/7.4/mods-available/imagick.ini /etc/php/7.4/cli/conf.d/20-imagick.ini
sudo ln -s /etc/php/7.4/mods-available/recode.ini /etc/php/7.4/cli/conf.d/20-recode.ini

sleep 5
sudo systemctl start php7.4-fpm
sudo systemctl status php7.4-fpm | sed -n "1,3p"
sleep 15
echo
echo -e "$GREEN Done...$COL_RESET"
