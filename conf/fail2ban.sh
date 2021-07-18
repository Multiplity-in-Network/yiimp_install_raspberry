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

# Installing Fail2Ban & UFW
echo
echo
echo -e "$CYAN => Some optional installs (Fail2Ban & UFW) $COL_RESET"
echo
sleep 3


if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
sudo apt -y install fail2ban
sleep 5
sudo systemctl status fail2ban | sed -n "1,3p"
    fi


if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
sudo apt -y install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 3333/tcp
sudo ufw allow 3339/tcp
sudo ufw allow 3334/tcp
sudo ufw allow 3433/tcp
sudo ufw allow 3555/tcp
sudo ufw allow 3556/tcp
sudo ufw allow 3573/tcp
sudo ufw allow 3535/tcp
sudo ufw allow 3533/tcp
sudo ufw allow 3553/tcp
sudo ufw allow 3633/tcp
sudo ufw allow 3733/tcp
sudo ufw allow 3636/tcp
sudo ufw allow 3737/tcp
sudo ufw allow 3739/tcp
sudo ufw allow 3747/tcp
sudo ufw allow 3833/tcp
sudo ufw allow 3933/tcp
sudo ufw allow 4033/tcp
sudo ufw allow 4133/tcp
sudo ufw allow 4233/tcp
sudo ufw allow 4234/tcp
sudo ufw allow 4333/tcp
sudo ufw allow 4433/tcp
sudo ufw allow 4533/tcp
sudo ufw allow 4553/tcp
sudo ufw allow 4633/tcp
sudo ufw allow 4733/tcp
sudo ufw allow 4833/tcp
sudo ufw allow 4933/tcp
sudo ufw allow 5033/tcp
sudo ufw allow 5133/tcp
sudo ufw allow 5233/tcp
sudo ufw allow 5333/tcp
sudo ufw allow 5433/tcp
sudo ufw allow 5533/tcp
sudo ufw allow 5733/tcp
sudo ufw allow 5743/tcp
sudo ufw allow 3252/tcp
sudo ufw allow 5755/tcp
sudo ufw allow 5766/tcp
sudo ufw allow 5833/tcp
sudo ufw allow 5933/tcp
sudo ufw allow 6033/tcp
sudo ufw allow 5034/tcp
sudo ufw allow 6133/tcp
sudo ufw allow 6233/tcp
sudo ufw allow 6333/tcp
sudo ufw allow 6433/tcp
sudo ufw allow 7433/tcp
sudo ufw allow 8333/tcp
sudo ufw allow 8463/tcp
sudo ufw allow 8433/tcp
sudo ufw allow 8533/tcp
sudo ufw --force enable
sleep 5
sudo systemctl status ufw | sed -n "1,3p"
fi


echo
echo -e "$GREEN Done...$COL_RESET"
