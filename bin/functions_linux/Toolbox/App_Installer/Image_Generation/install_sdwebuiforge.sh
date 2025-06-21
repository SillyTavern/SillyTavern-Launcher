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
app_installer_image_generation_dir="$functions_dir/Toolbox/App_Installer/Image_Generation"
image_generation_dir="$stl_root/image-generation"
sdwebuiforge_install_path="$image_generation_dir/stable-diffusion-webui-forge"

# Ensure log directory exists
mkdir -p "$log_dir"
logs_stl_console_path="$log_dir/stl_console.log"

# Function to log messages with timestamps and colors
log_message() {
    current_time=$(date +'%H:%M:%S')
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
    return 0
}

install_sdwebuiforge() {
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / App Installer / Image Generation / Install Stable Diffusion Web UI Forge${reset}"
    echo -e "-------------------------------------------------------------"
    log_message "INFO" "Installing Stable Diffusion Web UI Forge..."

    # Check if the image-generation folder exists
    if [[ ! -d "$image_generation_dir" ]]; then
        mkdir -p "$image_generation_dir"
        log_message "INFO" "Created folder: $image_generation_dir"
    else
        log_message "INFO" "image-generation folder already exists at: $image_generation_dir"
    fi

    cd "$image_generation_dir" || {
        log_message "ERROR" "Failed to change to directory: $image_generation_dir"
        read -p "Press Enter to continue..."
        bash "$app_installer_image_generation_dir/app_installer_image_generation.sh"
        exit 1
    }

    max_retries=3
    retry_count=0

    while [[ $retry_count -lt $max_retries ]]; do
        log_message "INFO" "Cloning the stable-diffusion-webui-forge repository into: $sdwebuiforge_install_path"
        git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git
        if [[ $? -eq 0 ]]; then
            if [[ -d "$sdwebuiforge_install_path" ]]; then
                log_message "INFO" "Successfully cloned stable-diffusion-webui-forge into: $sdwebuiforge_install_path"
                break
            else
                log_message "ERROR" "Clone succeeded but stable-diffusion-webui-forge directory not found at: $sdwebuiforge_install_path"
                ((retry_count++))
            fi
        else
            ((retry_count++))
            log_message "WARN" "Retry $retry_count of $max_retries"
        fi
        if [[ $retry_count -ge $max_retries ]]; then
            log_message "ERROR" "Failed to clone repository after $max_retries retries."
            read -p "Press Enter to continue..."
            exit
        fi
    done

    cd "$sdwebuiforge_install_path" 

    # Activate the Miniconda installation
    log_message "INFO" "Activating Miniconda environment..."
    source "${miniconda_path}/etc/profile.d/conda.sh"

    # Create a Conda environment named sdwebuiforge
    log_message "INFO" "Creating Conda environment: sdwebuiforge"
    conda create -n sdwebuiforge python=3.10.6 -y

    # Activate the sdwebuiforge environment
    log_message "INFO" "Activating Conda environment: sdwebuiforge"
    conda activate sdwebuiforge

    # Install pip requirements
    log_message "INFO" "Installing pip requirements"
    pip install civitdl

    log_message "OK" "Stable Diffusion Web UI Forge installed successfully."
    read -p "Press Enter to continue..."
    exit
}

# Execute the install function
find_conda
check_miniconda
install_sdwebuiforge