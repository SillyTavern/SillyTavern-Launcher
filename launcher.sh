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

echo -e "\033]0;STL\007"

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

# Environment Variables (miniconda3)
miniconda_path="$HOME/miniconda3"
miniconda_path_mingw="$miniconda_path/Library/mingw-w64/bin"
miniconda_path_usrbin="$miniconda_path/Library/usr/bin"
miniconda_path_bin="$miniconda_path/Library/bin"
miniconda_path_scripts="$miniconda_path/Scripts"

# Environment Variables (FFmpeg)
ffmpeg_download_url="https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z"
ffmpeg_download_path="$(dirname "$0")/bin/ffmpeg.7z"
ffmpeg_install_path="/opt/ffmpeg"
ffmpeg_path_bin="$ffmpeg_install_path/bin"

# Define variables to track module status (EXTRAS)
export extras_modules_path="$(dirname "$0")/bin/settings/modules-extras.txt"
export cuda_trigger="false"
export rvc_trigger="false"
export talkinghead_trigger="false"
export caption_trigger="false"
export summarize_trigger="false"
export listen_trigger="false"
export whisper_trigger="false"
export edge_tts_trigger="false"
export websearch_trigger="false"
if [ -f "$extras_modules_path" ]; then
    while IFS='=' read -r key value; do
        export "$key"="$value"
    done < "$extras_modules_path"
fi

# Define variables to track module status (XTTS)
export xtts_modules_path="$(dirname "$0")/bin/settings/modules-xtts.txt"
export xtts_cuda_trigger="false"
export xtts_hs_trigger="false"
export xtts_deepspeed_trigger="false"
export xtts_cache_trigger="false"
export xtts_listen_trigger="false"
export xtts_model_trigger="false"
if [ -f "$xtts_modules_path" ]; then
    while IFS='=' read -r key value; do
        export "$key"="$value"
    done < "$xtts_modules_path"
fi

# Define variables to track module status (STABLE DIFFUSION WEBUI)
export sdwebui_modules_path="$(dirname "$0")/bin/settings/modules-sdwebui.txt"
export sdwebui_autolaunch_trigger="false"
export sdwebui_api_trigger="false"
export sdwebui_listen_trigger="false"
export sdwebui_port_trigger="false"
export sdwebui_optsdpattention_trigger="false"
export sdwebui_themedark_trigger="false"
export sdwebui_skiptorchcudatest_trigger="false"
export sdwebui_lowvram_trigger="false"
export sdwebui_medvram_trigger="false"
if [ -f "$sdwebui_modules_path" ]; then
    while IFS='=' read -r key value; do
        export "$key"="$value"
    done < "$sdwebui_modules_path"
fi

# Define variables to track module status (STABLE DIFFUSION WEBUI FORGE)
export sdwebuiforge_modules_path="$(dirname "$0")/bin/settings/modules-sdwebuiforge.txt"
export sdwebuiforge_autolaunch_trigger="false"
export sdwebuiforge_api_trigger="false"
export sdwebuiforge_listen_trigger="false"
export sdwebuiforge_port_trigger="false"
export sdwebuiforge_optsdpattention_trigger="false"
export sdwebuiforge_themedark_trigger="false"
export sdwebuiforge_skiptorchcudatest_trigger="false"
export sdwebuiforge_lowvram_trigger="false"
export sdwebuiforge_medvram_trigger="false"
if [ -f "$sdwebuiforge_modules_path" ]; then
    while IFS='=' read -r key value; do
        export "$key"="$value"
    done < "$sdwebuiforge_modules_path"
fi

# Define variables to track module status (TEXT GENERATION WEBUI OOBABOOGA)
export ooba_modules_path="$(dirname "$0")/bin/settings/modules-ooba.txt"
export ooba_autolaunch_trigger="false"
export ooba_extopenai_trigger="false"
export ooba_listen_trigger="false"
export ooba_listenport_trigger="false"
export ooba_apiport_trigger="false"
export ooba_verbose_trigger="false"
if [ -f "$ooba_modules_path" ]; then
    while IFS='=' read -r key value; do
        export "$key"="$value"
    done < "$ooba_modules_path"
fi

# Define variables to track module status (TABBYAPI)
export tabbyapi_modules_path="$(dirname "$0")/bin/settings/modules-tabbyapi.txt"
export tabbyapi_selectedmodelname_trigger="false"
export selected_tabbyapi_model_folder=""

export tabbyapi_ignoreupdate_trigger="false"
export tabbyapi_port_trigger="false"
export tabbyapi_port=""
export tabbyapi_host_trigger="false"
export tabbyapi_maxseqlen_trigger="false"
export tabbyapi_maxseqlen=""
export tabbyapi_ropealpha_trigger=""
export tabbyapi_ropealpha=""
export ttabbyapi_cachemode_trigger=""
export tabbyapi_cachemode=""
export ttabbyapi_updatedeps_trigger=""
if [ -f "$tabbyapi_modules_path" ]; then
    while IFS='=' read -r key value; do
        export "$key"="$value"
    done < "$tabbyapi_modules_path"
fi

# Define variables for install locations (Core Utilities)
stl_root="$(dirname "$(realpath "$0")")"
st_install_path="$stl_root/SillyTavern"
st_package_json_path="$st_install_path/package.json"
extras_install_path="$stl_root/SillyTavern-extras"
st_backup_path="$stl_root/SillyTavern-backups"
NODE_ENV="production"

# Define variables for install locations (Image Generation)
image_generation_dir="$stl_root/image-generation"
sdwebui_install_path="$image_generation_dir/stable-diffusion-webui"
sdwebuiforge_install_path="$image_generation_dir/stable-diffusion-webui-forge"
comfyui_install_path="$image_generation_dir/ComfyUI"
fooocus_install_path="$image_generation_dir/Fooocus"
invokeai_install_path="$image_generation_dir/InvokeAI"
ostrisaitoolkit_install_path="$image_generation_dir/ai-toolkit"

# Define variables for install locations (Text Completion)
text_completion_dir="$stl_root/text-completion"
ooba_install_path="$text_completion_dir/text-generation-webui"
koboldcpp_install_path="$text_completion_dir/dev-koboldcpp"
llamacpp_install_path="$text_completion_dir/dev-llamacpp"
tabbyapi_install_path="$text_completion_dir/tabbyAPI"

# Define variables for install locations (Voice Generation)
voice_generation_dir="$stl_root/voice-generation"
alltalk_install_path="$voice_generation_dir/alltalk_tts"
alltalk_v2_install_path="$voice_generation_dir/alltalk_tts"
xtts_install_path="$voice_generation_dir/xtts"
rvc_install_path="$voice_generation_dir/Retrieval-based-Voice-Conversion-WebUI"

# Define variables for the core directories
bin_dir="$stl_root/bin"
log_dir="$bin_dir/logs"
functions_dir="$bin_dir/functions"

# Define variables for the directories for Toolbox
toolbox_dir="$functions_dir/Toolbox"
troubleshooting_dir="$toolbox_dir/Troubleshooting"
backup_dir="$toolbox_dir/Backup"

# Define variables for the directories for App Installer
app_installer_image_generation_dir="$functions_dir/Toolbox/App_Installer/Image_Generation"
app_installer_text_completion_dir="$functions_dir/Toolbox/App_Installer/Text_Completion"
app_installer_voice_generation_dir="$functions_dir/Toolbox/App_Installer/Voice_Generation"
app_installer_core_utilities_dir="$functions_dir/Toolbox/App_Installer/Core_Utilities"

# Define variables for the directories for App Uninstaller
app_uninstaller_image_generation_dir="$functions_dir/Toolbox/App_Uninstaller/Image_Generation"
app_uninstaller_text_completion_dir="$functions_dir/Toolbox/App_Uninstaller/Text_Completion"
app_uninstaller_voice_generation_dir="$functions_dir/Toolbox/App_Uninstaller/Voice_Generation"
app_uninstaller_core_utilities_dir="$functions_dir/Toolbox/App_Uninstaller/Core_Utilities"

# Define variables for the directories for App Launcher
app_launcher_image_generation_dir="$functions_dir/Toolbox/App_Launcher/Image_Generation"
app_launcher_text_completion_dir="$functions_dir/Toolbox/App_Launcher/Text_Completion"
app_launcher_voice_generation_dir="$functions_dir/Toolbox/App_Launcher/Voice_Generation"
app_launcher_core_utilities_dir="$functions_dir/Toolbox/App_Launcher/Core_Utilities"

# Define variables for the directories for Editor
editor_image_generation_dir="$functions_dir/Toolbox/Editor/Image_Generation"
editor_text_completion_dir="$functions_dir/Toolbox/Editor/Text_Completion"
editor_voice_generation_dir="$functions_dir/Toolbox/Editor/Voice_Generation"
editor_core_utilities_dir="$functions_dir/Toolbox/Editor/Core_Utilities"

# Define variables for logging
st_auto_repair="$log_dir/autorepair-setting.txt"
logs_stl_console_path="$log_dir/stl.log"
logs_st_console_path="$log_dir/st_console_output.log"


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

        case "$(uname -s)" in
            Linux)
                package_manager=$(detect_package_manager)
                case "$package_manager" in
                    apt)
                        log_message "INFO" "Detected apt (Debian/Ubuntu). Installing Git..."
                        sudo apt update && sudo apt install -y git
                        ;;
                    dnf|yum)
                        log_message "INFO" "Detected dnf/yum (Red Hat/Fedora). Installing Git..."
                        sudo $package_manager install -y git
                        ;;
                    apk)
                        log_message "INFO" "Detected apk (Alpine). Installing Git..."
                        sudo apk add git
                        ;;
                    pacman)
                        log_message "INFO" "Detected pacman (Arch). Installing Git..."
                        sudo pacman -Sy --noconfirm git
                        ;;
                    emerge)
                        log_message "INFO" "Detected emerge (Gentoo). Installing Git..."
                        sudo emerge --ask dev-vcs/git
                        ;;
                    zypper)
                        log_message "INFO" "Detected zypper (openSUSE). Installing Git..."
                        sudo zypper install -y git
                        ;;
                    xbps)
                        log_message "INFO" "Detected xbps (Void). Installing Git..."
                        sudo xbps-install -y git
                        ;;
                    nix)
                        log_message "INFO" "Detected nix (NixOS). Installing Git..."
                        nix-env -iA nixpkgs.git
                        ;;
                    guix)
                        log_message "INFO" "Detected guix (Guix). Installing Git..."
                        guix package -i git
                        ;;
                    pkg)
                        log_message "INFO" "Detected pkg (Termux). Installing Git..."
                        pkg install git
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported package manager or distribution.${reset}"
                        exit 1
                        ;;
                esac
                ;;
            Darwin)
                log_message "INFO" "Detected macOS. Installing Git via Homebrew..."
                if ! command -v brew &> /dev/null; then
                    log_message "ERROR" "${red_fg_strong}Homebrew not installed. Install it first: https://brew.sh/${reset}"
                    exit 1
                fi
                brew install git
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                exit 1
                ;;
        esac

        log_message "INFO" "${green_fg_strong}Git is installed.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}Git is already installed.${reset}"
    fi
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




