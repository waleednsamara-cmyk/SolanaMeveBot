#!/bin/bash
set -e

echo "🚀 Solana MEV Bot - VPS Setup Script"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo -e "${RED}Please run as root: sudo bash vps-setup.sh${NC}"
   exit 1
fi

echo -e "${YELLOW}Step 1/6: Updating system packages...${NC}"
apt-get update
apt-get upgrade -y

echo -e "${GREEN}✓ System updated${NC}"
echo ""

echo -e "${YELLOW}Step 2/6: Installing Node.js 20.x...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

echo -e "${GREEN}✓ Node.js installed: $(node --version)${NC}"
echo -e "${GREEN}✓ NPM installed: $(npm --version)${NC}"
echo ""

echo -e "${YELLOW}Step 3/6: Installing PM2 (Process Manager)...${NC}"
npm install -g pm2

echo -e "${GREEN}✓ PM2 installed${NC}"
echo ""

echo -e "${YELLOW}Step 4/6: Installing Git...${NC}"
apt-get install -y git

echo -e "${GREEN}✓ Git installed${NC}"
echo ""

echo -e "${YELLOW}Step 5/6: Setting up firewall...${NC}"
ufw allow 22/tcp  # SSH
ufw allow 5000/tcp  # Frontend (optional)
ufw --force enable

echo -e "${GREEN}✓ Firewall configured${NC}"
echo ""

echo -e "${YELLOW}Step 6/6: Creating bot user...${NC}"
if id "mevbot" &>/dev/null; then
    echo "User 'mevbot' already exists"
else
    useradd -m -s /bin/bash mevbot
    echo -e "${GREEN}✓ User 'mevbot' created${NC}"
fi
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ VPS Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Move bot files to: /home/mevbot/solana-mev-bot"
echo "   Example: sudo mv /tmp/solana-mev-bot /home/mevbot/"
echo "2. Set ownership: sudo chown -R mevbot:mevbot /home/mevbot/solana-mev-bot"
echo "3. Switch to mevbot user: sudo su - mevbot"
echo "4. Go to bot directory: cd ~/solana-mev-bot"
echo "5. Run deployment: bash deploy-bot.sh"
echo ""
