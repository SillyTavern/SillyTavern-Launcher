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
app_uninstaller_voice_generation_dir="$functions_dir/Toolbox/App_Uninstaller/Voice_Generation"
voice_generation_dir="$stl_root/voice-generation"
alltalk_v2_install_path="$voice_generation_dir/alltalk_tts"

# Ensure log directory exists
mkdir -p "$log_dir"
logs_stl_console_path="$log_dir/stl_console.log"


# Function to log messages with timestamps and colors
log_message() {
    current_time=$(date +'%H:%M:%S') # Current time
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
        "OK")
            echo -e "${green_bg}[$current_time]${reset} ${green_fg_strong}[OK]${reset} $2"
            ;;
        *)
            echo -e "${blue_bg}[$current_time]${reset} ${blue_fg_strong}[DEBUG]${reset} $2"
            ;;
    esac
}

# Function to find Miniconda installation directory
find_conda() {
    local paths=(
        "$HOME/miniconda3"
        "$HOME/miniconda"
        "/opt/miniconda3"
        "/opt/miniconda"
        "/usr/local/miniconda3"
        "/usr/local/miniconda"
        "/usr/miniconda3"
        "/usr/miniconda"
        "$HOME/anaconda3"
        "$HOME/anaconda"
        "/opt/anaconda3"
        "/opt/anaconda"
        "/usr/local/anaconda3"
        "/usr/local/anaconda"
        "/usr/anaconda3"
        "/usr/anaconda"
    )

    for path in "${paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done

    return 1
}

# Function to check if Miniconda3 is installed
check_miniconda() {
    # Try to find Miniconda installation
    miniconda_path=$(find_conda)
    if [ $? -ne 0 ]; then
        log_message "WARN" "${yellow_fg_strong}Miniconda3 is not installed on this system.${reset}"
        log_message "INFO" "Please install Miniconda3 manually from https://docs.conda.io/en/latest/miniconda.html"
        return 1
    fi

    # Source Conda initialization script
    if [ -f "${miniconda_path}/etc/profile.d/conda.sh" ]; then
        source "${miniconda_path}/etc/profile.d/conda.sh"
    else
        log_message "ERROR" "${red_fg_strong}Conda initialization script not found at ${miniconda_path}/etc/profile.d/conda.sh${reset}"
        log_message "INFO" "Please ensure Miniconda3 is properly installed from https://docs.conda.io/en/latest/miniconda.html"
        return 1
    fi
    
    # Check if conda command is available
    if ! command -v conda &> /dev/null; then
        log_message "ERROR" "${red_fg_strong}Conda command not available after initialization.${reset}"
        log_message "INFO" "Please ensure Miniconda3 is properly installed from https://docs.conda.io/en/latest/miniconda.html"
        return 1
    fi

    log_message "INFO" "${blue_fg_strong}Miniconda3 is installed at ${miniconda_path}${reset}"
}

uninstall_alltalk_v2() {
    echo -e "${red_bg}╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${red_bg}║ WARNING: This will delete all data of AllTalk V2                                              ║${reset}"
    echo -e "${red_bg}║ If you want to keep any data, make sure to create a backup before proceeding.                 ║${reset}"
    echo -e "${red_bg}╚═══════════════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo

    read -p "Are you sure you want to proceed? [Y/N]: " confirmation
    if [[ "${confirmation^^}" == "Y" ]]; then
        # Activate the Miniconda installation
        log_message "INFO" "Activating Miniconda environment..."
        source "${miniconda_path}/etc/profile.d/conda.sh"

        # Remove the Conda environment
        log_message "INFO" "Removing the Conda environment: alltalkv2"
        conda deactivate
        conda remove --name alltalkv2 --all -y
        conda clean -a -y

        # Remove the alltalk_tts directory
        if [[ -d "$alltalk_v2_install_path" ]]; then
            log_message "INFO" "Removing the alltalk_tts directory at: $alltalk_v2_install_path"
            rm -rf "$alltalk_v2_install_path"
        else
            log_message "INFO" "No alltalk_tts directory found at: $alltalk_v2_install_path"
        fi

        log_message "INFO" "AllTalk V2 has been uninstalled successfully."
        read -p "Press Enter to continue..."
        exit
    else
        log_message "INFO" "Uninstall canceled."
        read -p "Press Enter to continue..."
        exit
    fi
}

# Execute the uninstall function
find_conda
check_miniconda
uninstall_alltalk_v2