#!/bin/bash

# Advanced Trivy Container Scanner Tool
# Supports multiple image sources and flexible output options

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
TOOL_NAME="Advanced Trivy Scanner"
VERSION="2.0"
OUTPUT_DIR="trivy-advanced-results"
BASE_RESULTS_DIR="tab results"
SELECTED_IMAGES=()
OUTPUT_FORMAT="json"
PARSE_MODE="standard"
REPORT_MODE="combined"

# Functions
print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                              ║${NC}"
    echo -e "${CYAN}║        ${WHITE}${TOOL_NAME}${CYAN}                    ║${NC}"
    echo -e "${CYAN}║                     ${YELLOW}Version ${VERSION}${CYAN}                        ║${NC}"
    echo -e "${CYAN}║                                                              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_separator() {
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

check_dependencies() {
    log_step "Checking dependencies..."
    
    if ! command -v trivy &> /dev/null; then
        log_error "Trivy is not installed!"
        echo "Please install Trivy first: https://trivy.dev/v0.66/getting-started/installation/"
        exit 1
    fi
    
    if ! command -v python3 &> /dev/null; then
        log_error "Python3 is not installed!"
        exit 1
    fi
    
    if ! python3 -c "import pandas" 2>/dev/null; then
        log_warn "Pandas not found. Installing..."
        pip3 install pandas || {
            log_error "Failed to install pandas. Please install manually: pip3 install pandas"
            exit 1
        }
    fi
    
    log_info "All dependencies are satisfied ✓"
}

show_main_menu() {
    print_separator
    echo -e "${WHITE}🚀 ADVANCED TRIVY SCANNER - MAIN MENU${NC}"
    print_separator
    echo ""
    echo -e "${GREEN}1.${NC} 🌐 Scan Remote Images (ghcr.io, docker.io, etc.)"
    echo -e "${GREEN}2.${NC} 🏗️  Scan Local Docker Images"
    echo -e "${GREEN}3.${NC} 📦 Scan TAR/TAR.GZ Files"
    echo -e "${GREEN}4.${NC} 📁 Browse & Select from Directory"
    echo -e "${GREEN}5.${NC} ⚙️  Configure Output Options"
    echo -e "${GREEN}6.${NC} 🎯 Review Selected Images & Start Scan"
    echo -e "${GREEN}7.${NC} 📊 View Previous Results"
    echo -e "${GREEN}8.${NC} 🧹 Clean Up Old Results"
    echo -e "${GREEN}9.${NC} ❓ Help & Information"
    echo -e "${RED}0.${NC} 🚪 Exit"
    echo ""
    echo -e "${CYAN}Current Configuration:${NC}"
    echo -e "  Output Format: ${YELLOW}${OUTPUT_FORMAT}${NC}"
    echo -e "  Parse Mode: ${YELLOW}${PARSE_MODE}${NC}"
    echo -e "  Report Mode: ${YELLOW}${REPORT_MODE}${NC}"
    echo -e "  Selected Images: ${YELLOW}${#SELECTED_IMAGES[@]}${NC}"
    echo ""
    print_separator
}

