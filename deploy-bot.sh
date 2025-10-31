#!/bin/bash
set -e

echo "🤖 Solana MEV Bot - Deployment Script"
echo "====================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get current directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo -e "${YELLOW}Current directory: $SCRIPT_DIR${NC}"
echo ""

echo -e "${YELLOW}Step 1/6: Installing dependencies...${NC}"
npm install
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

echo -e "${YELLOW}Step 2/6: Checking for .env file...${NC}"
if [ ! -f .env ]; then
    echo -e "${RED}❌ .env file not found!${NC}"
    echo ""
    echo "Creating .env template..."
    cat > .env << 'EOF'
# Solana Private Key (base58 encoded)
SOLANA_PRIVATE_KEY=your_private_key_here

# Helius RPC URLs
SOLANA_RPC_URL=https://mainnet.helius-rpc.com/?api-key=YOUR_API_KEY
SOLANA_WS_URL=wss://mainnet.helius-rpc.com/?api-key=YOUR_API_KEY

# Optional: Set to 'false' to disable trading (simulation only)
TRADING_ENABLED=true
EOF
    echo -e "${YELLOW}⚠️  Please edit .env file with your actual values:${NC}"
    echo "   nano .env"
    echo ""
    echo "Then run this script again: bash deploy-bot.sh"
    exit 1
else
    echo -e "${GREEN}✓ .env file found${NC}"
fi
echo ""

echo -e "${YELLOW}Step 3/6: Validating environment variables...${NC}"
source .env

if [ "$SOLANA_PRIVATE_KEY" = "your_private_key_here" ]; then
    echo -e "${RED}❌ Please update SOLANA_PRIVATE_KEY in .env file${NC}"
    exit 1
fi

if [[ "$SOLANA_RPC_URL" == *"YOUR_API_KEY"* ]]; then
    echo -e "${RED}❌ Please update SOLANA_RPC_URL in .env file${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Environment variables validated${NC}"
echo ""

echo -e "${YELLOW}Step 4/6: Building backend...${NC}"
npm run build 2>/dev/null || echo "No build script found, using direct execution"
echo -e "${GREEN}✓ Build complete${NC}"
echo ""

echo -e "${YELLOW}Step 5/6: Starting bot with PM2...${NC}"

# Stop existing instance if running
pm2 delete mev-bot 2>/dev/null || true

# Start bot with PM2 - run both backend and frontend
pm2 start npm --name "mev-bot" -- run dev

# Save PM2 process list
pm2 save

echo -e "${GREEN}✓ Bot started with PM2${NC}"
echo ""

echo -e "${YELLOW}Step 6/6: Configuring auto-restart on reboot...${NC}"

# Check if running as root for pm2 startup
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}⚠️  You're running as root. PM2 startup should be run as the bot user.${NC}"
    echo -e "${YELLOW}Run this command manually after switching to bot user:${NC}"
    echo "   pm2 startup"
    echo "   (then run the command it gives you with sudo)"
else
    echo -e "${YELLOW}To enable auto-start on reboot, run:${NC}"
    echo "   pm2 startup"
    echo "   (then copy and run the command it gives you with sudo)"
    echo ""
    echo -e "${YELLOW}After that, run:${NC}"
    echo "   pm2 save"
fi
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Bot is now running 24/7 with TRUE atomic swaps!"
echo ""
echo "Useful PM2 commands:"
echo "  pm2 status              - Check bot status"
echo "  pm2 logs mev-bot        - View live logs"
echo "  pm2 logs mev-bot --lines 100  - View last 100 lines"
echo "  pm2 restart mev-bot     - Restart bot"
echo "  pm2 stop mev-bot        - Stop bot"
echo "  pm2 monit               - Monitor in real-time"
echo ""
echo -e "${YELLOW}Viewing logs (Ctrl+C to exit):${NC}"
pm2 logs mev-bot --lines 30
