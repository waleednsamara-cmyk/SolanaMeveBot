#!/bin/bash
set -e

echo "🔄 Updating Solana MEV Bot"
echo "=========================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Stopping bot...${NC}"
pm2 stop mev-bot

echo -e "${YELLOW}Pulling latest changes...${NC}"
git pull origin main || git pull origin master || echo "No git repository found, skipping pull"

echo -e "${YELLOW}Installing/updating dependencies...${NC}"
npm install

echo -e "${YELLOW}Restarting bot...${NC}"
pm2 restart mev-bot

echo -e "${GREEN}✅ Bot updated and restarted!${NC}"
echo ""
echo "View logs:"
pm2 logs mev-bot --lines 50
