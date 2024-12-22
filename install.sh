#!/bin/bash
#
# SillyTavern Installer Script
# Created by: Deffcolony
#
# Description:
# This script installs SillyTavern and/or Extras to your Linux system.
#
# Usage:
# chmod +x install.sh && ./install.sh
#
# In automated environments, you may want to run as root.
# If using curl, we recommend using the -fsSL flags.
#
# This script is intended for use on Linux systems. Please
# report any issues or bugs on the GitHub repository.
#
# GitHub: https://github.com/SillyTavern/SillyTavern-Launcher
# Issues: https://github.com/SillyTavern/SillyTavern-Launcher/issues
# ----------------------------------------------------------
# Note: Modify the script as needed to fit your requirements.
# ----------------------------------------------------------

echo -e "\033]0;SillyTavern Installer\007"

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

# Function to install Miniconda
install_miniconda() {
    # Check if Miniconda is already installed
    if command -v conda &>/dev/null; then
        echo "Miniconda is already installed. Skipping installation."
        installer
        return 0  # Exit the function with success status
    fi

    # Determine Miniconda installer based on OS and architecture
    os_name="$(uname -s)"
    arch="$(uname -m)"
    case "$os_name" in
        Linux)
            case "$arch" in
                x86_64) miniconda_installer="Miniconda3-latest-Linux-x86_64.sh" ;;
                aarch64) miniconda_installer="Miniconda3-latest-Linux-aarch64.sh" ;;
                *) echo "ERROR: Unsupported architecture: $arch" >&2; return 1 ;;
            esac
            ;;
        Darwin)
            case "$arch" in
                x86_64) miniconda_installer="Miniconda3-latest-MacOSX-x86_64.sh" ;;
                arm64) miniconda_installer="Miniconda3-latest-MacOSX-arm64.sh" ;;
                *) echo "ERROR: Unsupported architecture: $arch" >&2; return 1 ;;
            esac
            ;;
        *)
            echo "ERROR: Unsupported operating system: $os_name" >&2
            return 1
            ;;
    esac

    # Clean existing Miniconda installer script
    #rm -f /tmp/miniconda_installer.sh
    
    # Download the Miniconda installer script
    wget -c "https://repo.anaconda.com/miniconda/$miniconda_installer" -O /tmp/miniconda_installer.sh

    # Run the installer script
    bash /tmp/miniconda_installer.sh -b -p "$HOME/miniconda"

    # Add Miniconda to PATH
    export PATH="$HOME/miniconda/bin:$PATH"

    # Activate Conda environment
    source "$HOME/miniconda/etc/profile.d/conda.sh"

    # Clean up the Downloaded file
    #rm -f /tmp/miniconda_installer.sh

    echo "Miniconda installed successfully in $HOME/miniconda"
}

