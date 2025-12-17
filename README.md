# Tutor Marketplace DApp 🎓

A decentralized tutor marketplace built with **Solidity** and **React**, where students can securely book tutoring sessions, tutors can manage requests, and payments are handled transparently through smart contracts with dispute resolution by an admin.

---

## 📌 Overview

This project is a **blockchain-based tutoring platform** that removes the need for trust between students and tutors by using an **escrow smart contract**.

### Key Features
- Students book tutoring sessions with upfront payment
- Tutors can accept or reject session requests
- Payments are held in escrow until the session is completed
- Students confirm completion or open disputes
- Admin resolves disputes fairly on-chain
- Fully decentralized payment flow using Ethereum

---

## 🧠 Roles in the System

### 👨‍🎓 Student
- Requests a tutoring session
- Pays upfront (held in escrow)
- Confirms completion or opens a dispute

### 👩‍🏫 Tutor
- Accepts or rejects session requests
- Conducts tutoring session
- Marks session as completed

### 🛡️ Admin
- Handles disputes
- Decides whether funds go to the tutor or are refunded to the student

---

## 🔄 Session Lifecycle (Workflow)

1. **Student requests a session**
   - Student selects a tutor and topic
   - Student sends ETH as payment
   - Session status → `Requested`

2. **Tutor responds**
   - Tutor **accepts** → status `Accepted`
   - Tutor **rejects** → student is refunded immediately

3. **Tutor completes session**
   - Tutor marks session as completed
   - Status → `Completed`

4. **Student action**
   - Student **confirms session** → tutor is paid
   - OR student **opens a dispute**

5. **Admin resolves dispute**
   - Admin decides:
     - Refund student **OR**
     - Pay tutor
   - Status → `Resolved`

---

## 📜 Smart Contract Details

### Contract Name
`TutorMarketplace.sol`

### Solidity Version
```solidity
pragma solidity ^0.8.0;
```

### Session Status Enum
```solidity
enum SessionStatus {
  Requested,
  Accepted,
  Completed,
  Confirmed,
  Disputed,
  Resolved
}
```

### Session Structure
```solidity
struct Session {
    uint id;
    address payable student;
    address payable tutor;
    uint amount;
    SessionStatus status;
    string topic;
}
```

---

## 🔑 Core Smart Contract Functions

| Function | Called By | Description |
|--------|----------|-------------|
| `requestSession` | Student | Create a session and lock ETH payment |
| `acceptSession` | Tutor | Accept a session request |
| `rejectSession` | Tutor | Reject request and refund student |
| `markCompleted` | Tutor | Mark session as completed |
| `confirmSession` | Student | Release funds to tutor |
| `openDispute` | Student | Open dispute after completion |
| `resolveDispute` | Admin | Decide payout or refund |

---

## 🔐 Security & Trust Model

- Funds are **locked in the smart contract**
- No funds are released without valid state transitions
- Role-based access enforced via `require()`
- Admin-only dispute resolution
- Uses Solidity `transfer()` for ETH payouts

---

## 🖥️ Frontend (React)

The React frontend interacts with the smart contract using **MetaMask**.

### Frontend Capabilities
- Wallet connection
- Student dashboard
- Tutor dashboard
- Admin dispute panel
- Real-time session status tracking

### Tech Stack
- React
- Ethers.js / Web3.js
- MetaMask
- Solidity
- Ethereum

---
## 📈 Future Enhancements

- Tutor ratings & reviews
- Partial refunds
- Time-based auto settlement
- ERC20 payments
- DAO-based dispute resolution
- IPFS session records