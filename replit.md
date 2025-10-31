# Solana MEV Bot

## 🚀 Latest Update: VPS Deployment Ready (Oct 31, 2025)

The bot is now **ready for automated VPS deployment** to unlock:
- ✅ **TRUE atomic execution** via Jupiter V6 (blocked on Replit DNS)
- ✅ **24/7 operation** - Runs continuously even when PC is off
- ✅ **One-command deployment** - Automated setup scripts included
- ✅ **Better performance** - Lower latency, no network restrictions
- 📄 **See [VPS_DEPLOYMENT_GUIDE.md](./VPS_DEPLOYMENT_GUIDE.md)** for automated VPS deployment
- 📄 **See [LOCAL_SETUP.md](./LOCAL_SETUP.md)** for local PC deployment
- 📄 **See [README.md](./README.md)** for project overview

### 🛠️ Deployment Scripts
- **vps-setup.sh** - Automated VPS environment setup (Node.js, PM2, firewall)
- **deploy-bot.sh** - One-command bot deployment with validation
- **update-bot.sh** - Quick bot updates and restarts

## Overview
This project is a Solana MEV (Maximal Extractable Value) bot designed to identify and execute arbitrage opportunities across various decentralized exchanges (DEXs) like Jupiter, Meteora DLMM, and Raydium. Its primary purpose is to profit from price discrepancies by performing rapid, automated trades. The bot leverages Jito bundles for same-block execution, mitigating some risks associated with multi-transaction swaps, and aims for true atomic swaps where possible. The project is currently production-ready on Replit, with live trading enabled, scanning 7 high-quality tokens every 2 seconds. **Automated VPS deployment scripts are included** for easy migration to VPS environment with full atomic swap capabilities and 24/7 operation.

## User Preferences
I prefer iterative development with clear communication at each stage.
I value detailed explanations, especially for complex architectural decisions.
Please ask before making any major changes or executing trades beyond simulation mode.
Do not make changes to files outside the `src/` directory without explicit approval.
I prefer to keep the trading parameters (e.g., `MIN_PROFIT_PERCENT`, `TRADE_AMOUNT`) configurable and easily adjustable.
I want to ensure all sensitive information, like private keys and API keys, remains secured in Replit Secrets.

## System Architecture

### UI/UX Decisions
The bot features a real-time dashboard built with React 18, TypeScript, Vite, and Tailwind CSS. It includes components for displaying bot status, wallet balance, detected opportunities, and trade history. This provides a clear, concise overview of the bot's operation and performance.

### Technical Implementations
-   **Frontend:** React 18 + TypeScript + Vite + Tailwind CSS for a responsive, real-time dashboard.
-   **Backend:** Node.js + Express + TypeScript, serving as the core logic and API server.
-   **Blockchain Interaction:** Utilizes `@solana/web3.js` for Solana blockchain interactions, `@solana/spl-token` for token operations, and `jito-ts` for Jito bundle management.
-   **Real-time Communication:** Uses WebSockets (`ws` library) for live updates to the dashboard.
-   **Core Services:**
    -   **BlockchainMonitor:** Connects to Solana mainnet, monitors transactions, and manages wallet keypairs.
    -   **ArbitrageDetector:** Scans Jupiter V6 (primary), Meteora DLMM, and Raydium for circular arbitrage opportunities (SOL → tokens → SOL). It prioritizes Jupiter for atomic swaps, falling back to Meteora and Raydium with Jito bundles. Opportunities are filtered by a configurable minimum profit threshold.
    -   **TransactionExecutor:** Handles trade execution. For Jupiter, it aims for true atomic swaps (requires VPS). For Meteora and Raydium, it uses Jito bundles for same-block, ordered execution, though this is not truly atomic. It calculates fees, slippage, and tracks actual profit.
    -   **JitoBundleService:** Manages the creation, signing, and submission of transaction bundles to Jito Block Engine, ensuring same-block execution and ordering, but not atomic rollback. It uses an unauthenticated mode and adds small tips for validators.

### Feature Specifications
-   **Multi-DEX Arbitrage:** Supports Jupiter, Meteora DLMM, and Raydium.
-   **Atomic Swap Capability:** Aims for true atomic swaps via Jupiter V6 (requires unrestricted network access, e.g., VPS).
-   **Jito Bundle Integration:** For non-atomic DEXs (Meteora, Raydium), Jito bundles are used to group transactions for same-block, ordered execution, significantly reducing risk compared to sequential execution.
-   **Profitability Filter:** Executes trades only if the calculated profit exceeds a configurable `MIN_PROFIT_PERCENT` (currently 0.05%).
-   **Risk Management:** Implements trade size limits (e.g., 0.1 SOL), same-block execution via Jito bundles, and profit margin requirements.
-   **Real-time Monitoring:** Dashboard provides live status, opportunities, and trade history.
-   **Configurable Parameters:** Trading parameters like `MIN_PROFIT_PERCENT`, `SCAN_INTERVAL`, and `TRADE_AMOUNT` are easily adjustable.

### System Design Choices
-   **Waterfall Priority:** Jupiter (atomic) → Meteora (Jito bundle) → Raydium (Jito bundle) for arbitrage detection and execution.
-   **Modular Design:** Services are separated (BlockchainMonitor, ArbitrageDetector, TransactionExecutor, JitoBundleService) for maintainability and scalability.
-   **Real-time Feedback:** WebSocket communication ensures the UI dashboard provides immediate updates on bot activity.
-   **Environment Variable Configuration:** Critical settings and secrets are managed via Replit Secrets for security and easy configuration.

## External Dependencies

-   **Solana Blockchain:** Mainnet Beta network.
-   **RPC Endpoints:** Helius private RPC (configured via `SOLANA_RPC_URL` and `SOLANA_WS_URL`) for reliable blockchain access.
-   **DEX APIs:**
    -   **Jupiter Aggregator API (V6):** For atomic circular arbitrage quotes and execution (currently DNS blocked on Replit, requires VPS).
    -   **Meteora DLMM API:** Accessed via Solana Tracker API for quotes and execution.
    -   **Raydium API:** For quotes and execution.
-   **Jito Block Engine:** Used by `jito-ts` for submitting transaction bundles.
-   **Third-Party Libraries:**
    -   `@solana/web3.js`: Solana blockchain interaction.
    -   `@solana/spl-token`: SPL token program interactions.
    -   `jito-ts`: Jito client library for bundle management.
    -   `ws`: WebSocket server implementation.
    -   `express`: Node.js web application framework.
    -   `react`, `react-dom`: Frontend UI library.
    -   `typescript`: Programming language.
    -   `tailwindcss`: CSS framework.