# Define the paths and filenames for the shortcut creation
script_path="$(realpath "$(dirname "$0")")/launcher.sh"
icon_path="$(realpath "$(dirname "$0")")/st-launcher.ico"
script_name=st-launcher
desktop_dir="$(eval echo ~$(logname))/Desktop"
desktop_file="$desktop_dir/st-launcher.desktop"

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
boxDrawingText()
{
    local string=$1
    local maxwidth=$2
    # empty string
    local color=

    if [ $# -eq 3 ]; then
        color=$3
    fi

    local stringlength=${#string}

    # stringlength < maxwidth ? maxwidth : stringlength
    local width=$((stringlength < maxwidth ? maxwidth : stringlength))

    local topL="╔"
    local bottomL="╚"
    local topR="╗"
    local bottomR="╝"
    local middle="║"
    local space=" "

    echo -e "$color$middle$string$(printf ' %.0s' $(seq 1 $((width - stringlength))))$middle"
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
        elif command -v brew &>/dev/null; then
            # macOS
            log_message "INFO" "Installing Git using Homebrew..."
            brew install git
        elif command -v pkg &>/dev/null; then
            # Termux on Android
            log_message "INFO" "Installing Git using pkg..."
            pkg install git
        elif command -v zypper &>/dev/null; then
            # openSUSE
            log_message "INFO" "Installing Git using zypper..."
            sudo zypper install git
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        log_message "INFO" "${green_fg_strong}Git is installed.${reset}"
    else
        echo -e "${blue_fg_strong}[INFO] Git is already installed.${reset}"
    fi
}


# Function to install Node.js and npm
install_nodejs_npm() {
    if ! command -v npm &>/dev/null || ! command -v node &>/dev/null; then
        echo -e "${yellow_fg_strong}[WARN] Node.js and/or npm are not installed on this system.${reset}"

        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu-based system
            log_message "INFO" "Installing Node.js and npm using apt..."
            sudo apt-get update
            sudo apt-get install -y curl
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
            source "$NVM_DIR/nvm.sh"
            read -p "Press Enter to continue..."
            nvm install --lts
            nvm use --lts
        elif command -v yum &>/dev/null; then
            # Red Hat/Fedora-based system
            log_message "INFO" "Installing Node.js and npm using yum..."
            sudo yum install -y curl
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
            source "$NVM_DIR/nvm.sh"
            read -p "Press Enter to continue..."
            nvm install --lts
            nvm use --lts
        elif command -v apk &>/dev/null; then
            # Alpine Linux-based system
            log_message "INFO" "Installing Node.js and npm using apk..."
            sudo apk add curl
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
            source "$NVM_DIR/nvm.sh"
            read -p "Press Enter to continue..."
            nvm install --lts
            nvm use --lts
        elif command -v pacman &>/dev/null; then
            # Arch Linux-based system
            log_message "INFO" "Installing Node.js and npm using pacman..."
            sudo pacman -S --noconfirm curl
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
            source "$NVM_DIR/nvm.sh"
            read -p "Press Enter to continue..."
            nvm install --lts
            nvm use --lts
        elif command -v emerge &>/dev/null; then
            # Gentoo-based system
            log_message "INFO" "Installing Node.js and npm using emerge..."
            sudo emerge -av net-misc/curl
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
            source "$NVM_DIR/nvm.sh"
            read -p "Press Enter to continue..."
            nvm install --lts
            nvm use --lts
        elif command -v pkg &>/dev/null; then
            # Termux on Android
            log_message "INFO" "Installing Node.js and npm using pkg..."
            pkg install nodejs npm
        elif command -v brew &>/dev/null; then
            # macOS
            log_message "INFO" "Installing Node.js and npm using Homebrew..."
            brew install node
        elif command -v zypper &>/dev/null; then
            # openSUSE
            log_message "INFO" "Installing Node.js and npm using zypper..."
            sudo zypper --non-interactive install nodejs npm
        else
            log_message "ERROR" "${red_fg_strong}Unsupported Linux distribution.${reset}"
            exit 1
        fi

        echo "${green_fg_strong}Node.js and npm installed and configured with nvm.${reset}"
    else
        echo -e "${blue_fg_strong}[INFO] Node.js and npm are already installed.${reset}"
    fi
}


# Function to install all options from the installer
install_all() {
    echo -e "\033]0;SillyTavern [INSTALL-SILLYTAVERN-EXTRAS-XTTS]\007"
    clear
    echo -e "${blue_fg_strong}/ Installer / SillyTavern + Extras + XTTS${reset}"
    echo "---------------------------------------------------------------"

    echo ""
    echo -e "${blue_bg}╔════ INSTALL SUMMARY ══════════════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${blue_bg}║ You are about to install all options from the installer.                                      ║${reset}"
    echo -e "${blue_bg}║ This will include the following options: SillyTavern, SillyTavern-Extras and XTTS             ║${reset}"
    echo -e "${blue_bg}║ Below is a list of package requirements that will get installed:                              ║${reset}"
    echo -e "${blue_bg}║ * SillyTavern [Size: 478 MB]                                                                  ║${reset}"
    echo -e "${blue_bg}║ * SillyTavern-extras [Size: 65 MB]                                                            ║${reset}"
    echo -e "${blue_bg}║ * xtts [Size: 1.74 GB]                                                                        ║${reset}"
    echo -e "${blue_bg}║ * Miniconda3 [INSTALLED] [Size: 630 MB]                                                       ║${reset}"
    echo -e "${blue_bg}║ * Miniconda3 env - xtts [Size: 6.98 GB]                                                       ║${reset}"
    echo -e "${blue_bg}║ * Miniconda3 env - extras [Size: 9.98 GB]                                                     ║${reset}"
    echo -e "${blue_bg}║ * Git [INSTALLED] [Size: 338 MB]                                                              ║${reset}"
    echo -e "${blue_bg}║ * Node.js [Size: 87.5 MB]                                                                     ║${reset}"
    echo -e "${blue_bg}║ TOTAL INSTALL SIZE: 20.26 GB                                                                  ║${reset}"
    echo -e "${blue_bg}╚═══════════════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo ""

    echo -n "Are you sure you want to proceed? [Y/N]: "
    read confirmation

    if [ "$confirmation" = "Y" ] || [ "$confirmation" = "y" ]; then
        install_all_y
    else
        installer
    fi
}

install_all_y() {
    # Ask the user about the GPU
    echo -e "What is your GPU?"
    echo -e "1. NVIDIA"
    echo -e "2. AMD"
    echo -e "3. None (CPU-only mode)"
    echo -e "0. Cancel install"

    # Get GPU information
    gpu_info=""
    while IFS= read -r line; do
        gpu_info+=" $line"
    done < <(lspci | grep VGA | cut -d ':' -f3)

    echo ""
    echo -e "${blue_bg}╔════ GPU INFO ═════════════════════════════════════════════════════════════╗${reset}"
    boxDrawingText "" 75 $blue_bg
    boxDrawingText "* ${gpu_info:1}" 75 $blue_bg
    boxDrawingText "" 75 $blue_bg
    echo -e "${blue_bg}╚═══════════════════════════════════════════════════════════════════════════╝${reset}"
    echo ""

    # Prompt for GPU choice
    read -p "Enter number corresponding to your GPU: " gpu_choice

    # GPU menu - Backend
    # Set the GPU choice in an environment variable for choice callback
    export GPU_CHOICE=$gpu_choice

    # Check the user's response
    if [ "$gpu_choice" == "1" ]; then
        log_message "INFO" "GPU choice set to NVIDIA"
        install_all_pre
    elif [ "$gpu_choice" == "2" ]; then
        log_message "INFO" "GPU choice set to AMD"
        install_all_pre
    elif [ "$gpu_choice" == "3" ]; then
        log_message "INFO" "Using CPU-only mode"
        install_all_pre
    elif [ "$gpu_choice" == "0" ]; then
        installer
    else
        log_message "ERROR" "${red_fg_strong}Invalid number. Please enter a valid number.${reset}"
        read -p "Press Enter to continue..."
        install_all
    fi
}


install_all_pre() {
    log_message "INFO" "Installing SillyTavern + Extras + XTTS"
    echo -e "${cyan_fg_strong}This may take a while. Please be patient.${reset}"

    log_message "INFO" "Installing SillyTavern..."
    git clone https://github.com/SillyTavern/SillyTavern.git
    log_message "INFO" "${green_fg_strong}SillyTavern installed successfully.${reset}"

    log_message "INFO" "Installing Extras..."
    log_message "INFO" "Cloning SillyTavern-extras repository..."
    git clone https://github.com/SillyTavern/SillyTavern-extras.git

# Install script for XTTS 
    log_message "INFO" "Installing XTTS..."

    # Activate the Miniconda installation
    log_message "INFO" "Activating Miniconda environment..."
    source "$miniconda_path/bin/activate"

    # Create a Conda environment named xtts
    log_message "INFO" "Creating Conda environment: xtts"
    conda create -n xtts python=3.10 git -y

    # Activate the xtts environment
    log_message "INFO" "Activating Conda environment: xtts"
    source activate xtts

    # Check if xtts activation was successful
    if [ $? -eq 0 ]; then
        log_message "INFO" "Successfully activated Conda environment: xtts"
        install_all_pre_successful
    else
        log_message "ERROR" "${red_fg_strong}Failed to activate Conda environment: xtts${reset}"
        log_message "INFO" "Press Enter to try again otherwise close the installer and restart."
        read -p "Press Enter to try again..."
        install_all_pre
    fi
}

install_all_pre_successful() {
    # Create folders for xtts
    log_message "INFO" "Creating xtts folders..."
    mkdir "$PWD/xtts"
    mkdir "$PWD/xtts/speakers"
    mkdir "$PWD/xtts/output"

    # Clone the xtts-api-server repository for voice examples
    log_message "INFO" "Cloning xtts-api-server repository..."
    git clone https://github.com/daswer123/xtts-api-server.git

    log_message "INFO" "Adding voice examples to speakers directory..."
    cp -r "$PWD/xtts-api-server/example/"* "$PWD/xtts/speakers/"

    log_message "INFO" "Removing the xtts-api-server directory..."
    rm -rf "$PWD/xtts-api-server"

    # Install pip3 requirements
    log_message "INFO" "Installing pip3 requirements for xtts..."
    pip3 install xtts-api-server
    pip3 install pydub
    pip3 install stream2sentence


    # Use the GPU choice made earlier to install requirements for XTTS
    if [ "$GPU_CHOICE" == "1" ]; then
        log_message "INFO" "Installing NVIDIA version of PyTorch"
        pip3 install torch==2.1.1+cu118 torchvision torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
        install_all_post
    elif [ "$GPU_CHOICE" == "2" ]; then
        log_message "INFO" "Installing AMD version of PyTorch"
        pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
        install_all_post
    elif [ "$GPU_CHOICE" == "3" ]; then
        log_message "INFO" "Installing CPU-only version of PyTorch"
        pip3 install torch torchvision torchaudio
        install_all_post
    fi
}
# End of install script for XTTS


install_all_post() {
    # Create a Conda environment named extras
    log_message "INFO" "Creating Conda environment: extras"
    conda create -n extras python=3.11 git -y

    log_message "INFO" "Activating Conda environment: extras"
    conda activate extras

    # Check if extras activation was successful
    if [ $? -eq 0 ]; then
        log_message "INFO" "Successfully activated Conda environment: extras"
        install_all_post_successful
    else
        log_message "ERROR" "${red_fg_strong}Failed to activate Conda environment: extras${reset}"
        log_message "INFO" "Press Enter to try again otherwise close the installer and restart."
        read -p "Press Enter to try again..."
        install_all_post
    fi
}

install_all_post_successful() {
    # Navigate to the SillyTavern-extras directory
    cd "$PWD/SillyTavern-extras"

    log_message "INFO" "Installing pip requirements from requirements-rvc.txt in Conda enviroment: ${cyan_fg_strong}extras${reset}"
    pip3 install -r requirements-rvc.txt
    pip3 install tensorboardX

    # Use the GPU choice made earlier to install requirements for extras
    if [ "$GPU_CHOICE" == "1" ]; then
        log_message "INFO" "Installing modules for NVIDIA from requirements.txt in extras"
        pip3 install -r requirements.txt
        conda install -c conda-forge faiss-gpu -y
        log_message "INFO" "${green_fg_strong}SillyTavern + Extras + XTTS successfully installed.${reset}"
        install_all_final
    elif [ "$GPU_CHOICE" == "2" ]; then
        log_message "INFO" "Installing modules for AMD from requirements-rocm.txt in extras"
        pip3 install -r requirements-rocm.txt
        log_message "INFO" "${green_fg_strong}SillyTavern + Extras + XTTS successfully installed.${reset}"
        install_all_final
    elif [ "$GPU_CHOICE" == "3" ]; then
        log_message "INFO" "Installing modules for CPU from requirements-silicon.txt in extras"
        pip3 install -r requirements-silicon.txt
        log_message "INFO" "${green_fg_strong}SillyTavern + Extras + XTTS successfully installed.${reset}"
        install_all_final
    fi
}

install_all_final() {
    # Ask if the user wants to create a shortcut
    read -p "Do you want to create a shortcut on the desktop? [Y/n] " create_shortcut
    if [[ "${create_shortcut}" == "Y" || "${create_shortcut}" == "y" ]]; then

    # Create the desktop shortcut
    echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} Creating desktop shortcut..."
	
	echo "[Desktop Entry]" > "$desktop_file"
	echo "Version=1.0" >> "$desktop_file"
	echo "Type=Application" >> "$desktop_file"
	echo "Name=$script_name" >> "$desktop_file"
	echo "Exec=$script_path" >> "$desktop_file"
	echo "Icon=$icon_path" >> "$desktop_file"
	echo "Terminal=true" >> "$desktop_file"
	echo "Comment=SillyTavern Launcher" >> "$desktop_file"
	chmod +x "$desktop_file"

    echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} ${green_fg_strong}Desktop shortcut created at: $desktop_file${reset}"
    fi

    # Ask if the user wants to start the launcher
    read -p "Start the launcher now? [Y/n] " start_launcher
    if [[ "${start_launcher}" == "Y" || "${start_launcher}" == "y" ]]; then
        # Run the launcher
        echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} Running launcher in a new window..."
        cd "$(dirname "$0")"
        chmod +x launcher.sh && ./launcher.sh
    fi

    installer
}


