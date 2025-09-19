# Changelog

All notable changes to the Enhanced Trivy Scanner project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2024-12-19

### Added
- 🎯 **UX Improvements**
  - Auto-path completion with smart suggestions
  - Recent paths history (remembers last 10 directories)
  - Real-time progress bars with percentage indicators
  - Estimated time remaining calculations
  - Enhanced Ctrl+C handling with graceful shutdown
  - Color-coded severity levels (CRITICAL/HIGH/MEDIUM/LOW)
  - Sound notifications for scan completion

- ⚡ **Functionality Improvements**
  - Parallel scanning with configurable concurrency (1-10)
  - Resume capability for interrupted scans with state saving
  - Incremental scanning to skip already completed images
  - Auto-retry failed scans with configurable attempts (0-5)
  - Custom severity filters (ALL/HIGH_CRITICAL/CRITICAL_ONLY)
  - CVE age filtering (ALL/30D/90D/1Y)
  - Enhanced package manager detection

- 📊 **Output & Reporting**
  - Enhanced CSV conversion with better formatting
  - Advanced filtering and deduplication options
  - Improved summary reports with statistics

- 🛠️ **Development & Distribution**
  - Proper Git repository structure
  - Automated installation script
  - Comprehensive documentation
  - GitHub Actions CI/CD pipeline
  - MIT License

### Changed
- Restructured codebase for better maintainability
- Enhanced error handling and user feedback
- Improved dependency management
- Better configuration management with persistent settings

### Fixed
- Path handling issues with relative and absolute paths
- CSV output generation problems
- Memory optimization for large scans
- Various UI/UX improvements

## [2.0.0] - 2024-09-18

### Added
- Original advanced Trivy scanner functionality
- Multiple image source support (remote, local, TAR)
- Flexible output options (JSON, CSV)
- Configuration management
- Basic progress tracking

### Features
- Remote image scanning (ghcr.io, docker.io, etc.)
- Local Docker image scanning
- TAR/TAR.GZ file scanning
- Directory browsing and selection
- Multiple output formats
- Advanced scan configuration

## [1.0.0] - Initial Release

### Added
- Basic Trivy wrapper functionality
- Simple command-line interface
- JSON output support
- Basic error handling

---

## Planned Features (Roadmap)

### [3.1.0] - Upcoming
- [ ] Web UI interface
- [ ] REST API endpoints
- [ ] Docker container support
- [ ] Enhanced reporting with charts
- [ ] Integration with CI/CD pipelines

### [3.2.0] - Future
- [ ] Database storage for scan history
- [ ] Email notifications
- [ ] Slack/Teams integration
- [ ] Advanced vulnerability correlation
- [ ] Machine learning for false positive reduction

---

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details on how to contribute to this project.

## Support

If you encounter any issues or have questions, please:
1. Check the [documentation](docs/)
2. Search [existing issues](https://github.com/your-username/trivy-enhanced-scanner/issues)
3. Create a [new issue](https://github.com/your-username/trivy-enhanced-scanner/issues/new) if needed
