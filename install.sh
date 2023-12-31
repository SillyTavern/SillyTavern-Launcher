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


function find_conda {
    local paths=(
        "$HOME/miniconda3"
        "$HOME/miniconda"
        "$HOME/opt/miniconda3"
        "$HOME/opt/miniconda"
        "/opt/miniconda3"
        "/opt/miniconda"
        "/usr/local/miniconda3"
        "/usr/local/miniconda"
        "/usr/miniconda3"
        "/usr/miniconda"
        "$HOME/anaconda3"
        "$HOME/anaconda"
        "$HOME/opt/anaconda3"
        "$HOME/opt/anaconda"
        "/opt/anaconda3"
        "/opt/anaconda"
        "/usr/local/anaconda3"
        "/usr/local/anaconda"
        "/usr/anaconda3"
        "/usr/anaconda"
    )

    if [ "$(uname)" == "Darwin" ]; then
        paths+=("/opt/homebrew-cask/Caskroom/miniconda")
        paths+=("/usr/local/Caskroom/miniconda/base")
    fi

    for path in "${paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done

    echo "ERROR: Could not find miniconda installation" >&2
    return 1
}

if [ -n "$CONDA_PATH" ]; then
    CONDA_PATH="$(find_conda)"
fi

# miniconda_installer="Miniconda3-latest-Linux-x86_64.sh"
os_name="$(uname -s)"
arch="$(uname -m)"
if [ "$os_name" == "Linux" ]; then
    if [ "$arch" == "x86_64" ]; then
        miniconda_installer="Miniconda3-latest-Linux-x86_64.sh"
    elif [ "$arch" == "aarch64" ]; then
        miniconda_installer="Miniconda3-latest-Linux-aarch64.sh"
    else
        echo "ERROR: Unsupported architecture: $arch" >&2
        exit 1
    fi
elif [ "$os_name" == "Darwin" ]; then
    if [ "$arch" == "x86_64" ]; then
        miniconda_installer="Miniconda3-latest-MacOSX-x86_64.sh"
    else
        miniconda_installer="Miniconda3-latest-MacOSX-arm64.sh"
    fi
else
    echo "ERROR: Unsupported operating system: $os_name, using the linux installer (on $arch)" >&2
    if [ "$arch" == "x86_64" ]; then
        miniconda_installer="Miniconda3-latest-Linux-x86_64.sh"
    elif [ "$arch" == "aarch64" ]; then
        miniconda_installer="Miniconda3-latest-Linux-aarch64.sh"
    else
        echo "ERROR: Unsupported architecture: $arch" >&2
        exit 1
    fi
fi

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