# Function to install SillyTavern
install_sillytavern() {
    echo -e "\033]0;SillyTavern [INSTALL-ST]\007"
    clear
    echo -e "${blue_fg_strong}/ Installer / SillyTavern${reset}"
    echo "---------------------------------------------------------------"
    echo -e "${cyan_fg_strong}This may take a while. Please be patient.${reset}"
    log_message "INFO" "Installing SillyTavern..."
    log_message "INFO" "Cloning SillyTavern repository..."
    git clone https://github.com/SillyTavern/SillyTavern.git
    log_message "INFO" "${green_fg_strong}SillyTavern installed successfully.${reset}"

    # Ask if the user wants to create a desktop shortcut
    read -p "Do you want to create a shortcut on the desktop? [Y/n] " create_shortcut
    if [[ "${create_shortcut}" == "Y" || "${create_shortcut}" == "y" ]]; then

    # Create the desktop shortcut
    echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} Creating desktop shortcut..."
	
	echo "[Desktop Entry]" > "$desktop_file"
	echo "Version=1.0" >> "$desktop_file"
	echo "Type=Application" >> "$desktop_file"
	echo "Name=$script_name" >> "$desktop_file"
	echo "Exec=$script_path" >> "$desktop_file"
	echo "Icon=$icon_path" >> "$desktop_file"
	echo "Terminal=true" >> "$desktop_file"
	echo "Comment=SillyTavern Launcher" >> "$desktop_file"
	chmod +x "$desktop_file"

    echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} ${green_fg_strong}Desktop shortcut created at: $desktop_file${reset}"
    fi

    # Ask if the user wants to start the launcher
    read -p "Start the launcher now? [Y/n] " start_launcher
    if [[ "${start_launcher}" == "Y" || "${start_launcher}" == "y" ]]; then
        # Run the launcher
        echo -e "${blue_bg}[$(date +%T)]${reset} ${blue_fg_strong}[INFO]${reset} Running launcher in a new window..."
        cd "$(dirname "$0")"
        chmod +x launcher.sh && ./launcher.sh
    fi

    installer
}


