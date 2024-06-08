#!/bin/bash
#
# SillyTavern Launcher
# Created by: Deffcolony
#
# Description:
# This script runs SillyTavern and/or Extras on your Linux system.
#
# Usage:
# chmod +x launcher.sh && ./launcher.sh
#
# In automated environments, you may want to run as root.
# If using curl, we recommend using the -fsSL flags.
#
# This script is intended for use on Linux systems. Please
# report any issues or bugs on the GitHub repository.
#
# App Github: https://github.com/SillyTavern/SillyTavern.git
#
# GitHub: https://github.com/SillyTavern/SillyTavern-Launcher
# Issues: https://github.com/SillyTavern/SillyTavern-Launcher/issues
# ----------------------------------------------------------
# Note: Modify the script as needed to fit your requirements.
# ----------------------------------------------------------

echo -e "\033]0;SillyTavern Launcher\007"

# ANSI Escape Code for Colors
reset="\033[0m"
white_fg_strong="\033[90m"
red_fg_strong="\033[91m"
green_fg_strong="\033[92m"
yellow_fg_strong="\033[93m"
blue_fg_strong="\033[94m"
magenta_fg_strong="\033[95m"
cyan_fg_strong="\033[96m"

# Normal Background Colors
red_bg="\033[41m"
blue_bg="\033[44m"
yellow_bg="\033[43m"

# Environment Variables (TOOLBOX 7-Zip)
zip7version="7z2301-x64"
zip7_install_path="/usr/local/bin"

# Environment Variables (TOOLBOX FFmpeg)
ffmpeg_url="https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z"
ffdownload_path="/tmp/ffmpeg.7z"
ffextract_path="/opt/ffmpeg"
bin_path="$ffextract_path/bin"

# Environment Variables (TOOLBOX Node.js)
node_installer_path="/tmp/NodejsInstaller.sh"

# Environment Variables (TOOLBOX Install Extras)
miniconda_path="$HOME/miniconda3"

# Define variables to track module status
modules_path="$HOME/modules.txt"
coqui_trigger="false"
rvc_trigger="false"
talkinghead_trigger="false"
caption_trigger="false"
summarize_trigger="false"
edge_tts_trigger="false"


# Function to log messages with timestamps and colors
log_message() {
    # This is only time
    current_time=$(date +'%H:%M:%S')
    # This is with date and time
    # current_time=$(date +'%Y-%m-%d %H:%M:%S')
    case "$1" in
        "INFO")
            echo -e "${blue_bg}[$current_time]${reset} ${blue_fg_strong}[INFO]${reset} $2"
            ;;
        "WARN")
            echo -e "${yellow_bg}[$current_time]${reset} ${yellow_fg_strong}[WARN]${reset} $2"
            ;;
        "ERROR")
            echo -e "${red_bg}[$current_time]${reset} ${red_fg_strong}[ERROR]${reset} $2"
            ;;
        *)
            echo -e "${blue_bg}[$current_time]${reset} ${blue_fg_strong}[DEBUG]${reset} $2"
            ;;
    esac
}

# Log your messages test window
#log_message "INFO" "Something has been launched."
#log_message "WARN" "${yellow_fg_strong}Something is not installed on this system.${reset}"
#log_message "ERROR" "${red_fg_strong}An error occurred during the process.${reset}"
#log_message "DEBUG" "This is a debug message."
#read -p "Press Enter to continue..."

# Function to install Git
install_git() {
    if ! command -v git &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}Git is not installed on this system${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Installing Git using apt..."
            sudo apt-get update
            sudo apt-get install -y git
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Installing Git using yum..."
            sudo yum install -y git
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Installing Git using apk..."
            sudo apk add git
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Installing Git using pacman..."
            sudo pacman -S --noconfirm git
        elif command -v emerge &>/dev/null; then
            # Gentoo Linux-based system
            log_message "INFO" "Installing Git using emerge..."
            sudo emerge --ask dev-vcs/git
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}Git is installed.${reset}"
    else
        echo -e "${blue_fg_strong}[INFO] Git is already installed.${reset}"
    fi
}

# Change the current directory to 'sillytavern' folder
cd "SillyTavern" || exit 1

# Check for updates
git fetch origin

update_status="Up to Date"
current_branch="$(git branch --show-current)"

# Check for updates
if [[ "$(git rev-list HEAD...origin/$current_branch)" ]]; then
  update_status="Update Available"
fi

# Go back to base dir
cd ..

############################################################
################## HOME - FRONTEND #########################
############################################################
home() {
    echo -e "\033]0;SillyTavern [HOME]\007"
    clear
    echo -e "${blue_fg_strong}/ Home${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. Start SillyTavern"
    echo "2. Start Extras"
    echo "3. Start XTTS"
    echo "4. Update"
    echo "5. Backup"
    echo "6. Switch branch"
    echo "7. Toolbox"
    echo "8. Support"
    echo "0. Exit"

    echo "======== VERSION STATUS ========"
    echo -e "SillyTavern branch: ${cyan_fg_strong}$current_branch${reset}"
    echo -e "Sillytavern: $update_status"
    echo -e "Launcher: V1.0.8"
    echo "================================"

    read -p "Choose Your Destiny: " home_choice

    # Default to choice 1 if no input is provided
    if [ -z "$home_choice" ]; then
      home_choice=1
    fi

################## HOME - BACKEND #########################
    case $home_choice in
        1) start_st ;;
        2) start_extras ;;
        3) start_xtts ;;
        4) update ;;
        5) backup_menu ;;
        6) switch_branch_menu ;;
        7) toolbox ;;
        8) support ;;
        0) exit ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           home ;;
    esac
}