# Function to start SillyTavern with Extras
start_extras() {
    check_nodejs
    if [ "$LAUNCH_NEW_WIN" = "0" ]; then
        local main_pid=$!
        log_message "INFO" "Extras launched under pid $main_pid"
        {
            #has to be after the first one, so we are 1 directory up
            cd "SillyTavern-extras" || {
                log_message "ERROR" "SillyTavern-extras directory not found. Please make sure you have installed SillyTavern-extras."
                kill $main_pid
                exit 1
            }
            log_message "INFO" "Working dir: $(pwd)"
            ./start.sh
        } &
        local extras_pid=$!
        log_message "INFO" "Extras launched under pid $extras_pid"
        wait $main_pid
        kill $extras_pid
    else
        cd "SillyTavern-extras"
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
            open -a Terminal --args --title="SillyTavern Extras" --working-directory="SillyTavern-extras" --command "python server.py --listen --rvc-save-file --max-content-length=1000 --enable-modules=rvc,caption; exec bash"
        else
            exec "$detected_terminal" -e "python server.py --listen --rvc-save-file --max-content-length=1000 --enable-modules=rvc,caption; bash"
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
        cd "xtts" || {
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
        cd "xtts"
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
            open -a Terminal --args --title="XTTSv2 API Server" --working-directory="xtts" --command "conda activate xtts; python -m xtts_api_server; exec bash"
        else
            exec "$detected_terminal" -e "conda activate xtts && python -m xtts_api_server; bash"
        fi
    fi
    home
}


# Function to update
update() {
    echo -e "\033]0;STL [UPDATE]\007"
    log_message "INFO" "Updating SillyTavern-Launcher..."
    git pull --rebase --autostash

    # Update SillyTavern if directory exists
    if [ -d "SillyTavern" ]; then
        log_message "INFO" "Updating SillyTavern..."
        cd "SillyTavern"
        git pull --rebase --autostash
        cd ..
        log_message "INFO" "SillyTavern updated successfully."
    else
        log_message "WARN" "SillyTavern directory not found. Skipping SillyTavern update."
    fi

    # Update Extras if directory exists
    if [ -d "SillyTavern-extras" ]; then
        log_message "INFO" "Updating SillyTavern-extras..."
        cd "SillyTavern-extras"
        git pull --rebase --autostash
        cd ..
        log_message "INFO" "SillyTavern-extras updated successfully."
    else
        log_message "WARN" "SillyTavern-extras directory not found. Skipping SillyTavern-extras update."
    fi

    # Update XTTS if directory exists
    if [ -d "xtts" ]; then
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
    read -p "Press Enter to continue..."
    home
}


create_backup() {
    echo -e "\033]0;STL [CREATE BACKUP]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Toolbox / Backup / Create Backup                  |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"

    # Scan for user folders
    user_folders=()
    for dir in "$st_install_path/data"/*; do
        if [ -d "$dir" ]; then
            folder_name=$(basename "$dir")
            if [[ "$folder_name" != "_storage" && "$folder_name" != "_uploads" ]]; then
                user_folders+=("$folder_name")
            fi
        fi
    done

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Detected Accounts                                            |${reset}"
    for ((i = 0; i < ${#user_folders[@]}; i++)); do
        echo -e "    $((i + 1)). ${yellow_fg_strong}${user_folders[$i]}${reset}"
    done
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Cancel"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"

    # If only one user folder is found, skip the selection
    if [ ${#user_folders[@]} -eq 1 ]; then
        selected_user_folder="${user_folders[0]}"
    else
        echo
        read -p "Select a folder to backup: " user_choice

        # Check if the user wants to exit
        if [ "$user_choice" -eq 0 ]; then
            backup
        fi

        # Validate user input
        if [[ "$user_choice" -lt 1 || "$user_choice" -gt ${#user_folders[@]} ]]; then
            echo -e "${red_fg_strong}[ERROR] Invalid selection. Please enter a number between 1 and ${#user_folders[@]}, or press 0 to cancel.${reset}"
            read -p "Press Enter to continue..."
            create_backup
            return
        fi

        selected_user_folder="${user_folders[$((user_choice - 1))]}"
    fi

    # Prompt user for custom name
    read -p "  Give backup file a custom name? (Default is st_backup_DATE_TIME.7z) [Y/N]: " rename_choice
    rename_choice=$(echo "$rename_choice" | tr '[:upper:]' '[:lower:]')

    # Check if the user wants to exit
    if [[ "$rename_choice" == "0" ]]; then
        backup
    fi

    if [[ "$rename_choice" == "y" ]]; then
        read -p "Enter custom name for backup file (without extension): " custom_name
        backup_filename="st_backup_${custom_name}.7z"
    else
        # Get current date and time
        formatted_date=$(date +"%Y-%m-%d_%H-%M")
        backup_filename="st_backup_${formatted_date}.7z"
    fi

    # Create a backup using 7zip
    if ! command -v 7z &> /dev/null; then
        echo -e "${red_fg_strong}[ERROR] 7z is not installed. Please install it to create backups.${reset}"
        read -p "Press Enter to continue..."
        backup
    fi

    7z a "$st_backup_path/$backup_filename" "$st_install_path/data/$selected_user_folder/*" > /dev/null

    if [ $? -eq 0 ]; then
        echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} ${green_fg_strong}Backup created at $st_backup_path/$backup_filename${reset}"
    else
        echo -e "${red_fg_strong}[ERROR] Backup creation failed.${reset}"
    fi

    read -p "Press Enter to continue..."
    backup
}


restore_backup() {
    echo -e "\033]0;STL [RESTORE BACKUP]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Toolbox / Backup / Restore Backup                 |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Available Backups                                            |${reset}"
    backup_files=()
    backup_count=0

    for file in "$st_backup_path"/st_backup_*.7z; do
        if [ -f "$file" ]; then
            backup_count=$((backup_count + 1))
            backup_files+=("$(basename "$file" .7z)")
            echo -e "    $backup_count. ${yellow_fg_strong}$(basename "$file" .7z)${reset}"
        fi
    done

    if [ "$backup_count" -eq 0 ]; then
        echo -e "    ${red_fg_strong}No backups found.${reset}"
    fi

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Cancel"
    echo
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"

    # Prompt user to select a backup
    read -p "  Select backup to restore: " restore_choice

    # Check if the user wants to cancel
    if [[ "$restore_choice" == "0" ]]; then
        backup
    fi

    # Validate user input
    if [[ "$restore_choice" -lt 1 || "$restore_choice" -gt "$backup_count" ]]; then
        echo -e "${red_fg_strong}[ERROR] Invalid selection. Please enter a number between 1 and $backup_count, or press 0 to cancel.${reset}"
        read -p "Press Enter to continue..."
        restore_backup
        return
    fi

    # Get the selected backup file
    selected_backup="${backup_files[$((restore_choice - 1))]}"

    # Restore the backup
    echo "Restoring backup $selected_backup..."

    # Create a temporary directory for extraction
    temp_dir=$(mktemp -d)

    # Extract the backup to the temporary directory
    if ! command -v 7z &> /dev/null; then
        echo -e "${red_fg_strong}[ERROR] 7z is not installed. Please install it to restore backups.${reset}"
        read -p "Press Enter to continue..."
        backup
    fi

    7z x "$st_backup_path/$selected_backup.7z" -o"$temp_dir" -aoa > /dev/null

    if [ $? -ne 0 ]; then
        echo -e "${red_fg_strong}[ERROR] Failed to extract backup.${reset}"
        rm -rf "$temp_dir"
        read -p "Press Enter to continue..."
        backup
    fi

    # Copy the extracted data to the SillyTavern data directory
    if [ -d "$temp_dir/data" ]; then
        cp -r "$temp_dir/data/"* "$st_install_path/data/"
    else
        echo -e "${red_fg_strong}[ERROR] Backup does not contain a valid data directory.${reset}"
        rm -rf "$temp_dir"
        read -p "Press Enter to continue..."
        backup
    fi

    # Clean up the temporary directory
    rm -rf "$temp_dir"

    echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} ${green_fg_strong}$selected_backup restored successfully.${reset}"
    read -p "Press Enter to continue..."
    backup
}

############################################################
################# BACKUP - FRONTEND ########################
############################################################
backup() {
    echo -e "\033]0;STL [BACKUP]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Toolbox / Backup                                  |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"
    echo "    1. Create Backup"
    echo "    2. Restore Backup"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
    read -p "  Choose Your Destiny: " backup_choice

################# BACKUP - BACKEND ########################
    case $backup_choice in
        1) create_backup ;;
        2) restore_backup ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           backup ;;
    esac
}


########################################################################################
########################################################################################
####################### EDITOR FUNCTIONS  ##############################################
########################################################################################
########################################################################################

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
    echo -e "\033]0;STL [EDIT-MODULES]\007"
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
    echo -e "\033]0;STL [EDIT-XTTS-MODULES]\007"
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
edit_env_var() {
    # Open the environment variables file for editing
    if [ -f ~/.bashrc ]; then
        # Use your preferred text editor (e.g., nano, vim, or gedit)
        nano ~/.bashrc
    else
        echo "Environment file not found. Create or specify the correct file path."
    fi

    # Optionally, ask the user to reload the environment
    read -p "Would you like to reload the environment? [Y/N]: " reload
    if [ "$reload" = "Y" ] || [ "$reload" = "y" ]; then
        source ~/.bashrc  # Reload the environment (may vary based on your shell)
        echo "Environment reloaded."
    fi

    editor_core_utilities
}


edit_st_config() {
    # Check if nano is available
    if ! command -v nano &>/dev/null; then
        echo "Error: Nano is not installed. Please install Nano to edit config.yaml"
        editor_core_utilities
    fi
    # Open config.yaml file in nano
    nano "$st_install_path/config.yaml"

    editor_core_utilities
}


editor_text_completion() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    editor
}

editor_voice_generation() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    editor
}

editor_image_generation() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    editor
}

edit_extras_modules() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    editor_core_utilities

}
create_st_ssl() {
    # Check if a specific argument is passed to detect if called by another script
    local pause_required=true
    local silent_mode=false
    if [ -n "$1" ]; then
        silent_mode=true
    fi

    # Redirect output to /dev/null if in silent mode
    if [ "$silent_mode" = true ]; then
        local output_redirection=">/dev/null 2>&1"
    else
        local output_redirection=""
    fi

    # Set the SSL certificate directory and files
    local CERT_DIR="$st_install_path/certs"
    local CERT_FILE="$CERT_DIR/cert.pem"
    local KEY_FILE="$CERT_DIR/privkey.pem"
    local CERT_INFO_FILE="$CERT_DIR/SillyTavernSSLInfo.txt"
    local ERROR_LOG="$CERT_DIR/error_log.txt"

    # Check if the SillyTavern directory exists
    if [ ! -d "$st_install_path" ]; then
        echo "Please install SillyTavern first."
        if [ "$pause_required" = true ]; then
            read -p "Press Enter to continue..."
        fi
        editor_core_utilities
    fi

    # Create the SSL certificate directory if it doesn't exist
    if [ ! -d "$CERT_DIR" ]; then
        mkdir -p "$CERT_DIR"
        eval "echo Created directory $CERT_DIR $output_redirection"
    else
        eval "echo Directory $CERT_DIR already exists. $output_redirection"
    fi

    # Check if the certificate already exists and delete it if it does
    if [ -f "$CERT_FILE" ]; then
        rm "$CERT_FILE"
        eval "echo Existing certificate deleted. $output_redirection"
    fi

    if [ -f "$KEY_FILE" ]; then
        rm "$KEY_FILE"
        eval "echo Existing key deleted. $output_redirection"
    fi

    # Find the OpenSSL binary
    local openssl_path=$(which openssl)
    if [ -z "$openssl_path" ]; then
        echo "OpenSSL is not installed. Please install it first."
        if [ "$pause_required" = true ]; then
            read -p "Press Enter to continue..."
        fi
        editor_core_utilities
    fi

    eval "echo OpenSSL is located at: $openssl_path $output_redirection"

    # Generate the self-signed certificate in PEM format
    eval "echo Generating self-signed certificate... $output_redirection"
    eval "$openssl_path req -x509 -newkey rsa:4096 -keyout \"$KEY_FILE\" -out \"$CERT_FILE\" -days 825 -nodes -subj \"/CN=127.0.0.1\" $output_redirection"

    if [ $? -ne 0 ]; then
        echo "An error occurred. Please check the console output for details."
        echo "[$(date)] An error occurred during certificate generation." >> "$ERROR_LOG"
        if [ "$pause_required" = true ]; then
            read -p "Press Enter to continue..."
        fi
        editor_core_utilities
    fi

    eval "echo Certificate generation complete. $output_redirection"

    # Calculate the expiration date (today + 825 days) and format as YYYY-MM-DD
    local exp_date=$(date -d "+825 days" +"%Y-%m-%d")

    # Store the certificate and key path, and expiration date in the text file
    {
        echo "$CERT_FILE"
        echo "$KEY_FILE"
        echo "SSL Expiration Date (YYYY-MM-DD): $exp_date"
    } > "$CERT_INFO_FILE"

    eval "echo Certificate and key paths and expiration date stored in $CERT_INFO_FILE. $output_redirection"

    echo "Done."
    if [ "$pause_required" = true ]; then
        read -p "Press Enter to continue..."
    fi
    editor_core_utilities
}

delete_st_ssl() {
    CERTS_DIR="$st_install_path/certs"
    if [ -d "$CERTS_DIR" ]; then
        log_message "INFO" "Removing $CERTS_DIR..."
        rm -rf "$CERTS_DIR"
        if [ $? -eq 0 ]; then
            echo -e "${green_fg_strong}certs directory successfully deleted.${reset}"
        else
            log_message "ERROR" "Failed to delete certs directory. Please check permissions."
        fi
    else
        log_message "INFO" "No SSL certificates found. Nothing to delete."
    fi
    read -p "Press Enter to continue..."
    editor_core_utilities
}


config_tailscale() {
    echo -e "\033]0;STL [TAILSCALE CONFIGURATION]\007"
    clear

    echo -e "${blue_fg_strong}| > / Home / Toolbox / App Installer / Core Utilities / Tailscale${reset}"
    echo -e "${blue_fg_strong}============================================================================================${reset}"
    echo -e "${cyan_fg_strong}____________________________________________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                                                 |${reset}"

    # Calculate the path to the logs folder based on the current script location
    log_dir="$(dirname "$(readlink -f "$0")")/../../../logs"
    log_file="$log_dir/tailscale_status.txt"

    # Check if the log file exists before attempting to clear it
    if [ -f "$log_file" ]; then
        echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Clearing existing log file..."
        > "$log_file"
    else
        echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Log file does not exist, no need to clear."
    fi

    echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Configuring Tailscale..."
    echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Running Tailscale login..."

    tailscale up

    if [ $? -eq 0 ]; then
        echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Tailscale configuration successful."

        echo -e "${cyan_fg_strong}____________________________________________________________________________________________${reset}"
        echo -e "${cyan_fg_strong}| Menu Options:                                                                              |${reset}"
        echo "    1. Find Tailscale SillyTavern Remote URLs"
        echo "    0. Back"

        echo -e "${cyan_fg_strong}____________________________________________________________________________________________${reset}"
        echo -e "${cyan_fg_strong}|                                                                                            |${reset}"

        read -p "   Choose Your Destiny: " choice

        case $choice in
            1)
                echo
                echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Fetching Tailscale status..."

                # Fetch Tailscale status and write to log file
                tailscale status --json | jq -r '.Self | .TailscaleIPs[0], .HostName, .DNSName' > "$log_file"

                # Read values from the log file
                mapfile -t tailscale_info < "$log_file"
                ip4="${tailscale_info[0]}"
                hostName="${tailscale_info[1]}"
                dnsName="${tailscale_info[2]}"

                # Remove trailing period from dnsName if it exists
                dnsName="${dnsName%.}"

                echo -e "${blue_fg_strong}____________________________________________________________________________________________${reset}"
                echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Tailscale Remote SillyTavern URLs (if you changed your SillyTavern Port # change 8000 to that new port):"
                echo -e "${cyan_fg_strong}IP4:${reset} http://$ip4:8000"
                echo -e "${cyan_fg_strong}Machine Name:${reset} http://$hostName:8000"
                echo -e "${cyan_fg_strong}MagicDNS Name:${reset} http://$dnsName:8000"
                echo -e "${blue_fg_strong}____________________________________________________________________________________________${reset}"

                # Prompt the user to open the additional config instructions page
                read -p "Do you want to open the additional configuration instructions page (Y/N)? " userChoice
                if [[ "$userChoice" =~ ^[Yy]$ ]]; then
                    url="https://sillytavernai.com/tailscale-config/?HostName=$hostName&DNSName=$dnsName&IP4=$ip4#STL"
                    xdg-open "$url"
                else
                    echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Skipping additional configuration instructions."
                fi
                ;;
            0)
                echo -e "${blue_bg}[$(date '+%H:%M:%S')]${reset} ${blue_fg_strong}[INFO]${reset} Returning to Home..."
                editor_core_utilities
                ;;
            *)
                echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
                read -p "Press Enter to continue..."
                config_tailscale
                ;;
        esac
    else
        echo -e "${red_bg}[$(date +%T)]${reset} ${red_fg_strong}[ERROR] Tailscale configuration failed.${reset}"
        read -p "Press Enter to continue..."
        editor_core_utilities
    fi

    read -p "Press Enter to continue..."
    config_tailscale
}

editor_core_utilities() {
    echo -e "\033]0;STL [EDITOR CORE UTILITIES]\007"
    clear

    SSL_INFO_FILE="$st_install_path/certs/SillyTavernSSLInfo.txt"
    sslOption="2. Generate & Use Self-Signed SSL for SillyTavern"
    sslDeleteOption=""  # Initialize delete option as empty

    # Check if SSL exists and populate options
    if [ -f "$SSL_INFO_FILE" ]; then
        expDate=$(sed -n '3p' "$SSL_INFO_FILE")
        sslOption="2. Regenerate SillyTavern SSL - $expDate"
        sslDeleteOption="222. Delete Generated SSL"
    fi

    echo -e "${blue_fg_strong}| > / Home / Toolbox / Editor / Core Utilities                                               |${reset}"
    echo -e "${blue_fg_strong}============================================================================================${reset}"
    echo -e "${cyan_fg_strong}____________________________________________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                                                 |${reset}"

    echo "    1. Edit SillyTavern config.yaml"
    echo "    3. Edit Extras"
    echo "    4. Edit Environment Variables"
    echo "    5. View Tailscale configuration"

    echo -e "${cyan_fg_strong}____________________________________________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| SSL Options                                                                                |${reset}"
    echo -e "    $sslOption"
    [ -n "$sslDeleteOption" ] && echo -e ${yellow_fg_strong}"    $sslDeleteOption${reset}"  # Show delete option only if SSL exists
    echo -e "    223. Open SSL documentation"

    echo -e "${cyan_fg_strong}____________________________________________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                                              |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong}____________________________________________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                                                            |${reset}"

    read -p "   Choose Your Destiny: " editor_core_utilities_choice

    case $editor_core_utilities_choice in
        1) edit_st_config ;;
        2) create_st_ssl ;;
        3) edit_extras_modules ;;
        4) edit_env_var ;;
        5) config_tailscale ;;
        222) delete_st_ssl ;;
        223) xdg-open "https://sillytavernai.com/launcher-ssl" ; editor_core_utilities ;;
        0) editor ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           editor_core_utilities ;;
    esac
}

############################################################
############## EDITOR - FRONTEND ###########################
############################################################
editor() {
    echo -e "\033]0;STL [EDITOR]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Toolbox / Editor                                  |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"
    echo "    1. Text Completion"
    echo "    2. Voice Generation"
    echo "    3. Image Generation"
    echo "    4. Core Utilities"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
    read -p "  Choose Your Destiny: " editor_choice

################# EDITOR - BACKEND ################
    case $editor_choice in
        1) editor_text_completion ;;
        2) editor_voice_generation ;;
        3) editor_image_generation ;;
        4) editor_core_utilities ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           editor ;;
    esac
}

########################################################################################
########################################################################################
####################### TROUBLESHOOTING FUNCTIONS  #####################################
########################################################################################
########################################################################################
remove_node_modules() {
    log_message "INFO" "Removing node_modules folder..."
    rm -rf "$st_install_path/node_modules"
    log_message "INFO" "node_modules successfully removed."
    read -p "Press Enter to continue..."
    troubleshooting
}

remove_pip_cache() {
    log_message "INFO" "Clearing pip cache..."
    pip cache purge
    log_message "INFO" "pip cache cleared successfully."
    read -p "Press Enter to continue..."
    troubleshooting
}

fix_github_conflicts() {
    log_message "INFO" "Trying to resolve unresolved conflicts in the working directory or unmerged files..."
    git -C "$st_install_path" merge --abort
    git -C "$st_install_path" reset --hard
    git -C "$st_install_path" pull --rebase --autostash
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

find_app_port() {
    echo -e "\033]0;STL [FIND APP PORT]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Troubleshooting & Support / Find App Port         |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Cancel"

    # Prompt for port number if not provided
    if [ -z "$1" ]; then
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
        read -p "  Insert port number: " port_choice
    else
        port_choice="$1"
    fi

    # Check if the user wants to cancel
    if [[ "$port_choice" == "0" ]]; then
        troubleshooting
    fi

    # Validate input: Check if it's a number
    if ! [[ "$port_choice" =~ ^[0-9]+$ ]]; then
        echo -e "${red_bg}[$(date +%T)]${reset} ${red_fg_strong}[ERROR] Invalid input: Not a number.${reset}"
        read -p "Press Enter to continue..."
        troubleshooting
        return
    fi

    # Validate port range
    if [ "$port_choice" -gt 65535 ]; then
        echo -e "${red_bg}[$(date +%T)]${reset} ${red_fg_strong}[ERROR] Port out of range. There are only 65,535 possible port numbers.${reset}"
        echo "[0-1023]: These ports are reserved for system services or commonly used protocols."
        echo "[1024-49151]: These ports can be used by user processes or applications."
        echo "[49152-65535]: These ports are available for use by any application or service on the system."
        read -p "Press Enter to continue..."
        troubleshooting
        return
    fi

    echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} Searching for application using port: $port_choice..."

    # Find the PID of the process using the port
    pid=$(lsof -i :"$port_choice" -t)
    if [ -n "$pid" ]; then
        app_name=$(ps -p "$pid" -o comm=)
        echo -e "Application Name: ${cyan_fg_strong}$app_name${reset}"
        echo -e "PID of Port $port_choice: ${cyan_fg_strong}$pid${reset}"

        # Fetch the page title for the specified port
        fetch_page_title "$port_choice"
        if [ -n "$PAGE_TITLE" ]; then
            echo -e "Title of Application: ${cyan_fg_strong}$PAGE_TITLE${reset}"
        else
            echo -e "${yellow_bg}[$(date +%T)]${reset} ${yellow_fg_strong}[WARN]${reset} Could not retrieve page title."
        fi
    else
        echo -e "${yellow_bg}[$(date +%T)]${reset} ${yellow_fg_strong}[WARN]${reset} Port: $port_choice not found."
    fi

    read -p "Press Enter to continue..."
    find_app_port
}

# Function to fetch the page title for a given port
fetch_page_title() {
    local port="$1"
    local url="http://localhost:$port"

    # Use curl to fetch the page title
    PAGE_TITLE=$(curl -s "$url" | grep -oP '(?<=<title>).*?(?=</title>)')
}


onboarding_flow() {
    read -p "Enter new value for Onboarding Flow (true/false): " onboarding_flow_value
    if [[ "$onboarding_flow_value" != "true" && "$onboarding_flow_value" != "false" ]]; then
        log_message "WARN" "Invalid input. Please enter 'true' or 'false'."
        read -p "Press Enter to continue..."
        onboarding_flow
    fi
    sed -i "s/\"firstRun\": .*/\"firstRun\": $onboarding_flow_value,/" "$st_install_path/public/settings.json"
    log_message "INFO" "Value of 'firstRun' in settings.json has been updated to $onboarding_flow_value."
    read -p "Press Enter to continue..."
    troubleshooting
}

discord_servers_menu() {
    echo -e "\033]0;STL [DISCORD SERVERS]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Troubleshooting & Support / Discord Servers       |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo "    1. Join SillyTavern"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Discord - LLM Backends:                                      |${reset}"
    echo "    2. Join TabbyAPI"
    echo "    3. Join KoboldAI"
    echo "    4. Join Text Generation WEBUI ooba"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Discord - Cloud API:                                         |${reset}"
    echo "    5. Join Mancer"
    echo "    6. Join OpenRouter"
    echo "    7. Join AI Horde"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Discord - Model Devs & Research:                             |${reset}"
    echo "    8. Join TheBloke"
    echo "    9. Join PygmalionAI"
    echo "    10. Join Nous Research"
    echo "    11. Join RWKV"
    echo "    12. Join EleutherAI"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"

    read -p "  Choose Your Destiny: " discord_servers_choice

    ################ DISCORD SERVERS - BACKEND ################
    case $discord_servers_choice in
        1) discord_sillytavern ;;
        2) discord_tabbyapi ;;
        3) discord_koboldai ;;
        4) discord_textgenwebuiooba ;;
        5) discord_mancer ;;
        6) discord_openrouter ;;
        7) discord_aihorde ;;
        8) discord_thebloke ;;
        9) discord_pygmalionai ;;
        10) discord_nousresearch ;;
        11) discord_rwkv ;;
        12) discord_eleutherai ;;
        0) troubleshooting ;;
        *)
            echo -e "${red_fg_strong}[ERROR] Invalid input. Please enter a valid number.${reset}"
            read -p "Press Enter to continue..."
            discord_servers_menu
            ;;
    esac
}

