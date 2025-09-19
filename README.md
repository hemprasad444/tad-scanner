# 🚀 Enhanced Advanced Trivy Scanner

A powerful, user-friendly container vulnerability scanner built on top of Aqua Security's Trivy with enhanced features for better usability and functionality.

![Version](https://img.shields.io/badge/version-3.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Shell](https://img.shields.io/badge/shell-bash-yellow.svg)

## ✨ Features

### 🎯 UX Improvements
- **Auto-path completion** - Smart path suggestions as you type
- **Recent paths history** - Remembers last 10 used directories
- **Progress bars** - Visual progress with percentage indicators
- **Estimated time remaining** - Real-time completion estimates
- **Keyboard shortcuts** - Enhanced Ctrl+C handling with graceful shutdown
- **Color-coded severity** - Different colors for CRITICAL/HIGH/MEDIUM/LOW vulnerabilities
- **Sound notifications** - Audio alerts when scans complete

### ⚡ Functionality Improvements
- **Parallel scanning** - Configurable concurrent scans (1-10)
- **Resume capability** - Continue interrupted scans with state saving
- **Incremental scanning** - Skip already completed images
- **Auto-retry failed scans** - Configurable retry attempts (0-5)
- **Custom severity filters** - Focus on CRITICAL/HIGH vulnerabilities only
- **Vulnerability age filtering** - Filter by recent CVEs (30D/90D/1Y)
- **Enhanced package manager detection** - Better handling of different package types

### 📊 Output Options
- **JSON output** - Raw Trivy results
- **CSV output** - Processed vulnerability data
- **Multiple report modes** - Combined, separate, or both
- **Advanced filtering** - Unique vulnerability deduplication

## 🚀 Quick Start

### One-line Installation
```bash
curl -sSL https://raw.githubusercontent.com/your-username/trivy-enhanced-scanner/main/scripts/install.sh | bash
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/your-username/trivy-enhanced-scanner.git
cd trivy-enhanced-scanner

# Make executable
chmod +x src/trivy-enhanced-scanner.sh

# Run the scanner
./src/trivy-enhanced-scanner.sh
```

## 📋 Prerequisites

- **Trivy** - Container vulnerability scanner
- **jq** - JSON processor
- **Bash 4.0+** - Shell environment

### Install Dependencies

**Ubuntu/Debian:**
```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Install jq
sudo apt-get update && sudo apt-get install -y jq
```

**RHEL/CentOS:**
```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Install jq
sudo yum install -y jq
```

## 🎮 Usage

1. **Start the scanner:**
   ```bash
   ./src/trivy-enhanced-scanner.sh
   ```

2. **Select scanning option:**
   - 🌐 Scan Remote Images (ghcr.io, docker.io, etc.)
   - 🏗️ Scan Local Docker Images
   - 📦 Scan TAR/TAR.GZ Files (Enhanced)
   - 📁 Browse & Select from Directory

3. **Configure advanced options:**
   - Severity filtering (ALL/HIGH_CRITICAL/CRITICAL_ONLY)
   - CVE age filtering (ALL/30D/90D/1Y)
   - Parallel scanning (1-10 concurrent)
   - Auto-retry settings (0-5 attempts)

4. **Start scanning and enjoy:**
   - Real-time progress bars
   - Time estimation
   - Color-coded results
   - Sound notifications

## 📁 Project Structure

```
trivy-enhanced-scanner/
├── src/
│   ├── trivy-enhanced-scanner.sh    # Main enhanced scanner
│   └── trivy-scanner.sh             # Original scanner
├── scripts/
│   ├── install.sh                   # Installation script
│   └── update.sh                    # Update script
├── docs/
│   ├── USAGE.md                     # Detailed usage guide
│   ├── CONFIGURATION.md             # Configuration options
│   └── EXAMPLES.md                  # Usage examples
├── examples/
│   ├── docker-compose.yml           # Docker Compose example
│   └── sample-configs/              # Sample configuration files
├── tests/
│   └── test-scanner.sh              # Basic tests
├── .github/
│   └── workflows/
│       └── ci.yml                   # GitHub Actions CI
├── README.md                        # This file
├── LICENSE                          # MIT License
├── CHANGELOG.md                     # Version history
└── .gitignore                       # Git ignore rules
```

## ⚙️ Configuration

The scanner supports various configuration options:

- **Severity Filtering:** `ALL`, `HIGH_CRITICAL`, `CRITICAL_ONLY`
- **CVE Age Filtering:** `ALL`, `RECENT_30D`, `RECENT_90D`, `RECENT_1Y`
- **Parallel Scans:** 1-10 concurrent scans
- **Auto Retry:** 0-5 retry attempts
- **Output Formats:** JSON, CSV
- **Sound Notifications:** ON/OFF

## 📖 Examples

### Scan TAR Files with Enhanced Features
```bash
# The scanner will provide:
# - Auto-completion for directory paths
# - History of recent scan locations
# - Progress bars during scanning
# - Color-coded severity results
```

### Parallel Scanning
```bash
# Configure up to 10 parallel scans for faster processing
# Automatic retry on failures
# Resume capability for interrupted scans
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Aqua Security](https://github.com/aquasecurity/trivy) - For the amazing Trivy scanner
- Contributors and users who help improve this tool

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/your-username/trivy-enhanced-scanner?style=social)
![GitHub forks](https://img.shields.io/github/forks/your-username/trivy-enhanced-scanner?style=social)
![GitHub issues](https://img.shields.io/github/issues/your-username/trivy-enhanced-scanner)

---

⭐ **If you find this tool useful, please consider starring the repository!**
