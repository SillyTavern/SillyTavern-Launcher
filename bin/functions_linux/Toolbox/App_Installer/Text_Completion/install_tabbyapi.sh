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
text_completion_dir="$stl_root/text-completion"
tabbyapi_install_path="$text_completion_dir/tabbyAPI"

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
    install_tabbyapi
}



install_tabbyapi() {
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / App Installer / Text Completion / Install TabbyAPI${reset}"
    echo -e "-------------------------------------------------------------"
    echo "What is your GPU?"
    echo "1. NVIDIA"
    echo "2. AMD"
    echo "0. Cancel"

    # Get GPU information (Linux equivalent using lspci)
    gpu_info=$(lspci | grep -E 'VGA|3D' | head -n 1 | awk '{print $0}')
    if [[ -z "$gpu_info" ]]; then
        gpu_info="No GPU detected"
    fi

    echo
    echo -e "${blue_bg}╔════ GPU INFO ═════════════════════════════════╗${reset}"
    echo -e "${blue_bg}║                                               ║${reset}"
    echo -e "${blue_bg}║* ${gpu_info} ${reset}"
    echo -e "${blue_bg}║                                               ║${reset}"
    echo -e "${blue_bg}╚═══════════════════════════════════════════════╝${reset}"
    echo

    read -p "Enter number corresponding to your GPU: " gpu_choice

    # Set the GPU choice in an environment variable
    export GPU_CHOICE="$gpu_choice"

    # Check the user's response
    case "$gpu_choice" in
        1)
            log_message "INFO" "GPU choice set to NVIDIA"
            install_tabbyapi_pre
            ;;
        2)
            log_message "INFO" "GPU choice set to AMD"
            install_tabbyapi_pre
            ;;
        0)
            exit
            ;;
        *)
            log_message "ERROR" "Invalid input"
            read -p "Press Enter to continue..."
            install_tabbyapi
            ;;
    esac
}

install_tabbyapi_pre() {
    log_message "INFO" "Installing TabbyAPI..."

    # Ensure the text-completion folder exists
    if [[ ! -d "$text_completion_dir" ]]; then
        mkdir -p "$text_completion_dir"
        log_message "INFO" "Created folder: $text_completion_dir"
    else
        log_message "INFO" "text-completion folder already exists at: $text_completion_dir"
    fi

    # Remove existing tabbyAPI directory if it exists to avoid cloning conflicts
    if [[ -d "$tabbyapi_install_path" ]]; then
        log_message "WARN" "Existing tabbyAPI directory found at: $tabbyapi_install_path. Removing it..."
        rm -rf "$tabbyapi_install_path"
    fi

    # Check for incorrect tabbyAPI directory in stl_root
    if [[ -d "$stl_root/tabbyAPI" ]]; then
        log_message "WARN" "Incorrect tabbyAPI directory found at: $stl_root/tabbyAPI. Removing it..."
        rm -rf "$stl_root/tabbyAPI"
    fi

    cd "$text_completion_dir" || {
        log_message "ERROR" "Failed to change to directory: $text_completion_dir"
        read -p "Press Enter to continue..."
        exit
    }

    max_retries=3
    retry_count=0

    while [[ $retry_count -lt $max_retries ]]; do
        log_message "INFO" "Cloning the tabbyAPI repository into: $tabbyapi_install_path"
        git clone https://github.com/theroyallab/tabbyAPI.git
        if [[ $? -eq 0 ]]; then
            # Verify the clone created the correct directory
            if [[ -d "$tabbyapi_install_path" ]]; then
                log_message "INFO" "Successfully cloned tabbyAPI into: $tabbyapi_install_path"
                break
            else
                log_message "ERROR" "Clone succeeded but tabbyAPI directory not found at: $tabbyapi_install_path"
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

    # Activate the Miniconda installation
    log_message "INFO" "Activating Miniconda environment..."
    source "${miniconda_path}/etc/profile.d/conda.sh"

    # Create a Conda environment named tabbyapi
    log_message "INFO" "Creating Conda environment: tabbyapi"
    conda create -n tabbyapi python=3.11 -y

    # Activate the conda environment named tabbyapi
    log_message "INFO" "Activating Conda environment: tabbyapi"
    conda activate tabbyapi

    cd "$tabbyapi_install_path"

    # Use the GPU choice made earlier to configure tabbyapi
    case "$GPU_CHOICE" in
        1)
            log_message "INFO" "[tabbyapi] Setting TabbyAPI to use NVIDIA GPUs: tabbyapi"
            echo "cu121" > "gpu_lib.txt"
            install_tabbyapi_final
            ;;
        2)
            log_message "INFO" "[tabbyapi] Setting TabbyAPI to use AMD GPUs: tabbyapi"
            echo "amd" > "gpu_lib.txt"
            install_tabbyapi_final
            ;;
    esac
}

install_tabbyapi_final() {
    log_message "INFO" "Downgrading numpy to: 1.26.4"
    pip install numpy==1.26.4

    echo "Loading solely the API may not be your optimal usecase."
    echo "Therefore, a config.yml exists to tune initial launch parameters and other configuration options."
    echo
    echo "A config.yml file is required for overriding project defaults."
    echo "If you are okay with the defaults, you don't need a config file!"
    echo
    echo "If you do want a config file, copy over config_sample.yml to config.yml. All the fields are commented,"
    echo "so make sure to read the descriptions and comment out or remove fields that you don't need."
    echo

    log_message "INFO" "TabbyAPI installed successfully."

    log_message "INFO" "Updating TabbyAPI Dependencies..."
    log_message "WARN" "This process could take a while, typically around 10 minutes or less. Please be patient and do not close this window until the update is complete."

    # Run the update process and log the output
    python start.py --update-deps > "$log_dir/tabby_update_log.txt" 2>&1

    # Scan the log file for the specific success message
    if grep -q "Dependencies updated. Please run TabbyAPI" "$log_dir/tabby_update_log.txt"; then
        log_message "INFO" "OK"
    else
        log_message "ERROR" "TabbyAPI Update Failed. Please run the installer again"
    fi

    # Delete the log file
    rm -f "$log_dir/tabby_update_log.txt"

    log_message "INFO" "TabbyAPI Dependencies updated successfully."
    read -p "Press Enter to continue..."
    exit
}


# Execute the install function
find_conda
check_miniconda
install_tabbyapi