# Discord server functions
discord_sillytavern() {
    xdg-open "https://discord.gg/sillytavern"
    discord_servers_menu
}

discord_tabbyapi() {
    xdg-open "https://discord.gg/sYQxnuD7Fj"
    discord_servers_menu
}

discord_koboldai() {
    xdg-open "https://discord.gg/UCyXV7NssH"
    discord_servers_menu
}

discord_textgenwebuiooba() {
    xdg-open "https://discord.gg/jwZCF2dPQN"
    discord_servers_menu
}

discord_mancer() {
    xdg-open "https://discord.gg/6DZaU9Gv9F"
    discord_servers_menu
}

discord_openrouter() {
    xdg-open "https://discord.gg/H9tjZYgauh"
    discord_servers_menu
}

discord_aihorde() {
    xdg-open "https://discord.gg/3DxrhksKzn"
    discord_servers_menu
}

discord_thebloke() {
    xdg-open "https://discord.gg/Jq4vkcDakD"
    discord_servers_menu
}

discord_pygmalionai() {
    xdg-open "https://discord.gg/pygmalionai"
    discord_servers_menu
}

discord_nousresearch() {
    xdg-open "https://discord.gg/jqVphNsB4H"
    discord_servers_menu
}

discord_rwkv() {
    xdg-open "https://discord.gg/bDSBUMeFpc"
    discord_servers_menu
}

