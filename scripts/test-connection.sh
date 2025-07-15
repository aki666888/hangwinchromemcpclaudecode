#!/bin/bash

# Chrome MCP Connection Test Script
# Tests all components of the Chrome MCP setup

echo "Chrome MCP Connection Test"
echo "========================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

# Function to check test result
check_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((TESTS_FAILED++))
    fi
}

# Test 1: Node.js
echo -n "1. Checking Node.js installation... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓ Found $NODE_VERSION${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗ Not found${NC}"
    ((TESTS_FAILED++))
fi

# Test 2: mcp-chrome-bridge
echo -n "2. Checking mcp-chrome-bridge... "
if npm list -g mcp-chrome-bridge &> /dev/null; then
    check_result 0
else
    check_result 1
fi

# Test 3: Find mcp-server-stdio.js
echo -n "3. Locating mcp-server-stdio.js... "
MCP_PATH=$(find ~/.nvm /usr/local ~/.npm -name "mcp-server-stdio.js" -path "*/mcp-chrome-bridge/*" 2>/dev/null | head -1)
if [ ! -z "$MCP_PATH" ]; then
    echo -e "${GREEN}✓ Found${NC}"
    echo "   Path: $MCP_PATH"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗ Not found${NC}"
    ((TESTS_FAILED++))
fi

# Test 4: Native messaging host
echo -n "4. Checking native messaging host... "
NATIVE_HOST_FILE="$HOME/.config/google-chrome/NativeMessagingHosts/com.chromemcp.nativehost.json"
if [ -f "$NATIVE_HOST_FILE" ]; then
    check_result 0
    echo "   Extension ID: $(grep -o 'chrome-extension://[^/]*' "$NATIVE_HOST_FILE" | cut -d'/' -f3)"
else
    check_result 1
fi

# Test 5: Claude configuration
echo -n "5. Checking Claude configuration... "
if [ -f "$HOME/.claude/mcpSettings.json" ]; then
    check_result 0
elif [ -f ".claude/mcpSettings.json" ]; then
    echo -e "${GREEN}✓ Found project config${NC}"
    ((TESTS_PASSED++))
else
    check_result 1
fi

# Test 6: Port 12306
echo -n "6. Checking port 12306... "
if lsof -i :12306 &> /dev/null; then
    echo -e "${YELLOW}⚠ Port in use${NC}"
    echo "   $(lsof -i :12306 | grep LISTEN | head -1)"
    ((TESTS_PASSED++))
else
    echo -e "${GREEN}✓ Port available${NC}"
    ((TESTS_PASSED++))
fi

# Test 7: Chrome browser
echo -n "7. Checking Chrome browser... "
if command -v google-chrome &> /dev/null; then
    CHROME_VERSION=$(google-chrome --version)
    echo -e "${GREEN}✓ $CHROME_VERSION${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗ Not found${NC}"
    ((TESTS_FAILED++))
fi

# Summary
echo ""
echo "Test Summary"
echo "------------"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"

# Recommendations
if [ $TESTS_FAILED -gt 0 ]; then
    echo ""
    echo "Recommendations:"
    echo "---------------"
    
    if ! command -v node &> /dev/null; then
        echo "• Install Node.js >= 18.19.0"
    fi
    
    if ! npm list -g mcp-chrome-bridge &> /dev/null; then
        echo "• Run: npm install -g mcp-chrome-bridge"
    fi
    
    if [ ! -f "$NATIVE_HOST_FILE" ]; then
        echo "• Run: mcp-chrome-bridge register"
        echo "  Enter your Chrome extension ID"
    fi
    
    if [ ! -f "$HOME/.claude/mcpSettings.json" ] && [ ! -f ".claude/mcpSettings.json" ]; then
        echo "• Create mcpSettings.json configuration"
        echo "  See: docs/MANUAL-SETUP.md"
    fi
fi

echo ""
echo "For detailed setup instructions, see docs/MANUAL-SETUP.md"