HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
JUKEBOX_HOME_DIR="${HOME_DIR}/RPi-Jukebox-RFID"

GIT_BRANCH=${GIT_BRANCH:-develop}
GIT_URL=${GIT_URL:-https://github.com/Nexodaru/RPi-Jukebox-RFID.git}

# perform base installation
"${JUKEBOX_HOME_DIR}"/scripts/installscripts/install-jukebox.sh

# perform custom installation
/bin/cp -rf "${JUKEBOX_HOME_DIR}"/custom/my_gpio_settings.ini "${JUKEBOX_HOME_DIR}"/settings/gpio_settings.ini

# install oled-display-service
cd
rm install-my-jukebox.sh
wget https://raw.githubusercontent.com/Nexodaru/phoniebox_oled_and_utility/refs/heads/master/scripts/install/o4p_installer.sh
chmod +x o4p_installer.sh
./o4p_installer.sh