discord_eleutherai() {
    xdg-open "https://discord.gg/zBGx3azzUn"
    discord_servers_menu
}

############################################################
############## TROUBLESHOOTING - FRONTEND ##################
############################################################
troubleshooting() {
    echo -e "\033]0;STL [TROUBLESHOOTING SUPPORT]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Troubleshooting & Support                         |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Troubleshooting & Repair Options                             |${reset}"
    echo "    1. Remove node_modules folder"
    echo "    2. Clear npm cache"
    echo "    3. Clear pip cache"
    echo "    4. Fix unresolved conflicts or unmerged files [SillyTavern]"
    echo "    5. Export system info"
    echo "    6. Find what app is using port"
    echo "    7. Set Onboarding Flow"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Support Options:                                             |${reset}"
    echo "    8. Report an Issue"
    echo "    9. SillyTavern Documentation"
    echo "    10. Discord servers"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
    read -p "  Choose Your Destiny: " troubleshooting_choice

################# TROUBLESHOOTING - BACKEND ################
    case $troubleshooting_choice in
        1) remove_node_modules ;;
        2) remove_npm_cache ;;
        3) remove_pip_cache ;;
        4) fix_github_conflicts ;;
        5) export_system_info ;;
        6) find_app_port ;;
        7) onboarding_flow ;;
        8) issue_report ;;
        9) documentation ;;
        10) discord_servers_menu ;;
        0) home ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           troubleshooting ;;
    esac
}

########################################################################################
########################################################################################
####################### SUPPORT FUNCTIONS  #############################################
########################################################################################
########################################################################################
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
    troubleshooting
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
    troubleshooting
}


########################################################################################
########################################################################################
####################### TOOLBOX MENU FUNCTIONS  ########################################
########################################################################################
########################################################################################

# Function to switch to the Release branch in SillyTavern
switch_release_st() {
    log_message "INFO" "Switching to release branch..."
    git -C "$st_install_path" switch release
    read -p "Press Enter to continue..."
    switch_branch
}

# Function to switch to the Staging branch in SillyTavern
switch_staging_st() {
    log_message "INFO" "Switching to staging branch..."
    git -C "$st_install_path" switch staging
    read -p "Press Enter to continue..."
    switch_branch
}


############################################################
############## SWITCH BRANCE - FRONTEND ####################
############################################################
switch_branch() {
    echo -e "\033]0;STL [SWITCH BRANCH]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Toolbox / Switch Branch                           |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${yellow_fg_strong} ______________________________________________________________${reset}"
    echo -e "${yellow_fg_strong}| Version Status                                               |${reset}"
    current_st_branch=$(git -C "$st_install_path" branch --show-current)
    echo -e "    SillyTavern branch: ${cyan_fg_strong}$current_st_branch${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"
    echo "    1. Switch to Release - SillyTavern"
    echo "    2. Switch to Staging - SillyTavern"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"

    read -p "  Choose Your Destiny: " branch_choice

################# SWITCH BRANCE - BACKEND ########################
    case $branch_choice in
        1) switch_release_st ;;
        2) switch_staging_st ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           switch_branch ;;
    esac
}

reset_custom_shortcut() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    toolbox
}

app_launcher() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    toolbox
}

########################################################################################
########################################################################################
####################### APP INSTALLER MENU FUNCTIONS  ##################################
########################################################################################
########################################################################################

# Function to install p7zip (7-Zip)
install_p7zip() {
    if ! command -v 7z &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}p7zip (7-Zip) is not installed on this system${reset}"

        case "$(grep -E '^ID=' /etc/os-release | cut -d= -f2)" in
            debian|ubuntu)
                # Debian/Ubuntu-based system
                log_message "INFO" "Installing p7zip (7-Zip) using apt..."
                sudo apt-get update
                sudo apt-get install -y p7zip-full
                ;;
            fedora|centos|rhel)
                # Red Hat/Fedora-based system
                log_message "INFO" "Installing p7zip (7-Zip) using yum..."
                sudo yum install -y p7zip p7zip-plugins
                ;;
            alpine)
                # Alpine Linux-based system
                log_message "INFO" "Installing p7zip (7-Zip) using apk..."
                sudo apk add p7zip
                ;;
            arch|manjaro)
                # Arch Linux-based system
                log_message "INFO" "Installing p7zip (7-Zip) using pacman..."
                sudo pacman -Sy --noconfirm p7zip
                ;;
            gentoo)
                # Gentoo Linux-based system
                log_message "INFO" "Installing p7zip (7-Zip) using emerge..."
                sudo emerge --ask app-arch/p7zip
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
                exit 1
                ;;
        esac

        log_message "INFO" "${green_fg_strong}p7zip (7-Zip) is installed.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}p7zip (7-Zip) is already installed.${reset}"
    fi
}

# Function to install FFmpeg
install_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}FFmpeg is not installed on this system${reset}"

        case "$(grep -E '^ID=' /etc/os-release | cut -d= -f2)" in
            debian|ubuntu)
                # Debian/Ubuntu-based system
                log_message "INFO" "Installing FFmpeg using apt..."
                sudo apt-get update
                sudo apt-get install -y ffmpeg
                ;;
            fedora|centos|rhel)
                # Red Hat/Fedora-based system
                log_message "INFO" "Installing FFmpeg using yum..."
                sudo yum install -y ffmpeg
                ;;
            alpine)
                # Alpine Linux-based system
                log_message "INFO" "Installing FFmpeg using apk..."
                sudo apk add ffmpeg
                ;;
            arch|manjaro)
                # Arch Linux-based system
                log_message "INFO" "Installing FFmpeg using pacman..."
                sudo pacman -Sy --noconfirm ffmpeg
                ;;
            gentoo)
                # Gentoo Linux-based system
                log_message "INFO" "Installing FFmpeg using emerge..."
                sudo emerge --ask media-video/ffmpeg
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
                exit 1
                ;;
        esac

        log_message "INFO" "${green_fg_strong}FFmpeg is installed.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}FFmpeg is already installed.${reset}"
    fi
}

install_nodejs() {
    if ! command -v node &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}Node.js is not installed on this system${reset}"

        case "$(uname -s)" in
            Linux)
                package_manager=$(detect_package_manager)
                case "$package_manager" in
                    apt)
                        log_message "INFO" "Detected apt (Debian/Ubuntu). Installing Node.js..."
                        sudo apt update && sudo apt install -y nodejs npm
                        ;;
                    dnf|yum)
                        log_message "INFO" "Detected dnf/yum (Red Hat/Fedora). Installing Node.js..."
                        sudo $package_manager install -y nodejs npm
                        ;;
                    apk)
                        log_message "INFO" "Detected apk (Alpine). Installing Node.js..."
                        sudo apk add nodejs npm
                        ;;
                    pacman)
                        log_message "INFO" "Detected pacman (Arch). Installing Node.js..."
                        sudo pacman -Sy --noconfirm nodejs npm
                        ;;
                    emerge)
                        log_message "INFO" "Detected emerge (Gentoo). Installing Node.js..."
                        sudo emerge --ask nodejs npm
                        ;;
                    zypper)
                        log_message "INFO" "Detected zypper (openSUSE). Installing Node.js..."
                        sudo zypper install -y nodejs npm
                        ;;
                    xbps)
                        log_message "INFO" "Detected xbps (Void). Installing Node.js..."
                        sudo xbps-install -y nodejs npm
                        ;;
                    nix)
                        log_message "INFO" "Detected nix (NixOS). Installing Node.js..."
                        nix-env -iA nixpkgs.nodejs
                        ;;
                    guix)
                        log_message "INFO" "Detected guix (Guix). Installing Node.js..."
                        guix package -i node
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported package manager or distribution.${reset}"
                        exit 1
                        ;;
                esac
                ;;
            Darwin)
                log_message "INFO" "Detected macOS. Installing Node.js via Homebrew..."
                if ! command -v brew &> /dev/null; then
                    log_message "ERROR" "${red_fg_strong}Homebrew not installed. Install it first: https://brew.sh/${reset}"
                    exit 1
                fi
                brew install node
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                exit 1
                ;;
        esac

        log_message "INFO" "${green_fg_strong}Node.js is installed.${reset}"
    else
        log_message "INFO" "${blue_fg_strong}Node.js is already installed.${reset}"
    fi
}

install_yq() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_installer_core_utilities
}

install_vs_buildtools() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_installer_core_utilities
}

install_cuda_toolkit() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_installer_core_utilities
}


