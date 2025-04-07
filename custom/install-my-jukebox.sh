#!/usr/bin/env bash

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
JUKEBOX_HOME_DIR="${HOME_DIR}/RPi-Jukebox-RFID"

GIT_BRANCH=${GIT_BRANCH:-develop}
GIT_URL=${GIT_URL:-https://github.com/Nexodaru/RPi-Jukebox-RFID.git}
ORIG_INSTALL_SCRIPT_URL=https://raw.githubusercontent.com/Nexodaru/RPi-Jukebox-RFID/develop/scripts/installscripts/install-jukebox.sh

echo "Current Config"
echo "HomeDir: $HOME_DIR"
echo "JukeBoxHomeDir $JUKEBOX_HOME_DIR"
echo "GIT-Branch: $GIT_BRANCH"
echo "GitUrl: $GIT_URL"

rm install-jukebox.sh
wget $ORIG_INSTALL_SCRIPT_URL
chmod +x install-jukebox.sh

# perform base installation
. ./install-jukebox.sh

# This is currently not working

## perform custom installation
#/bin/cp -rf "${JUKEBOX_HOME_DIR}"/custom/my_gpio_settings.ini "${JUKEBOX_HOME_DIR}"/settings/gpio_settings.ini
#
#read -p "Basic installation finished. Press enter to continue"
#
## install oled-display-service
#cd
#rm o4p_installer.sh
#wget https://raw.githubusercontent.com/Nexodaru/phoniebox_oled_and_utility/refs/heads/master/scripts/install/o4p_installer.sh
#chmod +x o4p_installer.sh
#. ./o4p_installer.sh


