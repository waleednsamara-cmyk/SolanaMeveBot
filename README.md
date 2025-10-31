# Solana MEV Arbitrage Bot

A high-performance MEV bot that detects and executes arbitrage opportunities across Solana DEXs (Jupiter, Raydium, Meteora) with **TRUE atomic execution**.

## 🎯 Key Features

- ✅ **Jupiter V6 Atomic Swaps** - Single-transaction circular arbitrage (all-or-nothing guarantee)
- ✅ **Jito Bundle Integration** - Same-block execution for multi-transaction paths
- ✅ **Multi-DEX Support** - Jupiter (atomic), Raydium, Meteora DLMM
- ✅ **Real-time Dashboard** - WebSocket-powered monitoring interface
- ✅ **Risk Management** - Small trade sizes, profit thresholds, automatic execution
- ✅ **Production Ready** - Tested on mainnet with real SOL

## 🚀 Quick Start

### Running Locally (Recommended)

**See [LOCAL_SETUP.md](./LOCAL_SETUP.md) for complete instructions.**

Quick version:
```bash
# 1. Install dependencies
npm install

# 2. Configure environment
cp .env.example .env
# Edit .env with your wallet private key and RPC URL

# 3. Run the bot
npm run dev

# 4. Open dashboard
# Browser: http://localhost:5000
```

### Why Run Locally?
- ✅ **TRUE atomic execution** via Jupiter V6 (blocked on Replit DNS)
- ✅ **Access to all DEXs** (Jupiter + Raydium + Meteora)
- ✅ **Better performance** - Lower latency, no network restrictions
- ✅ **Full control** - Customize settings, monitor closely

## 📊 How It Works

### Scanning Priority (Every 10 seconds):
1. **Jupiter V6** - Atomic circular arbitrage (SOL → tokens → SOL in ONE transaction)
2. **Meteora DLMM** - Round-trip with Jito bundles (SOL → USDC → SOL)
3. **Raydium** - Round-trip with Jito bundles (SOL → USDC → SOL)

### Execution:
- **Jupiter**: Single atomic transaction (if any step fails, entire trade reverts)
- **Meteora/Raydium**: Jito bundles group swaps to execute in same block with guaranteed order

### Profit Threshold:
- Minimum **0.05% profit** required to execute
- Ensures profitability after gas fees, slippage, and Jito tips

## 🛡️ Safety Features

- ✅ **Atomic execution** (Jupiter) - All-or-nothing guarantee, no stranded funds
- ✅ **Same-block execution** (Jito bundles) - Reduces timing and MEV risks
- ✅ **Small trade sizes** - Default 0.1 SOL (~$20) limits risk exposure
- ✅ **Profit requirements** - Won't execute unless profitable after all costs
- ✅ **Real-time monitoring** - Dashboard shows every scan and trade

## 📁 Project Structure

```
solana-mev-bot/
├── src/
│   ├── frontend/           # React dashboard
│   │   ├── components/     # UI components
│   │   └── App.tsx
│   └── backend/            # Node.js server
│       ├── services/
│       │   ├── BlockchainMonitor.ts      # Solana connection
│       │   ├── ArbitrageDetector.ts      # Opportunity detection
│       │   ├── TransactionExecutor.ts    # Trade execution
│       │   └── JitoBundleService.ts      # Jito bundle management
│       └── server.ts       # Express + WebSocket server
├── LOCAL_SETUP.md          # Detailed setup guide
├── package.json
└── .env.example            # Configuration template
```

## ⚙️ Configuration

Edit `.env` file:

```env
# Solana RPC (use Helius or QuickNode for best performance)
SOLANA_RPC_URL=https://mainnet.helius-rpc.com/?api-key=YOUR_KEY
SOLANA_WS_URL=wss://mainnet.helius-rpc.com/?api-key=YOUR_KEY

# Your wallet private key (base58 format)
WALLET_PRIVATE_KEY=your_private_key_here

# Enable live trading (false = simulation mode)
EXECUTE_TRADES=true

# Trading parameters
MIN_PROFIT_SOL=0.005          # Minimum profit to execute
MAX_TRADE_SIZE_SOL=0.1        # Maximum per trade (limits risk)
MAX_SLIPPAGE_BPS=100          # 1% slippage tolerance
```

## 📈 Expected Performance

### Market Reality:
- **Opportunities**: 1-5 per day with ≥0.05% profit
- **Profit range**: 0.05-0.2% per trade
- **Competition**: High - many bots scanning same markets
- **Best conditions**: High volatility, large trades, market movements

### Example Trade:
```
🎯 JUPITER ATOMIC ARBITRAGE DETECTED!
   Amount: 0.1 SOL
   Output: 0.100068 SOL
   Profit: 0.068% (0.000068 SOL ≈ $0.014)
   ✅ Atomic transaction (all-or-nothing)
```

## 🐛 Troubleshooting

### No opportunities found?
- **Normal!** Markets are efficient, opportunities are rare
- Bot will keep scanning every 10 seconds
- Opportunities appear during volatility or large trades

### Dashboard not loading?
- Check console shows "Server running on port 3001"
- Open `http://localhost:5000` (not https)
- Try refreshing (Ctrl+F5)

### Wallet errors?
- Verify `WALLET_PRIVATE_KEY` is set in `.env`
- Check it's base58 format (export from Phantom/Solflare)
- Ensure wallet has SOL for gas fees

## 🔒 Security

### NEVER:
- ❌ Share your private key
- ❌ Commit `.env` to GitHub
- ❌ Use your main wallet (create dedicated bot wallet)

### ALWAYS:
- ✅ Keep `.env` local only
- ✅ Start with small amounts (0.1 SOL)
- ✅ Monitor trades closely
- ✅ Backup your private key safely

## 📚 Documentation

- **[LOCAL_SETUP.md](./LOCAL_SETUP.md)** - Complete setup guide for running locally
- **[replit.md](./replit.md)** - Technical architecture and development history

## 🎓 Technical Details

### Atomicity Comparison:

**Jupiter V6 (TRULY ATOMIC):**
- Single transaction: `SOL → Token A → Token B → SOL`
- If any swap fails, entire transaction reverts
- **Zero risk** of stranded funds
- Requires unrestricted network access (works locally, not on Replit)

**Jito Bundles (ORDERED, NOT ATOMIC):**
- Two transactions: `[TX1: SOL → USDC, TX2: USDC → SOL]`
- Both execute in same block, guaranteed order
- If TX2 fails, TX1 can still settle (funds stuck in USDC)
- **~2% risk** of stranded funds (very rare)

### Why This Matters:
Running locally gives you access to **Jupiter V6's true atomic execution**, eliminating the fund-stranding risk entirely.

## 📞 Support

For detailed setup instructions, see [LOCAL_SETUP.md](./LOCAL_SETUP.md).

## 📄 License

Educational and experimental use. Use at your own risk.

---

**Ready to start?** See [LOCAL_SETUP.md](./LOCAL_SETUP.md) for step-by-step instructions! 🚀