# Function to install SillyTavern + Extras
install_st_extras() {
    echo -e "\033]0;SillyTavern [INSTALL-ST-EXTRAS]\007"
    clear
    echo -e "${blue_fg_strong}/ Installer / SillyTavern + Extras${reset}"
    echo "---------------------------------------------------------------"
    log_message "INFO" "Installing SillyTavern + Extras..."
    echo -e "${cyan_fg_strong}This may take a while. Please be patient.${reset}"

    log_message "INFO" "Installing SillyTavern..."
    git clone https://github.com/SillyTavern/SillyTavern.git
    log_message "INFO" "${green_fg_strong}SillyTavern installed successfully.${reset}"

    log_message "INFO" "Installing Extras..."

    log_message "INFO" "Cloning SillyTavern-extras repository..."
    git clone https://github.com/SillyTavern/SillyTavern-extras.git

    # Download the Miniconda installer script
    wget https://repo.anaconda.com/miniconda/$miniconda_installer -P /tmp
    chmod +x /tmp/$miniconda_installer

    # Run the installer script
    bash /tmp/$miniconda_installer -b -u -p $CONDA_PATH

    # Update PATH to include Miniconda
    export PATH="$CONDA_PATH/bin:$PATH"

    # Activate Conda environment
    log_message "INFO" "Activating Miniconda environment..."
    source $CONDA_PATH/etc/profile.d/conda.sh

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

    # Provide a link to XTTS
    log_message "INFO" "${blue_fg_strong}Feeling excited to give your robotic waifu/husbando a new shiny voice modulator?${reset}"
    log_message "INFO" "${blue_fg_strong}To learn more about XTTS, visit:${reset} https://coqui.ai/blog/tts/open_xtts"

    # Ask the user if they want to install XTTS
    read -p "Install XTTS? [Y/N]: " install_xtts_requirements

    # Check the user's response
    if [[ "$install_xtts_requirements" == "Y" || "$install_xtts_requirements" == "y" ]]; then
        log_message "INFO" "Installing XTTS..."

        # Activate the Miniconda installation
        log_message "INFO" "Activating Miniconda environment..."
        source "$miniconda_path/bin/activate"

        # Create a Conda environment named xtts
        log_message "INFO" "Creating Conda environment xtts..."
        conda create -n xtts -y

        # Activate the xtts environment
        log_message "INFO" "Activating Conda environment xtts..."
        source activate xtts

        # Check if activation was successful
        if [ $? -eq 0 ]; then
            log_message "INFO" "Conda environment xtts activated successfully."
        else
            log_message "ERROR" "Failed to activate Conda environment xtts."
        fi

        # Install Python 3.10 in the xtts environment
        log_message "INFO" "Installing Python in the Conda environment..."
        conda install python=3.10 -y

        # Install pip3 requirements
        log_message "INFO" "Installing pip3 requirements for xtts..."
        pip3 install xtts-api-server
        pip3 install pydub
        pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

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

    else
        log_message "INFO" "XTTS installation skipped."
    fi

    # Activate the extras environment
    log_message "INFO" "Activating Conda environment extras..."
    conda activate extras

    # Navigate to the SillyTavern-extras directory
    cd "$PWD/SillyTavern-extras"

    # Ask the user about the GPU
    echo -e "What is your GPU?"
    echo -e "1. NVIDIA"
    echo -e "2. AMD"
    echo -e "3. None (CPU-only mode)"

    # Get GPU information
    gpu_info=""
    while IFS= read -r line; do
        gpu_info+=" $line"
    done < <(lspci | grep VGA | cut -d ':' -f3)

    echo ""
    echo -e "${blue_bg}╔════ GPU INFO ═════════════════════════════════╗${reset}"
    echo -e "${blue_bg}║                                               ║${reset}"
    echo -e "${blue_bg}║* ${gpu_info:1}                     ║${reset}"
    echo -e "${blue_bg}║                                               ║${reset}"
    echo -e "${blue_bg}╚═══════════════════════════════════════════════╝${reset}"
    echo ""

    # Prompt for GPU choice
    read -p "Enter the number corresponding to your GPU: " gpu_choice

    # Check the user's response
    if [ "$gpu_choice" == "1" ]; then
        # Install pip3 requirements
        log_message "INFO" "Installing modules from requirements.txt in extras..."
        pip3 install -r requirements.txt
        conda install -c conda-forge faiss-gpu -y
    elif [ "$gpu_choice" == "2" ]; then
        log_message "INFO" "Installing modules from requirements-rocm.txt in extras..."
        pip3 install -r requirements-rocm.txt
    elif [ "$gpu_choice" == "3" ]; then
        log_message "INFO" "Installing modules from requirements-silicon.txt in extras..."
        pip3 install -r requirements-silicon.txt
    else
        log_message "ERROR" "Invalid GPU choice. Please enter a valid number."
        exit 1
    fi

    log_message "INFO" "Installing pip3 requirements-rvc in extras environment..."
    pip3 install -r requirements-rvc.txt
    pip3 install tensorboardX

    # Cleanup the Downloaded file
    rm -rf /tmp/$miniconda_installer

    log_message "INFO" "${green_fg_strong}SillyTavern + Extras successfully installed.${reset}"
    
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
    log_message "INFO" "Installing Extras..."

    log_message "INFO" "Cloning SillyTavern-extras repository..."
    git clone https://github.com/SillyTavern/SillyTavern-extras.git

    # Download the Miniconda installer script
    wget https://repo.anaconda.com/miniconda/$miniconda_installer -P /tmp
    chmod +x /tmp/$miniconda_installer

    # Run the installer script
    bash /tmp/$miniconda_installer -b -u -p $CONDA_PATH

    # Update PATH to include Miniconda
    export PATH="$CONDA_PATH/bin:$PATH"

    # Activate Conda environment
    log_message "INFO" "Activating Miniconda environment..."
    source $CONDA_PATH/etc/profile.d/conda.sh

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

    # Provide a link to XTTS
    log_message "INFO" "${blue_fg_strong}Feeling excited to give your robotic waifu/husbando a new shiny voice modulator?${reset}"
    log_message "INFO" "${blue_fg_strong}To learn more about XTTS, visit:${reset} https://coqui.ai/blog/tts/open_xtts"

    # Ask the user if they want to install XTTS
    read -p "Install XTTS? [Y/N]: " install_xtts_requirements

    # Check the user's response
    if [[ "$install_xtts_requirements" == "Y" || "$install_xtts_requirements" == "y" ]]; then
        log_message "INFO" "Installing XTTS..."

        # Activate the Miniconda installation
        log_message "INFO" "Activating Miniconda environment..."
        source "$miniconda_path/bin/activate"

        # Create a Conda environment named xtts
        log_message "INFO" "Creating Conda environment xtts..."
        conda create -n xtts -y

        # Activate the xtts environment
        log_message "INFO" "Activating Conda environment xtts..."
        source activate xtts

        # Check if activation was successful
        if [ $? -eq 0 ]; then
            log_message "INFO" "Conda environment xtts activated successfully."
        else
            log_message "ERROR" "Failed to activate Conda environment xtts."
        fi

        # Install Python 3.10 in the xtts environment
        log_message "INFO" "Installing Python in the Conda environment..."
        conda install python=3.10 -y

        # Install pip3 requirements
        log_message "INFO" "Installing pip3 requirements for xtts..."
        pip3 install xtts-api-server
        pip3 install pydub
        pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

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

    else
        log_message "INFO" "XTTS installation skipped."
    fi

    # Activate the extras environment
    log_message "INFO" "Activating Conda environment extras..."
    conda activate extras

    # Navigate to the SillyTavern-extras directory
    cd "$PWD/SillyTavern-extras"

    # Ask the user about the GPU
    echo -e "What is your GPU?"
    echo -e "1. NVIDIA"
    echo -e "2. AMD"
    echo -e "3. None (CPU-only mode)"

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
    read -p "Enter the number corresponding to your GPU: " gpu_choice

    # Check the user's response
    if [ "$gpu_choice" == "1" ]; then
        # Install pip3 requirements
        log_message "INFO" "Installing modules from requirements.txt in extras..."
        pip3 install -r requirements.txt
        conda install -c conda-forge faiss-gpu -y
    elif [ "$gpu_choice" == "2" ]; then
        log_message "INFO" "Installing modules from requirements-rocm.txt in extras..."
        pip3 install -r requirements-rocm.txt
    elif [ "$gpu_choice" == "3" ]; then
        log_message "INFO" "Installing modules from requirements-silicon.txt in extras..."
        pip3 install -r requirements-silicon.txt
    else
        log_message "ERROR" "Invalid GPU choice. Please enter a valid number."
        exit 1
    fi

    log_message "INFO" "Installing pip3 requirements-rvc in extras environment..."
    pip3 install -r requirements-rvc.txt
    pip3 install tensorboardX

    # Cleanup the Downloaded file
    rm -rf /tmp/$miniconda_installer
    log_message "INFO" "${green_fg_strong}Extras has been successfully installed.${reset}"

    installer
}




