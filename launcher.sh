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

# Function for the home
home() {
    echo -e "\033]0;SillyTavern [HOME]\007"
    clear
    echo -e "${blue_fg_strong}/ Home${reset}"
    echo "-------------------------------------"
    echo "What would you like to do?"
    echo "1. Start SillyTavern"
    echo "2. Start SillyTavern + Extras"
    echo "3. Update"
    echo "4. Backup"
    echo "5. Switch branch"
    echo "6. Toolbox"
    echo "7. Exit"

    echo "======== VERSION STATUS ========"
    echo -e "SillyTavern branch: ${cyan_fg_strong}$current_branch${reset}"
    echo -e "Update Status: $update_status"
    echo "================================"

    read -p "Choose Your Destiny: " home_choice

    # Default to choice 1 if no input is provided
    if [ -z "$home_choice" ]; then
      home_choice=1
    fi

    # Home menu - Backend
    case $home_choice in
        1) start_st ;;
        2) start_st_extras ;;
        3) update ;;
        4) backup_menu ;;
        5) switch_branch_menu ;;
        6) toolbox ;;
        7) exit ;;
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
find_terminal() {
    for terminal in "$TERMINAL" x-terminal-emulator mate-terminal gnome-terminal terminator xfce4-terminal urxvt rxvt termit Eterm aterm uxterm xterm roxterm termite lxterminal terminology st qterminal lilyterm tilix terminix konsole kitty guake tilda alacritty hyper wezterm; do
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
start_st() {
    check_nodejs
    log_message "INFO" "SillyTavern launched in a new window."
    # Find a suitable terminal
    local detected_terminal
    detected_terminal=$(find_terminal)
    log_message "INFO" "Found terminal: $detected_terminal"
    # Enable read p command for troubleshooting    
#    read -p "Press Enter to continue..."
    # Start SillyTavern in the detected terminal
    exec "$detected_terminal" -e "cd $(dirname "$0")./SillyTavern && ./start.sh" &

    home
}

# Function to start SillyTavern with Extras
start_st_extras() {
    check_nodejs
    log_message "INFO" "SillyTavern launched in a new window."
    log_message "INFO" "Extras launched in a new window."
    # Find a suitable terminal
    local detected_terminal
    detected_terminal=$(find_terminal)
    log_message "INFO" "Found terminal: $detected_terminal"
    # Enable read p command for troubleshooting    
#    read -p "Press Enter to continue..."
    # Start SillyTavern + extras in the detected terminal
    exec "$detected_terminal" -e "cd $(dirname "$0")./SillyTavern && ./start.sh" &
    exec "$detected_terminal" -e "cd $(dirname "$0")./SillyTavern-extras && ./start.sh" &

    home
}


# Function to update
update() {
    echo -e "\033]0;SillyTavern [UPDATE]\007"
    log_message "INFO" "Updating SillyTavern..."
    cd "$(dirname "$0")./SillyTavern" || exit 1

    # Check if Git is installed
    if git --version > /dev/null 2>&1; then
        git pull --rebase --autostash
        if [ $? -ne 0 ]; then
            # In case there are errors while updating
            echo "There were errors while updating. Please download the latest version manually."
        fi
    else
        echo -e "${red_fg_strong}[ERROR] git command not found in PATH. Skipping update.${reset}"
        echo -e "${red_bg}Please make sure Git is installed and added to your PATH.${reset}"
        echo -e "${blue_bg}To install Git, go to Toolbox.${reset}"
    fi

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

# Function for backup
backup_menu() {
    echo -e "\033]0;SillyTavern [BACKUP]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Backup${reset}"
    echo "-------------------------------------"
    echo "What would you like to do?"
    echo "1. Create Backup"
    echo "2. Restore Backup"
    echo "3. Back to Home"

    read -p "Choose Your Destiny: " backup_choice

    # Backup menu - Backend
    case $backup_choice in
        1) create_backup ;;
        2) restore_backup ;;
        3) home ;;
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

# Function for switching branches
switch_branch_menu() {
    echo -e "\033]0;SillyTavern [SWITCH-BRANCE]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Switch Branch${reset}"
    echo "-------------------------------------"
    echo "What would you like to do?"
    echo "1. Switch to Release - SillyTavern"
    echo "2. Switch to Staging - SillyTavern"
    echo "3. Back to Home"

    current_branch=$(git branch --show-current)
    echo "======== VERSION STATUS ========"
    echo -e "SillyTavern branch: ${cyan_fg_strong}$current_branch${reset}"
    echo -e "Extras branch: ${cyan_fg_strong}$current_branch${reset}"
    echo "================================"

    read -p "Choose Your Destiny: " branch_choice

    # switch branch menu - Backend
    case $branch_choice in
        1) switch_release_st ;;
        2) switch_staging_st ;;
        3) home ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           switch_branch_menu ;;
    esac
}