scan_remote_images() {
    print_header
    log_step "Remote Image Scanner"
    echo ""
    echo "Enter remote image references (one per line):"
    echo "Examples:"
    echo "  ghcr.io/vunetsystems/canberra:74"
    echo "  docker.io/nginx:latest"
    echo "  registry.example.com/app:v1.0"
    echo ""
    echo "Press Enter twice when done, or type 'back' to return to menu"
    echo ""
    
    local images=()
    while true; do
        read -p "Image: " image
        
        if [[ -z "$image" ]]; then
            if [[ ${#images[@]} -gt 0 ]]; then
                break
            else
                echo "Please enter at least one image or type 'back'"
                continue
            fi
        fi
        
        if [[ "$image" == "back" ]]; then
            return 0
        fi
        
        # Validate image format (basic check)
        if [[ "$image" =~ ^[a-zA-Z0-9._/-]+:[a-zA-Z0-9._-]+$ ]] || [[ "$image" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
            images+=("remote:$image")
            log_info "Added: $image"
        else
            log_warn "Invalid image format: $image"
        fi
    done
    
    if [[ ${#images[@]} -gt 0 ]]; then
        SELECTED_IMAGES+=("${images[@]}")
        log_info "Added ${#images[@]} remote images to scan list"
    fi
    
    read -p "Press Enter to continue..."
}

scan_local_images() {
    print_header
    log_step "Local Docker Images Scanner"
    echo ""
    
    # Check if docker is available
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    log_info "Listing local Docker images..."
    echo ""
    
    # Get local images
    local images_output
    if ! images_output=$(docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}" 2>/dev/null); then
        log_error "Failed to list Docker images. Is Docker daemon running?"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo "$images_output"
    echo ""
    
    echo "Enter image references (repository:tag or image ID):"
    echo "Examples: nginx:latest, ubuntu:20.04, abc123def456"
    echo "Press Enter twice when done, or type 'back' to return"
    echo ""
    
    local images=()
    while true; do
        read -p "Image: " image
        
        if [[ -z "$image" ]]; then
            if [[ ${#images[@]} -gt 0 ]]; then
                break
            else
                echo "Please enter at least one image or type 'back'"
                continue
            fi
        fi
        
        if [[ "$image" == "back" ]]; then
            return 0
        fi
        
        # Validate image exists locally
        if docker inspect "$image" >/dev/null 2>&1; then
            images+=("local:$image")
            log_info "Added: $image"
        else
            log_warn "Image not found locally: $image"
        fi
    done
    
    if [[ ${#images[@]} -gt 0 ]]; then
        SELECTED_IMAGES+=("${images[@]}")
        log_info "Added ${#images[@]} local images to scan list"
    fi
    
    read -p "Press Enter to continue..."
}

scan_tar_files() {
    print_header
    log_step "TAR/TAR.GZ Files Scanner"
    echo ""
    
    while true; do
        read -p "Enter directory path containing TAR/TAR.GZ files (or 'back'): " dir_path
        
        if [[ "$dir_path" == "back" ]]; then
            return 0
        fi
        
        if [[ ! -d "$dir_path" ]]; then
            log_error "Directory does not exist: $dir_path"
            continue
        fi
        
        # Find tar files
        local tar_files=($(find "$dir_path" -maxdepth 1 -name "*.tar" -o -name "*.tar.gz"))
        
        if [[ ${#tar_files[@]} -eq 0 ]]; then
            log_error "No TAR or TAR.GZ files found in: $dir_path"
            continue
        fi
        
        break
    done
    
    echo ""
    log_info "Found ${#tar_files[@]} TAR files:"
    echo ""
    
    # Display files with numbers
    for i in "${!tar_files[@]}"; do
        local filename=$(basename "${tar_files[$i]}")
        echo "$((i+1)). $filename"
    done
    
    echo ""
    echo "Select files to scan:"
    echo "  Enter numbers separated by spaces (e.g., 1 3 5)"
    echo "  Enter 'all' to select all files"
    echo "  Enter 'back' to return to menu"
    echo ""
    
    read -p "Selection: " selection
    
    if [[ "$selection" == "back" ]]; then
        return 0
    fi
    
    local selected_files=()
    
    if [[ "$selection" == "all" ]]; then
        selected_files=("${tar_files[@]}")
    else
        # Parse individual selections
        for num in $selection; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [[ "$num" -ge 1 ]] && [[ "$num" -le "${#tar_files[@]}" ]]; then
                selected_files+=("${tar_files[$((num-1))]}")
            else
                log_warn "Invalid selection: $num"
            fi
        done
    fi
    
    if [[ ${#selected_files[@]} -gt 0 ]]; then
        for file in "${selected_files[@]}"; do
            SELECTED_IMAGES+=("tar:$file")
        done
        log_info "Added ${#selected_files[@]} TAR files to scan list"
    fi
    
    read -p "Press Enter to continue..."
}

browse_directory() {
    print_header
    log_step "Directory Browser"
    echo ""
    
    local current_dir=$(pwd)
    
    while true; do
        echo -e "${CYAN}Current directory: ${current_dir}${NC}"
        echo ""
        
        # List directories and image files
        echo "📁 Directories:"
        local dirs=($(ls -d */ 2>/dev/null | head -20))
        if [[ ${#dirs[@]} -eq 0 ]]; then
            echo "  (no subdirectories)"
        else
            for i in "${!dirs[@]}"; do
                echo "  d$((i+1)). ${dirs[$i]}"
            done
        fi
        
        echo ""
        echo "📦 Container Images:"
        local images=($(ls *.tar *.tar.gz 2>/dev/null | head -20))
        if [[ ${#images[@]} -eq 0 ]]; then
            echo "  (no TAR files found)"
        else
            for i in "${!images[@]}"; do
                echo "  f$((i+1)). ${images[$i]}"
            done
        fi
        
        echo ""
        echo "Commands:"
        echo "  d<num> - Enter directory (e.g., d1)"
        echo "  f<num> - Select file (e.g., f1)"
        echo "  fall - Select all files in current directory"
        echo "  .. - Go up one directory"
        echo "  pwd - Show current path"
        echo "  back - Return to main menu"
        echo ""
        
        read -p "Command: " command
        
        case "$command" in
            "back")
                return 0
                ;;
            "..")
                current_dir=$(dirname "$current_dir")
                cd "$current_dir"
                ;;
            "pwd")
                echo "Current path: $current_dir"
                ;;
            "fall")
                if [[ ${#images[@]} -gt 0 ]]; then
                    for image in "${images[@]}"; do
                        SELECTED_IMAGES+=("tar:$current_dir/$image")
                    done
                    log_info "Added ${#images[@]} files to scan list"
                else
                    log_warn "No image files found in current directory"
                fi
                ;;
            d*)
                local dir_num=${command:1}
                if [[ "$dir_num" =~ ^[0-9]+$ ]] && [[ "$dir_num" -ge 1 ]] && [[ "$dir_num" -le "${#dirs[@]}" ]]; then
                    current_dir="$current_dir/${dirs[$((dir_num-1))]}"
                    cd "$current_dir"
                else
                    log_error "Invalid directory selection"
                fi
                ;;
            f*)
                local file_num=${command:1}
                if [[ "$file_num" =~ ^[0-9]+$ ]] && [[ "$file_num" -ge 1 ]] && [[ "$file_num" -le "${#images[@]}" ]]; then
                    local selected_file="${images[$((file_num-1))]}"
                    SELECTED_IMAGES+=("tar:$current_dir/$selected_file")
                    log_info "Added: $selected_file"
                else
                    log_error "Invalid file selection"
                fi
                ;;
            *)
                log_error "Unknown command: $command"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
        log_step "Directory Browser"
        echo ""
    done
}

configure_output() {
    print_header
    log_step "Output Configuration"
    echo ""
    
    echo -e "${CYAN}Current Configuration:${NC}"
    echo -e "  1. Output Format: ${YELLOW}${OUTPUT_FORMAT}${NC}"
    echo -e "  2. Parse Mode: ${YELLOW}${PARSE_MODE}${NC}"
    echo -e "  3. Report Mode: ${YELLOW}${REPORT_MODE}${NC}"
    echo ""
    echo "Select option to change (1-3) or 'back' to return:"
    
    read -p "Choice: " choice
    
    case "$choice" in
        "1")
            echo ""
            echo "Output Format Options:"
            echo "  1. JSON (raw Trivy output)"
            echo "  2. CSV (processed vulnerability data)"
            echo ""
            read -p "Select format (1-2): " format_choice
            
            case "$format_choice" in
                "1") 
                    OUTPUT_FORMAT="json"
                    log_info "✅ Output format set to: JSON"
                    ;;
                "2") 
                    OUTPUT_FORMAT="csv"
                    log_info "✅ Output format set to: CSV"
                    ;;
                *) 
                    log_error "Invalid choice"
                    read -p "Press Enter to continue..."
                    ;;
            esac
            ;;
        "2")
            if [[ "$OUTPUT_FORMAT" == "csv" ]]; then
                echo ""
                echo "CSV Parse Mode Options:"
                echo "  1. Standard (all vulnerabilities)"
                echo "  2. Unique (deduplicated per image)"
                echo ""
                read -p "Select parse mode (1-2): " parse_choice
                
                case "$parse_choice" in
                    "1") 
                        PARSE_MODE="standard"
                        log_info "✅ Parse mode set to: Standard"
                        ;;
                    "2") 
                        PARSE_MODE="unique"
                        log_info "✅ Parse mode set to: Unique"
                        ;;
                    *) 
                        log_error "Invalid choice"
                        read -p "Press Enter to continue..."
                        ;;
                esac
            else
                log_warn "Parse mode only applies to CSV format"
                read -p "Press Enter to continue..."
            fi
            ;;
        "3")
            echo ""
            echo "Report Mode Options:"
            echo "  1. Combined (single report for all images)"
            echo "  2. Separate (individual reports per image)"
            echo "  3. Both (combined + separate reports)"
            echo ""
            read -p "Select report mode (1-3): " report_choice
            
            case "$report_choice" in
                "1") 
                    REPORT_MODE="combined"
                    log_info "✅ Report mode set to: Combined"
                    ;;
                "2") 
                    REPORT_MODE="separate"
                    log_info "✅ Report mode set to: Separate"
                    ;;
                "3") 
                    REPORT_MODE="both"
                    log_info "✅ Report mode set to: Both"
                    ;;
                *) 
                    log_error "Invalid choice"
                    read -p "Press Enter to continue..."
                    ;;
            esac
            ;;
        "back")
            return 0
            ;;
        *)
            log_error "Invalid option"
            read -p "Press Enter to continue..."
            ;;
    esac
    
    # Brief pause to show the confirmation message, then return to main menu
    sleep 1
}

review_and_scan() {
    print_header
    log_step "Review Selected Images & Start Scan"
    echo ""
    
    if [[ ${#SELECTED_IMAGES[@]} -eq 0 ]]; then
        log_warn "No images selected for scanning!"
        echo "Please select images using options 1-4 first."
        read -p "Press Enter to continue..."
        return 0
    fi
    
    echo -e "${CYAN}Selected Images (${#SELECTED_IMAGES[@]}):${NC}"
    echo ""
    
    for i in "${!SELECTED_IMAGES[@]}"; do
        local image="${SELECTED_IMAGES[$i]}"
        local type="${image%%:*}"
        local name="${image#*:}"
        
        case "$type" in
            "remote") echo "$((i+1)). 🌐 Remote: $name" ;;
            "local")  echo "$((i+1)). 🏗️  Local: $name" ;;
            "tar")    echo "$((i+1)). 📦 TAR: $(basename "$name")" ;;
        esac
    done
    
    echo ""
    echo -e "${CYAN}Configuration:${NC}"
    echo -e "  Output Format: ${YELLOW}${OUTPUT_FORMAT}${NC}"
    echo -e "  Parse Mode: ${YELLOW}${PARSE_MODE}${NC}"
    echo -e "  Report Mode: ${YELLOW}${REPORT_MODE}${NC}"
    echo ""
    
    echo "Options:"
    echo "  1. 🚀 Start Scan"
    echo "  2. 🗑️  Clear Selected Images"
    echo "  3. ❌ Remove Specific Image"
    echo "  4. 🔙 Back to Main Menu"
    echo ""
    
    read -p "Choice: " choice
    
    case "$choice" in
        "1")
            start_advanced_scan
            ;;
        "2")
            SELECTED_IMAGES=()
            log_info "Cleared all selected images"
            read -p "Press Enter to continue..."
            ;;
        "3")
            echo ""
            read -p "Enter image number to remove (1-${#SELECTED_IMAGES[@]}): " remove_num
            if [[ "$remove_num" =~ ^[0-9]+$ ]] && [[ "$remove_num" -ge 1 ]] && [[ "$remove_num" -le "${#SELECTED_IMAGES[@]}" ]]; then
                local removed_image="${SELECTED_IMAGES[$((remove_num-1))]}"
                unset SELECTED_IMAGES[$((remove_num-1))]
                SELECTED_IMAGES=("${SELECTED_IMAGES[@]}")  # Re-index array
                log_info "Removed: $removed_image"
            else
                log_error "Invalid image number"
            fi
            read -p "Press Enter to continue..."
            ;;
        "4")
            return 0
            ;;
        *)
            log_error "Invalid choice"
            read -p "Press Enter to continue..."
            ;;
    esac
}

start_advanced_scan() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local output_dir="${BASE_RESULTS_DIR}/${OUTPUT_DIR}_${timestamp}"
    
    log_step "Starting Advanced Scan"
    echo ""
    log_info "Creating output directory: $output_dir"
    
    mkdir -p "$output_dir"/{json,csv,logs}
    
    # Create scan log
    local scan_log="$output_dir/logs/scan.log"
    echo "Advanced Trivy Scan - Started at $(date)" > "$scan_log"
    echo "Configuration:" >> "$scan_log"
    echo "  Output Format: $OUTPUT_FORMAT" >> "$scan_log"
    echo "  Parse Mode: $PARSE_MODE" >> "$scan_log"
    echo "  Report Mode: $REPORT_MODE" >> "$scan_log"
    echo "  Total Images: ${#SELECTED_IMAGES[@]}" >> "$scan_log"
    echo "" >> "$scan_log"
    
    local success_count=0
    local fail_count=0
    
    # Scan each selected image
    for i in "${!SELECTED_IMAGES[@]}"; do
        local image="${SELECTED_IMAGES[$i]}"
        local type="${image%%:*}"
        local name="${image#*:}"
        local safe_name=$(echo "$name" | sed 's/[^a-zA-Z0-9._-]/_/g')
        
        log_info "Scanning ($((i+1))/${#SELECTED_IMAGES[@]}): $name"
        echo "Scanning ($((i+1))/${#SELECTED_IMAGES[@]}): $name" >> "$scan_log"
        
        local output_file="$output_dir/json/${safe_name}.json"
        local scan_success=false
        
        # Execute appropriate scan command based on type
        case "$type" in
            "remote"|"local")
                if trivy image -f json -o "$output_file" "$name" >> "$scan_log" 2>&1; then
                    scan_success=true
                fi
                ;;
            "tar")
                if trivy image --input "$name" -f json -o "$output_file" >> "$scan_log" 2>&1; then
                    scan_success=true
                fi
                ;;
        esac
        
        if $scan_success; then
            log_info "✅ Success: $name"
            echo "✅ Success: $name" >> "$scan_log"
            success_count=$((success_count + 1))
        else
            log_error "❌ Failed: $name"
            echo "❌ Failed: $name" >> "$scan_log"
            fail_count=$((fail_count + 1))
        fi
    done
    
    echo "" >> "$scan_log"
    echo "Scan completed at $(date)" >> "$scan_log"
    echo "Success: $success_count, Failed: $fail_count, Total: ${#SELECTED_IMAGES[@]}" >> "$scan_log"
    
    log_info "Scan completed! Success: $success_count, Failed: $fail_count"
    
    # Process results if CSV format selected
    if [[ "$OUTPUT_FORMAT" == "csv" ]]; then
        log_step "Processing results to CSV..."
        process_advanced_results "$output_dir"
    fi
    
    # Generate summary
    generate_advanced_summary "$output_dir"
    
    log_info "🎉 Advanced scan completed!"
    echo ""
    echo "Results saved in: $output_dir"
    echo ""
    read -p "Press Enter to continue..."
}

