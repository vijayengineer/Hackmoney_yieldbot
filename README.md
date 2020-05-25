# Hackmoney_yieldbot
This repository is a submission for the Hackmoney hackathon
This project uses Aave Flashloan to build a yield bot
Assumptions:
-->Infura project, endpoint
-->Small amount of Eth in Wallet for gas
Pipeline:
Python script spots arbitrage opportunity: 3 way token conversion in Uniswap exchange
Generate a flash loan for 1 Eth --> Use the amount to request a token in Uniswap --> Convert token back to eth --> Payback flashloan