# Function to check if Node.js is installed
check_nodejs() {
    node --version > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${red_fg_strong}[ERROR] node command not found in PATH${reset}"
        echo -e "${red_bg}Please make sure Node.js is installed and added to your PATH.${reset}"
        echo -e "${blue_bg}To install Node.js, go to Toolbox${reset}"
        read -p "Press Enter to continue..."
        home
    fi
}


# Function to find a suitable terminal emulator
find_terminal()
{
    for term in "$TERM"
    do
        if command -v "$term" > /dev/null 2>&1; then
            echo "$term"
            return 0
        fi
    done
    for terminal in "$TERMINAL"
    do
        if command -v "$terminal" > /dev/null 2>&1; then
            echo "$terminal"
            return 0
        fi
    done
    # Return a default terminal if none is found
    echo "x-terminal-emulator"
    return 1
}

# Function to start SillyTavern
start_st()
{
    check_nodejs
    #if LAUNCH_NEW_WIN is set to 0, SillyTavern will launch in the same window
    if [ "$LAUNCH_NEW_WIN" = "0" ]; then
        log_message "INFO" "SillyTavern launched"
        cd "$(dirname "$0")./SillyTavern" || exit 1
        ./start.sh
    else
        log_message "INFO" "SillyTavern launched in a new window."
        # Find a suitable terminal
        local detected_terminal
        detected_terminal=$(find_terminal)
        log_message "INFO" "Found terminal: $detected_terminal"
        # Enable read p command for troubleshooting
        # read -p "Press Enter to continue..."

        # Start SillyTavern in the detected terminal
        if [ "$(uname)" == "Darwin" ]; then
            log_message "INFO" "Detected macOS. Opening new Terminal window."
            open -a Terminal "$(dirname "$0")/start.sh"
        else
            exec "$detected_terminal" -e "cd $(dirname "$0")./SillyTavern && ./start.sh" &
        fi
    fi

    home
}

# Function to start SillyTavern with Extras
start_extras() {
    check_nodejs
    if [ "$LAUNCH_NEW_WIN" = "0" ]; then
        local main_pid=$!
        log_message "INFO" "Extras launched under pid $main_pid"
        {
            #has to be after the first one, so we are 1 directory up
            cd "$(dirname "$0")./SillyTavern-extras" || {
                log_message "ERROR" "SillyTavern-extras directory not found. Please make sure you have installed SillyTavern-extras."
                kill $main_pid
                exit 1
            }
            log_message "INFO" "Wordking dir: $(pwd)"
            ./start.sh
        } &
        local extras_pid=$!
        log_message "INFO" "Extras launched under pid $extras_pid"
        wait $main_pid
        kill $extras_pid
    else
        log_message "INFO" "Extras launched in a new window."
        # Find a suitable terminal
        local detected_terminal
        detected_terminal=$(find_terminal)
        log_message "INFO" "Found terminal: $detected_terminal"
        # Enable read p command for troubleshooting
        # read -p "Press Enter to continue..."

        # Start SillyTavern in the detected terminal
        if [ "$(uname)" == "Darwin" ]; then
            log_message "INFO" "Detected macOS. Opening new Terminal window."
            open -a Terminal --args --title="SillyTavern Extras" --working-directory="$(dirname "$0")/SillyTavern-extras" --command "conda activate xtts; python server.py --listen --rvc-save-file --max-content-length=1000 --enable-modules=rvc,caption; exec bash"
        else
            exec "$detected_terminal" -e "cd '$(dirname "$0")/SillyTavern-extras' && conda activate extras && python server.py --listen --rvc-save-file --max-content-length=1000 --enable-modules=rvc,caption; bash"
        fi
    fi
    home
} 

# Function to start xtts
start_xtts() {
    check_nodejs

    if [ "$LAUNCH_NEW_WIN" = "0" ]; then
        local main_pid=$!
        log_message "INFO" "xtts launched under pid $main_pid"

        # Move to xtts directory
        cd "$(dirname "$0")/xtts" || {
            log_message "ERROR" "xtts directory not found. Please make sure you have installed xtts"
            kill "$main_pid"
            exit 1
        }

        log_message "INFO" "Working dir: $(pwd)"
        ./start.sh &
        local xtts_pid=$!
        log_message "INFO" "xtts launched under pid $xtts_pid"

        wait "$main_pid"
        kill "$xtts_pid"
    else
        log_message "INFO" "xtts launched in a new window."
        # Find a suitable terminal
        local detected_terminal
        detected_terminal=$(find_terminal)
        log_message "INFO" "Found terminal: $detected_terminal"
        # Enable read p command for troubleshooting
        # read -p "Press Enter to continue..."

        # Start XTTS in the detected terminal
        if [ "$(uname)" == "Darwin" ]; then
            log_message "INFO" "Detected macOS. Opening new Terminal window."
            open -a Terminal --args --title="XTTSv2 API Server" --working-directory="$(dirname "$0")/xtts" --command "conda activate xtts; python -m xtts_api_server; exec bash"
        else
            exec "$detected_terminal" -e "cd '$(dirname "$0")/xtts' && conda activate xtts && python -m xtts_api_server; bash"
        fi
    fi
    home
}


