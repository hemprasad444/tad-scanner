#!/bin/bash

# TAD Scanner Installation Script
# Trivy Advanced Detection Scanner - Enhanced Container Vulnerability Scanner

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/your-username/tad-scanner"
INSTALL_DIR="$HOME/tad-scanner"
BIN_DIR="$HOME/.local/bin"

log_info() { echo -e "${GREEN}[TAD-INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[TAD-WARN]${NC} $1"; }
log_error() { echo -e "${RED}[TAD-ERROR]${NC} $1"; }

print_header() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════╗"
    echo "║                🛡️  TAD SCANNER 🛡️                 ║"
    echo "║         Trivy Advanced Detection Scanner          ║"
    echo "║                  Installer v3.0                  ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_dependencies() {
    log_info "Checking system dependencies for TAD Scanner..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        log_error "Git is required for TAD Scanner installation"
        echo "Please install git first:"
        echo "  Ubuntu/Debian: sudo apt-get install git"
        echo "  RHEL/CentOS: sudo yum install git"
        exit 1
    fi
    
    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        log_error "Curl is required for TAD Scanner installation"
        echo "Please install curl first:"
        echo "  Ubuntu/Debian: sudo apt-get install curl"
        echo "  RHEL/CentOS: sudo yum install curl"
        exit 1
    fi
    
    log_info "✓ System dependencies satisfied for TAD Scanner"
}

install_trivy() {
    if ! command -v trivy &> /dev/null; then
        log_info "Installing Trivy for TAD Scanner..."
        curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        log_info "✓ Trivy installed successfully for TAD Scanner"
    else
        log_info "✓ Trivy already installed for TAD Scanner: $(trivy --version | head -1)"
    fi
}

install_jq() {
    if ! command -v jq &> /dev/null; then
        log_info "Installing jq for TAD Scanner..."
        
        # Detect OS and install jq
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get update && sudo apt-get install -y jq
        elif [[ -f /etc/redhat-release ]]; then
            sudo yum install -y jq
        else
            log_warn "Unable to auto-install jq for TAD Scanner. Please install manually:"
            echo "  Ubuntu/Debian: sudo apt-get install jq"
            echo "  RHEL/CentOS: sudo yum install jq"
            return 1
        fi
        
        log_info "✓ jq installed successfully for TAD Scanner"
    else
        log_info "✓ jq already installed for TAD Scanner: $(jq --version)"
    fi
}

clone_repository() {
    log_info "Cloning TAD Scanner repository..."
    
    if [[ -d "$INSTALL_DIR" ]]; then
        log_warn "TAD Scanner directory $INSTALL_DIR already exists"
        read -p "Remove existing TAD Scanner installation and reinstall? (y/N): " choice
        if [[ "$choice" =~ ^[Yy] ]]; then
            rm -rf "$INSTALL_DIR"
        else
            log_info "TAD Scanner installation cancelled"
            exit 0
        fi
    fi
    
    git clone "$REPO_URL" "$INSTALL_DIR"
    log_info "✓ TAD Scanner repository cloned to $INSTALL_DIR"
}

setup_executable() {
    log_info "Setting up TAD Scanner executable..."
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR/src/tad-scanner.sh"
    chmod +x "$INSTALL_DIR/src/tad-scanner-legacy.sh"
    
    # Create bin directory if it doesn't exist
    mkdir -p "$BIN_DIR"
    
    # Create symlink
    ln -sf "$INSTALL_DIR/src/tad-scanner.sh" "$BIN_DIR/tad-scanner"
    ln -sf "$INSTALL_DIR/src/tad-scanner.sh" "$BIN_DIR/tad"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        log_info "✓ Added $BIN_DIR to PATH in ~/.bashrc"
        log_warn "Please run 'source ~/.bashrc' or restart your terminal"
    fi
    
    log_info "✓ TAD Scanner executable setup complete"
}

print_success() {
    echo ""
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════╗"
    echo "║         🛡️  TAD SCANNER INSTALLED! 🎉            ║"
    echo "║       Trivy Advanced Detection Scanner            ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo "TAD Scanner has been installed successfully!"
    echo ""
    echo "Usage:"
    echo "  $INSTALL_DIR/src/tad-scanner.sh"
    echo "  OR (if PATH is updated): tad-scanner"
    echo "  OR (short command): tad"
    echo ""
    echo "Documentation:"
    echo "  README: $INSTALL_DIR/README.md"
    echo "  Repository: $REPO_URL"
    echo ""
    echo "Next steps:"
    echo "  1. Run 'source ~/.bashrc' to update PATH"
    echo "  2. Run 'tad-scanner' or 'tad' to start TAD Scanner"
    echo "  3. Star the repository if you find TAD Scanner useful! ⭐"
    echo ""
    echo "🛡️ TAD Scanner - Making container security scanning simple and powerful!"
}

main() {
    print_header
    
    log_info "Starting TAD Scanner installation..."
    echo ""
    
    check_dependencies
    install_trivy
    install_jq
    clone_repository
    setup_executable
    
    print_success
}

# Run main function
main "$@"
