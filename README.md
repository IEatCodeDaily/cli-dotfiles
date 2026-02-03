# CLI Dotfiles

> Portable configuration and setup scripts for AI CLI tools

This repository contains portable configurations and automated setup scripts for popular AI-powered CLI tools. It's designed to be easily customizable and maintainable across multiple machines.

## 🚀 Supported Tools

- **Claude Code** - Anthropic's official AI coding assistant CLI
- **Factory CLI** - Advanced AI CLI with custom models and MCP support
- **Gemini CLI** - Google's Gemini AI CLI
- **Shell Configs** - Zsh and Bash configurations with useful aliases and plugins

## ✨ Features

- 🔐 **Secret Management** - Secure handling of API keys with `.env` file support or interactive prompts
- 📦 **Template-Based** - Configuration files use templates for easy customization
- 🔄 **Non-Destructive** - Automatically backs up existing configurations before applying changes
- 🎯 **Idempotent** - Safe to run multiple times
- 🧪 **Dry Run Mode** - Preview changes before applying them
- 🛠️ **Modular** - Install only the tools you need
- 📥 **Includes Custom Configs** - Skills, droids, and MCP server configurations

## 📋 Prerequisites

- Unix-like system (Linux, macOS, WSL)
- Bash shell
- Node.js and npm (for CLI tool installation)
- Git (for cloning this repo)

## 🚀 Quick Start

### Option 1: Interactive Setup (Recommended for first-time users)

```bash
git clone https://github.com/IEatCodeDaily/cli-dotfiles.git
cd cli-dotfiles
./scripts/setup.sh --interactive
```

The script will prompt you for each required API key.

### Option 2: Using a .env File

1. Copy the example environment file:
```bash
cp scripts/templates/.env.example scripts/templates/.env
```

2. Edit `.env` with your actual API keys:
```bash
nano scripts/templates/.env
```

3. Run setup with the .env file:
```bash
./scripts/setup.sh --env-file scripts/templates/.env
```

### Option 3: Selective Tool Installation

Install only specific tools:
```bash
./scripts/setup.sh --tools claude-code,shell
```

Available tools: `claude-code`, `factory-cli`, `gemini-cli`, `shell`

## 🔧 Configuration

### Required Secrets

| Variable | Description | Used By |
|----------|-------------|---------|
| `ANTHROPIC_API_KEY` | Your Anthropic API key | Claude Code, Factory |
| `ZAI_API_KEY` | Z.AI API key | Factory CLI, MCP servers |

### Optional Secrets

| Variable | Description | Used By |
|----------|-------------|---------|
| `CONTEXT7_API_KEY` | Context7 API key | MCP documentation server |
| `GITHUB_TOKEN` | GitHub personal access token | GitHub MCP server |

### Getting API Keys

- **Anthropic**: Get your key at https://console.anthropic.com/
- **Z.AI**: Get your key from your Z.AI account
- **Context7**: Get your key at https://context7.com/
- **GitHub**: Create a personal access token at https://github.com/settings/tokens

## 📁 Repository Structure

```
cli-dotfiles/
├── configs/
│   ├── claude-code/          # Claude Code configurations
│   │   ├── settings.json.template
│   │   └── skills/           # Custom skills
│   ├── factory-cli/          # Factory CLI configurations
│   │   ├── config.json.template
│   │   ├── mcp.json.template
│   │   ├── droids/           # Custom droids
│   │   └── skills/           # Custom skills
│   └── gemini-cli/           # Gemini CLI configurations
│       └── settings.json.template
├── shell/                    # Shell configurations
│   ├── .zshrc
│   └── .bashrc
├── scripts/                  # Setup and utility scripts
│   ├── setup.sh              # Main setup script
│   └── templates/
│       ├── .env.example      # Environment variable template
├── docs/                     # Documentation
│   ├── INSTALLATION.md       # Detailed installation guide
│   ├── SECRETS.md            # Secret management guide
│   └── TOOLS.md              # Tool-specific documentation
└── README.md
```

## 🛠️ Advanced Usage

### Dry Run Mode

Preview what would change without actually making changes:

```bash
./scripts/setup.sh --dry-run
```

### Skip Installation, Configure Only

If you already have tools installed but want to apply configurations:

```bash
./scripts/setup.sh --skip-install
```

### Custom Environment File

Use a custom path for your .env file:

```bash
./scripts/setup.sh --env-file /path/to/my-secrets.env
```

## 🔐 Security

- **Never commit** actual `.env` files with secrets to the repository
- The `.gitignore` file is configured to exclude `.env` files
- Configuration files are stored as `.template` files requiring secret injection
- Secrets are never logged to the console
- Backups of existing configs are created with timestamps

## 🔄 Updating

To get the latest configurations:

```bash
cd cli-dotfiles
git pull
./scripts/setup.sh --env-file scripts/templates/.env
```

## 🧪 Testing

The setup script includes a dry-run mode for testing:

```bash
# Test in a temporary directory without affecting your system
mkdir /tmp/test-setup
cd /tmp/test-setup
git clone https://github.com/IEatCodeDaily/cli-dotfiles.git
cd cli-dotfiles
./scripts/setup.sh --dry-run
```

## 🤝 Contributing

Contributions are welcome! To add support for a new CLI tool:

1. Add a new directory under `configs/`
2. Create `.template` files for configuration
3. Add installation logic to `scripts/setup.sh`
4. Update documentation

## 📝 Customization

### Adding Your Own Skills/Droids

Simply add your skills or droids to the respective directories:

```bash
# Add a custom Claude Code skill
cp -r my-custom-skill configs/claude-code/skills/

# Add a custom Factory droid
cp -r my-custom-droid configs/factory-cli/droids/
```

### Modifying Shell Configs

Edit the shell configurations directly:

```bash
nano shell/.zshrc
nano shell/.bashrc
```

Then run the setup script to apply changes.

## 🐛 Troubleshooting

### Script fails with "permission denied"

Make the script executable:
```bash
chmod +x scripts/setup.sh
```

### API key not working

- Verify your API key is correct
- Check that the key has the necessary permissions
- Ensure you haven't hit any rate limits

### Configuration not applied

- Check that you're using the correct path for the `.env` file
- Try running with `--dry-run` to see what would be changed
- Look for backup files (`.backup.*`) to see what was replaced

## 📄 License

This repository is licensed under the MIT License.

## 🙏 Acknowledgments

- Built for use with [Claude Code](https://github.com/anthropics/claude-code)
- Uses [Factory CLI](https://github.com/aifn/factory)
- Integrates with [Gemini CLI](https://github.com/google/gemini-cli)

---

**Made with ❤️ by [IEatCodeDaily](https://github.com/IEatCodeDaily)**