install_tailscale() {
    if ! command -v tailscale &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}Tailscale is not installed on this system${reset}"

        # Ask the user if they have a Tailscale account
        read -p "Do you have a Tailscale account? [Y/N]: " has_account
        if [[ "$has_account" =~ ^[Nn]$ ]]; then
            echo -e "${blue_fg_strong}Please create a Tailscale account at https://login.tailscale.com/start${reset}"
            xdg-open "https://login.tailscale.com/start"
            read -p "Press Enter after you have created an account to continue..."
        fi

        # Detect the package manager and install Tailscale
        case "$(uname -s)" in
            Linux)
                package_manager=$(detect_package_manager)
                case "$package_manager" in
                    apt)
                        log_message "INFO" "Detected apt (Debian/Ubuntu). Installing Tailscale..."
                        curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/$(lsb_release -cs).noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
                        curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/$(lsb_release -cs).tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
                        sudo apt update && sudo apt install -y tailscale
                        ;;
                    dnf|yum)
                        log_message "INFO" "Detected dnf/yum (Red Hat/Fedora). Installing Tailscale..."
                        sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
                        sudo dnf install -y tailscale
                        ;;
                    apk)
                        log_message "INFO" "Detected apk (Alpine). Installing Tailscale..."
                        sudo apk add tailscale
                        ;;
                    pacman)
                        log_message "INFO" "Detected pacman (Arch). Installing Tailscale..."
                        sudo pacman -Sy --noconfirm tailscale
                        ;;
                    emerge)
                        log_message "INFO" "Detected emerge (Gentoo). Installing Tailscale..."
                        sudo emerge --ask net-vpn/tailscale
                        ;;
                    zypper)
                        log_message "INFO" "Detected zypper (openSUSE). Installing Tailscale..."
                        sudo zypper addrepo https://pkgs.tailscale.com/stable/opensuse/tailscale.repo
                        sudo zypper refresh
                        sudo zypper install -y tailscale
                        ;;
                    xbps)
                        log_message "INFO" "Detected xbps (Void). Installing Tailscale..."
                        sudo xbps-install -y tailscale
                        ;;
                    nix)
                        log_message "INFO" "Detected nix (NixOS). Installing Tailscale..."
                        nix-env -iA nixpkgs.tailscale
                        ;;
                    guix)
                        log_message "INFO" "Detected guix (Guix). Installing Tailscale..."
                        guix package -i tailscale
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported package manager or distribution.${reset}"
                        app_installer_core_utilities
                        ;;
                esac
                ;;
            Darwin)
                log_message "INFO" "Detected macOS. Installing Tailscale via Homebrew..."
                if ! command -v brew &> /dev/null; then
                    log_message "ERROR" "${red_fg_strong}Homebrew not installed. Install it first: https://brew.sh/${reset}"
                    app_installer_core_utilities
                fi
                brew install tailscale
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                app_installer_core_utilities
                ;;
        esac

        # Start and enable Tailscale
        if command -v tailscale &> /dev/null; then
            log_message "INFO" "${green_fg_strong}Tailscale is installed. Starting Tailscale...${reset}"
            sudo tailscale up
            if [ $? -eq 0 ]; then
                log_message "INFO" "${green_fg_strong}Tailscale is now running.${reset}"
            else
                log_message "ERROR" "${red_fg_strong}Failed to start Tailscale.${reset}"
            fi
        else
            log_message "ERROR" "${red_fg_strong}Tailscale installation failed.${reset}"
        fi
    else
        log_message "INFO" "${blue_fg_strong}Tailscale is already installed.${reset}"
    fi

    read -p "Press Enter to continue..."
    app_installer_core_utilities
}

install_ngrok() {
    if ! command -v ngrok &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}ngrok is not installed on this system${reset}"

        # Detect the operating system and architecture
        case "$(uname -s)" in
            Linux)
                case "$(uname -m)" in
                    x86_64)
                        arch="amd64"
                        ;;
                    armv7l|armv8l|aarch64)
                        arch="arm64"
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported architecture.${reset}"
                        exit 1
                        ;;
                esac
                os="linux"
                ;;
            Darwin)
                case "$(uname -m)" in
                    x86_64)
                        arch="amd64"
                        ;;
                    arm64)
                        arch="arm64"
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported architecture.${reset}"
                        app_installer_core_utilities
                        ;;
                esac
                os="darwin"
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                app_installer_core_utilities
                ;;
        esac

        # Download and install ngrok
        log_message "INFO" "Downloading ngrok for ${os}-${arch}..."
        download_url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-${os}-${arch}.tgz"
        temp_dir=$(mktemp -d)
        curl -fsSL "$download_url" -o "$temp_dir/ngrok.tgz"

        if [ $? -ne 0 ]; then
            log_message "ERROR" "${red_fg_strong}Failed to download ngrok.${reset}"
            rm -rf "$temp_dir"
            read -p "Press Enter to continue..."
            app_installer_core_utilities
        fi

        log_message "INFO" "Installing ngrok..."
        tar -xzf "$temp_dir/ngrok.tgz" -C "$temp_dir"
        sudo mv "$temp_dir/ngrok" /usr/local/bin/ngrok
        rm -rf "$temp_dir"

        if command -v ngrok &> /dev/null; then
            log_message "INFO" "${green_fg_strong}ngrok is installed.${reset}"
        else
            log_message "ERROR" "${red_fg_strong}Failed to install ngrok.${reset}"
            read -p "Press Enter to continue..."
            app_installer_core_utilities
        fi
    else
        log_message "INFO" "${blue_fg_strong}ngrok is already installed.${reset}"
    fi

    # Authenticate ngrok if not already authenticated
    if [ ! -f "$HOME/.config/ngrok/ngrok.yml" ]; then
        log_message "INFO" "Authenticating ngrok..."
        echo -e "${blue_fg_strong}Please visit https://dashboard.ngrok.com/signup to create an account if you don't have one.${reset}"
        echo -e "${blue_fg_strong}After signing up, go to https://dashboard.ngrok.com/get-started/your-authtoken to get your authtoken.${reset}"
        read -p "Enter your ngrok authtoken: " authtoken
        ngrok config add-authtoken "$authtoken"

        if [ $? -eq 0 ]; then
            log_message "INFO" "${green_fg_strong}ngrok authenticated successfully.${reset}"
        else
            log_message "ERROR" "${red_fg_strong}Failed to authenticate ngrok.${reset}"
            read -p "Press Enter to continue..."
            app_installer_core_utilities
        fi
    else
        log_message "INFO" "${blue_fg_strong}ngrok is already authenticated.${reset}"
    fi

    read -p "Press Enter to continue..."
    app_installer_core_utilities
}


app_installer_text_completion() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_installer
}

app_installer_voice_generation() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_installer
}

app_installer_image_generation() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_installer
}

app_installer_core_utilities() {
    echo -e "\033]0;STL [APP INSTALLER CORE UTILITIES]\007"
    clear

    echo -e "${blue_fg_strong}| > / Home / Toolbox / App Installer / Core Utilities          |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"

    echo "    1. Install 7-Zip"
    echo "    2. Install FFmpeg"
    echo "    3. Install Node.js"
    echo "    4. Install yq"
    echo "    5. Install Visual Studio BuildTools"
    echo "    6. Install CUDA Toolkit"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Remote Access & Tunneling                                    |${reset}"
    echo "    7. Install Tailscale"
    echo "    8. Install ngrok"
    echo "    9. Install Cloudflare Tunnel"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
    read -p "   Choose Your Destiny: " app_installer_choice

    case $app_installer_choice in
        1) install_p7zip ;;
        2) install_ffmpeg ;;
        3) install_nodejs ;;
        4) install_yq ;;
        5) install_vs_buildtools ;;
        6) install_cuda_toolkit ;;
        7) install_tailscale ;;
        8) install_ngrok ;;
        9) start_st_remotelink ;;
        0) app_installer ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           app_installer_core_utilities ;;
    esac
}


############################################################
############## APP INSTALLER - FRONTEND ####################
############################################################
app_installer() {
    echo -e "\033]0;STL [APP INSTALLER]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Toolbox / App Installer                           |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"
    echo "    1. Text Completion"
    echo "    2. Voice Generation"
    echo "    3. Image Generation"
    echo "    4. Core Utilities"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
    read -p "  Choose Your Destiny: " app_installer_choice

################# APP INSTALLER - BACKEND ################
    case $app_installer_choice in
        1) app_installer_text_completion ;;
        2) app_installer_voice_generation ;;
        3) app_installer_image_generation ;;
        4) app_installer_core_utilities ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           app_installer ;;
    esac
}



########################################################################################
########################################################################################
####################### APP UNINSTALLER MENU FUNCTIONS  ################################
########################################################################################
########################################################################################

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
        log_message "INFO" "Removing the SillyTavern directory..."
        rm -rf "$st_install_path" 
        log_message "INFO" "${green_fg_strong}SillyTavern uninstalled successfully.${reset}"
    else
        echo "Uninstall canceled."
    fi
    read -p "Press Enter to continue..."
    app_uninstaller_core_utilities
}


uninstall_p7zip() {
    if command -v 7z &> /dev/null; then
        log_message "INFO" "${blue_fg_strong}Uninstalling p7zip (7-Zip)...${reset}"

        case "$(uname -s)" in
            Linux)
                package_manager=$(detect_package_manager)
                case "$package_manager" in
                    apt)
                        sudo apt remove -y p7zip p7zip-full
                        ;;
                    dnf|yum)
                        sudo $package_manager remove -y p7zip p7zip-plugins
                        ;;
                    apk)
                        sudo apk del p7zip
                        ;;
                    pacman)
                        sudo pacman -Rns --noconfirm p7zip
                        ;;
                    emerge)
                        sudo emerge --unmerge p7zip
                        ;;
                    zypper)
                        sudo zypper remove -y p7zip
                        ;;
                    xbps)
                        sudo xbps-remove -y p7zip
                        ;;
                    nix)
                        nix-env -e p7zip
                        ;;
                    guix)
                        guix package -r p7zip
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported package manager or distribution.${reset}"
                        app_uninstaller_core_utilities
                        ;;
                esac
                ;;
            Darwin)
                if command -v brew &> /dev/null; then
                    brew uninstall p7zip
                else
                    log_message "ERROR" "${red_fg_strong}Homebrew not installed.${reset}"
                    app_uninstaller_core_utilities
                fi
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                app_uninstaller_core_utilities
                ;;
        esac

        if ! command -v 7z &> /dev/null; then
            log_message "INFO" "${green_fg_strong}p7zip (7-Zip) has been successfully uninstalled.${reset}"
        else
            log_message "ERROR" "${red_fg_strong}Failed to uninstall p7zip (7-Zip).${reset}"
            app_uninstaller_core_utilities
        fi
    else
        log_message "INFO" "${blue_fg_strong}p7zip (7-Zip) is not installed.${reset}"
    fi

    read -p "Press Enter to continue..."
    app_uninstaller_core_utilities
}

uninstall_ffmpeg() {
    if command -v ffmpeg &> /dev/null; then
        log_message "INFO" "${blue_fg_strong}Uninstalling FFmpeg...${reset}"

        case "$(uname -s)" in
            Linux)
                package_manager=$(detect_package_manager)
                case "$package_manager" in
                    apt)
                        sudo apt remove -y ffmpeg
                        ;;
                    dnf|yum)
                        sudo $package_manager remove -y ffmpeg
                        ;;
                    apk)
                        sudo apk del ffmpeg
                        ;;
                    pacman)
                        sudo pacman -Rns --noconfirm ffmpeg
                        ;;
                    emerge)
                        sudo emerge --unmerge ffmpeg
                        ;;
                    zypper)
                        sudo zypper remove -y ffmpeg
                        ;;
                    xbps)
                        sudo xbps-remove -y ffmpeg
                        ;;
                    nix)
                        nix-env -e ffmpeg
                        ;;
                    guix)
                        guix package -r ffmpeg
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported package manager or distribution.${reset}"
                        app_uninstaller_core_utilities
                        ;;
                esac
                ;;
            Darwin)
                if command -v brew &> /dev/null; then
                    brew uninstall ffmpeg
                else
                    log_message "ERROR" "${red_fg_strong}Homebrew not installed.${reset}"
                    app_uninstaller_core_utilities
                fi
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                app_uninstaller_core_utilities
                ;;
        esac

        if ! command -v ffmpeg &> /dev/null; then
            log_message "INFO" "${green_fg_strong}FFmpeg has been successfully uninstalled.${reset}"
        else
            log_message "ERROR" "${red_fg_strong}Failed to uninstall FFmpeg.${reset}"
            app_uninstaller_core_utilities
        fi
    else
        log_message "INFO" "${blue_fg_strong}FFmpeg is not installed.${reset}"
    fi

    read -p "Press Enter to continue..."
    app_uninstaller_core_utilities
}