# Function to update
update() {
    echo -e "\033]0;SillyTavern [UPDATE]\007"
    log_message "INFO" "Updating SillyTavern-Launcher..."
    git pull --rebase --autostash

    # Update SillyTavern if directory exists
    if [ -d "./SillyTavern" ]; then
        log_message "INFO" "Updating SillyTavern..."
        cd "SillyTavern"
        git pull --rebase --autostash
        cd ..
        log_message "INFO" "SillyTavern updated successfully."
    else
        log_message "WARN" "SillyTavern directory not found. Skipping SillyTavern update."
    fi

    # Update Extras if directory exists
    if [ -d "./SillyTavern-extras" ]; then
        log_message "INFO" "Updating SillyTavern-extras..."
        cd "SillyTavern-extras"
        git pull --rebase --autostash
        cd ..
        log_message "INFO" "SillyTavern-extras updated successfully."
    else
        log_message "WARN" "SillyTavern-extras directory not found. Skipping SillyTavern-extras update."
    fi

    # Update XTTS if directory exists
    if [ -d "./xtts" ]; then
        log_message "INFO" "Updating XTTS..."
        cd "xtts"
        source activate xtts
        pip install --upgrade xtts-api-server
        conda deactivate
        cd ..
        log_message "INFO" "XTTS updated successfully."
    else
        log_message "WARN" "xtts directory not found. Skipping XTTS update."
    fi
    cd "$(dirname "$0")"
    read -p "Press Enter to continue..."
    home
}


create_backup() {
    echo -e "\033]0;SillyTavern [CREATE-BACKUP]\007"
    # Define the backup file name with a formatted date and time
    formatted_date=$(date +'%Y-%m-%d_%H%M')
    backup_file="backups/backup_$formatted_date.tar.gz"

    # Create the backup using tar
    tar -czvf "$backup_file" \
        "public/assets/" \
        "public/Backgrounds/" \
        "public/Characters/" \
        "public/Chats/" \
        "public/context/" \
        "public/Group chats/" \
        "public/Groups/" \
        "public/instruct/" \
        "public/KoboldAI Settings/" \
        "public/movingUI/" \
        "public/NovelAI Settings/" \
        "public/OpenAI Settings/" \
        "public/QuickReplies/" \
        "public/TextGen Settings/" \
        "public/themes/" \
        "public/User Avatars/" \
        "public/user/" \
        "public/worlds/" \
        "public/settings.json" \
        "secrets.json"

    echo -e "${green_fg_strong}Backup created successfully!${reset}"

    read -p "Press Enter to continue..."
    backup_menu
}


restore_backup() {
    echo -e "\033]0;SillyTavern [RESTORE-BACKUP]\007"
    # List available backups
    echo "List of available backups:"
    echo "========================"

    backup_count=0
    backup_files=()

    for file in backups/backup_*.tar.gz; do
        backup_count=$((backup_count + 1))
        backup_files+=("$file")
        echo -e "$backup_count. ${cyan_fg_strong}$(basename "$file")${reset}"
    done

    echo "========================"
    read -p "Enter the number of the backup to restore: " restore_choice

    if [ "$restore_choice" -ge 1 ] && [ "$restore_choice" -le "$backup_count" ]; then
        selected_backup="${backup_files[restore_choice - 1]}"
        echo "Restoring backup $selected_backup..."

        # Extract the contents of the backup to a temporary directory
        temp_dir=$(mktemp -d)
        tar -xzvf "$selected_backup" -C "$temp_dir"

        # Copy the restored files to the appropriate location
        rsync -av "$temp_dir/public/" "public/"

        # Clean up the temporary directory
        rm -r "$temp_dir"

        echo -e "${green_fg_strong}$selected_backup restored successfully.${reset}"
    else
        echo -e "${yellow_fg_strong}WARNING: Invalid backup number. Please insert a valid number.${reset}"
    fi

    read -p "Press Enter to continue..."
    backup_menu
}

############################################################
################# BACKUP - FRONTEND ########################
############################################################
backup_menu() {
    echo -e "\033]0;SillyTavern [BACKUP]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Backup${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. Create Backup"
    echo "2. Restore Backup"
    echo "0. Back to Home"

    read -p "Choose Your Destiny: " backup_choice

################# BACKUP - BACKEND ########################
    case $backup_choice in
        1) create_backup ;;
        2) restore_backup ;;
        0) home ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           backup_menu ;;
    esac
}


# Function to switch to the Release branch in SillyTavern
switch_release_st() {
    log_message "INFO" "Switching to release branch..."
    git switch release
    read -p "Press Enter to continue..."
    switch_branch_menu
}

# Function to switch to the Staging branch in SillyTavern
switch_staging_st() {
    log_message "INFO" "Switching to staging branch..."
    git switch staging
    read -p "Press Enter to continue..."
    switch_branch_menu
}


############################################################
############## SWITCH BRANCE - FRONTEND ####################
############################################################
switch_branch_menu() {
    echo -e "\033]0;SillyTavern [SWITCH-BRANCE]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Switch Branch${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. Switch to Release - SillyTavern"
    echo "2. Switch to Staging - SillyTavern"
    echo "0. Back to Home"

    current_branch=$(git branch --show-current)
    echo "======== VERSION STATUS ========"
    echo -e "SillyTavern branch: ${cyan_fg_strong}$current_branch${reset}"
    echo -e "Extras branch: ${cyan_fg_strong}$current_branch${reset}"
    echo "================================"

    read -p "Choose Your Destiny: " branch_choice

################# SWITCH BRANCE - BACKEND ########################
    case $branch_choice in
        1) switch_release_st ;;
        2) switch_staging_st ;;
        0) home ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           switch_branch_menu ;;
    esac
}



