# Agent ID Guard

Free soulbound **Guard Pass** for Agent ID holders on BNB Chain — 1 per Agent ID, value 0 (gas only), non-transferable. Plus a read-only **self-audit** of your own token approvals.

Built for the Binance Wallet x BNB Chain **Agent ID Hackathon** (60,000 USDC).

## Live product

- Website: https://cuucuan.github.io/agent-id-guard/
- X: https://x.com/ajengsua

## Contracts (BNB Chain mainnet)

- **GuardPass** (ERC-721, soulbound): `0x78af83801960d9FaD4e725f16F267540FE02a64b`
  - BscScan (verified source): https://bscscan.com/address/0x78af83801960d9FaD4e725f16F267540FE02a64b
  - `mint()` — free, value 0. Requires the caller to hold an Agent ID (`balanceOf > 0` on the Agent ID registry). One pass per wallet, max supply 10,000.
- **Agent ID registry** (SPACE ID): `0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F`

Testnet (BSC testnet): GuardPass `0xee4f009fd5128A436db9cfde6a30f9DC0e627Fb3`, MockAgentID `0x6689c29fC1046126c5Cae419862608041f36E8a9`.

## How it works

1. Connect your wallet (injected wallet only — no QR codes, no pairing codes, ever).
2. The page checks on-chain that your wallet holds an Agent ID.
3. Mint your free Guard Pass (value 0, gas only). The pass is soulbound: it cannot be transferred.
4. Self-audit: enter a token contract to read its allowances for well-known spenders and flag unlimited approvals. Read-only — nothing is signed.

## Safety

- No seed phrases, no private keys, no pairing codes — the page never asks for them.
- No approvals are requested by the mint. Mint is value 0.
- Contract source is verified and open-source on BscScan (see `GuardPass.sol` / `flattened.sol`).

## Files

- `index.html` — the product page (mint + self-audit)
- `GuardPass.sol` — the Guard Pass contract
- `flattened.sol` — flattened source, as verified on BscScan
