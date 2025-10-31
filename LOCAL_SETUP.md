# Running Solana MEV Bot Locally on Your PC

## ✅ Benefits of Running Locally
- **TRUE atomic execution via Jupiter V6** - No DNS restrictions
- **Access to all DEXs** - Jupiter, Raydium, and Meteora all work
- **Better performance** - Lower latency to Solana network
- **No Replit limitations** - Full network access

---

## 📋 Prerequisites

### 1. Install Node.js
- Download and install **Node.js v20 or higher**: https://nodejs.org/
- Verify installation:
  ```bash
  node --version  # Should show v20.x.x or higher
  npm --version   # Should show 10.x.x or higher
  ```

### 2. Download the Project
You have the code on Replit. Download it to your PC:
- Click "Download as ZIP" from Replit
- Extract to a folder on your PC (e.g., `C:\Users\YourName\solana-mev-bot`)

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Open Terminal/Command Prompt
- **Windows**: Press `Win + R`, type `cmd`, press Enter
- **Mac**: Press `Cmd + Space`, type `terminal`, press Enter
- Navigate to your project folder:
  ```bash
  cd C:\Users\YourName\solana-mev-bot
  ```

### Step 2: Install Dependencies
```bash
npm install
```
This will take 1-2 minutes to download all packages.

### Step 3: Configure Environment Variables
1. **Copy the example file**:
   ```bash
   # Windows
   copy .env.example .env
   
   # Mac/Linux
   cp .env.example .env
   ```

2. **Edit `.env` file** (use Notepad, VS Code, or any text editor):
   ```env
   # Use your Helius RPC (recommended for best performance)
   SOLANA_RPC_URL=https://mainnet.helius-rpc.com/?api-key=40692027-6716-4fcf-9340-a3cc93049a40
   SOLANA_WS_URL=wss://mainnet.helius-rpc.com/?api-key=40692027-6716-4fcf-9340-a3cc93049a40
   
   # Your wallet private key (base58 format)
   # ⚠️ KEEP THIS SECRET! Never share or commit to git!
   WALLET_PRIVATE_KEY=your_private_key_here
   
   # Enable LIVE trading (set to 'false' for simulation mode)
   EXECUTE_TRADES=true
   ```

### Step 4: Run the Bot
```bash
npm run dev
```

You should see:
```
✅ Wallet loaded: 5PNcW...
✅ Jito SearcherClient initialized
🚀 Server running on port 3001
🤖 Starting MEV bot...
🔍 Scanning for arbitrage opportunities...
```

### Step 5: Open Dashboard
Open your browser and go to:
```
http://localhost:5000
```

You'll see the dashboard with:
- Bot status (Running/Stopped)
- Wallet balance
- Recent opportunities detected
- Trade history

---

## 🎯 What Will Happen

### Scanning Priority (Every 10 seconds):
1. **Jupiter V6** (PRIMARY) - Checks for atomic circular arbitrage
   - ✅ **WORKS LOCALLY** (blocked on Replit)
   - TRUE atomic execution (single transaction, no stranded funds risk)
   - If profit ≥0.05%, executes immediately

2. **Meteora DLMM** (FALLBACK) - Checks SOL → USDC → SOL round-trip
   - Uses Jito bundles for same-block execution
   - If profit ≥0.05%, executes immediately

3. **Raydium** (FALLBACK) - Checks SOL → USDC → SOL round-trip
   - ✅ **WORKS LOCALLY** (blocked on Replit)
   - Uses Jito bundles for same-block execution
   - If profit ≥0.05%, executes immediately

### When Opportunity Found:
The bot will automatically:
1. Log the opportunity to console
2. Execute the trade (if `EXECUTE_TRADES=true`)
3. Wait for confirmation
4. Update dashboard with results
5. Continue scanning for next opportunity

---

## ⚙️ Configuration Options

Edit `.env` file to adjust settings:

```env
# PROFIT THRESHOLD
# Only execute trades with at least this much profit
MIN_PROFIT_SOL=0.005        # 0.005 SOL minimum profit

# TRADE SIZE
# Maximum amount per trade (protects against large losses)
MAX_TRADE_SIZE_SOL=0.1      # 0.1 SOL per trade (~$20)

# SLIPPAGE
# Maximum price movement tolerance
MAX_SLIPPAGE_BPS=100        # 1% slippage (100 basis points)

# TRADING MODE
EXECUTE_TRADES=true         # 'true' = live trading, 'false' = simulation only
```

---

## 🛡️ Safety Features

### Built-in Protections:
- ✅ **Jupiter atomic swaps** - If any step fails, entire transaction reverts
- ✅ **Jito bundles** - Multiple transactions execute in same block
- ✅ **Small trade sizes** - Default 0.1 SOL limits risk to ~$20 per trade
- ✅ **Profit threshold** - Won't execute unless profit covers all fees
- ✅ **Real-time monitoring** - Dashboard shows every action

### Risk Management:
- Start with **0.1 SOL trades** to test the system
- Monitor the first 5-10 trades closely
- If everything works well, you can increase trade size in `.env`
- Set `EXECUTE_TRADES=false` to test in simulation mode first

---

## 📊 Expected Performance

### Market Reality:
- **Opportunities are RARE** - Maybe 1-5 per day with ≥0.05% profit
- **High competition** - Hundreds of bots scanning same markets
- **Small profits** - Typically 0.05-0.2% when opportunities exist
- **Current market** - Very efficient, opportunities may take hours/days to appear

