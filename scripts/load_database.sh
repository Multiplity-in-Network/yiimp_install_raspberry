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

# Peforming the SQL import
echo
echo
echo -e "$CYAN => Database 'yiimpfrontend' and users 'panel' and 'stratum' created with password $password and $password2, will be saved for you $COL_RESET"
echo
echo -e "Performing the SQL import"
echo
sleep 3

cd $HOME/yiimp/sql

# Import sql dump
sudo zcat 2020-11-10-yaamp.sql.gz | sudo mysql --defaults-group-suffix=host1

# Oh the humanity!
sudo mysql --defaults-group-suffix=host1 --force <2016-04-24-market_history.sql
sudo mysql --defaults-group-suffix=host1 --force <2016-04-27-settings.sql
sudo mysql --defaults-group-suffix=host1 --force <2016-05-11-coins.sql
sudo mysql --defaults-group-suffix=host1 --force <2016-05-15-benchmarks.sql
sudo mysql --defaults-group-suffix=host1 --force <2016-05-23-bookmarks.sql
sudo mysql --defaults-group-suffix=host1 --force <2016-06-01-notifications.sql
sudo mysql --defaults-group-suffix=host1 --force <2016-06-04-bench_chips.sql
sudo mysql --defaults-group-suffix=host1 --force <2016-11-23-coins.sql
sudo mysql --defaults-group-suffix=host1 --force <2017-02-05-benchmarks.sql
sudo mysql --defaults-group-suffix=host1 --force <2017-03-31-earnings_index.sql
sudo mysql --defaults-group-suffix=host1 --force <2020-06-03-blocks.sql
sudo mysql --defaults-group-suffix=host1 --force <2017-05-accounts_case_swaptime.sql
sudo mysql --defaults-group-suffix=host1 --force <2017-06-payouts_coinid_memo.sql
sudo mysql --defaults-group-suffix=host1 --force <2017-09-notifications.sql
sudo mysql --defaults-group-suffix=host1 --force <2017-10-bookmarks.sql
sudo mysql --defaults-group-suffix=host1 --force <2018-09-22-workers.sql
sudo mysql --defaults-group-suffix=host1 --force <2017-11-segwit.sql
sudo mysql --defaults-group-suffix=host1 --force <2018-01-stratums_ports.sql
sudo mysql --defaults-group-suffix=host1 --force <2018-02-coins_getinfo.sql
sudo mysql --defaults-group-suffix=host1 --force <2019-03-coins_thepool_life.sql
echo -e "$GREEN Done...$COL_RESET"