# Function to install Extras
install_extras() {
    echo -e "\033]0;SillyTavern [INSTALL-EXTRAS]\007"
    clear
    echo -e "${blue_fg_strong}/ Installer / Extras${reset}"
    echo "---------------------------------------------------------------"

    echo ""
    echo -e "${red_bg}╔════ INSTALL SUMMARY ══════════════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${red_bg}║ Extras has been DISCONTINUED since April 2024 and WON'T receive any new updates or modules.   ║${reset}"
    echo -e "${red_bg}║ The vast majority of modules are available natively in the main SillyTavern application.      ║${reset}"
    echo -e "${red_bg}║ You may still install and use it but DON'T expect to get support if you face any issues.      ║${reset}"
    echo -e "${red_bg}║ Below is a list of package requirements that will get installed:                              ║${reset}"
    echo -e "${red_bg}║ * SillyTavern-extras [Size: 65 MB]                                                            ║${reset}"
    echo -e "${red_bg}║ * Miniconda3 [INSTALLED] [Size: 630 MB]                                                       ║${reset}"
    echo -e "${red_bg}║ * Miniconda3 env - extras [Size: 9,98 GB]                                                     ║${reset}"
    echo -e "${red_bg}║ * Git [INSTALLED] [Size: 338 MB]                                                              ║${reset}"
    echo -e "${red_bg}║ TOTAL INSTALL SIZE: 11 GB                                                                     ║${reset}"
    echo -e "${red_bg}╚═══════════════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo ""

    echo -n "Are you sure you want to proceed? [Y/N]: "
    read confirmation

    if [ "$confirmation" = "Y" ] || [ "$confirmation" = "y" ]; then
        install_extras_y
    else
        installer
    fi
}

