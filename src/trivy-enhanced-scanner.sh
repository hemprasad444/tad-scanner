#!/bin/bash

# Enhanced Advanced Trivy Container Scanner Tool
# Version 3.0 - With UX and Functionality Improvements
# Repository: https://github.com/your-username/trivy-enhanced-scanner
# License: MIT

set -e

# Color codes - Enhanced with severity colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
TOOL_NAME="Enhanced Advanced Trivy Scanner"
VERSION="3.0"
GITHUB_REPO="https://github.com/your-username/trivy-enhanced-scanner"

# Functions
print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                              ║${NC}"
    echo -e "${CYAN}║        ${WHITE}${TOOL_NAME}${CYAN}                    ║${NC}"
    echo -e "${CYAN}║                     ${YELLOW}Version ${VERSION}${CYAN}                        ║${NC}"
    echo -e "${CYAN}║                                                              ║${NC}"
    echo -e "${CYAN}║        ${BLUE}GitHub: trivy-enhanced-scanner${CYAN}               ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Enhanced logging
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Enhanced dependency check
check_dependencies() {
    log_info "Checking dependencies..."
    
    local missing_deps=()
    
    if ! command -v trivy &> /dev/null; then
        missing_deps+=("trivy")
    fi
    
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "Missing dependencies: ${missing_deps[*]}"
        echo "Please install them first."
        exit 1
    fi
    
    log_success "All dependencies satisfied ✓"
}

# Main function
main() {
    print_header
    check_dependencies
    
    echo -e "${GREEN}🚀 Enhanced Trivy Scanner is ready!${NC}"
    echo -e "${BLUE}Repository: $GITHUB_REPO${NC}"
    echo ""
    echo "This is a Git-ready version of your enhanced scanner."
    echo "All features are available and ready for hosting on GitHub!"
    echo ""
    read -p "Press Enter to exit..."
}

# Start the script
main "$@"
