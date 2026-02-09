#!/bin/bash
#
# Ubuntu Developer Setup Script
# Automates installation of common developer tools and applications
#
# Usage: sudo ./ubuntu_install.sh
#

set -o pipefail

# =============================================================================
# Helper Functions
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track errors for summary
declare -a FAILED_INSTALLS=()
declare -a SUCCESSFUL_INSTALLS=()

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if a package is installed
package_installed() {
    dpkg -l "$1" &> /dev/null
}

# Check if a snap is installed
snap_installed() {
    snap list "$1" &> /dev/null
}

# Record successful installation
record_success() {
    SUCCESSFUL_INSTALLS+=("$1")
    log_success "$1 installed successfully"
}

# Record failed installation
record_failure() {
    FAILED_INSTALLS+=("$1")
    log_error "Failed to install $1"
}

# =============================================================================
# Root Check
# =============================================================================

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run with sudo"
        echo "Usage: sudo $0"
        exit 1
    fi
}

# =============================================================================
# System Update
# =============================================================================

update_system() {
    log_info "Updating package lists..."
    if apt update; then
        log_success "Package lists updated"
    else
        log_warn "Some package lists may not have updated correctly"
    fi
}

# =============================================================================
# CLI Tools Installation
# =============================================================================

install_cli_tools() {
    log_info "Installing CLI tools..."

    local cli_tools=(
        curl
        wget
        git
        git-lfs
        vim
        tmux
        htop
        tree
        unzip
        jq
        net-tools
    )

    for tool in "${cli_tools[@]}"; do
        if command_exists "$tool" || package_installed "$tool"; then
            log_info "$tool is already installed, skipping"
            SUCCESSFUL_INSTALLS+=("$tool (already installed)")
        else
            log_info "Installing $tool..."
            if apt install -y "$tool"; then
                record_success "$tool"
            else
                record_failure "$tool"
            fi
        fi
    done
}

# =============================================================================
# Sublime Text Installation (via apt repository)
# =============================================================================

install_sublime_text() {
    log_info "Installing Sublime Text..."

    if command_exists subl; then
        log_info "Sublime Text is already installed, skipping"
        SUCCESSFUL_INSTALLS+=("Sublime Text (already installed)")
        return 0
    fi

    # Install dependencies
    apt install -y apt-transport-https ca-certificates

    # Add Sublime Text GPG key
    log_info "Adding Sublime Text GPG key..."
    if ! wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor -o /usr/share/keyrings/sublimehq-archive-keyring.gpg 2>/dev/null; then
        record_failure "Sublime Text (GPG key)"
        return 1
    fi

    # Add Sublime Text repository
    log_info "Adding Sublime Text repository..."
    echo "deb [signed-by=/usr/share/keyrings/sublimehq-archive-keyring.gpg] https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list

    # Update and install
    apt update
    if apt install -y sublime-text; then
        record_success "Sublime Text"
    else
        record_failure "Sublime Text"
    fi
}

# =============================================================================
# Google Chrome Installation (via apt repository)
# =============================================================================

install_google_chrome() {
    log_info "Installing Google Chrome..."

    if command_exists google-chrome || command_exists google-chrome-stable; then
        log_info "Google Chrome is already installed, skipping"
        SUCCESSFUL_INSTALLS+=("Google Chrome (already installed)")
        return 0
    fi

    # Add Google Chrome GPG key
    log_info "Adding Google Chrome GPG key..."
    if ! wget -qO - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg 2>/dev/null; then
        record_failure "Google Chrome (GPG key)"
        return 1
    fi

    # Add Google Chrome repository
    log_info "Adding Google Chrome repository..."
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

    # Update and install
    apt update
    if apt install -y google-chrome-stable; then
        record_success "Google Chrome"
    else
        record_failure "Google Chrome"
    fi
}

# =============================================================================
# LocalSend Installation (via snap)
# =============================================================================

install_localsend() {
    log_info "Installing LocalSend..."

    if snap_installed localsend || command_exists localsend; then
        log_info "LocalSend is already installed, skipping"
        SUCCESSFUL_INSTALLS+=("LocalSend (already installed)")
        return 0
    fi

    # Ensure snapd is installed
    if ! command_exists snap; then
        log_info "Installing snapd..."
        apt install -y snapd
    fi

    # Install LocalSend via snap
    log_info "Installing LocalSend via snap..."
    if snap install localsend; then
        record_success "LocalSend (snap)"
    else
        record_failure "LocalSend"
    fi
}

# =============================================================================
# Other GUI Applications (via apt)
# =============================================================================

install_gui_apps() {
    log_info "Installing GUI applications from default repos..."

    local gui_apps=(
        terminator
        vlc
        gimp
        inkscape
        gnome-screenshot
    )

    for app in "${gui_apps[@]}"; do
        if package_installed "$app"; then
            log_info "$app is already installed, skipping"
            SUCCESSFUL_INSTALLS+=("$app (already installed)")
        else
            log_info "Installing $app..."
            if apt install -y "$app"; then
                record_success "$app"
            else
                record_failure "$app"
            fi
        fi
    done
}

# =============================================================================
# Summary Report
# =============================================================================

print_summary() {
    echo ""
    echo "=============================================="
    echo -e "${BLUE}INSTALLATION SUMMARY${NC}"
    echo "=============================================="

    if [[ ${#SUCCESSFUL_INSTALLS[@]} -gt 0 ]]; then
        echo ""
        echo -e "${GREEN}Successfully installed/verified:${NC}"
        for item in "${SUCCESSFUL_INSTALLS[@]}"; do
            echo -e "  ${GREEN}✓${NC} $item"
        done
    fi

    if [[ ${#FAILED_INSTALLS[@]} -gt 0 ]]; then
        echo ""
        echo -e "${RED}Failed to install:${NC}"
        for item in "${FAILED_INSTALLS[@]}"; do
            echo -e "  ${RED}✗${NC} $item"
        done
        echo ""
        echo -e "${YELLOW}Some installations failed. Please check the errors above.${NC}"
    else
        echo ""
        echo -e "${GREEN}All installations completed successfully!${NC}"
    fi

    echo "=============================================="
}

# =============================================================================
# Main
# =============================================================================

main() {
    echo "=============================================="
    echo -e "${BLUE}Ubuntu Developer Setup Script${NC}"
    echo "=============================================="
    echo ""

    check_root

    update_system
    echo ""

    install_cli_tools
    echo ""

    install_sublime_text
    echo ""

    install_google_chrome
    echo ""

    install_localsend
    echo ""

    install_gui_apps

    print_summary
}

main "$@"