install_extras_y() {
    clear
    # Ask the user about the GPU
    echo -e "What is your GPU?"
    echo -e "1. NVIDIA"
    echo -e "2. AMD"
    echo -e "3. None (CPU-only mode)"
    echo -e "0. Cancel install"

    # Get GPU information
    gpu_info=""
    while IFS= read -r line; do
        gpu_info+=" $line"
    done < <(lspci | grep VGA | cut -d ':' -f3)

    echo ""
    echo -e "${blue_bg}╔════ GPU INFO ═════════════════════════════════════════════════════════════╗${reset}"
    boxDrawingText "" 75 $blue_bg
    boxDrawingText "* ${gpu_info:1}" 75 $blue_bg
    boxDrawingText "" 75 $blue_bg
    echo -e "${blue_bg}╚═══════════════════════════════════════════════════════════════════════════╝${reset}"
    echo ""

    # Prompt for GPU choice
    read -p "Enter number corresponding to your GPU: " gpu_choice

    # GPU menu - Backend
    # Set the GPU choice in an environment variable for choice callback
    export GPU_CHOICE=$gpu_choice

    # Check the user's response
    if [ "$gpu_choice" == "1" ]; then
        log_message "INFO" "GPU choice set to NVIDIA"
        install_extras_pre
    elif [ "$gpu_choice" == "2" ]; then
        log_message "INFO" "GPU choice set to AMD"
        install_extras_pre
    elif [ "$gpu_choice" == "3" ]; then
        log_message "INFO" "Using CPU-only mode"
        install_extras_pre
    elif [ "$gpu_choice" == "0" ]; then
        installer
    else
        log_message "ERROR" "${red_fg_strong}Invalid number. Please enter a valid number.${reset}"
        read -p "Press Enter to continue..."
        install_extras
    fi
}