process_advanced_results() {
    local output_dir="$1"
    
    # Create processing script
    cat > "$output_dir/process_advanced.py" << 'PROCESS_EOF'
#!/usr/bin/env python3

import json
import pandas as pd
import os
import glob
import sys
from datetime import datetime

def process_json_to_csv(json_file, image_name, parse_mode):
    """Process JSON to CSV with specified parse mode"""
    try:
        with open(json_file, 'r', encoding='utf-8') as file:
            data = json.load(file)
    except Exception as e:
        print(f"Error reading {json_file}: {e}")
        return pd.DataFrame()

    if isinstance(data, dict):
        results = data.get("Results", [])
    elif isinstance(data, list):
        results = data
    else:
        return pd.DataFrame()

    if parse_mode == "standard":
        return process_standard(results, image_name)
    else:
        return process_unique(results, image_name)

def process_standard(results, image_name):
    """Standard processing - all vulnerabilities"""
    processed_data = []
    for result in results:
        vulnerabilities = result.get("Vulnerabilities", [])
        if not vulnerabilities:
            processed_data.append({
                "Image Name": image_name,
                "Package": "No vulnerabilities found",
                "Installed Version": "",
                "Fixed Version": "",
                "Vulnerability ID": "",
                "Severity": "CLEAN",
                "URL": ""
            })
        else:
            for vuln in vulnerabilities:
                processed_data.append({
                    "Image Name": image_name,
                    "Package": vuln.get("PkgName"),
                    "Installed Version": vuln.get("InstalledVersion"),
                    "Fixed Version": vuln.get("FixedVersion", ""),
                    "Vulnerability ID": vuln.get("VulnerabilityID"),
                    "Severity": vuln.get("Severity", "N/A"),
                    "URL": vuln.get("PrimaryURL", "")
                })
    
    return pd.DataFrame(processed_data)

def process_unique(results, image_name):
    """Unique processing - deduplicated package@version combinations"""
    pkg_vulns = {}
    for result in results:
        vulnerabilities = result.get("Vulnerabilities", [])
        if not vulnerabilities:
            pkg_vulns["NO_VULNERABILITIES"] = {
                "Image Name": image_name,
                "Package": "No vulnerabilities found",
                "Installed Version": "",
                "Fixed Versions": set(),
                "Vulnerability IDs": set(),
                "Severities": set(["CLEAN"]),
                "URLs": set()
            }
        else:
            for vuln in vulnerabilities:
                pkg_name = vuln.get("PkgName")
                installed_version = vuln.get("InstalledVersion")
                fixed_version = vuln.get("FixedVersion", "")
                vulnerability_id = vuln.get("VulnerabilityID")
                severity = vuln.get("Severity", "N/A")
                url = vuln.get("PrimaryURL", "")

                key = f"{pkg_name}@{installed_version}"
                if key not in pkg_vulns:
                    pkg_vulns[key] = {
                        "Image Name": image_name,
                        "Package": pkg_name,
                        "Installed Version": installed_version,
                        "Fixed Versions": set(),
                        "Vulnerability IDs": set(),
                        "Severities": set(),
                        "URLs": set()
                    }

                if fixed_version:
                    pkg_vulns[key]["Fixed Versions"].add(fixed_version)
                pkg_vulns[key]["Vulnerability IDs"].add(vulnerability_id)
                pkg_vulns[key]["Severities"].add(severity)
                if url:
                    pkg_vulns[key]["URLs"].add(url)

    processed_data = []
    for pkg_data in pkg_vulns.values():
        pkg_data["Fixed Versions"] = ', '.join(filter(None, sorted(pkg_data["Fixed Versions"])))
        pkg_data["Vulnerability IDs"] = ', '.join(sorted(pkg_data["Vulnerability IDs"]))
        pkg_data["Severities"] = ', '.join(sorted(pkg_data["Severities"]))
        pkg_data["URLs"] = ', '.join(sorted([str(url) for url in pkg_data["URLs"] if url]))
        processed_data.append(pkg_data)

    return pd.DataFrame(processed_data)

def main():
    import sys
    if len(sys.argv) != 3:
        print("Usage: python3 process_advanced.py <parse_mode> <report_mode>")
        sys.exit(1)
    
    parse_mode = sys.argv[1]
    report_mode = sys.argv[2]
    
    json_dir = "json"
    csv_dir = "csv"
    
    os.makedirs(csv_dir, exist_ok=True)
    
    json_files = glob.glob(os.path.join(json_dir, "*.json"))
    all_dataframes = []
    
    print(f"Processing {len(json_files)} JSON files...")
    print(f"Parse mode: {parse_mode}")
    print(f"Report mode: {report_mode}")
    
    for json_file in json_files:
        image_name = os.path.basename(json_file).replace('.json', '')
        print(f"Processing {image_name}...")
        
        df = process_json_to_csv(json_file, image_name, parse_mode)
        
        if not df.empty:
            all_dataframes.append(df)
            
            # Generate separate reports if requested
            if report_mode in ["separate", "both"]:
                csv_file = os.path.join(csv_dir, f"{image_name}.csv")
                df.to_csv(csv_file, index=False)
                print(f"  ✓ Saved individual report: {csv_file}")
    
    # Generate combined report if requested
    if report_mode in ["combined", "both"] and all_dataframes:
        combined_df = pd.concat(all_dataframes, ignore_index=True)
        combined_file = f"combined_{parse_mode}.csv"
        combined_df.to_csv(combined_file, index=False)
        print(f"✓ Saved combined report: {combined_file} ({len(combined_df)} records)")
        
        # Generate summary statistics
        if not combined_df.empty and 'Severity' in combined_df.columns:
            severity_counts = combined_df['Severity'].value_counts()
            print("\nVulnerability Summary:")
            for severity, count in severity_counts.items():
                print(f"  {severity}: {count}")
    
    print("\nProcessing completed successfully!")

if __name__ == "__main__":
    main()
PROCESS_EOF
    
    cd "$output_dir"
    python3 process_advanced.py "$PARSE_MODE" "$REPORT_MODE"
    cd - > /dev/null
}

