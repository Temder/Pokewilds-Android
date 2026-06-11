#!/data/data/com.termux/files/usr/bin/bash

# Pokewilds Android Automated Setup Script
# Based on guide: https://github.com/Temder/Pokewilds-Android

# Function to print colored status messages
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "\n✔️ SUCCESS: $1"
    else
        echo -e "\n❌ FAILED: $1"
        echo "Please check the errors above. Exiting script."
        exit 1
    fi
}

echo "=========================================="
echo "  Pokewilds Android Setup Script"
echo "=========================================="

# --- STEP 0: USER PREFERENCE (Run Once) ---
echo -e "\nPlease select your preferred game window mode."
window_choice=""
while [ "$window_choice" != "1" ] && [ "$window_choice" != "2" ]; do
    echo "1) Square (Default)"
    echo "2) Fullscreen/Flexible"
    read -p "Enter 1 or 2: " window_choice
    
    if [ "$window_choice" != "1" ] && [ "$window_choice" != "2" ]; then
        echo "⚠️ Invalid input. Please type 1 or 2."
    fi
done

# --- STEP 1: SETUP STORAGE ---
# termux-setup-storage is mostly idempotent, but good to run first.
echo -e "\n[Step 1/7] Setting up storage permissions..."
termux-setup-storage
check_status "Storage permissions setup"

# --- STEP 2: UPDATE UPGRADE (Silent) ---
echo -e "\n[Step 2/7] Updating and upgrading Termux packages (Silent Mode)..."
# 'yes' automatically answers 'y' to prompts like "overwrite config file?"
yes | pkg update && yes | pkg upgrade -y
check_status "Termux packages updated"

# --- STEP 3: INSTALL BASE DEPENDENCIES ---
echo -e "\n[Step 3/7] Installing base dependencies..."
# -y assumes yes to installation, but we check if installed first to be safe/fast
pkg install -y x11-repo pulseaudio proot-distro termux-api wget unzip
check_status "Base dependencies installed"

# --- STEP 4: INSTALL TERMUX:X11 ---
echo -e "\n[Step 4/7] Installing Termux:X11 nightly..."
pkg install -y termux-x11-nightly
check_status "Termux:X11 installed"

# --- STEP 5: PROOT DEBIAN SETUP ---
proot-distro install --override-alias pokewilds debian
if [ $? -ne 0 ]; then
    echo "⚠️ Note: Debian installation might have failed if it alread>
fi
check_status "Debian proot installed"

echo "Configuring/Updating Debian environment..."
# Run update and install java regardless, to ensure it's present
proot-distro login pokewilds -- bash -c "apt update && apt upgrade -y && apt install x11-utils pulseaudio-utils openjdk-21-jre-headless unclutter -y"
check_status "Debian environment configured"

# Handle Window Manager based on initial choice
if [ "$window_choice" == "2" ]; then
    echo "Installing Openbox for fullscreen..."
    proot-distro login pokewilds -- bash -c "apt install -y openbox wmctrl"
    check_status "Openbox installed for fullscreen"
fi

# --- STEP 6: DOWNLOAD SCRIPTS ---
echo -e "\n[Step 6/7] Configuring startup scripts..."
mkdir -p ~/.shortcuts

if [ "$window_choice" == "2" ]; then
    echo "Downloading fullscreen startup script..."
    wget -q -O ~/.shortcuts/start_pokewilds.sh "https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/start_pokewilds_fullscreen.sh"
else
    echo "Downloading square startup script..."
    wget -q -O ~/.shortcuts/start_pokewilds.sh "https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/start_pokewilds_square.sh"
fi
check_status "start_pokewilds.sh downloaded"

echo "Downloading stop script..."
wget -q -O ~/.shortcuts/stop_pokewilds.sh "https://raw.githubusercontent.com/Temder/Pokewilds-Android/refs/heads/main/stop_pokewilds.sh"
check_status "stop_pokewilds.sh downloaded"

chmod +x ~/.shortcuts/*.sh
check_status "Scripts permissions set"

# --- STEP 7: GAME DATA ---
echo -e "\n[Step 7/7] Checking for Pokewilds game files..."
mkdir -p /sdcard/Pokewilds

# Check if a likely game file (e.g. the jar or a library) exists to determine if download is needed
# Assuming standard structure, checking for a directory or specific file is tricky as versions change.
# We'll just check if the directory is not empty or if the zip exists.
if [ -z "$(ls -A /sdcard/Pokewilds)" ]; then
    echo "No game files found. Starting download (this may take a while)..."
    wget -O /sdcard/Pokewilds/pokewilds.zip "https://github.com/SheerSt/pokewilds/releases/latest/download/pokewilds-otherplatforms.zip"
    check_status "Game zip downloaded"
    
    echo "Extracting game files..."
    unzip -o /sdcard/Pokewilds/pokewilds.zip -d /sdcard/Pokewilds/ && rm /sdcard/Pokewilds/pokewilds.zip
    check_status "Game files extracted and zip cleaned up"
else
    echo "✔️ Game files found in /sdcard/Pokewilds. Skipping download."
fi

# Final Verification
echo -e "\n=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo -e "To start the game, run:\n~/.shortcuts/start_pokewilds.sh"
echo -e "\nOr create a shortcut using Termux:Widget."
echo "=========================================="