uninstall_nodejs() {
    echo -e "\033]0;STL [UNINSTALL NODEJS]\007"
    if command -v node &> /dev/null; then
        log_message "INFO" "${blue_fg_strong}Uninstalling Node.js...${reset}"
        rm -rf /usr/local/bin/npm 
        rm -rf /usr/local/share/man/man1/node* 
        rm -rf /usr/local/lib/dtrace/node.d
        rm -rf ~/.npm
        rm -rf ~/.node-gyp
        rm -rf /opt/local/bin/node
        rm -rf /opt/local/include/node
        rm -rf /opt/local/lib/node_modules
        rm -rf /usr/local/lib/node*
        rm -rf /usr/local/include/node*
        rm -rf /usr/local/bin/node*
        case "$(uname -s)" in
            Linux)
                package_manager=$(detect_package_manager)
                case "$package_manager" in
                    apt)
                        sudo apt remove -y nodejs npm
                        ;;
                    dnf|yum)
                        sudo $package_manager remove -y nodejs npm
                        ;;
                    apk)
                        sudo apk del nodejs npm
                        ;;
                    pacman)
                        sudo pacman -Rns --noconfirm nodejs npm
                        ;;
                    emerge)
                        sudo emerge --unmerge nodejs
                        ;;
                    zypper)
                        sudo zypper remove -y nodejs npm
                        ;;
                    xbps)
                        sudo xbps-remove -y nodejs npm
                        ;;
                    nix)
                        nix-env -e nodejs
                        ;;
                    guix)
                        guix package -r node
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported package manager or distribution.${reset}"
                        exit 1
                        ;;
                esac
                ;;
            Darwin)
                if command -v brew &> /dev/null; then
                    brew uninstall node
                else
                    log_message "ERROR" "${red_fg_strong}Homebrew not installed.${reset}"
                    exit 1
                fi
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                exit 1
                ;;
        esac

        if ! command -v node &> /dev/null; then
            log_message "INFO" "${green_fg_strong}Node.js successfully uninstalled.${reset}"
        fi
    else
        log_message "INFO" "${blue_fg_strong}Node.js is not installed.${reset}"
    fi

    read -p "Press Enter to continue..."
    app_uninstaller_core_utilities
}


uninstall_git() {
    if command -v git &> /dev/null; then
        log_message "INFO" "${blue_fg_strong}Uninstalling Git...${reset}"

        case "$(uname -s)" in
            Linux)
                package_manager=$(detect_package_manager)
                case "$package_manager" in
                    apt)
                        sudo apt remove -y git
                        ;;
                    dnf|yum)
                        sudo $package_manager remove -y git
                        ;;
                    apk)
                        sudo apk del git
                        ;;
                    pacman)
                        sudo pacman -Rns --noconfirm git
                        ;;
                    emerge)
                        sudo emerge --unmerge dev-vcs/git
                        ;;
                    zypper)
                        sudo zypper remove -y git
                        ;;
                    xbps)
                        sudo xbps-remove -y git
                        ;;
                    nix)
                        nix-env -e git
                        ;;
                    guix)
                        guix package -r git
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported package manager or distribution.${reset}"
                        app_uninstaller_core_utilities
                        ;;
                esac
                ;;
            Darwin)
                if command -v brew &> /dev/null; then
                    brew uninstall git
                else
                    log_message "ERROR" "${red_fg_strong}Homebrew not installed.${reset}"
                    app_uninstaller_core_utilities
                fi
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                app_uninstaller_core_utilities
                ;;
        esac

        if ! command -v git &> /dev/null; then
            log_message "INFO" "${green_fg_strong}Git has been successfully uninstalled.${reset}"
        else
            log_message "ERROR" "${red_fg_strong}Failed to uninstall Git.${reset}"
            app_uninstaller_core_utilities
        fi
    else
        log_message "INFO" "${blue_fg_strong}Git is not installed.${reset}"
    fi

    read -p "Press Enter to continue..."
    app_uninstaller_core_utilities
}

uninstall_tailscale() {
    if command -v tailscale &> /dev/null; then
        log_message "INFO" "${blue_fg_strong}Uninstalling Tailscale...${reset}"

        # Stop Tailscale service
        if systemctl is-active --quiet tailscaled; then
            log_message "INFO" "Stopping Tailscale service..."
            sudo systemctl stop tailscaled
        fi

        # Disable Tailscale service
        if systemctl is-enabled --quiet tailscaled; then
            log_message "INFO" "Disabling Tailscale service..."
            sudo systemctl disable tailscaled
        fi

        # Remove Tailscale binary and configuration files
        case "$(uname -s)" in
            Linux)
                package_manager=$(detect_package_manager)
                case "$package_manager" in
                    apt)
                        sudo apt remove -y tailscale
                        ;;
                    dnf|yum)
                        sudo $package_manager remove -y tailscale
                        ;;
                    apk)
                        sudo apk del tailscale
                        ;;
                    pacman)
                        sudo pacman -R --noconfirm tailscale
                        ;;
                    emerge)
                        sudo emerge --ask --depclean net-vpn/tailscale
                        ;;
                    zypper)
                        sudo zypper remove -y tailscale
                        ;;
                    xbps)
                        sudo xbps-remove -y tailscale
                        ;;
                    nix)
                        nix-env -e tailscale
                        ;;
                    guix)
                        guix package -r tailscale
                        ;;
                    *)
                        log_message "ERROR" "${red_fg_strong}Unsupported package manager or distribution.${reset}"
                        app_uninstaller_core_utilities
                        ;;
                esac
                ;;
            Darwin)
                if command -v brew &> /dev/null; then
                    brew uninstall tailscale
                else
                    log_message "ERROR" "${red_fg_strong}Homebrew not installed.${reset}"
                    app_uninstaller_core_utilities
                fi
                ;;
            *)
                log_message "ERROR" "${red_fg_strong}Unsupported operating system.${reset}"
                app_uninstaller_core_utilities
                ;;
        esac

        # Remove Tailscale configuration files
        if [ -d "/var/lib/tailscale" ]; then
            log_message "INFO" "Removing Tailscale configuration files..."
            sudo rm -rf /var/lib/tailscale
        fi

        if ! command -v tailscale &> /dev/null; then
            log_message "INFO" "${green_fg_strong}Tailscale has been successfully uninstalled.${reset}"
        else
            log_message "ERROR" "${red_fg_strong}Failed to uninstall Tailscale.${reset}"
            app_uninstaller_core_utilities
        fi
    else
        log_message "INFO" "${blue_fg_strong}Tailscale is not installed.${reset}"
    fi

    read -p "Press Enter to continue..."
    app_uninstaller_core_utilities
}


uninstall_ngrok() {
    if command -v ngrok &> /dev/null; then
        log_message "INFO" "${blue_fg_strong}Uninstalling ngrok...${reset}"

        # Remove the ngrok binary
        sudo rm -f /usr/local/bin/ngrok

        # Remove ngrok configuration files
        if [ -d "$HOME/.config/ngrok" ]; then
            log_message "INFO" "Removing ngrok configuration files..."
            rm -rf "$HOME/.config/ngrok"
        fi

        if ! command -v ngrok &> /dev/null; then
            log_message "INFO" "${green_fg_strong}ngrok has been successfully uninstalled.${reset}"
        else
            log_message "ERROR" "${red_fg_strong}Failed to uninstall ngrok.${reset}"
            app_uninstaller_core_utilities
        fi
    else
        log_message "INFO" "${blue_fg_strong}ngrok is not installed.${reset}"
    fi

    read -p "Press Enter to continue..."
    app_uninstaller_core_utilities
}

app_uninstaller_text_completion() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_installer
}

app_uninstaller_voice_generation() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_installer
}

app_uninstaller_image_generation() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    app_uninstaller
}

app_uninstaller_core_utilities() {
    echo -e "\033]0;STL [APP UNINSTALLER CORE UTILITIES]\007"
    clear

    echo -e "${blue_fg_strong}| > / Home / Toolbox / App Uninstaller / Core Utilities        |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"

    echo "    1. UNINSTALL Extras"
    echo "    2. UNINSTALL SillyTavern"
    echo "    3. UNINSTALL 7-Zip"
    echo "    4. UNINSTALL FFmpeg"
    echo "    5. UNINSTALL Node.js"
    echo "    6. UNINSTALL yq"
    echo "    7. UNINSTALL Visual Studio BuildTools"
    echo "    8. UNINSTALL CUDA Toolkit"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Remote Access & Tunneling                                    |${reset}"
    echo "    9. UNINSTALL Tailscale"
    echo "    10. UNINSTALL ngrok"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
    read -p "   Choose Your Destiny: " app_uninstaller_choice

    case $app_uninstaller_choice in
        1) uninstall_extras ;;
        2) uninstall_st ;;
        3) uninstall_p7zip ;;
        4) uninstall_ffmpeg ;;
        5) uninstall_nodejs ;;
        6) uninstall_yq ;;
        7) uninstall_vs_buildtools ;;
        8) uninstall_cuda_toolkit ;;
        9) uninstall_tailscale ;;
        10) uninstall_ngrok ;;

        0) app_uninstaller ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           app_uninstaller_core_utilities ;;
    esac
}


############################################################
############## APP UNINSTALLER - FRONTEND ##################
############################################################
app_uninstaller() {
    echo -e "\033]0;STL [APP UNINSTALLER]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Toolbox / App Uninstaller                         |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"
    echo "    1. Text Completion"
    echo "    2. Voice Generation"
    echo "    3. Image Generation"
    echo "    4. Core Utilities"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
    read -p "  Choose Your Destiny: " app_uninstaller_choice

################# APP UNINSTALLER - BACKEND ################
    case $app_uninstaller_choice in
        1) app_uninstaller_text_completion ;;
        2) app_uninstaller_voice_generation ;;
        3) app_uninstaller_image_generation ;;
        4) app_uninstaller_core_utilities ;;
        0) toolbox ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           app_uninstaller ;;
    esac
}

############################################################
################# TOOLBOX - FRONTEND #######################
############################################################
toolbox() {
    echo -e "\033]0;STL [TOOLBOX]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / Toolbox                                           |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"
    echo "    1. App Launcher"
    echo "    2. App Installer"
    echo "    3. App Uninstaller"
    echo "    4. Editor"
    echo "    5. Backup"
    echo "    6. Switch Branch"
    echo "    7. Reset Custom Shortcut"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Back"

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"

    read -p "  Choose Your Destiny: " toolbox_choice

################# TOOLBOX - BACKEND #######################
    case $toolbox_choice in
        1) app_launcher ;;
        2) app_installer ;;
        3) app_uninstaller ;;
        4) editor ;;
        5) backup ;;
        6) switch_branch ;;
        7) reset_custom_shortcut ;;
        0) home ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           toolbox ;;
    esac
}


########################################################################################
########################################################################################
####################### STARTUP CHECK FUNCTIONS  #######################################
########################################################################################
########################################################################################

