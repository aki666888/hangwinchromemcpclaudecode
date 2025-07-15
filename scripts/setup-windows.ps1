# Chrome MCP Setup Script for Windows
# github.com/aki666888/hangwinchromemcpclaudecode

Write-Host "🚀 Chrome MCP Setup for Windows" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# Check Node.js
Write-Host "`nChecking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node -v
    Write-Host "✓ Node.js $nodeVersion found" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found! Please install Node.js >= 18.19.0" -ForegroundColor Red
    Write-Host "Download from: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Install mcp-chrome-bridge
Write-Host "`nInstalling mcp-chrome-bridge..." -ForegroundColor Yellow
npm install -g mcp-chrome-bridge

# Find installation path
$mcpPath = "$env:APPDATA\npm\node_modules\mcp-chrome-bridge\dist\mcp\mcp-server-stdio.js"
if (-not (Test-Path $mcpPath)) {
    Write-Host "❌ Could not find mcp-server-stdio.js at expected location" -ForegroundColor Red
    Write-Host "Expected path: $mcpPath" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Found MCP server at: $mcpPath" -ForegroundColor Green

# Create Claude Code configuration directory
Write-Host "`nCreating Claude Code configuration..." -ForegroundColor Yellow
$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
}

# Check if mcpSettings.json exists
$mcpSettingsPath = "$claudeDir\mcpSettings.json"
if (Test-Path $mcpSettingsPath) {
    Write-Host "⚠️  mcpSettings.json already exists. Creating backup..." -ForegroundColor Yellow
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Copy-Item $mcpSettingsPath "$mcpSettingsPath.backup.$timestamp"
}

# Create mcpSettings.json
$mcpSettings = @{
    "chrome-mcp" = @{
        "command" = "node"
        "args" = @($mcpPath.Replace('\', '\\'))
    }
}

$mcpSettings | ConvertTo-Json -Depth 10 | Set-Content $mcpSettingsPath
Write-Host "✓ Created $mcpSettingsPath" -ForegroundColor Green

# Register Chrome extension
Write-Host "`nChrome Extension Setup" -ForegroundColor Yellow
Write-Host "1. Download extension from: https://github.com/hangwin/mcp-chrome/releases"
Write-Host "2. Load unpacked in Chrome (chrome://extensions/)"
Write-Host "3. Copy the Extension ID"
Write-Host ""
$extensionId = Read-Host "Enter Chrome Extension ID (or press Enter to skip)"

if ($extensionId) {
    Write-Host "`nRegistering extension..." -ForegroundColor Yellow
    $extensionId | mcp-chrome-bridge register
    Write-Host "✓ Extension registered" -ForegroundColor Green
}

# Create project-specific configuration
Write-Host "`nCreating project configuration..." -ForegroundColor Yellow
$projectClaudeDir = ".\.claude"
if (-not (Test-Path $projectClaudeDir)) {
    New-Item -ItemType Directory -Path $projectClaudeDir -Force | Out-Null
}

$mcpSettings | ConvertTo-Json -Depth 10 | Set-Content "$projectClaudeDir\mcpSettings.json"
Write-Host "✓ Created .claude\mcpSettings.json in current directory" -ForegroundColor Green

# Create Claude Desktop config (if applicable)
Write-Host "`nCreating Claude Desktop configuration..." -ForegroundColor Yellow
$claudeDesktopDir = "$env:APPDATA\Claude"
if (-not (Test-Path $claudeDesktopDir)) {
    New-Item -ItemType Directory -Path $claudeDesktopDir -Force | Out-Null
}

$claudeDesktopConfig = @{
    "mcpServers" = @{
        "chrome-mcp-server" = @{
            "command" = "node"
            "args" = @($mcpPath.Replace('\', '\\'))
        }
    }
}

$claudeDesktopConfig | ConvertTo-Json -Depth 10 | Set-Content "$claudeDesktopDir\claude_desktop_config.json"
Write-Host "✓ Created Claude Desktop config" -ForegroundColor Green

# Test connection
Write-Host "`nSetup complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Start Chrome and click the MCP extension"
Write-Host "2. Click 'Connect' - should show port 12306"
Write-Host "3. In Claude Code, type: /mcp"
Write-Host ""
Write-Host "For Claude Desktop: Restart the application" -ForegroundColor Yellow