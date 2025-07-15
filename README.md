# Chrome MCP Claude Code Setup - Multi-Platform

Complete setup guide for Chrome MCP Server with Claude Code integration across Windows, Linux, and WSL. Quick deployment for multiple computers.

## 🚀 Quick Start

### Prerequisites
- Node.js ≥ 18.19.0
- Chrome Browser
- Claude Code installed
- Chrome MCP Extension from [releases](https://github.com/hangwin/mcp-chrome/releases)

### One-Command Install

**Linux/WSL:**
```bash
curl -sSL https://raw.githubusercontent.com/aki666888/hangwinchromemcpclaudecode/main/setup-linux.sh | bash
```

**Windows:**
```powershell
iwr -useb https://raw.githubusercontent.com/aki666888/hangwinchromemcpclaudecode/main/setup-windows.ps1 | iex
```

## 📁 Repository Structure

```
.
├── README.md                     # This file
├── .claude/
│   └── mcpSettings.json         # Claude Code MCP configuration
├── configs/
│   ├── claude-code-linux.json  # Linux config template
│   ├── claude-code-windows.json # Windows config template
│   └── claude-desktop.json      # Claude Desktop config
├── scripts/
│   ├── setup-linux.sh          # Linux automated setup
│   ├── setup-windows.ps1       # Windows automated setup
│   └── test-connection.sh      # Connection test script
└── docs/
    ├── TROUBLESHOOTING.md      # Common issues and fixes
    └── MANUAL-SETUP.md         # Step-by-step manual setup
```

## 🔧 Manual Setup

### Step 1: Install mcp-chrome-bridge

**Linux/WSL:**
```bash
npm install -g mcp-chrome-bridge
```

**Windows:**
```cmd
npm install -g mcp-chrome-bridge
```

### Step 2: Load Chrome Extension
1. Download from [GitHub releases](https://github.com/hangwin/mcp-chrome/releases)
2. Open Chrome → `chrome://extensions/`
3. Enable "Developer mode"
4. Click "Load unpacked" → Select extension folder
5. Copy the Extension ID (e.g., `hbdgbgagpkpjffpklnamcljpakneikee`)

### Step 3: Register Extension
```bash
mcp-chrome-bridge register
# Enter your Extension ID when prompted
```

### Step 4: Configure Claude Code

**Option 1: Using mcpSettings.json (Recommended)**

Create `.claude/mcpSettings.json` in your project:

```json
{
  "chrome-mcp": {
    "command": "node",
    "args": ["PATH_TO_MCP_SERVER_STDIO"]
  }
}
```

**Option 2: Using HTTP endpoint**

```json
{
  "chrome-mcp-server": {
    "type": "streamableHttp",
    "url": "http://127.0.0.1:12306/mcp"
  }
}
```

### Step 5: Connect and Test
1. Start Chrome and click extension → "Connect"
2. Should show "Connected" status on port 12306
3. In Claude Code: `/mcp` to verify connection

## 🐧 Linux/WSL Specific Configuration

### Find mcp-chrome-bridge path:
```bash
which mcp-chrome-bridge
# Usually: /home/USERNAME/.nvm/versions/node/vXX.X.X/bin/mcp-chrome-bridge
```

### Find server script:
```bash
find ~/.nvm -name "mcp-server-stdio.js" 2>/dev/null
```

### Linux mcpSettings.json template:
```json
{
  "chrome-mcp": {
    "command": "node",
    "args": ["/home/USERNAME/.nvm/versions/node/vXX.X.X/lib/node_modules/mcp-chrome-bridge/dist/mcp/mcp-server-stdio.js"]
  }
}
```

## 🪟 Windows Specific Configuration

### Windows mcpSettings.json template:
```json
{
  "chrome-mcp": {
    "command": "node",
    "args": ["C:\\Users\\USERNAME\\AppData\\Roaming\\npm\\node_modules\\mcp-chrome-bridge\\dist\\mcp\\mcp-server-stdio.js"]
  }
}
```

## 🛠️ Available Tools

### Browser Control
- `chrome_navigate` - Navigate to URLs, refresh pages
- `chrome_screenshot` - Capture screenshots
- `chrome_go_back_or_forward` - Navigate history
- `get_windows_and_tabs` - List all windows/tabs

### Web Interaction
- `chrome_click_element` - Click buttons, links
- `chrome_fill_or_select` - Fill forms
- `chrome_get_web_content` - Extract page content
- `chrome_get_interactive_elements` - Find clickable elements

### Advanced Features
- `chrome_network_request` - Make HTTP requests
- `chrome_network_debugger_start/stop` - Monitor network
- `chrome_bookmark_search/add/delete` - Manage bookmarks
- `search_tabs_content` - Search across all tabs
- `chrome_history` - Search browsing history
- `chrome_console` - Capture console output

## 📝 Example Usage

```
"Take a screenshot of the current page"
"Navigate to github.com and search for chrome-mcp"
"Click the login button"
"Fill the email field with test@example.com"
"Search for 'AI tools' across all my open tabs"
"Monitor network requests when I submit this form"
```

## 🐛 Troubleshooting

### Chrome Extension Shows "Disconnected"
1. Verify extension ID matches registered one
2. Check native messaging host: `~/.config/google-chrome/NativeMessagingHosts/`
3. Restart Chrome completely

### Claude Code "Failed to connect"
1. Check if extension shows "Connected" on port 12306
2. Verify mcpSettings.json path is correct
3. Try HTTP endpoint method instead of stdio

### Port 12306 Already in Use
```bash
# Linux/WSL
lsof -i :12306
kill -9 <PID>

# Windows
netstat -ano | findstr :12306
taskkill /F /PID <PID>
```

## 🔄 Quick Deployment to Multiple Computers

1. Clone this repository:
```bash
git clone https://github.com/aki666888/hangwinchromemcpclaudecode.git
cd hangwinchromemcpclaudecode
```

2. Run platform-specific setup:
```bash
# Linux/WSL
./scripts/setup-linux.sh

# Windows
./scripts/setup-windows.ps1
```

3. The script will:
   - Install mcp-chrome-bridge
   - Configure native messaging
   - Set up Claude Code configuration
   - Test the connection

## 🔐 Security Notes
- All communication is local (127.0.0.1)
- No external servers involved
- Extension requires explicit user permission
- Uses existing browser sessions/cookies

## 📚 Additional Resources
- [Chrome MCP Extension](https://github.com/hangwin/mcp-chrome)
- [MCP Protocol Docs](https://modelcontextprotocol.io/)
- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)

## 🤝 Contributing
Feel free to submit issues and pull requests!

## 📄 License
MIT License - See LICENSE file