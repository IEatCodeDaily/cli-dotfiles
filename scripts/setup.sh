#!/usr/bin/env bash
################################################################################
# CLI Dotfiles Setup Script
# Installs and configures AI CLI tools: Claude Code, Factory CLI, Gemini CLI
#
# Usage:
#   ./setup.sh [options]
#
# Options:
#   --interactive       Prompt for secrets interactively (default)
#   --env-file FILE     Use specified .env file for secrets
#   --dry-run           Show what would be done without making changes
#   --skip-install      Skip tool installation, only configure
#   --tools TOOLS       Comma-separated list of tools to install (default: all)
#                       Available: claude-code,factory-cli,gemini-cli,shell
#   -h, --help          Show this help message
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Default options
INTERACTIVE=true
ENV_FILE=""
DRY_RUN=false
SKIP_INSTALL=false
TOOLS="claude-code,factory-cli,gemini-cli,shell"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --interactive)
      INTERACTIVE=true
      shift
      ;;
    --env-file)
      ENV_FILE="$2"
      INTERACTIVE=false
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --skip-install)
      SKIP_INSTALL=true
      shift
      ;;
    --tools)
      TOOLS="$2"
      shift 2
      ;;
    -h|--help)
      sed -n '/^#!/,/^#####/p' "$0" | sed 's/^#$//; s/^# //; s/^#//'
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

################################################################################
# Helper Functions
################################################################################

log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

run_cmd() {
  if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}[DRY RUN]${NC} $@"
  else
    "$@"
  fi
}

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    log_info "Backing up $file to $backup"
    run_cmd cp "$file" "$backup"
  fi
}

prompt_secret() {
  local var_name="$1"
  local prompt="$2"
  local default_value="${3:-}"

  if [[ -n "$default_value" ]]; then
    read -p "$(echo -e ${GREEN}$prompt [default: $default_value]: ${NC})" input
    echo "${input:-$default_value}"
  else
    read -p "$(echo -e ${GREEN}$prompt: ${NC})" input
    echo "$input"
  fi
}

################################################################################
# Secret Management
################################################################################

load_env_file() {
  if [[ ! -f "$ENV_FILE" ]]; then
    log_error "Environment file not found: $ENV_FILE"
    exit 1
  fi

  log_info "Loading secrets from $ENV_FILE"
  set -a
  source "$ENV_FILE"
  set +a
}

prompt_secrets_interactive() {
  log_info "Prompting for secrets interactively"
  export ANTHROPIC_API_KEY=$(prompt_secret "ANTHROPIC_API_KEY" "Enter Anthropic API Key")
  export ZAI_API_KEY=$(prompt_secret "ZAI_API_KEY" "Enter Z.AI API Key")
  export CONTEXT7_API_KEY=$(prompt_secret "CONTEXT7_API_KEY" "Enter Context7 API Key" "")
  export GITHUB_TOKEN=$(prompt_secret "GITHUB_TOKEN" "Enter GitHub Token" "")
}