# Function for the installer menu
installer() {
    echo -e "\033]0;SillyTavern [INSTALLER]\007"
    clear
    echo -e "${blue_fg_strong}/ Installer${reset}"
    echo "-------------------------------------"
    echo "What would you like to do?"
    echo "1. Install SillyTavern + Extras"
    echo "2. Install SillyTavern"
    echo "3. Install Extras"
    echo "4. Exit"

    read -p "Choose Your Destiny (default is 1): " choice

    # Default to choice 1 if no input is provided
    if [ -z "$choice" ]; then
      choice=1
    fi

    # Installer - Backend
    if [ "$choice" = "1" ]; then
        install_st_extras
    elif [ "$choice" = "2" ]; then
        install_sillytavern
    elif [ "$choice" = "3" ]; then
        install_extras
    elif [ "$choice" = "4" ]; then
        exit
    else
        echo -e "${yellow_fg_strong}WARNING: Invalid number. Please insert a valid number.${reset}"
        read -p "Press Enter to continue..."
        installer
    fi
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
    installer
elif command -v apt-get &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Debian/Ubuntu-based system.${reset}"
    # Debian/Ubuntu
    install_git
    install_nodejs_npm
    installer
elif command -v yum &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Red Hat/Fedora-based system.${reset}"
    # Red Hat/Fedora
    install_git
    install_nodejs_npm
    installer
elif command -v apk &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Alpine Linux-based system.${reset}"
    # Alpine Linux
    install_git
    install_nodejs_npm
    installer
elif command -v pacman &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Arch Linux-based system.${reset}"
    # Arch Linux
    install_git
    install_nodejs_npm
    installer
elif command -v emerge &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected Gentoo Linux-based system. Now you are the real CHAD${reset}"
    # Gentoo Linux
    install_git
    install_nodejs_npm
    installer
elif command -v pkg &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected pkg System${reset}"
    # pkg
    install_git
    install_nodejs_npm
    installer
elif command -v zypper &>/dev/null; then
    log_message "INFO" "${blue_fg_strong}Detected openSUSE system.${reset}"
    # openSUSE
    install_git
    install_nodejs_npm
    installer
else
    log_message "ERROR" "${red_fg_strong}Unsupported package manager. Cannot detect Linux distribution.${reset}"
    exit 1
fi
