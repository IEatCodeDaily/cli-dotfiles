# Installation Guide

Detailed installation instructions for CLI Dotfiles.

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Initial Setup](#initial-setup)
3. [Tool-Specific Installation](#tool-specific-installation)
4. [Post-Installation](#post-installation)
5. [Troubleshooting](#troubleshooting)

## System Requirements

### Minimum Requirements

- **Operating System**: Linux, macOS, or WSL (Windows Subsystem for Linux)
- **Shell**: Bash 4.0+ or Zsh 5.0+
- **Node.js**: 16.x or later
- **npm**: 8.x or later
- **Git**: 2.0 or later
- **Disk Space**: ~500MB for CLI tools and configurations

### Checking Prerequisites

```bash
# Check OS
uname -s

# Check shell version
bash --version
zsh --version

# Check Node.js and npm
node --version
npm --version

# Check Git
git --version
```

## Initial Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/IEatCodeDaily/cli-dotfiles.git
cd cli-dotfiles
```

### Step 2: Prepare Secrets

Choose one of the following methods:

#### Option A: Interactive Mode (Easiest)

No preparation needed. The setup script will prompt you for each secret.

#### Option B: Environment File

1. Copy the example environment file:
```bash
cp scripts/templates/.env.example scripts/templates/.env
```

2. Edit the file with your API keys:
```bash
nano scripts/templates/.env
```

Required variables:
- `ANTHROPIC_API_KEY` - Get from https://console.anthropic.com/
- `ZAI_API_KEY` - Get from your Z.AI account

Optional variables:
- `CONTEXT7_API_KEY` - Get from https://context7.com/
- `GITHUB_TOKEN` - Get from https://github.com/settings/tokens

### Step 3: Run Setup

Choose your preferred method:

**Interactive:**
```bash
./scripts/setup.sh --interactive
```

**With .env file:**
```bash
./scripts/setup.sh --env-file scripts/templates/.env
```

**Dry run (preview only):**
```bash
./scripts/setup.sh --dry-run
```

## Tool-Specific Installation

### Claude Code

**Installation Method:** npm global package

**What gets installed:**
- `claude` CLI binary
- Configuration file at `~/.claude/settings.json`
- Custom skills from `configs/claude-code/skills/`

**What gets configured:**
- Enabled plugins (frontend-design, context7, code-review, etc.)
- API authentication
- MCP server connections

**Manual Installation (if script fails):**
```bash
npm install -g @anthropic-ai/claude-code
# Then manually copy configs
cp configs/claude-code/settings.json.template ~/.claude/settings.json
# Edit and replace ${VARIABLE} placeholders
```

### Factory CLI

**Installation Method:** curl script installer (downloads `droid` binary)

**What gets installed:**
- `droid` CLI binary at `~/.local/bin/droid`
- `rg` (ripgrep) binary at `~/.factory/bin/rg`
- Configuration files at `~/.factory/`
- Custom droids and skills
- MCP server configurations

**What gets configured:**
- Custom models (GLM-4.7)
- MCP servers (Context7, Playwright, GitHub, etc.)
- Z.AI API integration

**Manual Installation (if script fails):**
```bash
curl -fsSL https://app.factory.ai/cli | sh
# Then manually copy configs
cp configs/factory-cli/config.json.template ~/.factory/config.json
cp configs/factory-cli/mcp.json.template ~/.factory/mcp.json
# Edit and replace ${VARIABLE} placeholders

# Ensure ~/.local/bin is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc
```

### Gemini CLI

**Installation Method:** npm global package

**What gets installed:**
- `gemini` CLI binary
- Configuration file at `~/.gemini/settings.json`

**What gets configured:**
- UI preferences
- Tool settings
- Security settings

**Manual Installation (if script fails):**
```bash
npm install -g @google/gemini-cli
# Then manually copy configs
cp configs/gemini-cli/settings.json.template ~/.gemini/settings.json
```

### Shell Configurations

**What gets installed:**
- Zsh configuration at `~/.zshrc`
- Bash configuration at `~/.bashrc`

**Features included:**
- Oh My Zsh integration
- Custom theme (xiong-chiamiov-plus)
- Useful aliases (ll, la, l, fm, etc.)
- NVM lazy loading
- SSH agent management
- fzf integration
- Syntax highlighting

**Note:** These configs assume you have Oh My Zsh installed. If not, install it first:
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Post-Installation

### Verify Installation

```bash
# Check Claude Code
claude --version

# Check Factory CLI (droid)
droid --version

# Check Gemini CLI
gemini --version

# Test shell configs
source ~/.zshrc  # or restart terminal
```

### Restart Your Shell

For changes to take full effect, restart your shell:

```bash
# For Zsh
exec zsh

# For Bash
exec bash
```

Or simply close and reopen your terminal.

### Test the Tools

```bash
# Test Claude Code
claude "Hello, can you help me write a function?"

# Test Factory CLI
droid --help

# Test Gemini CLI
gemini --help
```

## Troubleshooting

### "Command not found" Errors

**Problem:** After installation, `claude`, `factory`, or `gemini` commands are not found.

**Solution:**

1. Check npm global installation directory:
```bash
npm config get prefix
```

2. Add npm global bin to your PATH if needed:
```bash
export PATH="$(npm config get prefix)/bin:$PATH"
# Add this to your ~/.zshrc or ~/.bashrc
```

3. Or use the full path:
```bash
~/.npm-global/bin/claude
```

### Permission Denied

**Problem:** Cannot run setup script.

**Solution:**
```bash
chmod +x scripts/setup.sh
```

### API Key Errors

**Problem:** Tools complain about invalid API keys.

**Solution:**

1. Verify your keys are correct:
```bash
# Check Claude Code
cat ~/.claude/settings.json | grep API_KEY

# Check Factory CLI
cat ~/.factory/config.json | grep api_key
```

2. Ensure no extra spaces or quotes in your `.env` file:
```bash
# Correct
ANTHROPIC_API_KEY=sk-ant-xxxxx

# Incorrect
ANTHROPIC_API_KEY = "sk-ant-xxxxx"
```

3. Regenerate keys if necessary from your respective provider's console.

### Port Already in Use

**Problem:** MCP server fails to start due to port conflicts.

**Solution:**

Different MCP servers may use different ports. Check which ports are in use:
```bash
lsof -i -P -n | grep LISTEN
```

Disable conflicting MCP servers in your `mcp.json.template`:
```json
{
  "mcpServers": {
    "conflicting-server": {
      "disabled": true
    }
  }
}
```

### Shell Config Not Applied

**Problem:** Shell aliases or functions don't work after setup.

**Solution:**

1. Manually source the config:
```bash
source ~/.zshrc  # For Zsh
source ~/.bashrc # For Bash
```

2. Check for syntax errors:
```bash
zsh -n ~/.zshrc  # Check Zsh syntax
bash -n ~/.bashrc # Check Bash syntax
```

3. Look for conflicts with existing configs in backup files.

### Node.js Version Too Old

**Problem:** CLI tools require a newer version of Node.js.

**Solution:**

Upgrade Node.js using nvm (Node Version Manager):

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell
source ~/.bashrc  # or ~/.zshrc

# Install latest Node.js
nvm install node
nvm use node
```

## Uninstallation

To remove all installed tools and configurations:

```bash
# Uninstall CLI tools
npm uninstall -g @anthropic-ai/claude-code
npm uninstall -g @google/gemini-cli

# Remove Factory CLI (droid) binary
rm -f ~/.local/bin/droid
rm -rf ~/.factory/bin/rg

# Remove configurations (optional - be careful!)
rm -rf ~/.claude
rm -rf ~/.factory
rm -rf ~/.gemini

# Restore original shell configs from backups if available
ls -la ~/.zshrc.backup.*
ls -la ~/.bashrc.backup.*
```

## Getting Help

If you encounter issues not covered here:

1. Check the main [README.md](../README.md)
2. Review [SECRETS.md](./SECRETS.md) for secret management issues
3. Check [TOOLS.md](./TOOLS.md) for tool-specific documentation
4. Open an issue on GitHub: https://github.com/IEatCodeDaily/cli-dotfiles/issues
