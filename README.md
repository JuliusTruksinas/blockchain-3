# Tutor Marketplace – Decentralized Application

A decentralized tutoring marketplace where students can book online sessions with tutors.  
Payments are held in **escrow on Ethereum** and released when sessions are confirmed as completed, or handled through a dispute flow.

---

## Table of Contents

- [Overview](#overview)
- [Implemented Features](#implemented-features)
- [Architecture](#architecture)
  - [Actors and Roles](#actors-and-roles)
  - [System Overview](#system-overview)
- [Implemented Process Flows](#implemented-process-flows)
  - [1. Session Request & Escrow Deposit](#1-session-request--escrow-deposit)
  - [2. Tutor Decision (Accept / Reject)](#2-tutor-decision-accept--reject)
  - [3. Session Delivery & Settlement](#3-session-delivery--settlement)
  - [4. Dispute Handling](#4-dispute-handling)
  - [5. Sequence Diagram – Textual Mapping](#5-sequence-diagram--textual-mapping)
- [Smart Contract Events](#smart-contract-events)
- [Tech Stack](#tech-stack)
- [Notes & Next Steps](#notes--next-steps)

---

## Overview

Tutor Marketplace is a decentralized platform that enables students to request online tutoring sessions with tutors.

A **smart contract on the Ethereum blockchain** manages:

- Escrowed payments for sessions
- Session lifecycle state changes (request → accept/reject → complete → confirm)
- Dispute lifecycle state changes (open → resolved)

A **DApp** provides a simple web UI that interacts with the contract (e.g., MetaMask transactions).

---

## Implemented Features

✅ **Escrow-based session requests**
- Student requests a session and deposits ETH into the contract escrow.

✅ **Tutor decision flow**
- Tutor can accept or reject a session request.
- If rejected, the student is refunded.

✅ **Session completion + student confirmation**
- Tutor marks the session as completed.
- Student confirms completion.
- Funds are released to the tutor upon confirmation.

✅ **Dispute lifecycle (recorded on-chain)**
- Student can open a dispute.
- Dispute can be resolved (decision recorded on-chain).

> Note: This README reflects only the functionality currently implemented.

---

## Architecture

### Actors and Roles

#### 1. Student
**Role:** Requests tutoring sessions and pays into escrow.

**Responsibilities:**
- Request a session and deposit payment into escrow
- Confirm session completion
- Open a dispute if needed

#### 2. Tutor
**Role:** Accepts/rejects requests and delivers sessions off-chain.

**Responsibilities:**
- Accept or reject incoming session requests
- Mark the session as completed after delivery

#### 3. Admin
**Role:** Resolves disputes (decision logged on-chain).

**Responsibilities:**
- Resolve disputes by recording a decision in the contract

---

### System Overview

- Student deposits ETH into the smart contract to create a session request (escrow).
- Tutor responds by accepting or rejecting.
- If accepted, tutoring happens **off-chain** (Zoom/Meet/etc.).
- Tutor marks the session as completed on-chain.
- Student confirms completion on-chain, triggering payment release.
- If something goes wrong, a dispute can be opened and later resolved.

---

## Implemented Process Flows

### 1. Session Request & Escrow Deposit

1. Student selects a tutor and submits a session request.
2. Student deposits the session payment into the smart contract (escrow).
3. Contract emits an event indicating the session was requested.

---

### 2. Tutor Decision (Accept / Reject)

**Tutor accepts:**
- Session moves to an accepted state.
- Contract emits `SessionAccepted`.

**Tutor rejects:**
- Contract refunds the student.
- Contract emits `SessionRejected`.

---

### 3. Session Delivery & Settlement

1. Tutor delivers the tutoring session off-chain.
2. Tutor marks the session as completed on-chain.
3. Student confirms the session completion on-chain.
4. Contract releases escrow funds to the tutor.

---

### 4. Dispute Handling

1. Student opens a dispute on-chain.
2. Contract emits `DisputeOpened`.
3. Admin resolves the dispute on-chain (decision recorded).
4. Contract emits `DisputeResolved`.

> Note: This README documents the dispute open/resolve lifecycle as implemented (event/log level + state changes).

---

### 5. Sequence Diagram – Textual Mapping

1. **Student → Smart Contract:** `Request session + deposit payment`
2. **(Event):** `SessionRequested`

3a. **Tutor → Smart Contract:** `Accept session`  
- **(Event):** `SessionAccepted`

3b. **Tutor → Smart Contract:** `Reject session`  
- **(Event):** `SessionRejected`  
- **Smart Contract → Student:** `Refund payment`

4. **Tutor → Smart Contract:** `Mark session completed`  
- **(Event):** `SessionCompleted`

5. **Student → Smart Contract:** `Confirm completion`  
- **(Event):** `SessionConfirmed`  
- **Smart Contract → Tutor:** `Release payment`

6. **Student → Smart Contract:** `Open dispute`  
- **(Event):** `DisputeOpened`

7. **Admin → Smart Contract:** `Resolve dispute`  
- **(Event):** `DisputeResolved`

---

## Smart Contract Events

The contract currently emits the following events:

```solidity
event SessionRequested(uint id, address student, address tutor, uint amount);
event SessionAccepted(uint id);
event SessionRejected(uint id);
event SessionCompleted(uint id);
event SessionConfirmed(uint id);
event DisputeOpened(uint id);
event DisputeResolved(uint id, string decision);
