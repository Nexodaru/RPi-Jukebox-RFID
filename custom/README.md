# Installation
siehe auch https://splittscheid.de/phoniebox-bauanleitung-toniebox-alternative/#ftoc-jukebox4kids-phoniebox-installieren


## Raspian installieren
There are a number of operating systems to chose from on the official RPi download page.

Currently we recommend to use the latest legacy release image.

Use the 'lite'-Version (configuration via ssh). If you need the Desktop UI you may need to fix some audio things (see https://github.com/MiczFlor/RPi-Jukebox-RFID/discussions/2267#discussioncomment-8556789).

Installation steps:

1. Connect a Micro SD card to your computer (preferable an SD card with high read throughput)
2. Download the Raspberry Pi Imager and run it
3. Click on "Choose Device" and select "No filtering"
4. Click on "Choose OS" and select "Raspberry Pi OS (other)"
   - Select Raspberry Pi OS (Legacy) Lite (prefered for Phoniebox)
     - if you need a desktop environment, select the non lite version
   - if you want to use a preloaded image, go back and choose Use Custom
5. Select your Micro SD card (your card will be formatted)
6. After you click Next, a prompt will ask you if you like to customize the OS settings
   - Click Edit Settings and configure
     - At the General tab
       - Provide a hostname.
       - ⚠️ Username MUST be pi. Other usernames are not supported.
       - User Password
       - Wifi
       - locale settings
    - At the Services tab.
       - Enable SSH with "Use password authentication"
    - At the Options tab.
       - Disable "Telemetrie" if you like
    - Click Save
   - Click Yes to use Settings
7. Click Write
8. Confirm the next warning about erasing the SD card with Yes
9. Wait for the imaging process to be finished (it'll take a few minutes)

Plug the SD into your Pi and optionally connect keyboard, monitor and mouse. And fire it up.

See the official RPi guide for further information.

## Änderungen auf SD-Karte

1. config.txt auf SD-Karte anpassen
    ```
        config_hdmi_boost=4
        #dtparam=audio=on
        dtoverlay=hifiberry-dac
    ```

## Änderungen nach dem Bootvorgang

1. SD-Karte in den PI und starten
2. passwd -> ändern des Passworts für den Raspi
3. Wlan-Datei verschieben
    ```
    sudo mv /boot/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
    sudo chown root:netdev /etc/wpa_supplicant/wpa_supplicant.conf
    sudo chmod 664 /etc/wpa_supplicant/wpa_supplicant.conf
    ```
4. Host-Namen ändern
    ```
    sudo sed -i -e 's/raspberrypi/KayasBox/g' /etc/hostname 
    sudo sed -i -e 's/raspberrypi/KayasBox/g' /etc/hosts
    sudo hostname -b KayasBox 
    sudo rm /etc/ssh/ssh_host_* 
    sudo dpkg-reconfigure openssh-server 
    sudo service ssh restart
    sudo reboot
    ```
5. Update 
    ```
    sudo apt update
    sudo apt full-upgrade
    ```
### HifiBerry MiniAmp

1. Editieren der Datei /etc/asound.conf
    ```
    pcm.hifiberry {
          type softvol
          slave.pcm "plughw:0"
          control.name "Master"
          control.card 0
    }
    pcm.!default {
      type plug
      slave.pcm "hifiberry"
    }
    ```
2. Reboot und hifiBerry testen  
   ```
   sudo reboot
   #nach diesem Befehl sollte der hifiberry angezeigt werden
   aplay -l
   # nach folgenden Befehl sollte Ton aus den Boxen kommenm, kann abgebrochen werden
   speaker-test -D hifiberry -c 2 
   ``` 

## Installations-Skript

```
cd; rm install-my-jukebox.sh; wget https://raw.githubusercontent.com/Nexodaru/RPi-Jukebox-RFID/develop/custom/install-my-jukebox.sh; chmod +x install-my-jukebox.sh; ./install-my-jukebox.sh
```

## On/Off-Shim

```
curl https://get.pimoroni.com/onoffshim | bash
```

- Ändern einiger Parammeter in /etc/cleanshutd.conf
    ```
    daemon_active=1
    trigger_pin=17
    led_pin=25
    poweroff_pin=4
    hold_time=2
    shutdown_delay=0
    polling_rate=1
    ```
- Reboot

## Ende

# Customizations
- added own install script
- added own gpio_settings
- merged PullRequest https://github.com/matthias-pelger/RPi-Jukebox-RFID/tree/random-subfolder-play