install_extras_pre() {
    log_message "INFO" "Installing Extras..."
    log_message "INFO" "Cloning SillyTavern-extras repository..."
    git clone https://github.com/SillyTavern/SillyTavern-extras.git


    log_message "INFO" "Creating Conda environment: ${cyan_fg_strong}extras${reset}"
    conda create -n extras python=3.11 git -y

    log_message "INFO" "Activating Conda environment: ${cyan_fg_strong}extras${reset}"
    conda init bash
    conda activate extras

    # Check if extras activation was successful
    if [ $? -eq 0 ]; then
        log_message "INFO" "Successfully activated Conda environment: extras"
        install_extras_successful
    else
        log_message "ERROR" "${red_fg_strong}Failed to activate Conda environment: extras${reset}"
        log_message "INFO" "Press Enter to try again otherwise close the installer and restart."
        read -p "Press Enter to try again..."
        install_extras_pre
    fi
}

install_extras_successful() {
    # Navigate to the SillyTavern-extras directory
    cd "$PWD/SillyTavern-extras"

    log_message "INFO" "Installing pip3 requirements-rvc in Conda environment: ${cyan_fg_strong}extras${reset}"
    pip3 install -r requirements-rvc.txt
    pip3 install tensorboardX

    # Use the GPU choice made earlier to install requirements in the Conda environment extras
    if [ "$GPU_CHOICE" == "1" ]; then
        log_message "INFO" "Installing modules for NVIDIA from requirements.txt in Conda environment: ${cyan_fg_strong}extras${reset}"
        pip3 install -r requirements.txt
        conda install -c conda-forge faiss-gpu -y
        log_message "INFO" "${green_fg_strong}Extras successfully installed.${reset}"
        installer
    elif [ "$GPU_CHOICE" == "2" ]; then
        log_message "INFO" "Installing modules for AMD from requirements-rocm.txt in Conda environment: ${cyan_fg_strong}extras${reset}"
        pip3 install -r requirements-rocm.txt
        log_message "INFO" "${green_fg_strong}Extras successfully installed.${reset}"
        installer
    elif [ "$GPU_CHOICE" == "3" ]; then
        log_message "INFO" "Installing modules for CPU from requirements-silicon.txt in Conda environment: ${cyan_fg_strong}extras${reset}"
        pip3 install -r requirements-silicon.txt
        log_message "INFO" "${green_fg_strong}Extras successfully installed.${reset}"
        installer
    fi
}


# Function to install XTTS
install_xtts() {
    log_message "INFO" "Installing XTTS..."

    # Activate the Miniconda installation
    log_message "INFO" "Activating Miniconda environment..."
    source "$miniconda_path/bin/activate"

    # Create a Conda environment named xtts
    log_message "INFO" "Creating Conda environment: xtts"
    conda create -n xtts python=3.10 git -y

    # Activate the xtts environment
    log_message "INFO" "Activating Conda environment: xtts"
    conda activate xtts

    # Check if activation was successful
    if [ $? -eq 0 ]; then
        log_message "INFO" "Successfully activated Conda environment: xtts"
        install_xtts_successful
    else
        log_message "ERROR" "${red_fg_strong}Failed to activate Conda environment: xtts${reset}"
        log_message "INFO" "Press Enter to try again otherwise close the installer and restart."
        read -p "Press Enter to try again..."
        install_xtts
    fi
}