# Function to install p7zip (7-Zip)
install_p7zip() {
    if ! command -v 7z &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}p7zip (7-Zip) is not installed on this system${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Installing p7zip (7-Zip) using apt..."
            sudo apt-get update
            sudo apt-get install -y p7zip-full
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Installing p7zip (7-Zip) using yum..."
            sudo yum install -y p7zip p7zip-plugins
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Installing p7zip (7-Zip) using apk..."
            sudo apk add p7zip
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Installing p7zip (7-Zip) using pacman..."
            sudo pacman -Sy --noconfirm p7zip
        elif command -v emerge &>/dev/null; then
            # Gentoo Linux-based system
            log_message "INFO" "Installing p7zip (7-Zip) using emerge..."
            sudo emerge --ask app-arch/p7zip
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}p7zip (7-Zip) is installed.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}p7zip (7-Zip) is already installed.${reset}"
    fi
}

# Function to install FFmpeg
install_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}FFmpeg is not installed on this system${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Installing FFmpeg using apt..."
            sudo apt-get update
            sudo apt-get install -y ffmpeg
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Installing FFmpeg using yum..."
            sudo yum install -y ffmpeg
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Installing FFmpeg using apk..."
            sudo apk add ffmpeg
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Installing FFmpeg using pacman..."
            sudo pacman -Sy --noconfirm ffmpeg
        elif command -v emerge &>/dev/null; then
            # Gentoo Linux-based system
            log_message "INFO" "Installing FFmpeg using emerge..."
            sudo emerge --ask media-video/ffmpeg
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}FFmpeg is installed.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}FFmpeg is already installed.${reset}"
    fi
}

# Function to install Node.js
install_nodejs() {
    if ! command -v node &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}Node.js is not installed on this system${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Installing Node.js using apt..."
            curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Installing Node.js using yum..."
            curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
            sudo yum install -y nodejs
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Installing Node.js using apk..."
            sudo apk add nodejs npm
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Installing Node.js using pacman..."
            sudo pacman -Sy --noconfirm nodejs npm
        elif command -v emerge &>/dev/null; then
            # Gentoo Linux-based system
            log_message "INFO" "Installing Node.js using emerge..."
            sudo emerge --ask nodejs
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}Node.js is installed.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}Node.js is already installed.${reset}"
    fi
}


############################################################
############## APP INSTALLER - FRONTEND ####################
############################################################
app_installer() {
    echo -e "\033]0;SillyTavern [APP INSTALLER]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / App Installer${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. Install 7-Zip"
    echo "2. Install FFmpeg"
    echo "3. Install Node.js"
    echo "0. Back to Toolbox"

    read -p "Choose Your Destiny: " app_installer_choice

################# APP INSTALLER - BACKEND #######################
    case $app_installer_choice in
        1) install_p7zip ;;
        2) install_ffmpeg ;;
        3) install_nodejs ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           app_installer ;;
    esac
}

# Function to uninstall Extras
uninstall_extras() {
    echo
    echo -e "${red_bg}╔════ DANGER ZONE ═══════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${red_bg}║ WARNING: This will delete all data in Extras                                       ║${reset}"
    echo -e "${red_bg}║ If you want to keep any data, make sure to create a backup before proceeding.      ║${reset}"
    echo -e "${red_bg}╚════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo
    echo -n "Are you sure you want to proceed? [Y/N]: "
    read confirmation

    if [ "$confirmation" = "Y" ] || [ "$confirmation" = "y" ]; then
        cd "$(dirname "$0")"
        log_message "INFO" "Removing the SillyTavern-extras directory..."
        rm -rf SillyTavern-extras
        log_message "INFO" "Removing the Conda environment: extras"
        conda remove --name extras --all -y

        log_message "INFO" "${green_fg_strong}Extras uninstalled successfully.${reset}"
    else
        echo "Uninstall canceled."
    fi
    pause
    app_uninstaller
}

# Function to uninstall XTTS
uninstall_xtts() {
    echo
    echo -e "${red_bg}╔════ DANGER ZONE ═══════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${red_bg}║ WARNING: This will delete all data in XTTS                                         ║${reset}"
    echo -e "${red_bg}║ If you want to keep any data, make sure to create a backup before proceeding.      ║${reset}"
    echo -e "${red_bg}╚════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo
    echo -n "Are you sure you want to proceed? [Y/N]: "
    read confirmation

    if [ "$confirmation" = "Y" ] || [ "$confirmation" = "y" ]; then
        cd "$(dirname "$0")"
        log_message "INFO" "Removing the xtts directory..."
        rm -rf xtts
        log_message "INFO" "Removing the Conda environment: xtts"
        conda remove --name xtts --all -y

        log_message "INFO" "${green_fg_strong}XTTS uninstalled successfully.${reset}"
    else
        echo "Uninstall canceled."
    fi
    pause
    app_uninstaller
    
}