### What Success Looks Like:
```
🔍 Scanning for arbitrage opportunities...
    Jupiter V6 API: SOL → USDC → SOL
    Jupiter ATOMIC round-trip: 0.1 SOL → 0.100068 SOL (0.068% profit)

🎯 JUPITER ATOMIC ARBITRAGE DETECTED!
   Amount: 0.1 SOL
   Path: SOL → intermediate tokens → SOL (ATOMIC)
   Output: 0.100068 SOL
   Profit: 0.068% (0.000068 SOL)
   ✅ ONE transaction (atomic, no stranded funds risk)

⏳ Executing Jupiter atomic swap...
✅ Transaction confirmed: abc123...
💰 Actual profit: 0.000065 SOL (~$0.013)
```

---

## 🐛 Troubleshooting

### Bot won't start:
```bash
# Make sure you're in the project folder
cd C:\Users\YourName\solana-mev-bot

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Try running again
npm run dev
```

### "WALLET_PRIVATE_KEY is required":
- Make sure you created `.env` file (copy from `.env.example`)
- Check that `WALLET_PRIVATE_KEY` is set in `.env` file
- Make sure it's your wallet's base58 private key (from Phantom/Solflare export)

### Dashboard not loading:
- Check console output - should say "Server running on port 3001"
- Open browser to `http://localhost:5000` (not https)
- Try refreshing the page (Ctrl+F5 / Cmd+Shift+R)

### No opportunities found:
- **This is normal!** Arbitrage opportunities are rare
- Market may be very efficient (all prices aligned)
- Bot will keep scanning every 10 seconds
- Opportunities typically appear during high volatility or large trades

### Connection errors:
- Check your internet connection
- Verify Helius RPC URL is correct in `.env`
- Try using public RPC: `https://api.mainnet-beta.solana.com`

---

## 🎓 Understanding the Output

### Console Messages:

**Every 10 seconds (scan cycle):**
```
🔍 Scanning for arbitrage opportunities...
```

**When checking Jupiter:**
```
Querying Jupiter V6 API for ATOMIC circular arbitrage...
Jupiter ATOMIC round-trip: 0.1 SOL → 0.100012 SOL (0.012% profit)
```
- Below 0.05% = skipped (not profitable after fees)
- Above 0.05% = executed automatically

**When checking Meteora/Raydium:**
```
Querying Meteora API for SOL → USDC...
Meteora SOL → USDC success, querying USDC → SOL...
Meteora round-trip: 0.1 SOL → 0.100045 SOL (0.045% profit)
```

**When executing trade:**
```
⏳ Executing Jupiter atomic swap...
📝 Sending transaction to Solana...
✅ Transaction confirmed: 2ZE7M... (view on explorer)
💰 Actual profit: 0.000042 SOL
```

---

## 📈 Optimization Tips

### For Better Performance:
1. **Use a fast RPC** - Helius or QuickNode (free tier works)
2. **Run during high volatility** - More opportunities during market movements
3. **Monitor gas fees** - Lower fees during off-peak hours
4. **Start small** - Test with 0.1 SOL before scaling up

### For Maximum Profit:
1. **Lower threshold to 0.03%** - Catches more opportunities (but watch fees)
2. **Increase trade size** - Larger trades = larger absolute profit (but more risk)
3. **Add more DEXs** - More sources = more opportunities
4. **Optimize timing** - Run during US/Asia market hours for higher volume

---

## 🔒 Security Best Practices

### NEVER:
- ❌ Share your `WALLET_PRIVATE_KEY` with anyone
- ❌ Commit `.env` file to GitHub or public repos
- ❌ Run code you don't understand
- ❌ Use your main wallet (create a separate bot wallet)

### ALWAYS:
- ✅ Keep `.env` file local only
- ✅ Use a dedicated wallet for the bot (not your main funds)
- ✅ Start with small amounts (0.1-1 SOL)
- ✅ Monitor trades in the dashboard
- ✅ Keep backups of your private key in a safe place

---

## 📞 Support

### Common Questions:

**Q: How much can I make?**
A: Arbitrage profits are typically 0.05-0.2% per trade. With 0.1 SOL trades and 3 opportunities/day, expect ~$0.03-0.06/day ($1-2/month). This is educational/experimental.

**Q: Why no opportunities for hours?**
A: Markets are very efficient. Professional MEV bots compete for the same opportunities. This is normal.

**Q: Can I increase trade size to 1 SOL?**
A: Yes, edit `MAX_TRADE_SIZE_SOL=1.0` in `.env`. But start small (0.1 SOL) to test first!

**Q: Is this risky?**
A: Jupiter provides atomic execution (all-or-nothing). Worst case with 0.1 SOL trades is ~$20 loss if bugs exist. Start small!

**Q: Can I run 24/7?**
A: Yes! Just leave the terminal window open. Consider using `pm2` or running as a service for automatic restarts.

---

## 🎉 Ready to Go!

Your bot is now configured to run locally with:
- ✅ **TRUE atomic execution** via Jupiter V6
- ✅ **Access to all DEXs** (Jupiter + Raydium + Meteora)
- ✅ **Real-time dashboard** for monitoring
- ✅ **Jito bundles** for same-block execution
- ✅ **0.05% profit threshold** for profitable trades only

**Start the bot:**
```bash
npm run dev
```

**Open dashboard:**
```
http://localhost:5000
```

Good luck! The bot will scan every 10 seconds and execute automatically when profitable opportunities appear. 🚀
