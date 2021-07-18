#!/bin/bash
#####################################################
# Source: https://github.com/Multiplity-in-Network/yiimp_install_raspberry
# Web:    https://multiply.network
# Modified by Multiplity in Network
# Modified by cryptopool.builders
# Modified by Xavatar
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
#############################################################################

echo
echo
echo -e "$CYAN => Check prerequisites : $COL_RESET"
echo

echo "Operating system"
if [ "`lsb_release -d | sed 's/.*:\s*//' | sed 's/20\.04\.[0-9]/20.04/' `" == "Ubuntu 20.04 LTS" ]; then
  DISTRO=20
  echo "-Ubuntu 20.04 LTS"
else [ "`lsb_release -d | sed 's/.*:\s*//' | sed 's/18\.04\.[0-9]/18.04/' `" == "Ubuntu 18.04 LTS" ];
  DISTRO=18
  echo "-Ubuntu 18.04 LTS"
#else [ "`lsb_release -d | sed 's/.*:\s*//' | sed 's/16\.04\.[0-9]/16.04/' `" == "Ubuntu 16.04 LTS" ];
#  DISTRO=16
#  echo "-Ubuntu 16.04 LTS"
fi


echo
echo "System memory"
TOTAL_PHYSICAL_MEM=$(head -n 1 /proc/meminfo | awk '{print $2}')
TOTAL_PHYSICAL_MEM_DISPLAY=$(expr \( \( $TOTAL_PHYSICAL_MEM \* 1024 \) / 1024 \) / 1024)
if [ $TOTAL_PHYSICAL_MEM -lt 1024000 ]; then
  if [ ! -d /vagrant ]; then
    echo " Your Mining Pool Server needs more memory (RAM) to function properly."
    echo " Please provision a machine with at least 1024 MB, 6144 MB recommended."
    echo " This machine has $TOTAL_PHYSICAL_MEM_DISPLAY MB memory."
    exit
  fi
else
  echo "-$TOTAL_PHYSICAL_MEM_DISPLAY MB of RAM"
fi

if [ $TOTAL_PHYSICAL_MEM -lt 1572000 ]; then
  echo -e "$RED WARNING: Your Mining Pool Server has less than 1500 MB of RAM.$COL_RESET"
  echo " It might run unreliably when under heavy load."
  sleep 5
fi


echo
echo "Swap memory"

SWAP_MOUNTED=$(cat /proc/swaps | tail -n+2)
SWAP_IN_FSTAB=$(grep "swap" /etc/fstab)
ROOT_IS_BTRFS=$(grep "\/ .*btrfs" /proc/mounts)
TOTAL_PHYSICAL_MEM=$(head -n 1 /proc/meminfo | awk '{print $2}')
AVAILABLE_DISK_SPACE=$(df / --output=avail | tail -n 1)
if
  [ -z "$SWAP_MOUNTED" ] &&
  [ -z "$SWAP_IN_FSTAB" ] &&
  [ ! -e /swapfile ] &&
  [ -z "$ROOT_IS_BTRFS" ] &&
  [ $TOTAL_PHYSICAL_MEM -lt 4096000 ] &&
  [ $AVAILABLE_DISK_SPACE -gt 5242880 ]
then
  echo "-Adding a swap file to the system..."

  # Allocate and activate the swap file. Allocate in 1KB chuncks
  # doing it in one go, could fail on low memory systems
  sudo fallocate -l 3G /swapfile
    if [ -e /swapfile ]; then
      sudo chmod 600 /swapfile
      hide_output sudo mkswap /swapfile
      sudo swapon /swapfile
      echo "vm.swappiness=10" >> sudo /etc/sysctl.conf
    fi
  echo "-Check if swap is mounted then activate on boot"
  if swapon -s | grep -q "\/swapfile"; then
    echo "/swapfile  none swap sw 0  0" >> sudo /etc/fstab
  else
    echo "$RED ERROR: Swap allocation failed $COL_RESET"
  fi
else
  echo "-No need create swap"
  echo " `free -h | tail -n+3`"
fi


#ARCHITECTURE=$(uname -m)
#if [ "$ARCHITECTURE" != "x86_64" ]; then
#  if [ -z "$ARM" ]; then
#    echo -e "$RED YiimP Install Script only supports x86_64 and will not work on any other architecture, like ARM or 32 bit OS. $COL_RESET"
#    echo -e "$RED Your architecture is $ARCHITECTURE $COL_RESET"
#    exit
#  fi
#fi

echo -e "$GREEN Done...$COL_RESET"