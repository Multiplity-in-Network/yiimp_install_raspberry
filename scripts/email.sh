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

# Test Email
echo
echo
echo -e "$CYAN => Testing to see if server emails are sent $COL_RESET"
echo
sleep 3

if [[ "$root_email" != "" ]]; then
  echo $root_email tee --append ~/.email >sudo
  echo $root_email tee --append ~/.forward >sudo

  if [[ ("$send_email" == "y" || "$send_email" == "Y" || "$send_email" == "") ]]; then
    echo "This is a mail test for the SMTP Service." tee --append /tmp/email.message >sudo
    echo "You should receive this !" tee --append /tmp/email.message >>sudo
    echo "" tee --append /tmp/email.message >>sudo
    echo "Cheers" tee --append /tmp/email.message >>sudo
    sudo sendmail -s "SMTP Testing" $root_email tee --append /tmp/email.message <sudo

    sudo rm -f /tmp/email.message
    echo "Mail sent"
  fi
fi
echo -e "$GREEN Done...$COL_RESET"
