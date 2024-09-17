#!/usr/bin/env bash

# Check if stdout is a terminal
if [ -t 1 ]; then
    # Define color variables using ANSI escape codes
    RED='\e[31m'
    GREEN='\e[32m'
    YELLOW='\e[33m'
    BLUE='\e[34m'
    NC='\e[0m' # No Color
else
    # No color if not a terminal
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Define supported log levels
SUPPORTED_LEVELS=("ERROR" "INFO" "WARN" "INSTRUCT")

# Function to display usage information for the log function
_log_usage() {
    echo -e "Usage: log <LEVEL> \"message\""
    echo -e "Supported LEVELs: ERROR, INFO, WARN, INSTRUCT"
}

# Logging function with validation and integrated exit for ERROR level
log() {
    local level="$1"
    local message="$2"

    # Check if the user asked for help
    if [[ "$level" == "--help" || "$level" == "?" ]]; then
        _log_usage
        return 0
    fi

    # Check if exactly two arguments are provided
    if [ "$#" -ne 2 ]; then
        echo -e "${RED}Error:${NC} 'log' function expects exactly 2 arguments." >&2
        _log_usage
        return 1
    fi

    # Validate log level
    local valid_level=0
    for lvl in "${SUPPORTED_LEVELS[@]}"; do
        if [ "$level" == "$lvl" ]; then
            valid_level=1
            break
        fi
    done

    if [ "$valid_level" -ne 1 ]; then
        echo -e "${RED}Error: Unsupported log level '${level}'.${NC}" >&2
        _log_usage
        return 1
    fi

    # Log based on level
    case "$level" in
        ERROR)
            echo -e "${RED}\t[ERROR] ${message}${NC}" >&2
            echo -e "${RED}\t[ERROR] Exiting...${NC}" >&2
            exit 1
            ;;
        INFO)
            echo -e "${GREEN}\t[INFO] ${message}${NC}"
            ;;
        WARN)
            echo -e "${YELLOW}\t[WARN] ${message}${NC}"
            ;;
        INSTRUCT)
            echo -e "${BLUE}\t[INSTRUCT] ${message}${NC}"
            ;;
    esac
}
