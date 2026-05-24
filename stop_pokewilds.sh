#!/data/data/com.termux/files/usr/bin/bash

# 1. Kill the Game
pkill -f java

# 2. Kill the Server
pkill -f termux-x11

# 3. Kill Audio
pulseaudio --kill

# 4. Close the App Window
am broadcast -a com.termux.x11.ACTION_STOP -p com.termux.x11

# 5. Remove the notification
termux-notification-remove pokewilds