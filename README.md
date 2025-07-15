# Chrome MCP for WSL Claude Code + Windows Chrome

Quick setup for using Claude Code in WSL to control Chrome on Windows.

## Prerequisites
- Windows with WSL installed
- Chrome on Windows
- Claude Code in WSL
- Node.js on Windows (NOT WSL) - https://nodejs.org/

## Quick Setup (Copy-Paste Commands)

### 1. Windows Setup (PowerShell as Admin)
```powershell
# Install Chrome MCP Bridge
npm install -g mcp-chrome-bridge

# Download and load Chrome extension from:
# https://github.com/hangwin/mcp-chrome/releases
# Then get Extension ID from chrome://extensions/

# Register extension (replace YOUR_EXTENSION_ID)
mcp-chrome-bridge register
# Paste YOUR_EXTENSION_ID when prompted
```

### 2. WSL Setup (WSL Terminal)
```bash
# Create Claude Code config
mkdir -p ~/.claude
cat > ~/.claude/mcpSettings.json << 'EOF'
{
  "chrome-mcp": {
    "type": "streamableHttp",
    "url": "http://localhost:12306/mcp"
  }
}
EOF

# Test connection
curl http://localhost:12306/health
```

### 3. Connect
1. Open Chrome on Windows
2. Click Chrome MCP extension → "Connect"
3. Should show "Connected" on port 12306
4. In WSL Claude Code: type `/mcp`

## Configuration File

Save this as `~/.claude/mcpSettings.json` in WSL:
```json
{
  "chrome-mcp": {
    "type": "streamableHttp",
    "url": "http://localhost:12306/mcp"
  }
}
```

## Troubleshooting

### Extension shows "NATIVE_DISCONNECTED"
```powershell
# Windows PowerShell - Reinstall
npm uninstall -g mcp-chrome-bridge
npm install -g mcp-chrome-bridge
mcp-chrome-bridge register
```

### Can't connect from WSL
```powershell
# Windows PowerShell Admin - Allow WSL access
New-NetFirewallRule -DisplayName "Chrome MCP WSL" -Direction Inbound -LocalPort 12306 -Protocol TCP -Action Allow
```

### Test Commands
```bash
# WSL - Test connection
curl http://localhost:12306/health

# WSL - Test MCP
curl -X POST http://localhost:12306/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"0.1.0"},"id":1}'
```

## For Multiple Computers

1. Save your Extension ID: `YOUR_EXTENSION_ID_HERE`
2. Copy this README to new computer
3. Run Windows commands in PowerShell
4. Run WSL commands in WSL terminal
5. Replace Extension ID where needed

That's it! Keep Chrome extension connected when using Claude Code.