# Function to uninstall SillyTavern
uninstall_st() {
    echo
    echo -e "${red_bg}╔════ DANGER ZONE ═══════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${red_bg}║ WARNING: This will delete all data in SillyTavern                                  ║${reset}"
    echo -e "${red_bg}║ If you want to keep any data, make sure to create a backup before proceeding.      ║${reset}"
    echo -e "${red_bg}╚════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo
    echo -n "Are you sure you want to proceed? [Y/N]: "
    read confirmation

    if [ "$confirmation" = "Y" ] || [ "$confirmation" = "y" ]; then
        cd "$(dirname "$0")"
        log_message "INFO" "Removing the SillyTavern directory..."
        rm -rf SillyTavern
        log_message "INFO" "${green_fg_strong}SillyTavern uninstalled successfully.${reset}"
    else
        echo "Uninstall canceled."
    fi
    pause
    app_uninstaller
}


# Function to uninstall p7zip (7-Zip)
uninstall_p7zip() {
    if command -v 7z &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}p7zip (7-Zip) is installed on this system${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Uninstalling p7zip (7-Zip) using apt..."
            sudo apt-get remove --purge -y p7zip p7zip-full
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Uninstalling p7zip (7-Zip) using yum..."
            sudo yum remove -y p7zip p7zip-plugins
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Uninstalling p7zip (7-Zip) using apk..."
            sudo apk del p7zip
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Uninstalling p7zip (7-Zip) using pacman..."
            sudo pacman -Rns --noconfirm p7zip
        elif command -v emerge &>/dev/null; then
            # Gentoo Linux-based system
            log_message "INFO" "Uninstalling p7zip (7-Zip) using emerge..."
            sudo emerge --unmerge p7zip
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}p7zip (7-Zip) is uninstalled.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}p7zip (7-Zip) is not installed.${reset}"
    fi
}

# Function to uninstall FFmpeg
uninstall_ffmpeg() {
    if command -v ffmpeg &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}FFmpeg is installed on this system${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Uninstalling FFmpeg using apt..."
            sudo apt-get remove --purge -y ffmpeg
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Uninstalling FFmpeg using yum..."
            sudo yum remove -y ffmpeg
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Uninstalling FFmpeg using apk..."
            sudo apk del ffmpeg
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Uninstalling FFmpeg using pacman..."
            sudo pacman -Rns --noconfirm ffmpeg
        elif command -v emerge &>/dev/null; then
            # Gentoo Linux-based system
            log_message "INFO" "Uninstalling FFmpeg using emerge..."
            sudo emerge --unmerge ffmpeg
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}FFmpeg is uninstalled.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}FFmpeg is not installed.${reset}"
    fi
}


# Function to uninstall Node.js and npm
uninstall_nodejs() {
    if command -v node &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}Node.js is installed on this system${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Uninstalling Node.js using apt..."
            sudo apt-get remove --purge -y nodejs npm
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Uninstalling Node.js using yum..."
            sudo yum remove -y nodejs npm
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Uninstalling Node.js using apk..."
            sudo apk del nodejs npm
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Uninstalling Node.js using pacman..."
            sudo pacman -Rns --noconfirm nodejs npm
        elif command -v emerge &>/dev/null; then
            # Gentoo Linux-based system
            log_message "INFO" "Uninstalling Node.js using emerge..."
            sudo emerge --unmerge nodejs
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}Node.js and npm are uninstalled.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}Node.js is not installed.${reset}"
    fi
}

# Function to uninstall Git
uninstall_git() {
    if command -v git &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}Git is installed on this system${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Uninstalling Git using apt..."
            sudo apt-get remove --purge -y git
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Uninstalling Git using yum..."
            sudo yum remove -y git
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Uninstalling Git using apk..."
            sudo apk del git
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Uninstalling Git using pacman..."
            sudo pacman -Rns --noconfirm git
        elif command -v emerge &>/dev/null; then
            # Gentoo Linux-based system
            log_message "INFO" "Uninstalling Git using emerge..."
            sudo emerge --unmerge dev-vcs/git
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}Git is uninstalled.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}Git is not installed.${reset}"
    fi
}
############################################################
############## APP UNINSTALLER - FRONTEND ##################
############################################################
app_uninstaller() {
    echo -e "\033]0;SillyTavern [APP UNINSTALLER]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / App Uninstaller${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. UNINSTALL Extras"
    echo "2. UNINSTALL XTTS"
    echo "3. UNINSTALL SillyTavern"
    echo "4. UNINSTALL 7-Zip"
    echo "5. UNINSTALL FFmpeg"
    echo "6. UNINSTALL Node.js"
    echo "7. UNINSTALL git"
    echo "0. Back to Toolbox"

    read -p "Choose Your Destiny: " app_uninstaller_choice

################# APP UNINSTALLER - BACKEND #######################
    case $app_uninstaller_choice in
        1) uninstall_extras ;;
        2) uninstall_xtts ;;
        3) uninstall_st ;;
        4) uninstall_p7zip ;;
        5) uninstall_ffmpeg ;;
        6) uninstall_nodejs ;;
        7) uninstall_git ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           app_uninstaller ;;
    esac
}


# Function to print module options with color based on their status
printModule() {
    if [ "$2" == "true" ]; then
        echo -e "\e[32;1m$1 [Enabled]\e[0m"
    else
        echo -e "\e[31;1m$1 [Disabled]\e[0m"
    fi
}

