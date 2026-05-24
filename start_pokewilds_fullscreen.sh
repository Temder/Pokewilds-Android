#!/data/data/com.termux/files/usr/bin/bash                           
# 1. Start Audio
pulseaudio --start --exit-idle-time=-1 > /dev/null 2>&1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

# 2. Open Termux X11 app
am start -n com.termux.x11/.MainActivity

# 3. Display "Stop Game" notification if Termux:API is installed
if termux-api-start; then
     termux-notification \
          --title "PokeWilds Running" \
          --content "Tap the notification to stop the game." \
          --action "bash ~/.shortcuts/stop_pokewilds.sh" \
          --id pokewilds \
          --ongoing
fi

# 3. Launch the game inside Debian in the background
proot-distro login pokewilds -- bash -c "
export PULSE_SERVER=127.0.0.1
cd // && cd /sdcard/Pokewilds/pokewilds-v0.8.11-otherplatforms
termux-x11 :1 -xstartup 'unclutter -idle 0 -root & openbox & java -jar pokewilds.jar & sleep 5 && wmctrl -r :ACTIVE: -b add,fullscreen && wait'
"
