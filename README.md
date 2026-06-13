# Pokewilds-Android
Setup scripts and guide to run Pokewilds on android.

Work in progress. Bugs expected.

If something is unclear or missing please create an issue with the minimum information:
- error message
- at which step was the error encountered

If you used the one line script please copy the output up to the last checkmark (✓).

## New: One line script

There is a new one line script. Just paste the following command in Termux and select your prefered window mode (sqare or fullscreen). You still need to download the apps (step 1). The script takes some minutes to run all commands. After it finishes you can continue with step 5.
```bash
bash <(curl -s https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/setup_pokewilds.sh)
```

## 1. Installing necessary apps

Install and setup the following apps.

- Termux ([F-Droid](https://f-droid.org/de/packages/com.termux/) / [Github](https://github.com/termux/termux-app/releases))
- Termux:X11 ([Github](https://github.com/termux/termux-x11/releases)) **or** use Termux:X11-extra for onscreen touch controls ([Github](https://github.com/moio9/termux-x11-extra/releases))
- Termux:API ([F-Droid](https://f-droid.org/de/packages/com.termux.api/) / [Github](https://github.com/termux/termux-api/releases)) (optional for closing notification)
- Termux:Widget ([F-Droid](https://f-droid.org/de/packages/com.termux.widget/) / [Github](https://github.com/termux/termux-widget)) (optional but recommended to create a shortcut to execute the script)

## 2. Setup environment

Open Termux and run the following. This will create an environment for Pokewilds to run.
```bash
termux-setup-storage && yes | pkg update && pkg upgrade -y && pkg install x11-repo  pulseaudio proot-distro termux-api wget unzip -y && pkg install termux-x11-nightly -y && proot-distro install --override-alias pokewilds debian && proot-distro login pokewilds -- bash -c "apt update && apt upgrade -y && apt install x11-utils pulseaudio-utils openjdk-21-jre-headless unclutter -y"
```
If you want a fullscreen window (default is a square) run the following command.
```bash
proot-distro login pokewilds -- bash -c "apt install openbox wmctrl -y"
```

## 3. Startup/Stop scripts

Choose a command to download the scripts based on your preference.

**Option 1: square game window**

```bash
mkdir -p ~/.shortcuts && wget -O ~/.shortcuts/start_pokewilds.sh "https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/start_pokewilds_square.sh" && chmod +x ~/.shortcuts/start_pokewilds.sh && wget -O ~/.shortcuts/stop_pokewilds.sh "https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/stop_pokewilds.sh" && chmod +x ~/.shortcuts/stop_pokewilds.sh
```

**Option 2: fullscreen/flexible game window**

```bash
mkdir -p ~/.shortcuts && wget -O ~/.shortcuts/start_pokewilds.sh "https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/start_pokewilds_fullscreen.sh" && chmod +x ~/.shortcuts/start_pokewilds.sh && wget -O ~/.shortcuts/stop_pokewilds.sh "https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/stop_pokewilds.sh" && chmod +x ~/.shortcuts/stop_pokewilds.sh
```

## 4. Get pokewilds package

**Option 1: Automatic download/extraction (paste command in Termux)**

```bash
mkdir -p /sdcard/Pokewilds && wget -O /sdcard/Pokewilds/pokewilds.zip "https://github.com/SheerSt/pokewilds/releases/latest/download/pokewilds-otherplatforms.zip" && unzip -o /sdcard/Pokewilds/pokewilds.zip -d /sdcard/Pokewilds/ && rm /sdcard/Pokewilds/pokewilds.zip
```

**Option 2: Manual download/extraction (fallback if Option 1 is not working)**

- Download the archive ([Link](https://github.com/SheerSt/pokewilds/releases/latest/download/pokewilds-otherplatforms.zip))
- Create the directory /storage/emulated/0/Pokewilds if it does not exist yet
- Extract/copy the contents of the archive to /storage/emulated/0/Pokewilds
- the result paths should look like the following: /storage/emulated/0/Pokewilds/pokewilds-v0.8.11-otherplatforms/[game files]

## 5. Test the script

Run the following commands in Termux. If the game is not running, post the output as an issue in the github repository. If the game runs you can stop it by pressing CTRL + C inside Termux and continue to the next steps.
```bash
exit
~/.shortcuts/start_pokewilds.sh
```

## 6. Creating a shortcut

You can choose to run the game everytime with the command or create a shortcut by following the steps
- Go to the widget creation process on your homescreen (usually by long pressing on your homescreen and choosing widget)
- Select Termux:Widget -> Termux shortcut 1 x 1 and place it on your homescreen
- Select the start_pokewilds.sh entry

The shortcut should now execute the script and launch the game.

## 7. Controls

You can play the game by connecting a keyboard (or controller not tested) to your phone.

Another option is using Termux:X11-extra with onscreen touch controls:
- Download the [control layout file](https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/termux-x11-extra-keys-pokewilds.json)
- Open Termux:X11-extra and navigate to Preferences -> Keyboard -> Show additional keyboard -> Import Virtual Key Preset
- Select the downloaded file
- you can also create your own or edit my provided controls

## 8. Termux:X11 settings

The following settings are recommended. Smaller resolutions are better for performance. The display resolution mode setting will only work with the full screen when the option fullscreen/flexible game window was chosen.

| Setting | Location | Value | Description |
| ------- | -------- | ----- | ----------- |
| Display resolution mode | Output | scaled or exact | scaled: whole display; exact: specific resolution |
| Display scale | if Display resolution mode is scaled | as high as possible | uses the whole screen and scales it down by the factor |
| Display resolution | if Display resolution mode is exact | as low as possible | sets the game window to an exact resolution |
| Fullscreen | Output | On | hides the status bar |
| Screen orientation | Output | Landscape | automaticly orients the game to lanscape |