# Function to edit extras modules
edit_extras_modules() {
    echo -e "\033]0;SillyTavern [EDIT-MODULES]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / Editor / Edit Extras Modules${reset}"
    echo "-------------------------------------"
    echo "Choose extras modules to enable or disable (e.g., \"1 2 4\" to enable Cuda, RVC, and Caption)"

    # Display module options with colors based on their status
    printModule "1. Cuda (--gpu 0 --cuda --cuda-device=0)" "$cuda_trigger"
    printModule "2. RVC (--enable-modules=rvc --rvc-save-file --max-content-length=1000)" "$rvc_trigger"
    printModule "3. talkinghead (--enable-modules=talkinghead)" "$talkinghead_trigger"
    printModule "4. caption (--enable-modules=caption)" "$caption_trigger"
    printModule "5. summarize (--enable-modules=summarize)" "$summarize_trigger"
    printModule "6. listen (--listen)" "$listen_trigger"
    printModule "7. Edge TTS (--enable-modules=edge-tts)" "$edge_tts_trigger"
    echo "0. Back to Toolbox"

    set "python_command="

    read -p "Choose modules to enable/disable (1-6): " module_choices

    # Handle the user's module choices and construct the Python command
    for i in $module_choices; do
        case $i in
            1) [ "$cuda_trigger" == "true" ] && cuda_trigger=false || cuda_trigger=true ;;
            2) [ "$rvc_trigger" == "true" ] && rvc_trigger=false || rvc_trigger=true ;;
            3) [ "$talkinghead_trigger" == "true" ] && talkinghead_trigger=false || talkinghead_trigger=true ;;
            4) [ "$caption_trigger" == "true" ] && caption_trigger=false || caption_trigger=true ;;
            5) [ "$summarize_trigger" == "true" ] && summarize_trigger=false || summarize_trigger=true ;;
            6) [ "$listen_trigger" == "true" ] && listen_trigger=false || listen_trigger=true ;;
            7) [ "$edge_tts_trigger" == "true" ] && edge_tts_trigger=false || edge_tts_trigger=true ;;
            0) toolbox ;;
        esac
    done

    # Save the module flags to modules.txt
    modules_file="$(dirname "$0")/modules.txt"
    echo "cuda_trigger=$cuda_trigger" > "$modules_file"
    echo "rvc_trigger=$rvc_trigger" >> "$modules_file"
    echo "talkinghead_trigger=$talkinghead_trigger" >> "$modules_file"
    echo "caption_trigger=$caption_trigger" >> "$modules_file"
    echo "summarize_trigger=$summarize_trigger" >> "$modules_file"
    echo "listen_trigger=$listen_trigger" >> "$modules_file"
    echo "edge_tts_trigger=$edge_tts_trigger" >> "$modules_file"

    # Compile the Python command
    python_command="python server.py"
    [ "$listen_trigger" == "true" ] && python_command+=" --listen"
    [ "$cuda_trigger" == "true" ] && python_command+=" --gpu 0 --cuda --cuda-device=0 "
    [ "$rvc_trigger" == "true" ] && python_command+=" --rvc-save-file --max-content-length=1000"
    modules_enable=""
    [ "$talkinghead_trigger" == "true" ] && modules_enable+="talkinghead,"
    [ "$caption_trigger" == "true" ] && modules_enable+="caption,"
    [ "$summarize_trigger" == "true" ] && modules_enable+="summarize,"
    [ "$edge_tts_trigger" == "true" ] && modules_enable+="edge-tts,"

    # Remove the last comma from modules_enable
    modules_enable="${modules_enable%,}"

    # Save the constructed Python command to modules.txt for testing
    echo "start_command=$python_command --enable-modules=$modules_enable" >> "$modules_file"
    edit_extras_modules
}

# Function to edit XTTS modules
edit_xtts_modules() {
    echo -e "\033]0;SillyTavern [EDIT-XTTS-MODULES]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / Editor / Edit XTTS Modules${reset}"
    echo "-------------------------------------"
    echo "Choose XTTS modules to enable or disable (e.g., "1 2 4" to enable Cuda, hs, and cache)"

    # Display module options with colors based on their status
    printModule "1. cuda (--device cuda)" "$xtts_cuda_trigger"
    printModule "2. hs (-hs 0.0.0.0)" "$xtts_hs_trigger"
    printModule "3. deepspeed (--deepspeed)" "$xtts_deepspeed_trigger"
    printModule "4. cache (--use-cache)" "$xtts_cache_trigger"
    printModule "5. listen (--listen)" "$xtts_listen_trigger"
    printModule "6. model (--model-source local)" "$xtts_model_trigger"
    echo "0. Back to Editor"s

    set "python_command="

    read -p "Choose modules to enable/disable (1-6): " module_choices

    # Handle the user's module choices and construct the Python command
    for i in $module_choices; do
        case $i in
            1) [ "$xtts_cuda_trigger" == "true" ] && xtts_cuda_trigger=false || xtts_cuda_trigger=true ;;
            2) [ "$xtts_hs_trigger" == "true" ] && xtts_hs_trigger=false || xtts_hs_trigger=true ;;
            3) [ "$xtts_deepspeed_trigger" == "true" ] && xtts_deepspeed_trigger=false || xtts_deepspeed_trigger=true ;;
            4) [ "$xtts_cache_trigger" == "true" ] && xtts_cache_trigger=false || xtts_cache_trigger=true ;;
            5) [ "$xtts_listen_trigger" == "true" ] && xtts_listen_trigger=false || xtts_listen_trigger=true ;;
            6) [ "$xtts_model_trigger" == "true" ] && xtts_model_trigger=false || xtts_model_trigger=true ;;
            0) editor ;;
        esac
    done

    # Save the module flags to modules-xtts.txt
    modules_file="$(dirname "$0")/modules-xtts.txt"
    echo "xtts_cuda_trigger=$xtts_cuda_trigger" > "$modules_file"
    echo "xtts_hs_trigger=$xtts_hs_trigger" >> "$modules_file"
    echo "xtts_deepspeed_trigger=$xtts_deepspeed_trigger" >> "$modules_file"
    echo "xtts_cache_trigger=$xtts_cache_trigger" >> "$modules_file"
    echo "xtts_listen_trigger=$xtts_listen_trigger" >> "$modules_file"
    echo "xtts_model_trigger=$xtts_model_trigger" >> "$modules_file"

    # Compile the Python command
    python_command="python server.py"
    [ "$xtts_cuda_trigger" == "true" ] && python_command+=" --device cuda"
    [ "$xtts_hs_trigger" == "true" ] && python_command+=" -hs 0.0.0.0"
    [ "$xtts_deepspeed_trigger" == "true" ] && python_command+=" --deepspeed"
    [ "$xtts_cache_trigger" == "true" ] && python_command+=" --use-cache"
    [ "$xtts_listen_trigger" == "true" ] && python_command+=" --listen"
    [ "$xtts_model_trigger" == "true" ] && python_command+=" --model-source local"

    # Save the constructed Python command to modules.txt for testing
    echo "start_command=$python_command" >> "$modules_file"
    edit_xtts_modules
}


