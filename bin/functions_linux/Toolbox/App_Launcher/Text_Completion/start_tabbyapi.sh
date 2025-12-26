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
}

start_tabbyapi() {
    # Read modules-tabbyapi and find the tabbyapi_start_command line
    tabbyapi_start_command=$(grep -E "^tabbyapi_start_command=" "$tabbyapi_modules_path" | cut -d'=' -f2-)

    if [[ -z "$tabbyapi_start_command" ]]; then
        log_message "ERROR" "No modules enabled."
        echo -e "${RED_BG}Please make sure you enabled at least one of the modules from Edit tabbyapi Modules.${RESET}"
        echo
        echo -e "${BLUE_BG}We will redirect you to the Edit tabbyapi Modules menu.${RESET}"
        read -p "Press Enter to continue..."

        if [[ -f "$editor_text_completion_dir/edit_tabbyapi_modules.sh" ]]; then
            bash "$editor_text_completion_dir/edit_tabbyapi_modules.sh"
            exit
        else
            log_message "ERROR" "edit_tabbyapi_modules.sh not found in: $editor_text_completion_dir"
            log_message "INFO" "Running Automatic Repair..."
            git pull
            read -p "Press Enter to continue..."
            exit
        fi
        exit 0
    fi

    # Activate the Miniconda installation
    log_message "INFO" "Activating Miniconda environment..."
    source "${miniconda_path}/etc/profile.d/conda.sh"

    # Activate the tabbyapi environment
    log_message "INFO" "Activating Conda environment: tabbyapi"
    conda activate tabbyapi

    # Start TabbyAPI with desired configurations in a new terminal
    log_message "INFO" "TabbyAPI launched in a new window."
    cd "$tabbyapi_install_path" || {
        log_message "ERROR" "Failed to change to directory: $tabbyapi_install_path"
        read -p "Press Enter to continue..."
        exit
    }

    # Use xterm to open a new terminal window for TabbyAPI (alternative terminals like gnome-terminal or konsole can be used)
    xterm -T "TabbyAPI" -e "bash -c '$tabbyapi_start_command; exec bash'" &

    # Return to the launcher menu
    exit
}

# Execute the start function
start_tabbyapi