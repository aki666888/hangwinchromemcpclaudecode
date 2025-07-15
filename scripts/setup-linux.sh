#!/bin/bash

# Chrome MCP Setup Script for Linux/WSL
# github.com/aki666888/hangwinchromemcpclaudecode

set -e

echo "🚀 Chrome MCP Setup for Linux/WSL"
echo "================================"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Node.js
echo -e "\n${YELLOW}Checking Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found! Please install Node.js >= 18.19.0${NC}"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2)
echo -e "${GREEN}✓ Node.js v${NODE_VERSION} found${NC}"

# Install mcp-chrome-bridge
echo -e "\n${YELLOW}Installing mcp-chrome-bridge...${NC}"
npm install -g mcp-chrome-bridge

# Find installation path
MCP_PATH=$(find ~/.nvm -name "mcp-server-stdio.js" -path "*/mcp-chrome-bridge/*" 2>/dev/null | head -1)
if [ -z "$MCP_PATH" ]; then
    MCP_PATH=$(find /usr -name "mcp-server-stdio.js" -path "*/mcp-chrome-bridge/*" 2>/dev/null | head -1)
fi

if [ -z "$MCP_PATH" ]; then
    echo -e "${RED}❌ Could not find mcp-server-stdio.js${NC}"
    echo "Please check npm installation path"
    exit 1
fi

echo -e "${GREEN}✓ Found MCP server at: $MCP_PATH${NC}"

# Create Claude Code configuration directory
echo -e "\n${YELLOW}Creating Claude Code configuration...${NC}"
mkdir -p ~/.claude

# Check if mcpSettings.json exists
if [ -f ~/.claude/mcpSettings.json ]; then
    echo -e "${YELLOW}⚠️  mcpSettings.json already exists. Creating backup...${NC}"
    cp ~/.claude/mcpSettings.json ~/.claude/mcpSettings.json.backup.$(date +%Y%m%d_%H%M%S)
fi

# Create mcpSettings.json
cat > ~/.claude/mcpSettings.json << EOF
{
  "chrome-mcp": {
    "command": "node",
    "args": ["$MCP_PATH"]
  }
}
EOF

echo -e "${GREEN}✓ Created ~/.claude/mcpSettings.json${NC}"

# Register Chrome extension
echo -e "\n${YELLOW}Chrome Extension Setup${NC}"
echo "1. Download extension from: https://github.com/hangwin/mcp-chrome/releases"
echo "2. Load unpacked in Chrome (chrome://extensions/)"
echo "3. Copy the Extension ID"
echo ""
read -p "Enter Chrome Extension ID (or press Enter to skip): " EXTENSION_ID

if [ ! -z "$EXTENSION_ID" ]; then
    echo -e "\n${YELLOW}Registering extension...${NC}"
    echo "$EXTENSION_ID" | mcp-chrome-bridge register
    echo -e "${GREEN}✓ Extension registered${NC}"
fi

# Create project-specific configuration
echo -e "\n${YELLOW}Creating project configuration...${NC}"
mkdir -p .claude
cat > .claude/mcpSettings.json << EOF
{
  "chrome-mcp": {
    "command": "node",
    "args": ["$MCP_PATH"]
  }
}
EOF

echo -e "${GREEN}✓ Created .claude/mcpSettings.json in current directory${NC}"

# Test connection
echo -e "\n${YELLOW}Testing setup...${NC}"
echo "1. Start Chrome and click the MCP extension"
echo "2. Click 'Connect' - should show port 12306"
echo "3. In Claude Code, type: /mcp"
echo ""
echo -e "${GREEN}✓ Setup complete!${NC}"

# Optional: Create alias for quick access
echo -e "\n${YELLOW}Optional: Add this alias to ~/.bashrc for quick access:${NC}"
echo "alias chrome-mcp='cd $(pwd) && claude'"