# Function to detect package manager
detect_package_manager() {
    local package_manager

    case "$(true; command -v apt dnf yum apk pacman emerge zypper xbps-install guix nix-env 2>/dev/null | head -n1)" in
        *apt) package_manager="apt" ;;
        *dnf) package_manager="dnf" ;;
        *yum) package_manager="yum" ;;
        *apk) package_manager="apk" ;;
        *pacman) package_manager="pacman" ;;
        *emerge) package_manager="emerge" ;;
        *zypper) package_manager="zypper" ;;
        *xbps-install) package_manager="xbps" ;;
        *guix) package_manager="guix" ;;
        *nix-env) package_manager="nix" ;;
        *)
            if [ -f /etc/os-release ]; then
                os_id=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
                case "$os_id" in
                    almalinux|centos_stream|ol|rhel|rocky|fedora|fedoraremixforwsl|nobara)
                        package_manager="yum" ;;
                    alpine|wolfi)
                        package_manager="apk" ;;
                    arch|arch32|archcraft|arcolinux|arkane|artix|aurora|bazzite|blackarch|blendos|bluefin|bodhi|cachyos|chimera|chimeraos|endeavouros|garuda|hyperbola|kaos|manjaro|manjaro-arm|rebornos|steamos|void)
                        package_manager="pacman" ;;
                    debian|devuan|elementary|kali|linuxmint|parrot|pika|pisilinux|pop|pureos|raspbian|tails|ubuntu|ubuntu_kylin|vanillaos|zorin)
                        package_manager="apt" ;;
                    opensuse-leap|opensuse-tumbleweed|sled|sles)
                        package_manager="zypper" ;;
                    gentoo|funtoo)
                        package_manager="emerge" ;;
                    nixos)
                        package_manager="nix" ;;
                    guix)
                        package_manager="guix" ;;
                    clear-linux-os|miraclelinux|photon|solus|tencentos|tinycore|trisquel|ultramarine)
                        package_manager="unknown" ;; # Custom handling needed
                    *)
                        package_manager="unknown" ;;
                esac
            else
                package_manager="unknown"
            fi
            ;;
    esac

    echo "$package_manager"
}

# Function to create the logs folder if it doesn't exist
create_logs_folder() {
    if [ ! -d "$log_dir" ]; then
        mkdir -p "$log_dir"
        log_message "INFO" "Created logs directory: $log_dir"
    fi
}

# Function to check if the folder path has no spaces
check_path_spaces() {
    if [[ "$PWD" =~ [[:space:]] ]]; then
        log_message "ERROR" "${red_fg_strong}Path cannot have spaces! Please remove them or replace with: - ${reset}"
        log_message "ERROR" "Folders containing spaces make the launcher unstable."
        log_message "ERROR" "Path: ${red_fg_strong}$PWD${reset}"
        exit 1
    fi
}

# Function to check if the folder path has no special characters
check_path_special_chars() {
    if [[ "$PWD" =~ [\!\#\$\%\&\*\+\,\;\<\=\>\?\@\[\]\^\`\{\|\}\~] ]]; then
        log_message "ERROR" "${red_fg_strong}Path cannot have special characters! Please remove them.${reset}"
        log_message "ERROR" "Folders containing special characters make the launcher unstable."
        log_message "ERROR" "Path: ${red_fg_strong}$PWD${reset}"
        exit 1
    fi
}


# Function to check for updates in the launcher
check_launcher_updates() {
    log_message "INFO" "Checking for updates..."
    git fetch origin
    current_branch=$(git branch --show-current)
    if [ "$(git rev-list HEAD..origin/$current_branch)" ]; then
        log_message "INFO" "${cyan_fg_strong}New update for SillyTavern-Launcher is available!${reset}"
        read -p "Update now? [Y/n]: " update_choice
        update_choice=${update_choice:-Y}
        if [[ "$update_choice" =~ ^[Yy]$ ]]; then
            log_message "INFO" "Updating the repository..."
            git pull
            log_message "INFO" "${green_fg_strong}SillyTavern-Launcher updated successfully. Restarting launcher...${reset}"
            sleep 10
            exec ./launcher.sh
            exit
        fi
    else
        log_message "INFO" "${green_fg_strong}SillyTavern-Launcher is up to date.${reset}"
    fi
}

# Function to create necessary directories
create_directories() {
    if [ ! -d "$bin_dir" ]; then
        mkdir -p "$bin_dir"
        log_message "INFO" "Created folder: $bin_dir"
    fi

    if [ ! -d "$functions_dir" ]; then
        mkdir -p "$functions_dir"
        log_message "INFO" "Created folder: $functions_dir"
    fi

    if [ ! -d "$log_dir" ]; then
        mkdir -p "$log_dir"
        log_message "INFO" "Created folder: $log_dir"
    fi
}

# Function to create empty module files if they don't exist
create_module_files() {
    modules=("extras" "xtts" "sdwebui" "ooba" "tabbyapi")
    for module in "${modules[@]}"; do
        module_path="$bin_dir/settings/modules-$module.txt"
        if [ ! -f "$module_path" ]; then
            touch "$module_path"
            log_message "INFO" "Created text file: modules-$module.txt"
        fi
    done
}


# Function to check if Miniconda3 is installed
check_miniconda() {
    if ! command -v conda &> /dev/null; then
        log_message "WARN" "${yellow_fg_strong}Miniconda3 is not installed on this system.${reset}"
        log_message "INFO" "Please install Miniconda3 manually from https://docs.conda.io/en/latest/miniconda.html"
    else
        log_message "INFO" "${blue_fg_strong}Miniconda3 is already installed.${reset}"
    fi
}

# Function to check if SillyTavern folder exists
check_sillytavern_folder() {
    if [ ! -d "$st_install_path" ]; then
        log_message "ERROR" "${red_fg_strong}SillyTavern not found in: $st_install_path${reset}"
        read -p "Press Enter to run the install.sh script"
        ./install.sh
    fi
}

# Function to check for updates in SillyTavern
check_sillytavern_updates() {
    cd "$st_install_path" || { log_message "ERROR" "${red_fg_strong}Failed to change directory to SillyTavern.${reset}"; exit 1; }
    log_message "INFO" "Checking for SillyTavern updates..."
    git fetch origin
    if [ "$(git rev-list HEAD..origin/$(git branch --show-current))" ]; then
        log_message "INFO" "${cyan_fg_strong}New update for SillyTavern is available!${reset}"
        read -p "Update now? [Y/n]: " update_choice
        update_choice=${update_choice:-Y}
        if [[ "$update_choice" =~ ^[Yy]$ ]]; then
            log_message "INFO" "Updating SillyTavern..."
            git pull
            log_message "INFO" "${green_fg_strong}SillyTavern updated successfully.${reset}"
        fi
    else
        log_message "INFO" "${green_fg_strong}SillyTavern is up to date.${reset}"
    fi
}


########################################################################################
########################################################################################
####################### DISPLAY STATUS FUNCTIONS  ######################################
########################################################################################
########################################################################################

# Function to get the current Git branch
get_current_branch() {
    current_st_branch=$(git -C "$st_install_path" branch --show-current)

}

# Function to manage the GPU info counter
manage_gpu_counter() {
    counter_file="$log_dir/gpu_counter.txt"
    if [ -f "$counter_file" ]; then
        counter=$(cat "$counter_file")
        counter=$((counter + 1))
    else
        counter=1
    fi

    if [ "$counter" -ge 10 ]; then
        counter=0
        rm -f "$log_dir/gpu_info_output.txt"
    fi

    echo "$counter" > "$counter_file"
}

# Function to detect GPU info
detect_gpu_info() {
    if [ ! -f "$log_dir/gpu_info_output.txt" ]; then
        "$troubleshooting_dir/gpu_info.sh" > "$log_dir/gpu_info_output.txt"
    fi

    if [ -f "$log_dir/gpu_info_output.txt" ]; then
        gpuInfo=$(cat "$log_dir/gpu_info_output.txt")
    else
        gpuInfo="GPU Info not found"
    fi
}

# Function to read Tailscale status
read_tailscale_status() {
    if [ -f "$log_dir/tailscale_status.txt" ]; then
        count=0
        while IFS= read -r line; do
            count=$((count + 1))
            case $count in
                1) ip4="$line" ;;
                2) hostName="$line" ;;
                3) dnsName="$line" ;;
            esac
        done < "$log_dir/tailscale_status.txt"

        # Remove trailing period from dnsName if it exists
        if [[ "$dnsName" == *. ]]; then
            dnsName="${dnsName%.}"
        fi
    fi
}

# Function to get SillyTavern version from package.json
get_sillytavern_version() {
    if [ -f "$st_package_json_path" ]; then
        st_version=$(grep -oP '"version": "\K[^"]+' "$st_package_json_path")
    else
        st_version="${red_fg_strong}[ERROR] Cannot get ST version because package.json file not found in $st_install_path${reset}"
    fi
}

# Function to display version and compatibility status
display_version_status() {
    echo -e "${yellow_fg_strong} ______________________________________________________________${reset}"
    echo -e "${yellow_fg_strong}| Version & Compatibility Status:                              |${reset}"
    echo -e "    SillyTavern - Branch: ${cyan_fg_strong}$current_st_branch ${reset}| Status: ${cyan_fg_strong}$update_status_st${reset}"
    echo -e "    SillyTavern: ${cyan_fg_strong}$st_version${reset}"
    echo -e "    STL: ${cyan_fg_strong}$stl_version${reset}"
    echo -e "    Node.js: ${cyan_fg_strong}$node_version${reset}"

    if [ -n "$ip4" ]; then
        echo -e "    Tailscale URL - IP4: ${cyan_fg_strong}http://$ip4:8000${reset}"
    fi
    if [ -n "$hostName" ]; then
        echo -e "    Tailscale URL - Machine Name: ${cyan_fg_strong}http://$hostName:8000${reset}"
    fi
    if [ -n "$dnsName" ]; then
        echo -e "    Tailscale URL - MagicDNS Name: ${cyan_fg_strong}http://$dnsName:8000${reset}"
    fi

    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
}

########################################################################################
########################################################################################
####################### HOME MENU  FUNCTIONS  ##########################################
########################################################################################
########################################################################################

# Exit Function
exit_program() {
    clear
    echo "Bye!"
    exit 0
}

# Function to find a suitable terminal emulator with proper fallbacks
find_terminal() {
    # List of common terminal emulators in priority order
    local terminals=(
        "gnome-terminal"          # GNOME
        "konsole"                 # KDE
        "xfce4-terminal"          # XFCE
        "mate-terminal"           # MATE
        "lxterminal"              # LXDE
        "kitty"                   # Kitty
        "alacritty"               # Alacritty
        "tilix"                   # Tilix
        "terminator"              # Terminator
        "urxvt"                   # RXVT
        "xterm"                   # XTerm
        "x-terminal-emulator"     # Debian/Ubuntu fallback
    )

    # First check the $TERMINAL environment variable
    if [ -n "$TERMINAL" ] && command -v "$TERMINAL" >/dev/null 2>&1; then
        echo "$TERMINAL"
        return 0
    fi

    # Check the list of known terminals
    for term in "${terminals[@]}"; do
        if command -v "$term" >/dev/null 2>&1; then
            echo "$term"
            return 0
        fi
    done

    # Final fallback to x-terminal-emulator
    if command -v "x-terminal-emulator" >/dev/null 2>&1; then
        echo "x-terminal-emulator"
        return 0
    fi

    # If no terminal found, return error
    return 1
}

