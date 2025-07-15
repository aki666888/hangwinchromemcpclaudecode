# Chrome MCP Troubleshooting Guide

## Common Issues and Solutions

### 🔴 Extension Shows "NATIVE_DISCONNECTED"

**Cause:** Chrome extension cannot communicate with the native messaging host.

**Solutions:**
1. **Verify Node.js Installation**
   ```bash
   node -v  # Should be >= 18.19.0
   npm -v   # Should be installed
   ```

2. **Check mcp-chrome-bridge Installation**
   ```bash
   npm list -g mcp-chrome-bridge
   ```

3. **Re-register Extension**
   ```bash
   mcp-chrome-bridge register
   # Enter your extension ID
   ```

4. **Verify Native Messaging Host**
   - Linux: Check `~/.config/google-chrome/NativeMessagingHosts/com.chromemcp.nativehost.json`
   - Windows: Check registry `HKEY_CURRENT_USER\Software\Google\Chrome\NativeMessagingHosts\com.chromemcp.nativehost`

### 🔴 Claude Code: "Failed to connect to chrome-mcp-server"

**Cause:** MCP server configuration is incorrect or server isn't running.

**Solutions:**
1. **Check Extension Status**
   - Click Chrome MCP extension icon
   - Should show "Connected" and port 12306

2. **Verify mcpSettings.json Path**
   ```bash
   # Linux
   cat ~/.claude/mcpSettings.json
   
   # Check if path exists
   ls -la /path/from/mcpSettings.json
   ```

3. **Try HTTP Endpoint Instead**
   ```json
   {
     "chrome-mcp-server": {
       "type": "streamableHttp",
       "url": "http://127.0.0.1:12306/mcp"
     }
   }
   ```

### 🔴 Port 12306 Already in Use

**Symptoms:** Extension fails to connect, shows error about port.

**Solutions:**
1. **Find Process Using Port**
   ```bash
   # Linux
   lsof -i :12306
   
   # Windows
   netstat -ano | findstr :12306
   ```

2. **Kill Process**
   ```bash
   # Linux
   kill -9 <PID>
   
   # Windows
   taskkill /F /PID <PID>
   ```

### 🔴 WSL-Specific Issues

**Problem:** Chrome on Windows cannot access WSL paths.

**Solutions:**
1. **Install Everything on Windows Side**
   - Use Windows Command Prompt/PowerShell
   - Install Node.js for Windows (not WSL)
   - Run `npm install -g mcp-chrome-bridge` in Windows

2. **Use Windows Paths in Configuration**
   ```json
   {
     "chrome-mcp": {
       "command": "node",
       "args": ["C:\\Users\\USERNAME\\AppData\\Roaming\\npm\\node_modules\\mcp-chrome-bridge\\dist\\mcp\\mcp-server-stdio.js"]
     }
   }
   ```

### 🔴 "Cannot find module" Error

**Cause:** Path to mcp-server-stdio.js is incorrect.

**Solutions:**
1. **Find Correct Path**
   ```bash
   # Linux
   find ~/.nvm -name "mcp-server-stdio.js" 2>/dev/null
   find /usr -name "mcp-server-stdio.js" 2>/dev/null
   
   # Windows
   dir C:\Users\%USERNAME%\AppData\Roaming\npm\node_modules\mcp-chrome-bridge\dist\mcp\*.js
   ```

2. **Update Configuration**
   Use the exact path found above in mcpSettings.json

### 🔴 Extension Not Loading

**Symptoms:** Extension doesn't appear in Chrome or shows errors.

**Solutions:**
1. **Enable Developer Mode**
   - Chrome → chrome://extensions/
   - Toggle "Developer mode" ON

2. **Check Extension Files**
   - Ensure manifest.json exists
   - No missing files from download

3. **Chrome Version**
   - Update Chrome to latest version
   - Some features require Chrome 88+

### 🔴 No Response from Claude Code

**Symptoms:** /mcp command doesn't show chrome-mcp tools.

**Solutions:**
1. **Check Project Configuration**
   ```bash
   ls -la .claude/mcpSettings.json
   cat .claude/mcpSettings.json
   ```

2. **Global Configuration**
   ```bash
   cat ~/.claude/mcpSettings.json
   ```

3. **Restart Claude Code**
   - Close all Claude Code instances
   - Restart from terminal

## Diagnostic Commands

### Check Everything at Once
```bash
# Linux diagnostic script
echo "Node version:" && node -v
echo "NPM version:" && npm -v
echo "MCP Bridge:" && npm list -g mcp-chrome-bridge
echo "Native host:" && ls -la ~/.config/google-chrome/NativeMessagingHosts/
echo "Claude config:" && cat ~/.claude/mcpSettings.json
echo "Port 12306:" && lsof -i :12306
```

### Windows PowerShell Diagnostic
```powershell
Write-Host "Node version:" (node -v)
Write-Host "NPM version:" (npm -v)
Write-Host "MCP Bridge:" (npm list -g mcp-chrome-bridge)
Write-Host "Claude config:" (Get-Content $env:USERPROFILE\.claude\mcpSettings.json)
Write-Host "Port 12306:" (netstat -ano | findstr :12306)
```

## Still Having Issues?

1. **Enable Debug Mode**
   ```bash
   claude --debug
   ```

2. **Check Logs**
   - Linux: `~/.cache/claude-cli-nodejs/`
   - Windows: `%APPDATA%\claude-cli-nodejs\`

3. **Report Issue**
   - Include diagnostic output
   - Chrome version
   - OS version
   - Extension ID
   - Error messages

## Quick Fixes Checklist

- [ ] Chrome extension shows "Connected"
- [ ] Port 12306 is free
- [ ] Node.js >= 18.19.0 installed
- [ ] mcp-chrome-bridge installed globally
- [ ] Extension ID registered correctly
- [ ] mcpSettings.json has correct paths
- [ ] Restarted Chrome and Claude Code
- [ ] Using correct platform (Windows/Linux)