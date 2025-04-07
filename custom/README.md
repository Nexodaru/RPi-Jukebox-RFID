# Anmerkung 
Viele Dinge auf dieser Seite habe ich direkt von https://splittscheid.de/phoniebox-bauanleitung-toniebox-alternative/#ftoc-jukebox4kids-phoniebox-installieren übernommen und für meine Zwecke angepasst.
# Installation
siehe auch https://splittscheid.de/phoniebox-bauanleitung-toniebox-alternative/#ftoc-jukebox4kids-phoniebox-installieren

## Probleme 
- RFID registrierung funzt nicht https://github.com/MiczFlor/RPi-Jukebox-RFID/issues/1618
  - vorherige Installation
    ```
    /home/pi/RPi-Jukebox-RFID/scripts/deviceName.txt
    -rw-r--r--  1 pi www-data    17 Dec 14  2019 deviceName.txt
    ```
    Inhalt: HXGCoLtd Keyboard
  - 
## Raspian installieren
There are a number of operating systems to chose from on the official RPi download page.

Currently we recommend to use the latest legacy release image. 
https://www.raspberrypi.org/software/operating-systems/#raspberry-pi-os-legacy

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
2. Update 
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
[//]: # (TODO Ab hier weiter)
```
cd; rm install-my-jukebox.sh; wget https://raw.githubusercontent.com/Nexodaru/RPi-Jukebox-RFID/develop/custom/install-my-jukebox.sh; chmod +x install-my-jukebox.sh; ./install-my-jukebox.sh
```

### Basis Installation
- Ja, wir wollen den interaktiven Installer nutzen „Y“
- Da ich WiFi schon konfiguriert habe, wähle ich „n“.
- AutoHotSpot nach Bedarf konfigurieren
- Headphone als iFace ist nicht korrekt, hier wähle ich zunächst „n“ und gebe „Master“ ein.
- Spotify, na klar also „Y“.
- Die Default locations bestätige ich mit „Y“.
- Ja, ich nutze Buttons, also nehme ich auch die Steuerung mit „Y“.
- Der erste Part der Installation wird mit „Y“ ausgeführt.
- Da ich den USB-Reader angeschlossen habe bestätigt ich mit „Y“, dann „1“ (Neuftech Reader) und wähle die „0“ für „0 HXGCoLtd Keyboard“.
- Die Anfrage nach dem Boot mit „n“ beantworten, da weitere Dinge im Script installiert werden

### Installation Oled und Utility

- Eigentlich soll nach dem Skript ein weiteres gestartet werden. Das passiert aktuell nicht
- Daher nach der Installation folgendes durchführen
    ```
    # GPIO-Setting übernehmen
    /bin/cp -rf "${JUKEBOX_HOME_DIR}"/custom/my_gpio_settings.ini "${JUKEBOX_HOME_DIR}"/settings/gpio_settings.ini
    # OLED Display und LEDs installieren
    cd;rm o4p_installer.sh;wget https://raw.githubusercontent.com/Nexodaru/phoniebox_oled_and_utility/refs/heads/master/scripts/install/o4p_installer.sh;chmod +x o4p_installer.sh;./o4p_installer.sh
    ```
  
- Aktuell verwende ich AZDelivery 1 x 1,3 Zoll OLED Display I2C SSH1106
  - Daher Option 2 wählen
  - Rest ist selbsterklärend

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
