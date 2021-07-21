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
echo -e "$CYAN => Check prerequisites : $COL_RESET"
echo

echo "Operating system"
if [ "`lsb_release -d | sed 's/.*:\s*//' | sed 's/20\.04\.[0-9]/20.04/' `" == "Ubuntu 20.04 LTS" ]; then
  DISTRO=20
  echo "-Ubuntu 20.04 LTS"
else
  DISTRO=0
  echo -e "$RED-`lsb_release -d | sed 's/.*:\s*//'`$COL_RESET"
  exit
fi


echo
echo "System memory"
TOTAL_PHYSICAL_MEM=$(head -n 1 /proc/meminfo | awk '{print $2}')
TOTAL_PHYSICAL_MEM_DISPLAY=$(expr \( \( $TOTAL_PHYSICAL_MEM \* 1024 \) / 1024 \) / 1024)
if [ $TOTAL_PHYSICAL_MEM -lt 1945600 ]; then
  if [ ! -d /vagrant ]; then
    echo " Your Mining Pool Server needs more memory (RAM) to function properly."
    echo " Please provision a machine with at least 1900 MB, 6144 MB recommended."
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
  [ $TOTAL_PHYSICAL_MEM -lt 4194304 ] &&
  [ $AVAILABLE_DISK_SPACE -gt 6291456 ]
then
  echo "-Adding a swap file to the system..."

  # Allocate and activate the swap file. Allocate in 1KB chuncks
  # doing it in one go, could fail on low memory systems
  sudo fallocate -l 3G /swapfile
  if [ -e /swapfile ]; then
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    if swapon -s | grep -q "\/swapfile"; then
      echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    else
      echo "$RED ERROR: Swap allocation failed $COL_RESET"
    fi
    sudo sysctl vm.swappiness=10
    sudo sysctl vm.vfs_cache_pressure=50
    echo "vm.swappiness=10" >> sudo /etc/sysctl.conf
    echo "vm.vfs_cache_pressure=50" >> sudo /etc/sysctl.conf
  fi
else
  echo "-No need create swap"
  echo " `free -h | tail -n+3 | awk '{print $2}'`"
fi


ARCHITECTURE=$(uname -m)
if [ "$ARCHITECTURE" != "aarch64" ]; then
    echo -e "$RED YiimP Install Raspberry only supports ARM64 and will not work on any other architecture, like ARM32 or x86_64 OS. $COL_RESET"
    echo -e "$RED Your architecture is $ARCHITECTURE $COL_RESET"
    exit
fi

echo -e "$GREEN Done...$COL_RESET"
sleep 3