start_st() {
    check_nodejs

    local start_script_path="$st_install_path/start.sh"
    local detected_terminal

    if [ "$LAUNCH_NEW_WIN" = "0" ]; then
        log_message "INFO" "SillyTavern launched"
        (cd "$st_install_path" && exec "./start.sh")
    else
        log_message "INFO" "SillyTavern launched in a new window."
        detected_terminal=$(find_terminal)
        
        if [ $? -ne 0 ]; then
            log_message "ERROR" "No terminal emulator found! Falling back to current shell"
            (cd "$st_install_path" && exec "./start.sh")
            return
        fi

        log_message "INFO" "Found terminal: $detected_terminal"

        # macOS handling
        if [ "$(uname)" = "Darwin" ]; then
            log_message "INFO" "Detected macOS. Opening new Terminal window."
            osascript <<EOD
tell application "Terminal"
    do script "cd \"$st_install_path\" && ./start.sh"
    activate
end tell
EOD
        else
            # Linux terminal handling with appropriate flags
            case $(basename "$detected_terminal") in
                "gnome-terminal")
                    "$detected_terminal" --working-directory="$st_install_path" -- bash -c "./start.sh; exec bash" &
                    home
                    ;;
                "mate-terminal"|"xfce4-terminal"|"tilix"|"terminator")
                    "$detected_terminal" --working-directory="$st_install_path" -e "bash -c './start.sh; exec bash'" &
                    home
                    ;;
                "konsole")
                    "$detected_terminal" --workdir "$st_install_path" -e "bash -c './start.sh; exec bash'" &
                    home
                    ;;
                "kitty"|"alacritty")
                    "$detected_terminal" --working-directory "$st_install_path" -e bash -c "./start.sh" &
                    home
                    ;;
                "xterm"|"uxterm"|"urxvt")
                    "$detected_terminal" -e "bash -c 'cd \"$st_install_path\" && ./start.sh; exec bash'" &
                    home
                    ;;
                *)
                    # Generic fallback for other terminals
                    "$detected_terminal" --working-directory="$st_install_path" -- bash -c "./start.sh; exec bash" &
                    home
                    ;;
            esac
        fi
    fi
}

update_start_st() {
    git -C "$st_install_path" pull
    start_st
}

start_st_remotelink() {
    echo -e "\033]0;STL [ST REMOTE LINK]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home / SillyTavern Remote Link                           |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"

    # Warning and confirmation prompt
    echo
    echo -e "${blue_bg}${bold}╔═══════════════ CLOUDFLARE TUNNEL ═══════════════════════════════════════════════════╗${reset}"
    echo -e "${blue_bg}${bold}║ WARNING: This script downloads and runs the latest cloudflared from Cloudflare to   ║${reset}"
    echo -e "${blue_bg}${bold}║ set up an HTTPS tunnel to your SillyTavern.                                         ║${reset}"
    echo -e "${blue_bg}${bold}║                                                                                     ║${reset}"
    echo -e "${blue_bg}${bold}║ Using the randomly generated temporary tunnel URL, anyone can access your           ║${reset}"
    echo -e "${blue_bg}${bold}║ SillyTavern over the Internet while the tunnel is active.                           ║${reset}"
    echo -e "${blue_bg}${bold}║                                                                                     ║${reset}"
    echo -e "${blue_bg}${bold}║ Keep the URL safe and secure your SillyTavern installation by setting a username    ║${reset}"
    echo -e "${blue_bg}${bold}║ and password in config.yaml.                                                        ║${reset}"
    echo -e "${blue_bg}${bold}║                                                                                     ║${reset}"
    echo -e "${blue_bg}${bold}║ See https://docs.sillytavern.app/usage/remoteconnections/ for more details about    ║${reset}"
    echo -e "${blue_bg}${bold}║ how to secure your SillyTavern install.                                             ║${reset}"
    echo -e "${blue_bg}${bold}║                                                                                     ║${reset}"
    echo -e "${blue_bg}${bold}║ By continuing you confirm that you're aware of the potential dangers of having a    ║${reset}"
    echo -e "${blue_bg}${bold}║ tunnel open and take all responsibility to properly use and secure it.              ║${reset}"
    echo -e "${blue_bg}${bold}╚═════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo
    echo -n -e "${yellow_fg_strong}Are you sure you want to continue? [Y/N]: ${reset}"
    read -r confirm

    case "$confirm" in
        [Yy]*)
            # Check if cloudflared is already downloaded, if not, download it
            if [ ! -f cloudflared ]; then
                echo "Downloading cloudflared..."
                curl -Lo cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
                chmod +x cloudflared
            fi

            # Run cloudflared tunnel
            ./cloudflared tunnel --url localhost:8000
            start_st
            ;;
        [Nn]*)
            home
            ;;
        *)
            log_message "ERROR" "Invalid input. Please enter Y or N."
            read -p "Press Enter to try again..."
            start_st_remotelink
            ;;
    esac
}

launch_custom_shortcut() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    home

}

update_manager() {
    log_message "INFO" "coming soon"
    read -p "Press Enter to continue..."
    home
    
}

info_vram() {
    # Clear the screen
    clear

    # Get GPU information using lspci and filter for VGA compatible controllers
    gpu_info=$(lspci | grep -i vga)
    if [ -z "$gpu_info" ]; then
        gpu_info="GPU information not found"
    fi

    # Get VRAM size using nvidia-smi (for NVIDIA GPUs) or fallback to other methods
    if command -v nvidia-smi &> /dev/null; then
        UVRAM=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | awk '{print $1/1024}')
    else
        UVRAM=0
        echo "DEBUG: VRAM could not be detected. Defaulting to 0."
    fi

    # Handle undefined or invalid UVRAM
    if [ -z "$UVRAM" ] || [ "$UVRAM" = "Property not found" ]; then
        UVRAM=0
        echo "DEBUG: VRAM could not be detected. Defaulting to 0."
    fi

    # Display header
    echo -e "${blue_fg_strong}| > / Home / VRAM & LLM Info                                                                           |${reset}"
    echo -e "${blue_fg_strong}======================================================================================================${reset}"

    # Display GPU information
    echo -e "${cyan_fg_strong}GPU: $gpu_info${reset}"
    echo -e "${cyan_fg_strong}GPU VRAM: $UVRAM GB${reset}"

    # Recommendations based on VRAM size
    if (( $(echo "$UVRAM < 8" | bc -l) )); then
        echo "It's recommended to stick with APIs like OpenAI, Claude, or OpenRouter for LLM usage."
        echo "Local models will result in memory errors or perform very slowly."
    elif (( $(echo "$UVRAM < 12" | bc -l) )); then
        echo "Great for 7B and 8B models. Check info below for BPW (Bits Per Weight)."
        display_bpw_table
    elif (( $(echo "$UVRAM < 22" | bc -l) )); then
        echo "Great for 7B, 8B, and 13B models. Check info below for BPW (Bits Per Weight)."
        display_bpw_table
    elif (( $(echo "$UVRAM < 25" | bc -l) )); then
        echo "Great for 7B, 8B, 13B, and 30B models. Check info below for BPW (Bits Per Weight)."
        display_bpw_table
    elif (( $(echo "$UVRAM >= 25" | bc -l) )); then
        echo "Great for 7B, 8B, 13B, 30B, and 70B models. Check info below for BPW (Bits Per Weight)."
        display_bpw_table
    else
        echo "An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications."
    fi

    # Ask if the user wants to check the VRAM calculator website
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}|                                                              |${reset}"
    read -p "  Check for compatible models on VRAM calculator website? [Y/N]: " info_vram_choice
    info_vram_choice=$(echo "$info_vram_choice" | tr '[:upper:]' '[:lower:]')

    if [ "$info_vram_choice" = "y" ]; then
        xdg-open "https://sillytavernai.com/llm-model-vram-calculator/?vram=$UVRAM"
    fi

    # Return to the home menu
    home
}

# Function to display the BPW (Bits Per Weight) table
display_bpw_table() {
    echo
    echo "╔══ EXL2 - RECOMMENDED BPW [Bits Per Weight] ═════════════════════════════════════════════════════════════════════════════════╗"
    echo "║ Branch ║ Bits ║ lm_head bits ║ VRAM - 4k ║ VRAM - 8k ║ VRAM - 16k ║ VRAM - 32k ║ Description                                ║"
    echo "║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║"
    echo "║ 8.0    ║ 8.0  ║ 8.0          ║ 10.1 GB   ║ 10.5 GB   ║ 11.5 GB    ║ 13.6 GB    ║ Maximum quality that ExLlamaV2             ║"
    echo "║        ║      ║              ║           ║           ║            ║            ║ can produce, near unquantized performance. ║"
    echo "║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║"
    echo "║ 6.5    ║ 6.5  ║ 8.0          ║ 8.9 GB    ║ 9.3 GB    ║ 10.3 GB    ║ 12.4 GB    ║ Similar to 8.0, good tradeoff of           ║"
    echo "║        ║      ║              ║           ║           ║            ║            ║ size vs performance, RECOMMENDED.          ║"
    echo "║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║"
    echo "║ 5.0    ║ 5.0  ║ 6.0          ║ 7.7 GB    ║ 8.1 GB    ║ 9.1 GB     ║ 11.2 GB    ║ Slightly lower quality vs 6.5,             ║"
    echo "║        ║      ║              ║           ║           ║            ║            ║ but usable on 8GB cards.                   ║"
    echo "║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║"
    echo "║ 4.25   ║ 4.25 ║ 6.0          ║ 7.0 GB    ║ 7.4 GB    ║ 8.4 GB     ║ 10.5 GB    ║ GPTQ equivalent bits per weight,           ║"
    echo "║        ║      ║              ║           ║           ║            ║            ║ slightly higher quality.                   ║"
    echo "║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║"
    echo "║ 3.5    ║ 3.5  ║ 6.0          ║ 6.4 GB    ║ 6.8 GB    ║ 7.8 GB     ║ 9.9 GB     ║ Lower quality, only use if you have to.    ║"
    echo "╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
    echo
}

############################################################
################## HOME - FRONTEND #########################
############################################################
home() {
    echo -e "\033]0;STL [HOME]\007"
    clear
    echo -e "${blue_fg_strong}| > / Home                                                     |${reset}"
    echo -e "${blue_fg_strong}==============================================================${reset}"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| What would you like to do?                                   |${reset}"
    echo "    1. Update & Start SillyTavern"
    echo "    2. Start SillyTavern"
    echo "    3. Start SillyTavern With Remote Link"
    echo "    4. Create Custom App Shortcut"
    echo "    5. Update Manager"
    echo "    6. Toolbox"
    echo "    7. Troubleshooting & Support"
    echo "    8. More info about LLM models your GPU can run."
    # DEBUG CURRENT PATH
    #echo -e "$(pwd)"
    #echo -e "$stl_root"
    #echo "$(dirname "$(realpath "$0")")"
    echo -e "${cyan_fg_strong} ______________________________________________________________${reset}"
    echo -e "${cyan_fg_strong}| Menu Options:                                                |${reset}"
    echo "    0. Exit"

    # Display version and compatibility status
    display_version_status

    read -p "  Choose Your Destiny: " home_choice

    # Default to choice 1 if no input is provided
    if [ -z "$home_choice" ]; then
        home_choice=1
    fi


################## HOME - BACKEND #########################
    case $home_choice in
        1) update_start_st ;;
        2) start_st ;;
        3) start_st_remotelink ;;
        4) launch_custom_shortcut ;;
        5) update_manager ;;
        6) toolbox ;;
        7) troubleshooting ;;
        8) info_vram ;;
        0) exit_program ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           home ;;
    esac
}

# Startup functions
startup() {
    create_logs_folder
    check_path_spaces
    check_path_special_chars
    install_git
    check_launcher_updates
    create_directories
    create_module_files
    install_nodejs
    check_miniconda
    check_sillytavern_folder
    check_sillytavern_updates

    # Functions related for displaying status
    cd "$stl_root"
    
    get_current_branch
    manage_gpu_counter
    detect_gpu_info
    read_tailscale_status
    get_sillytavern_version
    node_version=$(node -v)
    stl_version="24.1.0.0"
    update_status_st="Up to date"
}

# Run startup functions
startup

# Display the main menu
home