install_xtts_successful() {
    # Create folders for xtts
    log_message "INFO" "Creating xtts folders..."
    mkdir "$PWD/xtts"
    mkdir "$PWD/xtts/speakers"
    mkdir "$PWD/xtts/output"

    # Clone the xtts-api-server repository for voice examples
    log_message "INFO" "Cloning xtts-api-server repository..."
    git clone https://github.com/daswer123/xtts-api-server.git

    log_message "INFO" "Adding voice examples to speakers directory..."
    cp -r "$PWD/xtts-api-server/example/"* "$PWD/xtts/speakers/"

    log_message "INFO" "Removing the xtts-api-server directory..."
    rm -rf "$PWD/xtts-api-server"

    # Install pip3 requirements
    log_message "INFO" "Installing pip3 requirements for xtts..."
    pip3 install xtts-api-server
    pip3 install pydub
    pip3 install stream2sentence

    installer
}


############################################################
################# INSTALLER - FRONTEND #####################
############################################################
installer() {
    echo -e "\033]0;SillyTavern [INSTALLER]\007"
    clear
    echo -e "${blue_fg_strong}/ Installer${reset}"
    echo "-------------------------------------"
    echo "What would you like to do?"
    echo "1. Install SillyTavern"
    echo "2. Install Extras"
    echo "3. Install XTTS"
    echo "4. Install All Options From Above"
    echo "5. Support"
    echo "0. Exit"

    read -p "Choose Your Destiny (default is 1): " choice

    # Default to choice 1 if no input is provided
    if [ -z "$choice" ]; then
      choice=1
    fi

################# INSTALLER - BACKEND #####################
    case $choice in
        1) install_sillytavern ;;
        2) install_extras ;;
        3) install_xtts ;;
        4) install_all ;;
        5) support ;;
        0) exit ;;
        *) echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
           read -p "Press Enter to continue..."
           installer ;;
    esac
}

# Functions for Support Menu - Backend
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


# Support Menu - Frontend
support() {
    echo -e "\033]0;SillyTavern [SUPPORT]\007"
    clear
    echo -e "${blue_fg_strong}/ Home / Support${reset}"
    echo "-------------------------------------"
    echo "What would you like to do?"
    echo "1. I want to report an issue"
    echo "2. Documentation"
    echo "3. Discord"
    echo "0. Back to installer"

    read -p "Choose Your Destiny: " support_choice

    # Support Menu - Backend
    case $support_choice in
        1) issue_report ;;
        2) documentation ;;
        3) discord ;;
        0) installer ;;
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
    install_nodejs_npm
    install_miniconda
    installer
elif command -v apt-get &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Debian/Ubuntu-based system.${reset}"
    # Debian/Ubuntu
    install_git
    install_nodejs_npm
    install_miniconda
    installer
elif command -v yum &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Red Hat/Fedora-based system.${reset}"
    # Red Hat/Fedora
    install_git
    install_nodejs_npm
    install_miniconda
    installer
elif command -v apk &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Alpine Linux-based system.${reset}"
    # Alpine Linux
    install_git
    install_nodejs_npm
    install_miniconda
    installer
elif command -v pacman &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Arch Linux-based system.${reset}"
    # Arch Linux
    install_git
    install_nodejs_npm
    install_miniconda
    installer
elif command -v emerge &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Gentoo Linux-based system. Now you are the real CHAD${reset}"
    # Gentoo Linux
    install_git
    install_nodejs_npm
    install_miniconda
    installer
elif command -v pkg &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected pkg System${reset}"
    # pkg
    install_git
    install_nodejs_npm
    install_miniconda
    installer
elif command -v zypper &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected openSUSE system.${reset}"
    # openSUSE
    install_git
    install_nodejs_npm
    install_miniconda
    installer
else
    log_message "ERROR" "${red_fg_strong}Unsupported package manager. Cannot detect Linux distribution.${reset}"
    exit 1
fi


