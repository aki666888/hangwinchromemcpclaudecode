# WSL Claude Code + Windows Chrome Setup Guide

## Architecture
```
Claude Code (WSL) → HTTP (localhost:12306) → Chrome MCP (Windows)
```

## Windows Setup (PowerShell Admin)

```powershell
# 1. Install Node.js from https://nodejs.org/ on Windows (NOT WSL)

# 2. Install Chrome MCP Bridge
npm install -g mcp-chrome-bridge

# 3. Download Chrome extension from:
# https://github.com/hangwin/mcp-chrome/releases
# Load unpacked in chrome://extensions/
# Copy the Extension ID

# 4. Register extension
mcp-chrome-bridge register
# Enter Extension ID when prompted

# 5. Allow WSL access (if needed)
New-NetFirewallRule -DisplayName "Chrome MCP WSL" -Direction Inbound -LocalPort 12306 -Protocol TCP -Action Allow
```

## WSL Setup (WSL Terminal)

```bash
# Create config directory
mkdir -p ~/.claude

# Create mcpSettings.json
cat > ~/.claude/mcpSettings.json << 'EOF'
{
  "chrome-mcp": {
    "type": "streamableHttp",
    "url": "http://localhost:12306/mcp"
  }
}
EOF

# Test connection
curl http://localhost:12306/health || echo "Not connected yet"
```

## Connect & Test

1. Open Chrome on Windows
2. Click Chrome MCP extension → "Connect" (shows port 12306)
3. In WSL Claude Code: type `/mcp` to see tools

## Quick Fixes

### "NATIVE_DISCONNECTED" Error
```powershell
# Windows PowerShell
npm uninstall -g mcp-chrome-bridge
npm install -g mcp-chrome-bridge
mcp-chrome-bridge register
```

### Cannot connect from WSL
1. Check Windows Firewall
2. Ensure Chrome extension shows "Connected"
3. Restart Chrome and reconnect extension

## Files Created

- Windows: `%APPDATA%\npm\node_modules\mcp-chrome-bridge\`
- WSL: `~/.claude/mcpSettings.json`

## Important Notes

- ✅ Use HTTP endpoint in WSL (not stdio)
- ✅ Install everything on Windows side
- ✅ Keep Chrome extension connected
- ❌ Don't install mcp-chrome-bridge in WSL