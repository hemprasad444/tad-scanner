#!/bin/bash

# Enhanced Trivy Scanner Installation Script
# This script installs the Enhanced Trivy Scanner and its dependencies

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/your-username/trivy-enhanced-scanner"
INSTALL_DIR="$HOME/trivy-enhanced-scanner"
BIN_DIR="$HOME/.local/bin"

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════╗"
    echo "║           Enhanced Trivy Scanner Installer        ║"
    echo "║                    Version 3.0                    ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_dependencies() {
    log_info "Checking system dependencies..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        log_error "Git is required but not installed"
        echo "Please install git first:"
        echo "  Ubuntu/Debian: sudo apt-get install git"
        echo "  RHEL/CentOS: sudo yum install git"
        exit 1
    fi
    
    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        log_error "Curl is required but not installed"
        echo "Please install curl first:"
        echo "  Ubuntu/Debian: sudo apt-get install curl"
        echo "  RHEL/CentOS: sudo yum install curl"
        exit 1
    fi
    
    log_info "✓ System dependencies satisfied"
}

install_trivy() {
    if ! command -v trivy &> /dev/null; then
        log_info "Installing Trivy..."
        curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        log_info "✓ Trivy installed successfully"
    else
        log_info "✓ Trivy already installed: $(trivy --version | head -1)"
    fi
}

install_jq() {
    if ! command -v jq &> /dev/null; then
        log_info "Installing jq..."
        
        # Detect OS and install jq
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get update && sudo apt-get install -y jq
        elif [[ -f /etc/redhat-release ]]; then
            sudo yum install -y jq
        else
            log_warn "Unable to auto-install jq. Please install manually:"
            echo "  Ubuntu/Debian: sudo apt-get install jq"
            echo "  RHEL/CentOS: sudo yum install jq"
            return 1
        fi
        
        log_info "✓ jq installed successfully"
    else
        log_info "✓ jq already installed: $(jq --version)"
    fi
}

clone_repository() {
    log_info "Cloning Enhanced Trivy Scanner repository..."
    
    if [[ -d "$INSTALL_DIR" ]]; then
        log_warn "Directory $INSTALL_DIR already exists"
        read -p "Remove existing installation and reinstall? (y/N): " choice
        if [[ "$choice" =~ ^[Yy] ]]; then
            rm -rf "$INSTALL_DIR"
        else
            log_info "Installation cancelled"
            exit 0
        fi
    fi
    
    git clone "$REPO_URL" "$INSTALL_DIR"
    log_info "✓ Repository cloned to $INSTALL_DIR"
}

setup_executable() {
    log_info "Setting up executable..."
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR/src/trivy-enhanced-scanner.sh"
    chmod +x "$INSTALL_DIR/src/trivy-scanner.sh"
    
    # Create bin directory if it doesn't exist
    mkdir -p "$BIN_DIR"
    
    # Create symlink
    ln -sf "$INSTALL_DIR/src/trivy-enhanced-scanner.sh" "$BIN_DIR/trivy-enhanced"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        log_info "✓ Added $BIN_DIR to PATH in ~/.bashrc"
        log_warn "Please run 'source ~/.bashrc' or restart your terminal"
    fi
    
    log_info "✓ Executable setup complete"
}

print_success() {
    echo ""
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════╗"
    echo "║            Installation Successful! 🎉            ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo "Enhanced Trivy Scanner has been installed successfully!"
    echo ""
    echo "Usage:"
    echo "  $INSTALL_DIR/src/trivy-enhanced-scanner.sh"
    echo "  OR (if PATH is updated): trivy-enhanced"
    echo ""
    echo "Documentation:"
    echo "  README: $INSTALL_DIR/README.md"
    echo "  Repository: $REPO_URL"
    echo ""
    echo "Next steps:"
    echo "  1. Run 'source ~/.bashrc' to update PATH"
    echo "  2. Run 'trivy-enhanced' to start the scanner"
    echo "  3. Star the repository if you find it useful! ⭐"
}

main() {
    print_header
    
    log_info "Starting Enhanced Trivy Scanner installation..."
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