# Function to edit environment variables
edit_environment_var() {
    # Open the environment variables file for editing
    if [ -f ~/.bashrc ]; then
        # Use your preferred text editor (e.g., nano, vim, or gedit)
        nano ~/.bashrc
    else
        echo "Environment file not found. Create or specify the correct file path."
    fi

    # Provide instructions to the user
    echo "Edit your environment variables. Save and exit the editor when done."

    # Optionally, ask the user to reload the environment
    read -p "Do you want to reload the environment? (Y/N): " reload
    if [ "$reload" = "Y" ] || [ "$reload" = "y" ]; then
        source ~/.bashrc  # Reload the environment (may vary based on your shell)
        echo "Environment reloaded."
    fi
}


edit_st_config() {
    # Check if nano is available
    if ! command -v nano &>/dev/null; then
        echo "Error: Nano is not installed. Please install Nano to edit config.yaml"
        exit 1
    fi
    # Open config.yaml file in nano
    nano "$(dirname "$0")/SillyTavern/config.yaml"
}

############################################################
############## EDITOR - FRONTEND ###########################
############################################################
editor() {
    echo -e "\033]0;SillyTavern [EDITOR]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / Editor${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. Edit Extras Modules"
    echo "2. Edit XTTS Modules"
    echo "3. Edit Environment Variables"
    echo "4. Edit SillyTavern config.yaml"
    echo "0. Back to Toolbox"

    read -p "Choose Your Destiny: " editor_choice

################# EDITOR - BACKEND #########################
    case $editor_choice in
        1) edit_extras_modules ;;
        2) edit_xtts_modules ;;
        3) edit_environment_var ;;
        4) edit_st_config ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           editor ;;
    esac
}


# Function to remove node modules folder
remove_node_modules() {
    log_message "INFO" "Removing node_modules folder..."
    cd "$(dirname "$0")./SillyTavern"
    rm -rf node_modules package-lock.json
    npm cache clean --force
    log_message "INFO" "node_modules successfully removed."
    read -p "Press Enter to continue..."
    troubleshooting
}

unresolved_unmerged() {
    log_message "INFO" "Trying to resolve unresolved conflicts in the working directory or unmerged files..."
    cd "$(dirname "$0")./SillyTavern"
    git merge --abort
    git reset --hard
    git pull --rebase --autostash
    read -p "Press Enter to continue..."
    troubleshooting
}

export_system_info() {
    log_message "INFO" "Exporting system information..."
    lshw > "$(dirname "$0")/system_info.txt"
    log_message "INFO" "You can find the system_info.txt at: $(dirname "$0")/system_info.txt"
    read -p "Press Enter to continue..."
    troubleshooting
}

# Function to find and display the application using the specified port
find_app_port() {
    clear
    read -p "Insert port number: " port

    # Check if the input is a number
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        log_message "ERROR" "Invalid input: Not a number."
        read -p "Press Enter to continue..."
        find_app_port
    fi

    # Check if the port is within range
    if (( port > 65535 )); then
        log_message "ERROR" "Port out of range. There are only 65,535 possible port numbers."
        echo "[0-1023]: These ports are reserved for system services or commonly used protocols."
        echo "[1024-49151]: These ports can be used by user processes or applications."
        echo "[49152-65535]: These ports are available for use by any application or service on the system."
        read -p "Press Enter to continue..."
        find_app_port
    fi

    log_message "INFO" "Searching for application using port: $port..."
    pid=$(netstat -tuln | awk '{print $4}' | grep ":$port" | awk -F'/' '{print $NF}')

    if [[ -n "$pid" ]]; then
        app_name=$(ps -p $pid -o comm=)
        echo -e "Application Name: \e[36;1m$app_name\e[0m"
        echo -e "PID of Port $port: \e[36;1m$pid\e[0m"
    else
        log_message "WARN" "Port: $port not found."
        read -p "Press Enter to continue..."
        find_app_port
    fi

    read -p "Press Enter to continue..."
    troubleshooting
}