generate_advanced_summary() {
    local output_dir="$1"
    local timestamp=$(date +%Y-%m-%d\ %H:%M:%S)
    
    cat > "$output_dir/advanced_scan_summary.txt" << SUMMARY_EOF
Advanced Trivy Scan Summary Report
Generated: $timestamp
$('='*50)

CONFIGURATION:
  Output Format: $OUTPUT_FORMAT
  Parse Mode: $PARSE_MODE
  Report Mode: $REPORT_MODE

IMAGES SCANNED: ${#SELECTED_IMAGES[@]}

SELECTED IMAGES:
SUMMARY_EOF

    for i in "${!SELECTED_IMAGES[@]}"; do
        local image="${SELECTED_IMAGES[$i]}"
        local type="${image%%:*}"
        local name="${image#*:}"
        echo "$((i+1)). [$type] $name" >> "$output_dir/advanced_scan_summary.txt"
    done
    
    echo "" >> "$output_dir/advanced_scan_summary.txt"
    echo "OUTPUT FILES:" >> "$output_dir/advanced_scan_summary.txt"
    echo "  json/ - Individual JSON scan reports" >> "$output_dir/advanced_scan_summary.txt"
    
    if [[ "$OUTPUT_FORMAT" == "csv" ]]; then
        if [[ "$REPORT_MODE" == "combined" ]] || [[ "$REPORT_MODE" == "both" ]]; then
            echo "  combined_${PARSE_MODE}.csv - Combined vulnerability report" >> "$output_dir/advanced_scan_summary.txt"
        fi
        if [[ "$REPORT_MODE" == "separate" ]] || [[ "$REPORT_MODE" == "both" ]]; then
            echo "  csv/ - Individual CSV reports" >> "$output_dir/advanced_scan_summary.txt"
        fi
    fi
    
    echo "  logs/scan.log - Detailed scan log" >> "$output_dir/advanced_scan_summary.txt"
    echo "  advanced_scan_summary.txt - This summary file" >> "$output_dir/advanced_scan_summary.txt"
}

show_help() {
    print_separator
    echo -e "${WHITE}ADVANCED TRIVY SCANNER - HELP${NC}"
    print_separator
    echo ""
    echo -e "${YELLOW}OVERVIEW:${NC}"
    echo "Advanced vulnerability scanner supporting multiple image sources and flexible output options."
    echo ""
    echo -e "${YELLOW}IMAGE SOURCES:${NC}"
    echo "• Remote Images: ghcr.io, docker.io, registry.example.com, etc."
    echo "• Local Docker Images: Images available in local Docker daemon"
    echo "• TAR/TAR.GZ Files: Container image archives"
    echo "• Directory Browser: Interactive file selection"
    echo ""
    echo -e "${YELLOW}OUTPUT OPTIONS:${NC}"
    echo "• Format: JSON (raw) or CSV (processed)"
    echo "• Parse Mode: Standard (all vulnerabilities) or Unique (deduplicated)"
    echo "• Report Mode: Combined, Separate, or Both"
    echo ""
    echo -e "${YELLOW}EXAMPLES:${NC}"
    echo "Remote image: ghcr.io/vunetsystems/canberra:74"
    echo "Local image: nginx:latest"
    echo "TAR file: /path/to/image.tar.gz"
    echo ""
    read -p "Press Enter to continue..."
}

# Main execution
main() {
    while true; do
        print_header
        check_dependencies
        show_main_menu
        
        read -p "Choose an option (0-9): " choice
        
        case $choice in
            1) scan_remote_images ;;
            2) scan_local_images ;;
            3) scan_tar_files ;;
            4) browse_directory ;;
            5) configure_output ;;
            6) review_and_scan ;;
            7) 
                print_header
        log_warn "View results functionality - check your ${BASE_RESULTS_DIR}/${OUTPUT_DIR}_* directories"
                read -p "Press Enter to continue..."
                ;;
            8)
                print_header
        log_warn "Clean up functionality - manually remove ${BASE_RESULTS_DIR}/${OUTPUT_DIR}_* directories"
                read -p "Press Enter to continue..."
                ;;
            9) show_help ;;
            0)
                print_header
                log_info "Thank you for using Advanced Trivy Scanner!"
                exit 0
                ;;
            *)
                log_error "Invalid option. Please choose 0-9."
                sleep 2
                ;;
        esac
    done
}

# Run the main function
main "$@"
