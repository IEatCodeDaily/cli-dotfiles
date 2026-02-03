# Tools Documentation

Detailed documentation for each CLI tool supported by CLI Dotfiles.

## Table of Contents

1. [Claude Code](#claude-code)
2. [Factory CLI](#factory-cli)
3. [Gemini CLI](#gemini-cli)
4. [Shell Configurations](#shell-configurations)

## Claude Code

### Overview

[Claude Code](https://github.com/anthropics/claude-code) is Anthropic's official CLI for interacting with Claude AI. It provides advanced coding assistance, file editing, and project management capabilities.

### Installation

```bash
npm install -g @anthropic-ai/claude-code
```

### Configuration Files

#### `~/.claude/settings.json`

Main configuration file containing:
- API authentication
- Base URL (can use custom endpoints)
- Enabled plugins
- Permission settings
- Environment variables

**Template location:** `configs/claude-code/settings.json.template`

**Key settings:**
```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "${ANTHROPIC_API_KEY}",
    "ANTHROPIC_BASE_URL": "https://api.anthropic.com",
    "API_TIMEOUT_MS": "3000000"
  },
  "enabledPlugins": {
    "frontend-design@claude-plugins-official": true,
    "context7@claude-plugins-official": true,
    "github@claude-plugins-official": true
  }
}
```

#### `~/.claude/skills/`

Directory containing custom skills. This repository includes:

- **code-review** - Code review capabilities
- **commit-security-scan** - Security scanning for commits
- **security-review** - Security review functionality
- **threat-model-generation** - STRIDE threat modeling
- **vulnerability-validation** - Validate security findings

### Enabled Plugins

This configuration enables the following official plugins:

| Plugin | Purpose |
|--------|---------|
| `frontend-design` | Generate frontend UI components |
| `context7` | Query up-to-date library documentation |
| `code-review` | Review code changes |
| `feature-dev` | Guided feature development |
| `code-simplifier` | Simplify complex code |
| `ralph-loop` | Ralph Loop functionality |
| `typescript-lsp` | TypeScript language support |
| `playwright` | Browser automation |
| `commit-commands` | Git commit helpers |
| `serena` - Serena workflow integration |
| `security-guidance` | Security best practices |
| `superpowers` | Development workflow superpowers |
| `pr-review-toolkit` | PR review agents |
| `gopls-lsp` | Go language support |
| `claude-code-setup` | Claude Code setup helpers |
| `github` | GitHub integration |

### Usage Examples

```bash
# Start interactive session
claude

# Ask a question directly
claude "Help me debug this function"

# Edit a file
claude --edit path/to/file.ts

# Review a PR
claude "Review the changes in PR #123"
```

### Tips and Tricks

1. **Custom API Endpoints**: You can use custom Anthropic-compatible endpoints by modifying `ANTHROPIC_BASE_URL` in settings.

2. **Plugin Management**: Enable/disable plugins in the `enabledPlugins` section of settings.

3. **Timeout Adjustment**: Increase `API_TIMEOUT_MS` for long-running operations.

4. **Context Awareness**: Claude Code automatically reads your project files for context.

## Factory CLI

### Overview

[Factory CLI](https://github.com/aifn/factory) is an advanced AI CLI with support for custom models, MCP (Model Context Protocol) servers, skills, and droids (subagents).

### Installation

```bash
npm install -g @aifn/factory
```

### Configuration Files

#### `~/.factory/config.json`

Main configuration for custom models and settings.

**Template location:** `configs/factory-cli/config.json.template`

**Key settings:**
```json
{
  "custom_models": [
    {
      "model_display_name": "GLM-4.7 [GLM Coding Plan Global]",
      "model": "glm-4.7",
      "base_url": "https://api.z.ai/api/coding/paas/v4",
      "api_key": "${ZAI_API_KEY}",
      "provider": "generic-chat-completion-api",
      "max_tokens": 131072
    }
  ]
}
```

#### `~/.factory/mcp.json`

MCP server configurations for extending Factory's capabilities.

**Template location:** `configs/factory-cli/mcp.json.template`

**Configured MCP Servers:**

| Server | Type | Purpose |
|--------|------|---------|
| `context7` | HTTP | Documentation lookup |
| `playwright` | stdio | Browser automation |
| `chrome-devtools` | stdio | Chrome DevTools protocol |
| `atlassian` | HTTP | Atlassian integration |
| `mongodb` | stdio | MongoDB database operations |
| `zai-mcp-server` | stdio | Z.AI custom MCP server |
| `sequential-thinking` | stdio | Sequential thinking protocol |
| `github` | HTTP | GitHub integration |
| `web-search-prime` | HTTP | Web search |
| `web-reader` | HTTP | Web page reading |
| `zread` | HTTP | Repository reading |

### Droids and Skills

#### `~/.factory/droids/`

Custom droids (subagents) for specialized tasks.

#### `~/.factory/skills/`

Custom skills for extending Factory's capabilities.

### Usage Examples

```bash
# Start Factory CLI
factory

# Use custom model
factory --model glm-4.7 "Help me with this task"

# List available MCP servers
factory mcp list

# Use specific MCP server
factory "Search the web for X" --mcp web-search-prime
```

### Tips and Tricks

1. **Model Selection**: Use `--model` flag to switch between custom models.

2. **MCP Server Debugging**: Check MCP server status with `factory mcp status`.

3. **Custom Droids**: Add your own droids to `~/.factory/droids/` for specialized tasks.

4. **Environment Variables**: MCP servers can use environment variables for authentication.

## Gemini CLI

### Overview

[Gemini CLI](https://github.com/google/gemini-cli) is Google's official CLI for interacting with Gemini AI models.

### Installation

```bash
npm install -g @google/gemini-cli
```

### Configuration Files

#### `~/.gemini/settings.json`

UI and tool preferences.

**Template location:** `configs/gemini-cli/settings.json.template`

**Key settings:**
```json
{
  "security": {
    "auth": {
      "selectedType": "oauth-personal"
    },
    "enablePermanentToolApproval": true
  },
  "ui": {
    "showStatusInTitle": true,
    "showCitations": true,
    "showModelInfoInChat": true,
    "showMemoryUsage": true
  }
}
```

### Authentication

Gemini CLI uses OAuth for authentication. Run:

```bash
gemini auth login
```

This will open a browser window for OAuth authentication.

### Usage Examples

```bash
# Start interactive session
gemini chat

# Generate code
gemini code "Write a function to sort an array"

# Ask a question
gemini ask "Explain quantum computing"
```

## Shell Configurations

### Overview

Custom shell configurations for Zsh and Bash with useful aliases, plugins, and optimizations.

### Files

- `~/.zshrc` - Zsh configuration
- `~/.bashrc` - Bash configuration

**Locations:** `shell/.zshrc`, `shell/.bashrc`

### Features

#### Oh My Zsh Integration

Uses [Oh My Zsh](https://ohmyz.sh/) framework with the following plugins:

- `git` - Git aliases and functions
- `docker` - Docker completion
- `sudo` - Double ESC to add sudo
- `history` - History navigation
- `copypath` - Copy current path to clipboard
- `dirhistory` - Directory history navigation
- `jsontools` - JSON manipulation tools
- `colored-man-pages` - Colored man pages
- `command-not-found` - Suggest package for missing commands

#### Theme

Uses `xiong-chiamiov-plus` theme with:
- Git branch/status display
- Exit code indication
- Path truncation for long paths
- Color-coded file types

#### Aliases

```bash
ll      # ls -alF
la      # ls -A
l       # ls -CF
..      # cd ..
...     # cd ../..
vi      # vim
fm      # ranger (file manager)
bat     # batcat (if installed as batcat on Debian)
```

#### NVM Lazy Loading

Node Version Manager (NVM) is loaded lazily to improve shell startup time:

```bash
# nvm, node, npm, npx commands trigger NVM loading
nvm install 20  # Loads NVM and installs Node 20
```

#### SSH Agent Management

Automatically starts SSH agent and adds all keys from `~/.ssh/keys/`:

```bash
# Place private keys in ~/.ssh/keys/
# They will be automatically added on shell startup
```

#### FZF Integration

[FZF](https://github.com/junegunn/fzf) (fuzzy finder) integration if installed:

```bash
# Ctrl+R - Fuzzy history search
# Ctrl+T - Fuzzy file search
```

#### Syntax Highlighting and Autosuggestions

- **zsh-autosuggestions** - Autosuggestions based on history
- **zsh-syntax-highlighting** - Syntax highlighting as you type

### Prerequisites for Shell Configs

1. **Oh My Zsh** (required for Zsh config):
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

2. **Zsh plugins** (auto-installed by Oh My Zsh):
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
```

3. **Optional but recommended**:
```bash
# fzf (fuzzy finder)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# ranger (file manager)
sudo apt install ranger  # Debian/Ubuntu
brew install ranger      # macOS

# bat (cat alternative)
sudo apt install bat  # Debian/Ubuntu
brew install bat      # macOS

# fastfetch (neofetch alternative)
sudo apt install fastfetch  # Debian/Ubuntu
brew install fastfetch      # macOS
```

### Customization

To customize shell configs, edit the files directly:

```bash
nano ~/cli-dotfiles/shell/.zshrc
nano ~/cli-dotfiles/shell/.bashrc

# Then re-run setup
cd ~/cli-dotfiles
./scripts/setup.sh --tools shell
```

Or edit the installed configs directly:

```bash
nano ~/.zshrc
source ~/.zshrc  # Apply changes
```

### Shell-Specific Notes

#### Zsh

- Uses Oh My Zsh as the framework
- Loads plugins from `~/.oh-my-zsh/plugins/` and `~/.zsh/`
- Theme can be changed by modifying `ZSH_THEME` variable

#### Bash

- Standard bash configuration
- Includes bash-completion if available
- No framework dependency (works on any system with Bash)

## Integration Between Tools

### Shared MCP Servers

Both Claude Code and Factory CLI can use the same MCP servers. The MCP configurations in this repository are set up for Factory CLI, but similar configurations can be used in Claude Code.

### API Keys

The same API keys can be used across tools:
- `ANTHROPIC_API_KEY` - Claude Code and potentially other Anthropic-compatible tools
- `ZAI_API_KEY` - Factory CLI and Z.AI MCP servers
- `GITHUB_TOKEN` - GitHub MCP servers in both tools

### Shell Environment

All tools respect the shell environment:
- Environment variables set in `.zshrc`/`.bashrc` are available to all tools
- PATH modifications affect tool accessibility
- Aliases and functions work with tool commands

## Troubleshooting Tool-Specific Issues

### Claude Code

**Problem:** "Plugin not found"

**Solution:**
```bash
claude plugin update
# Or reinstall
npm install -g @anthropic-ai/claude-code
```

**Problem:** Context not loading

**Solution:** Check file permissions:
```bash
ls -la ~/.claude/
chmod -R 755 ~/.claude/
```

### Factory CLI

**Problem:** MCP server connection failed

**Solution:** Check MCP server status:
```bash
factory mcp status
# Check if the server is disabled in mcp.json
```

**Problem:** Custom model not working

**Solution:** Verify API key and base URL:
```bash
cat ~/.factory/config.json | grep api_key
cat ~/.factory/config.json | grep base_url
```

### Gemini CLI

**Problem:** OAuth failed

**Solution:**
```bash
gemini auth logout
gemini auth login
```

**Problem:** Tool approval prompts

**Solution:** Enable permanent tool approval in settings:
```json
{
  "security": {
    "enablePermanentToolApproval": true
  }
}
```

### Shell Configs

**Problem:** Theme not displaying correctly

**Solution:** Install powerline fonts:
```bash
sudo apt install fonts-powerline  # Debian/Ubuntu
brew tap homebrew/cask-fonts      # macOS
brew install font-powerline
```

**Problem:** Plugins not loading

**Solution:** Check Oh My Zsh installation:
```bash
echo $ZSH  # Should point to ~/.oh-my-zsh
ls ~/.oh-my-zsh/plugins/
```

## Additional Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Factory CLI GitHub](https://github.com/aifn/factory)
- [Gemini CLI Documentation](https://github.com/google/gemini-cli)
- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
