# 🛡️ TAD Scanner - Trivy Advanced Detection Scanner

A powerful, user-friendly container vulnerability scanner built on top of Aqua Security's Trivy with enhanced features for better usability and functionality.

![Version](https://img.shields.io/badge/version-3.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Shell](https://img.shields.io/badge/shell-bash-yellow.svg)

## 🎯 What is TAD Scanner?

**TAD Scanner** = **T**rivy **A**dvanced **D**etection Scanner

An enhanced container vulnerability scanner that transforms the powerful Trivy scanner into a user-friendly, feature-rich security tool with advanced capabilities for DevSecOps teams.

## ✨ Features

### 🎯 Enhanced User Experience
- **🔍 Auto-path completion** - Smart path suggestions as you type
- **📚 Recent paths history** - Remembers last 10 used directories
- **📊 Progress bars** - Visual progress with percentage indicators
- **⏱️ Time estimation** - Real-time completion estimates
- **⌨️ Keyboard shortcuts** - Enhanced Ctrl+C handling with graceful shutdown
- **🎨 Color-coded severity** - Different colors for CRITICAL/HIGH/MEDIUM/LOW vulnerabilities
- **🔔 Sound notifications** - Audio alerts when scans complete

### ⚡ Advanced Functionality
- **🚀 Parallel scanning** - Configurable concurrent scans (1-10)
- **🔄 Resume capability** - Continue interrupted scans with state saving
- **📈 Incremental scanning** - Skip already completed images
- **🔁 Auto-retry failed scans** - Configurable retry attempts (0-5)
- **🎛️ Custom severity filters** - Focus on CRITICAL/HIGH vulnerabilities only
- **📅 Vulnerability age filtering** - Filter by recent CVEs (30D/90D/1Y)
- **📦 Enhanced package detection** - Better handling of different package managers

### 📊 Flexible Output Options
- **📄 JSON output** - Raw Trivy results for automation
- **📋 CSV output** - Processed vulnerability data for analysis
- **📈 Multiple report modes** - Combined, separate, or both
- **🔧 Advanced filtering** - Unique vulnerability deduplication

## 🚀 Quick Start

### One-line Installation
```bash
curl -sSL https://raw.githubusercontent.com/your-username/tad-scanner/main/scripts/install.sh | bash
```

### Manual Installation
```bash
# Clone the TAD Scanner repository
git clone https://github.com/your-username/tad-scanner.git
cd tad-scanner

# Make executable
chmod +x src/tad-scanner.sh

# Run TAD Scanner
./src/tad-scanner.sh
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

1. **Start TAD Scanner:**
   ```bash
   ./src/tad-scanner.sh
   ```

2. **Select scanning option:**
   - 🌐 Scan Remote Images (ghcr.io, docker.io, etc.)
   - 🏗️ Scan Local Docker Images
   - 📦 Scan TAR/TAR.GZ Files (TAD Enhanced)
   - 📁 Browse & Select from Directory

3. **Configure TAD Scanner options:**
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
tad-scanner/
├── src/
│   ├── tad-scanner.sh              # Main TAD Scanner
│   └── tad-scanner-legacy.sh       # Legacy version
├── scripts/
│   ├── install.sh                  # TAD Scanner installation script
│   └── json_to_csv_converter.py    # CSV conversion utility
├── docs/
│   ├── USAGE.md                    # Detailed TAD Scanner usage guide
│   ├── CONFIGURATION.md            # TAD Scanner configuration options
│   └── EXAMPLES.md                 # TAD Scanner usage examples
├── examples/
│   ├── docker-compose.yml          # Docker Compose example
│   └── sample-configs/             # Sample configuration files
├── tests/
│   └── test-scanner.sh             # TAD Scanner tests
├── .github/
│   └── workflows/
│       └── ci.yml                  # GitHub Actions CI
├── README.md                       # This file
├── LICENSE                         # MIT License
├── CHANGELOG.md                    # Version history
└── .gitignore                      # Git ignore rules
```

## ⚙️ TAD Scanner Configuration

TAD Scanner supports various configuration options:

- **Severity Filtering:** `ALL`, `HIGH_CRITICAL`, `CRITICAL_ONLY`
- **CVE Age Filtering:** `ALL`, `RECENT_30D`, `RECENT_90D`, `RECENT_1Y`
- **Parallel Scans:** 1-10 concurrent scans
- **Auto Retry:** 0-5 retry attempts
- **Output Formats:** JSON, CSV
- **Sound Notifications:** ON/OFF

## 📖 Examples

### Scan TAR Files with TAD Scanner Enhanced Features
```bash
# TAD Scanner provides:
# - Auto-completion for directory paths
# - History of recent scan locations
# - Progress bars during scanning
# - Color-coded severity results
```

### TAD Scanner Parallel Scanning
```bash
# Configure up to 10 parallel scans for faster processing
# Automatic retry on failures
# Resume capability for interrupted scans
```

## 🤝 Contributing

We welcome contributions to TAD Scanner! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the TAD Scanner repository
2. Create your feature branch (`git checkout -b feature/amazing-tad-feature`)
3. Commit your changes (`git commit -m 'Add some amazing TAD feature'`)
4. Push to the branch (`git push origin feature/amazing-tad-feature`)
5. Open a Pull Request

## 📝 License

TAD Scanner is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Aqua Security](https://github.com/aquasecurity/trivy) - For the amazing Trivy scanner that powers TAD Scanner
- Contributors and users who help improve TAD Scanner

## 📊 TAD Scanner Stats

![GitHub stars](https://img.shields.io/github/stars/your-username/tad-scanner?style=social)
![GitHub forks](https://img.shields.io/github/forks/your-username/tad-scanner?style=social)
![GitHub issues](https://img.shields.io/github/issues/your-username/tad-scanner)

---

⭐ **If you find TAD Scanner useful, please consider starring the repository!**

🛡️ **TAD Scanner - Making container security scanning simple and powerful!**
