# Usage Guide - Enhanced Trivy Scanner

This guide provides detailed instructions on how to use the Enhanced Trivy Scanner effectively.

## Table of Contents
- [Getting Started](#getting-started)
- [Basic Usage](#basic-usage)
- [Advanced Features](#advanced-features)
- [Configuration Options](#configuration-options)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Installation
```bash
# One-line installation
curl -sSL https://raw.githubusercontent.com/your-username/trivy-enhanced-scanner/main/scripts/install.sh | bash

# Manual installation
git clone https://github.com/your-username/trivy-enhanced-scanner.git
cd trivy-enhanced-scanner
chmod +x src/trivy-enhanced-scanner.sh
```

### First Run
```bash
./src/trivy-enhanced-scanner.sh
```

## Basic Usage

### 1. Scanning Remote Images
- Select option **1** from the main menu
- Enter image names (e.g., `nginx:latest`, `ubuntu:20.04`)
- Press Enter twice when done

### 2. Scanning Local Images
- Select option **2** from the main menu
- Choose from available local Docker images
- Select specific images or all

### 3. Scanning TAR Files
- Select option **3** from the main menu
- Use enhanced path completion:
  - Type partial paths for auto-completion
  - Use numbers to select from recent paths
  - Get smart suggestions for similar directories

### 4. Configuration
- Select option **5** for enhanced configuration
- Configure severity filters, parallel scans, and more

## Advanced Features

### Path Completion
The scanner remembers your recent scan locations and provides smart suggestions:

```
💡 Recent paths:
  1. /home/user/docker-images
  2. /opt/containers
  3. /var/lib/docker

Enter directory path: 1  # Select recent path by number
```

### Progress Tracking
Real-time progress bars show:
- Current scan progress
- Estimated time remaining
- Success/failure counts

```
[PROGRESS] Scanning nginx:latest [=====>-----] 45% (3/7) - Est: 2m 15s
```

### Severity Filtering
Focus on critical vulnerabilities:
- **ALL**: Show all vulnerabilities
- **HIGH_CRITICAL**: Only HIGH and CRITICAL
- **CRITICAL_ONLY**: Only CRITICAL vulnerabilities

### Parallel Scanning
Configure concurrent scans for faster processing:
- 1-10 parallel scans supported
- Automatic load balancing
- Retry failed scans automatically

### Resume Capability
Interrupted scans can be resumed:
- Automatic state saving
- Resume from last completed image
- Preserve configuration settings

## Configuration Options

### Severity Filters
```
ALL              - Show all vulnerabilities (default)
HIGH_CRITICAL    - Show only HIGH and CRITICAL
CRITICAL_ONLY    - Show only CRITICAL vulnerabilities
```

### CVE Age Filters
```
ALL              - Show all CVEs (default)
RECENT_30D       - CVEs from last 30 days
RECENT_90D       - CVEs from last 90 days
RECENT_1Y        - CVEs from last 1 year
```

### Parallel Scanning
```
1-10 concurrent scans (default: 3)
Higher numbers = faster scanning (if system can handle it)
```

### Auto Retry
```
0-5 retry attempts (default: 2)
Exponential backoff between retries
```

## Examples

### Example 1: Scanning Multiple TAR Files
```bash
# Start scanner
./src/trivy-enhanced-scanner.sh

# Select option 3 (TAR scanning)
# Enter path: /opt/container-images
# Select: a (all files)
# Configure severity filter to HIGH_CRITICAL
# Start scan with parallel processing
```

### Example 2: Critical Vulnerabilities Only
```bash
# Configure severity filter
# Option 5 -> Option 4 -> Option 3 (CRITICAL_ONLY)
# Scan will only show CRITICAL vulnerabilities
```

### Example 3: Recent CVEs Only
```bash
# Configure CVE age filter
# Option 5 -> Option 5 -> Option 2 (RECENT_30D)
# Scan will only show CVEs from last 30 days
```

## Color Coding

The scanner uses color coding for better visibility:

- 🔴 **CRITICAL**: Bright red - Immediate attention required
- 🟠 **HIGH**: Red - Should be addressed soon
- 🟡 **MEDIUM**: Yellow - Moderate priority
- 🔵 **LOW**: Cyan - Low priority
- ⚪ **UNKNOWN**: Gray - Severity not determined

## Output Formats

### JSON Output
- Raw Trivy results
- Complete vulnerability data
- Machine-readable format

### CSV Output
- Processed vulnerability data
- Spreadsheet-friendly format
- Filtered and deduplicated

## Troubleshooting

### Common Issues

**1. Permission Denied**
```bash
chmod +x src/trivy-enhanced-scanner.sh
```

**2. Missing Dependencies**
```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Install jq
sudo apt-get install jq  # Ubuntu/Debian
sudo yum install jq      # RHEL/CentOS
```

**3. Path Not Found**
- Use absolute paths (starting with /)
- Check directory permissions
- Use tab completion for path assistance

**4. Scan Failures**
- Check network connectivity for remote images
- Verify TAR file integrity
- Increase retry count in configuration

### Debug Mode
For troubleshooting, you can run with debug output:
```bash
bash -x ./src/trivy-enhanced-scanner.sh
```

### Log Files
Scan logs are saved in:
- `trivy-advanced-results-*/logs/scan.log`
- Check logs for detailed error information

## Performance Tips

1. **Use Parallel Scanning**: Set 3-5 parallel scans for optimal performance
2. **Filter Early**: Use severity filters to reduce processing time
3. **Resume Long Scans**: Use resume feature for large scan jobs
4. **Local Caching**: Trivy caches vulnerability databases locally

## Getting Help

- Check the [README](../README.md) for overview
- Review [Configuration Guide](CONFIGURATION.md) for advanced options
- See [Examples](EXAMPLES.md) for common use cases
- Report issues on [GitHub](https://github.com/your-username/trivy-enhanced-scanner/issues)
