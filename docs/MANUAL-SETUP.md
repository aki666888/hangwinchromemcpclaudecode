# Manual Setup Guide - Chrome MCP

This guide provides detailed step-by-step instructions for manually setting up Chrome MCP with Claude Code.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Linux/WSL Setup](#linuxwsl-setup)
3. [Windows Setup](#windows-setup)
4. [Configuration Options](#configuration-options)
5. [Verification](#verification)

## Prerequisites

### Required Software
- **Node.js** >= 18.19.0
  - Download: https://nodejs.org/
  - Verify: `node -v`
- **Chrome Browser** (latest version)
- **Claude Code** installed

### Download Chrome MCP Extension
1. Go to https://github.com/hangwin/mcp-chrome/releases
2. Download the latest release ZIP
3. Extract to a folder (remember this location)

## Linux/WSL Setup

### Step 1: Install mcp-chrome-bridge
```bash
# Using npm (global installation)
npm install -g mcp-chrome-bridge

# Verify installation
npm list -g mcp-chrome-bridge
```

### Step 2: Find Installation Paths
```bash
# Find mcp-chrome-bridge executable
which mcp-chrome-bridge

# Find mcp-server-stdio.js
find ~/.nvm -name "mcp-server-stdio.js" -path "*/mcp-chrome-bridge/*" 2>/dev/null

# Alternative locations
find /usr/local -name "mcp-server-stdio.js" 2>/dev/null
find ~/.npm -name "mcp-server-stdio.js" 2>/dev/null
```

### Step 3: Load Chrome Extension
1. Open Chrome
2. Navigate to `chrome://extensions/`
3. Enable "Developer mode" (toggle in top right)
4. Click "Load unpacked"
5. Select the extracted extension folder
6. Copy the Extension ID (looks like: `hbdgbgagpkpjffpklnamcljpakneikee`)

### Step 4: Register Extension
```bash
# Run registration command
mcp-chrome-bridge register

# When prompted, paste your Extension ID
# Press Enter to confirm
```

### Step 5: Verify Native Messaging Host
```bash
# Check if registration succeeded
cat ~/.config/google-chrome/NativeMessagingHosts/com.chromemcp.nativehost.json

# Should show something like:
# {
#   "name": "com.chromemcp.nativehost",
#   "description": "Node.js Host for Browser Bridge Extension",
#   "path": "/home/USERNAME/.nvm/versions/node/vXX.X.X/lib/node_modules/mcp-chrome-bridge/dist/run_host.sh",
#   "type": "stdio",
#   "allowed_origins": ["chrome-extension://YOUR_EXTENSION_ID/"]
# }
```

### Step 6: Configure Claude Code

**Option A: Global Configuration**
```bash
# Create Claude config directory
mkdir -p ~/.claude

# Create mcpSettings.json
cat > ~/.claude/mcpSettings.json << 'EOF'
{
  "chrome-mcp": {
    "command": "node",
    "args": ["/YOUR/PATH/TO/mcp-server-stdio.js"]
  }
}
EOF

# Replace /YOUR/PATH/TO/ with actual path from Step 2
```

**Option B: Project-Specific Configuration**
```bash
# In your project directory
mkdir -p .claude

# Create mcpSettings.json
cat > .claude/mcpSettings.json << 'EOF'
{
  "chrome-mcp": {
    "command": "node",
    "args": ["/YOUR/PATH/TO/mcp-server-stdio.js"]
  }
}
EOF
```

## Windows Setup

### Step 1: Install mcp-chrome-bridge
```powershell
# Open PowerShell as Administrator
npm install -g mcp-chrome-bridge

# Verify installation
npm list -g mcp-chrome-bridge
```

### Step 2: Find Installation Path
```powershell
# Default location
$mcpPath = "$env:APPDATA\npm\node_modules\mcp-chrome-bridge\dist\mcp\mcp-server-stdio.js"

# Verify it exists
Test-Path $mcpPath
```

### Step 3: Load Chrome Extension
Same as Linux Step 3

### Step 4: Register Extension
```powershell
# Run registration
mcp-chrome-bridge register

# Enter Extension ID when prompted
```

### Step 5: Configure Claude Code
```powershell
# Create config directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force

# Create mcpSettings.json
@{
  "chrome-mcp" = @{
    "command" = "node"
    "args" = @("$env:APPDATA\npm\node_modules\mcp-chrome-bridge\dist\mcp\mcp-server-stdio.js")
  }
} | ConvertTo-Json -Depth 10 | Set-Content "$env:USERPROFILE\.claude\mcpSettings.json"
```

### Step 6: Configure Claude Desktop (Optional)
```powershell
# Create Claude Desktop config
@{
  "mcpServers" = @{
    "chrome-mcp-server" = @{
      "command" = "node"
      "args" = @("$env:APPDATA\npm\node_modules\mcp-chrome-bridge\dist\mcp\mcp-server-stdio.js")
    }
  }
} | ConvertTo-Json -Depth 10 | Set-Content "$env:APPDATA\Claude\claude_desktop_config.json"
```

## Configuration Options

### 1. STDIO Method (Recommended)
```json
{
  "chrome-mcp": {
    "command": "node",
    "args": ["/absolute/path/to/mcp-server-stdio.js"]
  }
}
```

### 2. HTTP Endpoint Method
```json
{
  "chrome-mcp-server": {
    "type": "streamableHttp",
    "url": "http://127.0.0.1:12306/mcp"
  }
}
```

### 3. NPX Method
```json
{
  "chrome-mcp": {
    "command": "npx",
    "args": ["-y", "mcp-chrome-bridge", "mcp-server"]
  }
}
```

### 4. Combined Configuration
```json
{
  "chrome-mcp": {
    "command": "node",
    "args": ["/path/to/mcp-server-stdio.js"]
  },
  "chrome-mcp-http": {
    "type": "streamableHttp",
    "url": "http://127.0.0.1:12306/mcp"
  }
}
```

## Verification

### 1. Test Chrome Extension
1. Click the Chrome MCP extension icon
2. Click "Connect"
3. Should show:
   - Status: Connected
   - Port: 12306

### 2. Test in Claude Code
```bash
# Start Claude Code
claude

# Type in chat
/mcp

# Should show chrome-mcp tools like:
# - chrome_navigate
# - chrome_screenshot
# - chrome_click_element
# etc.
```

### 3. Test Basic Command
In Claude Code:
```
Take a screenshot of the current browser tab
```

## File Locations Reference

### Linux/WSL
- Node modules: `~/.nvm/versions/node/vXX.X.X/lib/node_modules/`
- Native host: `~/.config/google-chrome/NativeMessagingHosts/`
- Claude config: `~/.claude/mcpSettings.json`
- Project config: `./.claude/mcpSettings.json`

### Windows
- Node modules: `%APPDATA%\npm\node_modules\`
- Native host: Registry `HKEY_CURRENT_USER\Software\Google\Chrome\NativeMessagingHosts\`
- Claude config: `%USERPROFILE%\.claude\mcpSettings.json`
- Claude Desktop: `%APPDATA%\Claude\claude_desktop_config.json`

## Additional Notes

### Permission Requirements
- Chrome extension needs permission to access websites
- Native messaging host needs execute permissions
- Claude Code needs file system access

### Security Considerations
- All communication is local (127.0.0.1)
- No external servers involved
- Extension uses existing browser session/cookies

### Performance Tips
- Use STDIO method for better performance
- HTTP method adds slight overhead
- Close unused browser tabs to reduce memory usage