# Function to edit environment variables
edit_environment() {
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

# Function to reinstall SillyTavern
reinstall_sillytavern() {
    local script_name=$(basename "$0")
    local excluded_folders="backups"
    local excluded_files="$script_name"

    echo
    echo -e "${red_bg}╔════ DANGER ZONE ═══════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${red_bg}║ WARNING: This will delete all data in the current branch except the Backups.   ║${reset}"
    echo -e "${red_bg}║ If you want to keep any data, make sure to create a backup before proceeding.  ║${reset}"
    echo -e "${red_bg}╚════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo
    echo -n "Are you sure you want to proceed? [Y/N]: "
    read confirmation

    if [ "$confirmation" = "Y" ] || [ "$confirmation" = "y" ]; then
        cd "$PWD/SillyTavern"

        # Remove non-excluded folders
        for dir in *; do
            exclude_folder=false
            for excluded_folder in $excluded_folders; do
                if [ "$dir" = "$excluded_folder" ]; then
                    exclude_folder=true
                    break
                fi
            done
            if [ "$exclude_folder" = "false" ]; then
                rm -r "$dir" 2>/dev/null
            fi
        done

        # Remove non-excluded files
        for file in *; do
            exclude_file=false
            for excluded_file in $excluded_files; do
                if [ "$file" = "$excluded_file" ]; then
                    exclude_file=true
                    break
                fi
            done
            if [ "$exclude_file" = "false" ]; then
                rm -f "$file" 2>/dev/null
            fi
        done

        # Clone repo into a temporary folder
        git clone https://github.com/SillyTavern/SillyTavern.git "/tmp/SillyTavern-TEMP"

        # Move the contents of the temporary folder to the current directory
        cp -r /tmp/SillyTavern-TEMP/* .

        # Clean up the temporary folder
        rm -r /tmp/SillyTavern-TEMP

        echo -e "${green_fg_strong}SillyTavern reinstalled successfully!${reset}"
    else
        echo "Reinstall canceled."
    fi

    pause
    toolbox
}

# Function to reinstall SillyTavern Extras
reinstall_extras() {
    local script_name=$(basename "$0")
    local excluded_folders="backups"
    local excluded_files="$script_name"

    echo
    echo -e "${red_bg}╔════ DANGER ZONE ═══════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${red_bg}║ WARNING: This will delete all data in Sillytavern-extras                           ║${reset}"
    echo -e "${red_bg}║ If you want to keep any data, make sure to create a backup before proceeding.      ║${reset}"
    echo -e "${red_bg}╚════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo
    echo -n "Are you sure you want to proceed? [Y/N]: "
    read confirmation

    if [ "$confirmation" = "Y" ] || [ "$confirmation" = "y" ]; then
        cd "$PWD/SillyTavern-extras"

        # Remove non-excluded folders
        for dir in *; do
            exclude_folder=false
            for excluded_folder in $excluded_folders; do
                if [ "$dir" = "$excluded_folder" ]; then
                    exclude_folder=true
                    break
                fi
            done
            if [ "$exclude_folder" = "false" ]; then
                rm -r "$dir" 2>/dev/null
            fi
        done

        # Remove non-excluded files
        for file in *; do
            exclude_file=false
            for excluded_file in $excluded_files; do
                if [ "$file" = "$excluded_file" ]; then
                    exclude_file=true
                    break
                fi
            done
            if [ "$exclude_file" = "false" ]; then
                rm -f "$file" 2>/dev/null
            fi
        done

        # Clone the SillyTavern Extras repository
        git clone https://github.com/SillyTavern/SillyTavern-extras

        echo -e "${green_fg_strong}SillyTavern Extras${reset}"
        echo "---------------------------------------------------------------"
        echo -e "${cyan_fg_strong}This may take a while. Please be patient.${reset}"
        log_message "INFO" "Installing SillyTavern Extras..."

        # Update PATH to include Miniconda
        export PATH="$miniconda_path/bin:$PATH"

        # Activate Conda environment
        log_message "INFO" "Activating Miniconda environment..."
        source $miniconda_path/etc/profile.d/conda.sh

        # Create and activate the Conda environment
        log_message "INFO" "Disabling conda auto activate..."
        conda config --set auto_activate_base false
        conda init bash

        log_message "INFO" "Creating Conda environment extras..."
        conda create -n extras -y

        log_message "INFO" "Activating Conda environment extras..."
        conda activate extras

        log_message "INFO" "Installing Python and Git in the Conda environment..."
        conda install python=3.11 git -y

        log_message "INFO" "Cloning SillyTavern-extras repository..."
        git clone https://github.com/SillyTavern/SillyTavern-extras.git

        cd SillyTavern-extras

        log_message "INFO" "Installing modules from requirements.txt..."
        pip install -r requirements.txt

        log_message "DISCLAIMER" "The installation of Coqui requirements is not recommended unless you have a specific use case. It may conflict with additional dependencies and functionalities to your environment."
        log_message "INFO" "To learn more about Coqui, visit: https://docs.sillytavern.app/extras/installation/#decide-which-module-to-use"

        read -p "Do you want to install Coqui TTS? [Y/N] " install_coqui_requirements

        if [[ "$install_coqui_requirements" == [Yy] ]]; then
            log_message "INFO" "Installing pip requirements-coqui..."
            pip install -r requirements-coqui.txt
        else
            log_message "INFO" "Coqui requirements installation skipped."
        fi

        log_message "INFO" "Installing pip requirements-rvc..."
        pip install -r requirements-rvc.txt

        log_message "INFO" "${green_fg_strong}SillyTavern Extras reinstalled successfully.${reset}"
    else
        echo "Reinstall canceled."
    fi
    pause
    toolbox
}

# Function to uninstall SillyTavern + Extras
uninstall_st_extras() {

    echo
    echo -e "${red_bg}╔════ DANGER ZONE ═══════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${red_bg}║ WARNING: This will delete all data in Sillytavern + Extras                         ║${reset}"
    echo -e "${red_bg}║ If you want to keep any data, make sure to create a backup before proceeding.      ║${reset}"
    echo -e "${red_bg}╚════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo
    echo -n "Are you sure you want to proceed? [Y/N]: "
    read confirmation

    if [ "$confirmation" = "Y" ] || [ "$confirmation" = "y" ]; then
        cd "$PWD"
        log_message "INFO" "Removing the SillyTavern + Sillytavern-extras directory..."
        rm -rf SillyTavern SillyTavern-extras
        log_message "INFO" "Removing the Conda environment 'extras'..."
        conda remove --name extras --all -y

        log_message "INFO" "${green_fg_strong}SillyTavern + Extras uninstalled successfully.${reset}"
    else
        echo "Uninstall canceled."
    fi
    pause
    toolbox
}

toolbox() {
    echo -e "\033]0;SillyTavern [TOOLBOX]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox${reset}"
    echo "-------------------------------------"
    echo "What would you like to do?"
    echo "1. Install 7-Zip"
    echo "2. Install FFmpeg"
    echo "3. Install Node.js"
    echo "4. Edit Environment"
    echo "5. Edit Extras Modules"
    echo "6. Reinstall SillyTavern"
    echo "7. Reinstall Extras"
    echo "8. Uninstall SillyTavern + Extras"
    echo "9. Back to Home"

    read -p "Choose Your Destiny: " toolbox_choice

    case $toolbox_choice in
        1) install_7zip ;;
        2) install_ffmpeg ;;
        3) install_nodejs ;;
        4) edit_environment ;;
        5) edit_extras_modules ;;
        6) reinstall_sillytavern ;;
        7) reinstall_extras ;;
        8) uninstall_st_extras ;;
        9) home ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           toolbox ;;
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
    install_nodejs_npm
    home
# Detect the package manager and execute the appropriate installation
elif command -v apt-get &>/dev/null; then
    log_message "INFO" "Detected Debian/Ubuntu-based system.${reset}"
    # Debian/Ubuntu
    install_git
    install_nodejs_npm
    home
elif command -v yum &>/dev/null; then
    log_message "INFO" "Detected Red Hat/Fedora-based system.${reset}"
    # Red Hat/Fedora
    install_git
    install_nodejs_npm
    home
elif command -v apk &>/dev/null; then
    log_message "INFO" "Detected Alpine Linux-based system.${reset}"
    # Alpine Linux
    install_git
    install_nodejs_npm
    home
elif command -v pacman &>/dev/null; then
    log_message "INFO" "Detected Arch Linux-based system.${reset}"
    # Arch Linux
    install_git
    install_nodejs_npm
    home
elif command -v emerge &>/dev/null; then
    log_message "INFO" "Detected Gentoo Linux-based system. Now you are the real CHAD${reset}"
    # Gentoo Linux
    install_git
    install_nodejs_npm
    home
else
    log_message "ERROR" "${red_fg_strong}Unsupported package manager. Cannot detect Linux distribution.${reset}"
    exit 1
fi