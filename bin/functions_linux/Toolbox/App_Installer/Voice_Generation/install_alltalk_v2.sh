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
app_installer_voice_generation_dir="$functions_dir/Toolbox/App_Installer/Voice_Generation"
voice_generation_dir="$stl_root/voice-generation"
alltalk_v2_install_path="$voice_generation_dir/alltalk_tts"
miniconda_path="$stl_root/miniconda"

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



install_alltalk_v2() {
    clear
    echo -e "${blue_fg_strong}/ Home / Toolbox / App Installer / Voice Generation / Install AllTalk V2${reset}"
    echo -e "-------------------------------------------------------------"

    # Check if git is installed
    if ! command -v git &> /dev/null; then
        log_message "ERROR" "Git is not installed. Please install git and try again."
        read -p "Press Enter to continue..."
        exit
    fi

    # GPU menu - Frontend
    echo "What is your GPU?"
    echo "1. NVIDIA"
    echo "2. AMD"
    echo "0. Cancel"

    # Get GPU information
    gpu_info=$(lspci | grep -E "VGA|3D" | grep -Ei "NVIDIA|AMD" | head -n 1 | awk -F: '{print $3}' | sed 's/^[[:space:]]*//')
    if [[ -z "$gpu_info" ]]; then
        gpu_info="No GPU detected"
    fi

    echo -e "${blue_bg}╔════ GPU INFO ═════════════════════════════════╗${reset}"
    echo -e "${blue_bg}║                                               ║${reset}"
    echo -e "${blue_bg}║* ${gpu_info}${reset}"
    echo -e "${blue_bg}║                                               ║${reset}"
    echo -e "${blue_bg}╚═══════════════════════════════════════════════╝${reset}"
    echo

    read -p "Enter number corresponding to your GPU: " gpu_choice

    # Validate GPU choice
    if [[ ! "$gpu_choice" =~ ^[0-2]$ ]]; then
        log_message "ERROR" "Invalid input. Please enter a valid number (0-2)."
        read -p "Press Enter to continue..."
        install_alltalk_v2
        return
    fi

    # Check the user's response
    case "$gpu_choice" in
        "1")
            log_message "INFO" "GPU choice set to NVIDIA"
            ;;
        "2")
            log_message "INFO" "GPU choice set to AMD"
            ;;
        "0")
            log_message "INFO" "Installation canceled."
            read -p "Press Enter to continue..."
            exit
            ;;
    esac

    # Check and create voice-generation directory
    if [[ ! -d "$voice_generation_dir" ]]; then
        if ! mkdir -p "$voice_generation_dir"; then
            log_message "ERROR" "Failed to create directory: $voice_generation_dir"
            read -p "Press Enter to continue..."
            exit
        fi
        log_message "INFO" "Created folder: voice-generation"
    else
        log_message "INFO" "voice-generation folder already exists."
    fi

    cd "$voice_generation_dir"

    # Check if alltalk_tts already exists
    if [[ -d "$alltalk_v2_install_path" ]]; then
        log_message "WARN" "alltalk_tts already exists in $voice_generation_dir."
        read -p "Press Enter to continue..."
        exit
    fi

    # Clone repository with retry logic
    max_retries=3
    retry_count=0

    while [ $retry_count -lt $max_retries ]; do
        log_message "INFO" "Cloning alltalk_tts repository..."
        git clone -b alltalkbeta https://github.com/erew123/alltalk_tts
        if [ $? -eq 0 ]; then
            break
        else
            retry_count=$((retry_count + 1))
            log_message "WARN" "Retry $retry_count of $max_retries"
            if [ $retry_count -eq $max_retries ]; then
                log_message "ERROR" "Failed to clone repository after $max_retries retries."
                read -p "Press Enter to continue..."
                exit
            fi
        fi
    done

    cd "$alltalk_v2_install_path" || {
        log_message "ERROR" "Failed to change to directory: $alltalk_v2_install_path"
        read -p "Press Enter to continue..."
        exit
    }

    # Install system dependencies
    log_message "INFO" "Installing system dependencies..."
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y build-essential espeak-ng ffmpeg
    else
        log_message "WARN" "APT not found. Please ensure build-essential, espeak-ng, and ffmpeg are installed."
    fi

    # Activate Miniconda and create environment
    log_message "INFO" "Activating Miniconda environment..."
    if [[ ! -f "$miniconda_path/bin/activate" ]]; then
        log_message "ERROR" "Miniconda not found at $miniconda_path. Please install Miniconda."
        read -p "Press Enter to continue..."
        exit
    fi

    source "$miniconda_path/bin/activate"
    log_message "INFO" "Creating Conda environment: alltalkv2"
    conda create -n alltalkv2 python=3.11.9 -y
    log_message "INFO" "Activating Conda environment: alltalkv2"
    conda activate alltalkv2

    # Install GPU-specific dependencies
    if [ "$gpu_choice" = "1" ]; then
        log_message "INFO" "[alltalkv2] Installing NVIDIA version of PyTorch in conda environment: alltalkv2"
        conda install -y pytorch==2.2.1 torchvision==0.17.1 torchaudio==2.2.1 pytorch-cuda=12.1 -c pytorch -c nvidia

        log_message "INFO" "[alltalkv2] Installing deepspeed..."
        curl -LO https://github.com/erew123/alltalk_tts/releases/download/DeepSpeed-14.0/deepspeed-0.14.0+ce78a63-cp311-cp311-linux_x86_64.whl
        pip install deepspeed-0.14.0+ce78a63-cp311-cp311-linux_x86_64.whl
        rm deepspeed-0.14.0+ce78a63-cp311-cp311-linux_x86_64.whl
    elif [ "$gpu_choice" = "2" ]; then
        log_message "INFO" "[alltalkv2] Installing AMD dependencies..."
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
    fi

    # Install additional dependencies
    log_message "INFO" "[alltalkv2] Installing Faiss..."
    conda install -y -c pytorch faiss-cpu

    log_message "INFO" "[alltalkv2] Installing FFmpeg..."
    conda install -y -c conda-forge "ffmpeg=*=*gpl*"
    conda install -y -c conda-forge "ffmpeg=*=h*_*" --no-deps

    log_message "INFO" "[alltalkv2] Installing pip requirements from requirements_standalone.txt"
    if [[ -f "system/requirements/requirements_standalone.txt" ]]; then
        pip install -r system/requirements/requirements_standalone.txt
    else
        log_message "ERROR" "requirements_standalone.txt not found."
        read -p "Press Enter to continue..."
        exit
    fi

    log_message "INFO" "[alltalkv2] Updating Gradio..."
    pip install gradio==4.32.2  # 4.44.1 is bugged

    log_message "INFO" "[alltalkv2] Updating transformers..."
    pip install transformers==4.42.4

    log_message "INFO" "[alltalkv2] Installing temporary fix for pydantic..."
    pip install pydantic==2.10.6

    log_message "INFO" "[alltalkv2] Installing Parler..."
    if [[ -f "system/requirements/requirements_parler.txt" ]]; then
        pip install -r system/requirements/requirements_parler.txt
    else
        log_message "ERROR" "requirements_parler.txt not found."
        read -p "Press Enter to continue..."
        exit
    fi

    log_message "INFO" "Cleaning Conda cache..."
    conda clean --all --force-pkgs-dirs -y

    log_message "OK" "AllTalk V2 installed successfully"
    read -p "Press Enter to continue..."
    exit
}

# Execute the install function
install_alltalk_v2