# VPS Deployment Guide - Solana MEV Bot

Deploy your MEV bot to a VPS in **5 minutes** with true atomic swap capability via Jupiter V6!

---

## 📋 Prerequisites

1. **VPS Account** - Choose one:
   - [DigitalOcean](https://www.digitalocean.com/) - $6/month (Recommended)
   - [Vultr](https://www.vultr.com/) - $6/month
   - [AWS Lightsail](https://aws.amazon.com/lightsail/) - $5/month
   
2. **Your Secrets Ready**:
   - Solana private key (from Replit Secrets)
   - Helius RPC URL
   - Helius WebSocket URL

---

## 🚀 Quick Deployment (5 Minutes)

### Step 1: Create VPS

1. Sign up at your chosen provider
2. Create a new server/droplet:
   - **OS**: Ubuntu 22.04 LTS
   - **Plan**: Basic $6/month (1GB RAM, 1 CPU)
   - **Location**: Choose closest to you or East Coast USA (closer to Solana validators)
3. Note your **IP address** and **root password**

### Step 2: Connect to VPS

**On Windows (PowerShell):**
```powershell
ssh root@YOUR_VPS_IP
```

**On Mac/Linux (Terminal):**
```bash
ssh root@YOUR_VPS_IP
```

Enter the password when prompted.

### Step 3: Upload Bot Files

**Option A: Using SCP (from your computer)**
```powershell
# On Windows PowerShell (from your Downloads folder)
scp -r "solanaMevBot (1)\SolanaMevBot" root@YOUR_VPS_IP:/tmp/
```

**Option B: Using Git (if you have a GitHub repo)**
```bash
# On the VPS
git clone https://github.com/YOUR_USERNAME/solana-mev-bot.git /tmp/solana-mev-bot
```

### Step 4: Run VPS Setup

```bash
# On the VPS
cd /tmp/solana-mev-bot
sudo bash vps-setup.sh
```

This will install:
- Node.js 20.x
- PM2 (process manager)
- Git
- Firewall configuration
- Create 'mevbot' user with home directory

**Then move bot files to mevbot's home:**
```bash
# Move bot directory to /home/mevbot/
sudo mv /tmp/solana-mev-bot /home/mevbot/

# Set correct ownership
sudo chown -R mevbot:mevbot /home/mevbot/solana-mev-bot
```

### Step 5: Configure Environment Variables

```bash
# Switch to bot user
sudo su - mevbot
cd ~/solana-mev-bot

# Create .env file
nano .env
```

Paste your secrets:
```env
SOLANA_PRIVATE_KEY=your_base58_private_key
SOLANA_RPC_URL=https://mainnet.helius-rpc.com/?api-key=YOUR_KEY
SOLANA_WS_URL=wss://mainnet.helius-rpc.com/?api-key=YOUR_KEY
TRADING_ENABLED=true
```

**Save:** `Ctrl + X`, then `Y`, then `Enter`

### Step 6: Deploy Bot

```bash
# Deploy and start bot (as mevbot user)
bash deploy-bot.sh
```

**After deployment, enable auto-start on reboot:**
```bash
# Run this command and copy the output
pm2 startup

# Run the command it gives you (will look like):
# sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u mevbot --hp /home/mevbot

# Then save the PM2 process list
pm2 save
```

**That's it!** 🎉 Your bot is now running 24/7 with **TRUE atomic swaps**!

---

## 📊 Managing Your Bot

### View Live Logs
```bash
pm2 logs mev-bot
```

### Check Status
```bash
pm2 status
```

### Monitor Real-Time
```bash
pm2 monit
```

### Restart Bot
```bash
pm2 restart mev-bot
```

### Stop Bot
```bash
pm2 stop mev-bot
```

### View Last 100 Log Lines
```bash
pm2 logs mev-bot --lines 100
```

---

## 🔄 Updating Your Bot

When you make changes to your code:

```bash
# On your VPS (as mevbot user)
sudo su - mevbot
cd ~/solana-mev-bot
bash update-bot.sh
```

This will:
1. Pull latest changes from Git
2. Install new dependencies
3. Restart the bot

---

## 🛡️ Security Best Practices

### 1. Change Root Password
```bash
passwd
```

### 2. Create SSH Key (Optional but Recommended)
```bash
ssh-keygen -t rsa -b 4096
```

### 3. Enable Automatic Security Updates
```bash
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### 4. Monitor Wallet Balance
Check your bot's wallet regularly to ensure funds are safe.

---

## 💰 Cost Breakdown

| Provider | Plan | RAM | CPU | Storage | Cost/Month |
|----------|------|-----|-----|---------|------------|
| **DigitalOcean** | Basic | 1GB | 1 | 25GB SSD | **$6** |
| **Vultr** | Regular | 1GB | 1 | 25GB SSD | **$6** |
| **AWS Lightsail** | Nano | 0.5GB | 1 | 20GB SSD | **$5** |

**Recommended:** DigitalOcean Basic ($6/month) - Best performance for Solana

---

## 🔧 Troubleshooting

### Bot Won't Start
```bash
# Check logs
pm2 logs mev-bot --err

# Verify .env file
cat .env

# Test Node.js
node --version  # Should be v20.x
```

### Can't Connect via SSH
- Check IP address is correct
- Ensure port 22 is open in VPS firewall
- Try password instead of SSH key

### Out of Memory
```bash
# Check memory usage
free -h

# Upgrade to 2GB plan if needed
```

### Bot Keeps Stopping
```bash
# Ensure PM2 startup is configured
pm2 startup
pm2 save
```

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Bot is running: `pm2 status` shows "online"
- [ ] Logs show "Jupiter V6 atomic swap enabled"
- [ ] Logs show "Bot started successfully"
- [ ] Wallet balance is displayed
- [ ] Scanning for opportunities every 2 seconds
- [ ] No DNS errors (Jupiter/Raydium accessible)

---

## 🎯 Performance Tips

### 1. Choose VPS Location Wisely
- **Best:** East Coast USA (closest to Solana validators)
- **Good:** West Coast USA, Europe
- **Avoid:** Asia, South America (higher latency)

### 2. Upgrade RPC Provider
- Use dedicated Helius/QuickNode endpoint ($50/month)
- Better rate limits = faster scanning

### 3. Monitor Performance
```bash
# CPU and Memory
htop

# Network latency to Solana
ping mainnet.helius-rpc.com
```

---

## 🆘 Support

If you encounter issues:

1. Check logs: `pm2 logs mev-bot --lines 200`
2. Verify .env file has correct values
3. Ensure VPS has enough memory: `free -h`
4. Test RPC connection: `curl $SOLANA_RPC_URL`

---

## 🎉 Success!

Your MEV bot is now:
- ✅ Running 24/7 on VPS
- ✅ Using TRUE atomic swaps (Jupiter V6)
- ✅ Scanning 7 tokens every 2 seconds
- ✅ Auto-restarting on crashes
- ✅ Auto-starting on VPS reboot

**Happy arbitrage trading!** 🚀