validate_secrets() {
  local missing=()

  [[ -z "${ANTHROPIC_API_KEY:-}" ]] && missing+=("ANTHROPIC_API_KEY")
  [[ -z "${ZAI_API_KEY:-}" ]] && missing+=("ZAI_API_KEY")

  if [[ ${#missing[@]} -gt 0 ]]; then
    log_error "Missing required secrets: ${missing[*]}"
    log_info "Either provide a .env file with --env-file or use --interactive"
    exit 1
  fi
}

################################################################################
# Template Processing
################################################################################

process_template() {
  local template="$1"
  local output="$2"

  log_info "Processing template: $template -> $output"

  if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would process $template to $output"
    return
  fi

  # Create output directory if it doesn't exist
  mkdir -p "$(dirname "$output")"

  # Process template with environment variable substitution
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Replace ${VAR} with actual value
    eval "echo \"$line\"" >> "$output"
  done < "$template"
}

################################################################################
# Tool Installation Functions
################################################################################

install_claude_code() {
  log_info "Installing Claude Code..."

  if command -v claude &> /dev/null; then
    log_info "Claude Code already installed"
    if [[ "$INTERACTIVE" == true ]]; then
      read -p "Upgrade to latest version? [y/N]: " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        run_cmd npm install -g @anthropic-ai/claude-code
      fi
    fi
  else
    run_cmd npm install -g @anthropic-ai/claude-code
  fi

  # Configure Claude Code
  local config_dir="$HOME/.claude"
  local settings_template="$REPO_ROOT/configs/claude-code/settings.json.template"
  local settings_output="$config_dir/settings.json"

  backup_file "$settings_output"
  process_template "$settings_template" "$settings_output"

  # Copy skills
  if [[ -d "$REPO_ROOT/configs/claude-code/skills" ]]; then
    log_info "Installing Claude Code skills..."
    run_cmd cp -r "$REPO_ROOT/configs/claude-code/skills" "$config_dir/"
  fi

  log_success "Claude Code configured"
}

install_factory_cli() {
  log_info "Installing Factory CLI..."

  if command -v factory &> /dev/null; then
    log_info "Factory CLI already installed"
    if [[ "$INTERACTIVE" == true ]]; then
      read -p "Upgrade to latest version? [y/N]: " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        run_cmd npm install -g @aifn/factory
      fi
    fi
  else
    run_cmd npm install -g @aifn/factory
  fi

  # Configure Factory CLI
  local config_dir="$HOME/.factory"
  local config_template="$REPO_ROOT/configs/factory-cli/config.json.template"
  local mcp_template="$REPO_ROOT/configs/factory-cli/mcp.json.template"
  local config_output="$config_dir/config.json"
  local mcp_output="$config_dir/mcp.json"

  backup_file "$config_output"
  backup_file "$mcp_output"

  process_template "$config_template" "$config_output"
  process_template "$mcp_template" "$mcp_output"

  # Copy droids and skills
  if [[ -d "$REPO_ROOT/configs/factory-cli/droids" ]]; then
    log_info "Installing Factory droids..."
    run_cmd cp -r "$REPO_ROOT/configs/factory-cli/droids" "$config_dir/"
  fi

  if [[ -d "$REPO_ROOT/configs/factory-cli/skills" ]]; then
    log_info "Installing Factory skills..."
    run_cmd cp -r "$REPO_ROOT/configs/factory-cli/skills" "$config_dir/"
  fi

  log_success "Factory CLI configured"
}

install_gemini_cli() {
  log_info "Installing Gemini CLI..."

  if command -v gemini &> /dev/null; then
    log_info "Gemini CLI already installed"
    if [[ "$INTERACTIVE" == true ]]; then
      read -p "Upgrade to latest version? [y/N]: " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        run_cmd npm install -g @google/gemini-cli
      fi
    fi
  else
    run_cmd npm install -g @google/gemini-cli
  fi

  # Configure Gemini CLI
  local config_dir="$HOME/.gemini"
  local settings_template="$REPO_ROOT/configs/gemini-cli/settings.json.template"
  local settings_output="$config_dir/settings.json"

  backup_file "$settings_output"
  process_template "$settings_template" "$settings_output"

  log_success "Gemini CLI configured"
}

install_shell_configs() {
  log_info "Installing shell configurations..."

  # Backup existing configs
  backup_file "$HOME/.zshrc"
  backup_file "$HOME/.bashrc"

  if [[ -f "$REPO_ROOT/shell/.zshrc" ]]; then
    run_cmd cp "$REPO_ROOT/shell/.zshrc" "$HOME/.zshrc"
  fi

  if [[ -f "$REPO_ROOT/shell/.bashrc" ]]; then
    run_cmd cp "$REPO_ROOT/shell/.bashrc" "$HOME/.bashrc"
  fi

  log_success "Shell configurations installed"
}

################################################################################
# Main Setup
################################################################################

main() {
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}CLI Dotfiles Setup${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo

  # Load or prompt for secrets
  if [[ "$INTERACTIVE" == false ]]; then
    load_env_file
  else
    prompt_secrets_interactive
  fi

  validate_secrets

  # Parse tools to install
  IFS=',' read -ra TOOLS_ARRAY <<< "$TOOLS"

  # Install each tool
  for tool in "${TOOLS_ARRAY[@]}"; do
    case "$tool" in
      claude-code)
        if [[ "$SKIP_INSTALL" == false ]]; then
          install_claude_code
        else
          log_info "Skipping installation for claude-code"
        fi
        ;;
      factory-cli)
        if [[ "$SKIP_INSTALL" == false ]]; then
          install_factory_cli
        else
          log_info "Skipping installation for factory-cli"
        fi
        ;;
      gemini-cli)
        if [[ "$SKIP_INSTALL" == false ]]; then
          install_gemini_cli
        else
          log_info "Skipping installation for gemini-cli"
        fi
        ;;
      shell)
        install_shell_configs
        ;;
      *)
        log_warning "Unknown tool: $tool"
        ;;
    esac
  done

  echo
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}Setup Complete!${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo
  log_info "You may need to restart your shell for changes to take effect."

  if [[ "$DRY_RUN" == false ]]; then
    log_warning "Please review your configurations in:"
    echo "  - ~/.claude/settings.json"
    echo "  - ~/.factory/config.json"
    echo "  - ~/.factory/mcp.json"
    echo "  - ~/.gemini/settings.json"
  fi
}

# Run main function
main