onboarding_flow() {
    read -p "Enter new value for Onboarding Flow (true/false): " onboarding_flow_value
    if [[ "$onboarding_flow_value" != "true" && "$onboarding_flow_value" != "false" ]]; then
        log_message "WARN" "Invalid input. Please enter 'true' or 'false'."
        read -p "Press Enter to continue..."
        onboarding_flow
    fi
    sed -i "s/\"firstRun\": .*/\"firstRun\": $onboarding_flow_value,/" "$PWD/SillyTavern/public/settings.json"
    log_message "INFO" "Value of 'firstRun' in settings.json has been updated to $onboarding_flow_value."
    read -p "Press Enter to continue..."
    troubleshooting
}

############################################################
############## TROUBLESHOOTING - FRONTEND ##################
############################################################
troubleshooting() {
    echo -e "\033]0;SillyTavern [TROUBLESHOOTING]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / Troubleshooting${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. Remove node_modules folder"
    echo "2. Fix unresolved conflicts or unmerged files [SillyTavern]"
    echo "3. Export system info"
    echo "4. Find what app is using port"
    echo "5. Set Onboarding Flow"
    echo "0. Back to Toolbox"

    read -p "Choose Your Destiny: " troubleshooting_choice

################# TROUBLESHOOTING - BACKEND ################
    case $troubleshooting_choice in
        1) remove_node_modules ;;
        2) unresolved_unmerged ;;
        3) export_system_info ;;
        4) find_app_port ;;
        5) onboarding_flow ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           troubleshooting ;;
    esac
}


############################################################
################# TOOLBOX - FRONTEND #######################
############################################################
toolbox() {
    echo -e "\033]0;SillyTavern [TOOLBOX]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. App Installer"
    echo "2. App Uninstaller"
    echo "3. Editor"
    echo "4. Troubleshooting"
    echo "0. Back to Home"

    read -p "Choose Your Destiny: " toolbox_choice

################# TOOLBOX - BACKEND #######################
    case $toolbox_choice in
        1) app_installer ;;
        2) app_uninstaller ;;
        3) editor ;;
        4) troubleshooting ;;
        0) home ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           toolbox ;;
    esac
}


issue_report() {
    if [ "$EUID" -eq 0 ]; then
        log_message "ERROR" "${red_fg_strong}Cannot run xdg-open as root. Please run the script without root permission.${reset}"
    else
        if [ "$(uname -s)" == "Darwin" ]; then
            open https://github.com/SillyTavern/SillyTavern-Launcher/issues/new/choose
        else
            xdg-open https://github.com/SillyTavern/SillyTavern-Launcher/issues/new/choose
        fi
    fi
    read -p "Press Enter to continue..."
    support
}

documentation() {
    if [ "$EUID" -eq 0 ]; then
        log_message "ERROR" "${red_fg_strong}Cannot run xdg-open as root. Please run the script without root permission.${reset}"
    else
        if [ "$(uname -s)" == "Darwin" ]; then
            open https://docs.sillytavern.app/
        else
            xdg-open https://docs.sillytavern.app/
        fi
    fi
    read -p "Press Enter to continue..."
    support
}

discord() {
    if [ "$EUID" -eq 0 ]; then
        log_message "ERROR" "${red_fg_strong}Cannot run xdg-open as root. Please run the script without root permission.${reset}"
    else
        if [ "$(uname -s)" == "Darwin" ]; then
            open https://discord.gg/sillytavern
        else
            xdg-open https://discord.gg/sillytavern
        fi
    fi
    read -p "Press Enter to continue..."
    support
}


############################################################
############## SUPPORT - FRONTEND ##########################
############################################################
support() {
    echo -e "\033]0;SillyTavern [SUPPORT]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Support${reset}"
    echo "------------------------------------------------"
    echo "What would you like to do?"
    echo "1. I want to report an issue"
    echo "2. Documentation"
    echo "3. Discord"
    echo "0. Back to Home"

    read -p "Choose Your Destiny: " support_choice

############## SUPPORT - BACKEND ##########################
    case $support_choice in
        1) issue_report ;;
        2) documentation ;;
        3) discord ;;
        0) home ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           support ;;
    esac
}

# Check if the script is running on macOS
if [ "$(uname)" == "Darwin" ]; then
    IS_MACOS="1"
fi

# Detect the package manager and execute the appropriate installation
if [ -n "$IS_MACOS" ]; then
    log_message "INFO" "${blue_fg_strong}Detected macOS system.${reset}"
    # macOS
    install_git
    install_nodejs
    home
# Detect the package manager and execute the appropriate installation
elif command -v apt-get &>/dev/null; then
    log_message "INFO" "Detected Debian/Ubuntu-based system.${reset}"
    # Debian/Ubuntu
    install_git
    install_nodejs
    home
elif command -v yum &>/dev/null; then
    log_message "INFO" "Detected Red Hat/Fedora-based system.${reset}"
    # Red Hat/Fedora
    install_git
    install_nodejs
    home
elif command -v apk &>/dev/null; then
    log_message "INFO" "Detected Alpine Linux-based system.${reset}"
    # Alpine Linux
    install_git
    install_nodejs
    home
elif command -v pacman &>/dev/null; then
    log_message "INFO" "Detected Arch Linux-based system.${reset}"
    # Arch Linux
    install_git
    install_nodejs
    home
elif command -v emerge &>/dev/null; then
    log_message "INFO" "Detected Gentoo Linux-based system. Now you are the real CHAD${reset}"
    # Gentoo Linux
    install_git
    install_nodejs
    home
else
    log_message "ERROR" "${red_fg_strong}Unsupported package manager. Cannot detect Linux distribution.${reset}"
    exit 1
fi
