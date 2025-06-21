#!/bin/bash

# ANSI Escape Code for Colors
reset="\033[0m"
white_fg_strong="\033[90m"
red_fg_strong="\033[91m"
green_fg_strong="\033[92m"
yellow_fg_strong="\033[93m"
blue_fg_strong="\033[94m"
magenta_fg_strong="\033[95m"
cyan_fg_strong="\033[96m"

# Text styles
bold="\033[1m"

# Normal Background Colors
red_bg="\033[41m"
blue_bg="\033[44m"
yellow_bg="\033[43m"
green_bg="\033[42m"

# Foreground colors
yellow_fg_strong_fg="\033[33;1m"

# Set stl_root dynamically if not already set by launcher.sh
if [[ -z "$stl_root" ]]; then
    # Navigate up 5 directories from the script's location
    script_dir="$(dirname "$(realpath "$0")")"
    stl_root="$(realpath "$script_dir/../../../../../")"
fi

# Use directory variables
bin_dir="$stl_root/bin"
log_dir="$bin_dir/logs"
functions_dir="$bin_dir/functions_linux"
app_installer_text_completion_dir="$functions_dir/Toolbox/App_Installer/Text_Completion"
st_install_path="$stl_root/SillyTavern"
text_completion_dir="$stl_root/text-completion"
tabbyapi_install_path="$text_completion_dir/tabbyAPI"

# Ensure log directory exists
if ! mkdir -p "$log_dir"; then
    echo -e "${red_bg}[$(date +'%H:%M:%S')]${reset} ${red_fg_strong}[ERROR]${reset} Failed to create log directory: $log_dir"
    exit 1
fi
logs_stl_console_path="$log_dir/stl_console.log"

# Function to log messages with timestamps and colors
log_message() {
    current_time=$(date +'%H:%M:%S')
    case "$1" in
        "INFO")
            echo -e "${blue_bg}[$current_time]${reset} ${blue_fg_strong}[INFO]${reset} $2" | tee -a "$logs_stl_console_path"
            ;;
        "WARN")
            echo -e "${yellow_bg}[$current_time]${reset} ${yellow_fg_strong}[WARN]${reset} $2" | tee -a "$logs_stl_console_path"
            ;;
        "ERROR")
            echo -e "${red_bg}[$current_time]${reset} ${red_fg_strong}[ERROR]${reset} $2" | tee -a "$logs_stl_console_path"
            ;;
        "OK")
            echo -e "${green_bg}[$current_time]${reset} ${green_fg_strong}[OK]${reset} $2" | tee -a "$logs_stl_console_path"
            ;;
        *)
            echo -e "${blue_bg}[$current_time]${reset} ${blue_fg_strong}[DEBUG]${reset} $2" | tee -a "$logs_stl_console_path"
            ;;
    esac
}

install_tabbyapi_st_ext() {
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / App Installer / Text Completion / Install ST-tabbyAPI-loader Extension${reset}"
    echo -e "-------------------------------------------------------------"

    # Check if SillyTavern data directory exists
    if [[ ! -d "$st_install_path/data" ]]; then
        log_message "ERROR" "SillyTavern data directory not found at: $st_install_path/data"
        read -p "Press Enter to continue..."
        exit
    fi

    # Check if git is installed
    if ! command -v git &> /dev/null; then
        log_message "ERROR" "Git is not installed. Please install git and try again."
        read -p "Press Enter to continue..."
        exit
    fi

    # Scan for user folders, excluding _storage and _uploads
    user_folders=()
    while IFS= read -r -d '' folder; do
        folder_name=$(basename "$folder")
        if [[ "$folder_name" != "_storage" && "$folder_name" != "_uploads" ]]; then
            user_folders+=("$folder_name")
        fi
    done < <(find "$st_install_path/data" -maxdepth 1 -type d -not -path "$st_install_path/data" -print0)

    # Check if any user folders were found
    if [ ${#user_folders[@]} -eq 0 ]; then
        log_message "ERROR" "No user folders found in $st_install_path/data"
        read -p "Press Enter to continue..."
        exit
    fi

    # Check if default-user exists
    default_user_exists=false
    for folder in "${user_folders[@]}"; do
        if [[ "$folder" == "default-user" ]]; then
            default_user_exists=true
            break
        fi
    done

    # If default-user exists or multiple folders are found, prompt for selection
    if [[ "$default_user_exists" == true || ${#user_folders[@]} -gt 1 ]]; then
        echo "Detected accounts:"
        echo "================================"
        for i in "${!user_folders[@]}"; do
        echo -e "$((i+1)). ${cyan_fg_strong}${user_folders[i]}${reset}"
        done
        echo "================================"
        echo "0. Cancel"
        echo

        # Prompt user to select a folder
        read -p "Select a folder to install ST-tabbyAPI-loader: " user_choice

        # Check if the user wants to cancel
        if [ "$user_choice" = "0" ]; then
            log_message "INFO" "Installation canceled."
            read -p "Press Enter to continue..."
            exit
        fi

        # Validate user choice
        if ! [[ "$user_choice" =~ ^[0-9]+$ ]]; then
            log_message "ERROR" "Invalid input. Please enter a number."
            read -p "Press Enter to continue..."
            install_tabbyapi_st_ext
            return
        fi

        if [ "$user_choice" -ge 1 ] && [ "$user_choice" -le ${#user_folders[@]} ]; then
            selected_user_folder="${user_folders[$((user_choice-1))]}"
        else
            log_message "ERROR" "Invalid selection. Please enter a number between 1 and ${#user_folders[@]}, or 0 to cancel."
            read -p "Press Enter to continue..."
            install_tabbyapi_st_ext
            return
        fi
    else
        # Auto-select the only folder if default-user doesn't exist
        selected_user_folder="${user_folders[0]}"
        log_message "INFO" "Only one user folder found: $selected_user_folder"
    fi

    # Create extensions directory
    extensions_dir="$st_install_path/data/$selected_user_folder/extensions"
    if ! mkdir -p "$extensions_dir"; then
        log_message "ERROR" "Failed to create directory: $extensions_dir"
        read -p "Press Enter to continue..."
        exit
    fi

    # Check if extension already exists
    if [[ -d "$extensions_dir/ST-tabbyAPI-loader" ]]; then
        log_message "WARN" "ST-tabbyAPI-loader already exists in $extensions_dir."
        read -p "Press Enter to continue..."
        exit
    fi

    # Install the extension in the selected user folder
    log_message "INFO" "Installing ST-tabbyAPI-loader extension in $extensions_dir..."
    cd "$extensions_dir" || {
        log_message "ERROR" "Failed to change to directory: $extensions_dir"
        read -p "Press Enter to continue..."
        exit
    }

    git clone https://github.com/theroyallab/ST-tabbyAPI-loader.git
    if [ $? -eq 0 ]; then
        log_message "OK" "ST-tabbyAPI-loader Extension for SillyTavern has been installed successfully in $extensions_dir/ST-tabbyAPI-loader."
    else
        log_message "ERROR" "Failed to clone ST-tabbyAPI-loader repository."
        read -p "Press Enter to continue..."
        exit
    fi

    read -p "Press Enter to continue..."
    exit
}

# Execute the install function
install_tabbyapi_st_ext