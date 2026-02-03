# Secret Management Guide

How to securely manage API keys and secrets in CLI Dotfiles.

## Overview

This repository uses a template-based approach to keep secrets out of version control while still maintaining portable configurations.

## 🔒 Security Principles

1. **Never commit secrets** - `.env` files are gitignored
2. **Use templates** - Config files use `${VARIABLE}` placeholders
3. **Secure storage** - Secrets are stored in user home directories with proper permissions
4. **Minimal exposure** - Secrets are never logged or echoed during setup

## 📁 File Structure

### Files in Repository (Safe to Commit)

```
configs/
├── claude-code/
│   └── settings.json.template     # Contains ${ANTHROPIC_API_KEY}
├── factory-cli/
│   ├── config.json.template       # Contains ${ZAI_API_KEY}
│   └── mcp.json.template          # Contains various ${API_KEY}s
└── gemini-cli/
    └── settings.json.template     # No secrets (UI config only)

scripts/
└── templates/
    └── .env.example               # Example with placeholder values
```

### Files on Your System (Never Commit)

```
~/.claude/settings.json            # Contains actual API keys
~/.factory/config.json             # Contains actual API keys
~/.factory/mcp.json                # Contains actual API keys
~/.gemini/settings.json            # May contain OAuth tokens
.env                               # Your actual secrets (gitignored)
```

## 🔑 Required Secrets

| Variable | Purpose | Where to Get |
|----------|---------|--------------|
| `ANTHROPIC_API_KEY` | Claude Code authentication | https://console.anthropic.com/ |
| `ZAI_API_KEY` | Factory CLI & MCP servers | Your Z.AI account dashboard |

## 🎯 Optional Secrets

| Variable | Purpose | Where to Get |
|----------|---------|--------------|
| `CONTEXT7_API_KEY` | Documentation MCP server | https://context7.com/ |
| `GITHUB_TOKEN` | GitHub MCP server | https://github.com/settings/tokens |
| `GOOGLE_OAUTH_CREDENTIALS` | Gemini CLI OAuth | Google Cloud Console |

## 📝 Setup Methods

### Method 1: Interactive Mode (Default)

```bash
./scripts/setup.sh --interactive
```

**How it works:**
1. Script prompts for each required secret
2. Secrets are stored as environment variables for the session
3. Template files are processed with these variables
4. Secrets are written to config files in your home directory
5. Environment variables are cleared when script exits

**Pros:**
- No files to manage
- Secrets only live for the duration of setup

**Cons:**
- Must re-enter secrets on each setup run
- Not suitable for automation

### Method 2: Environment File

```bash
./scripts/setup.sh --env-file path/to/.env
```

**How it works:**
1. Script reads `.env` file
2. Variables are exported to the script's environment
3. Template files are processed
4. Secrets are written to config files

**Pros:**
- Can reuse same `.env` file across machines
- Suitable for automation
- Enter secrets once, use many times

**Cons:**
- Must protect `.env` file (never commit it)
- File permissions must be set correctly

### Method 3: Environment Variables (Existing)

If you already have secrets in your environment:

```bash
export ANTHROPIC_API_KEY="sk-ant-xxxxx"
export ZAI_API_KEY="your-key"
./scripts/setup.sh
```

**Pros:**
- Works with existing secret management systems
- No additional files needed

**Cons:**
- Secrets visible in process list while running
- Must set variables before each run

## 🛡️ Best Practices

### 1. File Permissions

Ensure your `.env` file has restricted permissions:

```bash
chmod 600 scripts/templates/.env
```

This ensures only you can read and write the file.

### 2. Multiple Machines

Use separate API keys for different machines when possible:

```bash
# Laptop
ANTHROPIC_API_KEY=sk-ant-laptop-xxxxx

# Desktop
ANTHROPIC_API_KEY=sk-ant-desktop-xxxxx

# Server
ANTHROPIC_API_KEY=sk-ant-server-xxxxx
```

This allows you to:
- Revoke individual keys if a machine is compromised
- Track usage per machine
- Enforce different rate limits or quotas

### 3. Rotate Keys Regularly

Periodically rotate your API keys:

1. Generate new key from provider's console
2. Update your `.env` file
3. Run setup script to apply changes
4. Delete old key from provider's console

### 4. Use Key Scopes

When creating API keys, use the minimum required scope:

- **Claude Code**: Only needs API access, no billing/admin
- **GitHub Token**: Only needs `repo` scope, not `user` or `admin`
- **MCP Servers**: Use separate keys for each server when possible

### 5. Audit Access

Regularly check which machines have access to your keys:

```bash
# List Claude Code usage
# (Check Anthropic console for usage logs)

# List GitHub token usage
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/rate_limit
```

## 🔍 How Template Processing Works

The setup script uses Bash's built-in variable expansion:

```bash
# Template file (settings.json.template)
{
  "apiKey": "${ANTHROPIC_API_KEY}"
}

# Processing
eval "echo \"$line\""  # Expands ${ANTHROPIC_API_KEY}

# Output (settings.json)
{
  "apiKey": "sk-ant-xxxxx"
}
```

**Security note:** The script uses `eval` only on template lines, not on user input.

## 🚫 What Gets Gitignored

The `.gitignore` file excludes:

```
# Environment files
.env
*.env
.env.*

# Local configs (may contain secrets)
configs/*/*.json
configs/*/*.yml
configs/*/*.yaml

# Backup files
*.backup.*
*~

# OS files
.DS_Store
Thumbs.db
```

Only `.template` files are committed to the repository.

## 🧪 Testing Secret Handling

To test secret handling without exposing real keys:

```bash
# Create a test .env file with fake keys
cat > test.env << EOF
ANTHROPIC_API_KEY=test-key-12345
ZAI_API_KEY=test-key-67890
CONTEXT7_API_KEY=test-key-context7
GITHUB_TOKEN=ghp_test-token
EOF

# Run in dry-run mode
./scripts/setup.sh --env-file test.env --dry-run

# Clean up
rm test.env
```

## 🔄 Updating Secrets

To change your secrets:

1. Update your `.env` file:
```bash
nano scripts/templates/.env
```

2. Re-run setup:
```bash
./scripts/setup.sh --env-file scripts/templates/.env
```

3. The old config files will be backed up with timestamps before being replaced.

## 🚨 Emergency Key Revocation

If a key is compromised:

1. **Immediately revoke** the key from the provider's console
2. **Generate new key** from the provider's console
3. **Update your `.env` file** with the new key
4. **Re-run setup** to apply changes
5. **Rotate keys on all other machines** that used the compromised key

## 📚 Provider-Specific Resources

### Anthropic (Claude)

- Console: https://console.anthropic.com/
- API Key Management: https://console.anthropic.com/settings/keys
- Rate Limits: https://docs.anthropic.com/claude/reference/rate-limits

### Z.AI

- Dashboard: Check your account dashboard
- API Docs: Provided by Z.AI

### Context7

- Website: https://context7.com/
- API Key: Sign up and get key from dashboard

### GitHub

- Token Settings: https://github.com/settings/tokens
- Scopes: Use `repo` scope for MCP server access

## 🆘 Troubleshooting

### "Missing required secrets" Error

**Cause:** Required environment variables not set.

**Solution:**
```bash
# Check what's set
env | grep API_KEY

# Either provide --env-file or use --interactive
./scripts/setup.sh --interactive
```

### Secrets Not Working in Tools

**Cause:** Template not processed correctly.

**Solution:**
```bash
# Check the actual config file
cat ~/.claude/settings.json | grep apiKey

# If you see ${ANTHROPIC_API_KEY} instead of actual key,
# the template wasn't processed. Re-run setup.
```

### Accidental Commit of Secrets

**Cause:** `.env` file or actual config was committed.

**Solution:**
```bash
# 1. Revoke the compromised keys immediately
# 2. Remove from git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" --prune-empty --tag-name-filter cat -- --all

# 3. Force push (careful!)
git push origin --force --all

# 4. Rotate all secrets
```

## 🔗 Related Documentation

- [Installation Guide](./INSTALLATION.md) - General setup instructions
- [Tools Documentation](./TOOLS.md) - Tool-specific configuration
- [Main README](../README.md) - Project overview
