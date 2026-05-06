# Library Management System — Software Engineering Report

**Group 10 | Course: Software Engineering 13477 | Instructor: Dr. Samer Elkababji**

| Member | Student ID |
|---|---|
| Mohammad Abu Taha | 20230279 |
| Hashim Zuraiqi | 20230166 |
| Faris Asaad | 20230015 |
| Hytham Fares | 20230156 |

---

## 1. System Description

The Library Management System helps libraries manage day-to-day operations. It supports three types of users:

- **Members** — search books, borrow, return, reserve, renew, and pay fines
- **Librarians** — manage the catalog, process checkouts and returns
- **Admins** — manage accounts, set policies, and generate reports

The system connects to four external services: an **Email Service** for notifications, a **Payment Gateway** for fines, an **RFID/Barcode Subsystem** for scanning, and an **ISBN Lookup Service** for adding new books quickly.

---

## 2. Context (C4 Level 1)

![C4 L1 Context Diagram](images/c4_l1_context.png)

This diagram shows the system in context. The Library Management System sits at the center, surrounded by three user roles (Member, Librarian, Admin) and four external systems. It makes clear what the team builds versus what the team integrates with.

---

## 3. Containers (C4 Level 2)

![C4 L2 Container Diagram](images/c4_l2_container.png)

The system is split into five containers:

| Container | Purpose |
|---|---|
| **Member Web App** | Self-service portal for members (search, borrow, reserve, pay) |
| **Staff Web App** | Internal tool for librarians and admins |
| **Backend API** | Handles all business logic, auth, and validation |
| **Database** | Stores all records (PostgreSQL) |
| **Notification Worker** | Sends emails in the background without slowing down the API |

---

## 4. Use Case Model

### 4.1 Use Case Diagram

![Use Case Diagram](images/use_case.png)

The diagram shows 11 use cases across three actors (Member, Librarian, Admin). Key relationships:
- `<<include>>` Authentication — required by every action
- `<<extend>>` Pay Fine — triggered only when a fine exists after return
- `<<extend>>` Send Notification — triggered after borrow, return, or reserve

### 4.2 Use Case Descriptions

#### UC-02: Borrow Book

| Field | Content |
|---|---|
| **Actors** | Member, Librarian / Email Service |
| **Preconditions** | Member logged in; account in good standing; book available; loan limit not reached |
| **Main Flow** | 1. Librarian scans member ID → 2. System checks eligibility → 3. Librarian scans book → 4. System checks availability → 5. Loan created (due in 21 days) → 6. Book marked BORROWED → 7. Confirmation email sent |
| **Alternatives** | Account blocked → stop; Book unavailable → offer reserve; Loan limit reached → show limit; Email fails → retry up to 3 times |
| **Postconditions** | Loan saved; book marked BORROWED; confirmation email sent |

#### UC-03: Return Book

| Field | Content |
|---|---|
| **Actors** | Member, Librarian / Email Service |
| **Preconditions** | Member logged in; book was borrowed by this member |
| **Main Flow** | 1. Librarian scans member ID → 2. System finds active loans → 3. Librarian scans book → 4. Return date recorded → 5. Fine calculated if late → 6. Book marked AVAILABLE → 7. Confirmation email sent |
| **Alternatives** | Loan not found → error shown; Book late → fine applied (UC-06); Book damaged → marked DAMAGED |
| **Postconditions** | Loan marked RETURNED; book AVAILABLE; fine recorded if applicable |

#### UC-04: Reserve Book

| Field | Content |
|---|---|
| **Actors** | Member / Librarian, Email Service |
| **Preconditions** | Member logged in; account in good standing; book exists; not already reserved |
| **Main Flow** | 1. Member searches and clicks Reserve → 2. System shows summary → 3. Member confirms → 4. System queues reservation → 5. Confirmation email sent |
| **Alternatives** | No copies exist → suggest alternatives; Already reserved → show existing hold; Book available → offer borrow instead |
| **Postconditions** | Reservation saved; queue position assigned; email sent |

#### UC-06: Pay Fine

| Field | Content |
|---|---|
| **Actors** | Member / Payment Gateway, Email Service |
| **Preconditions** | Member logged in; unpaid fine exists; payment system online |
| **Main Flow** | 1. System shows unpaid fines → 2. Member selects and confirms → 3. Member enters payment details → 4. Payment Gateway processes → 5. Fine marked PAID → 6. Receipt email sent |
| **Alternatives** | Payment declined → show error; Timeout → ask to retry; No fines → show message |
| **Postconditions** | Fine marked PAID; balance cleared; receipt emailed |

#### UC-07: Manage Book Records

| Field | Content |
|---|---|
| **Actors** | Librarian, Admin |
| **Preconditions** | User logged in with Librarian or Admin role |
| **Main Flow** | 1. Open Catalog Management → 2. Search by ISBN/title/author → 3. Select book → 4. Edit details (copies, condition, tags) → 5. System validates → 6. Changes saved with audit log |
| **Postconditions** | Book record updated; change logged with user and timestamp |

#### Remaining Use Cases (Summary)

| ID | Use Case | Summary |
|---|---|---|
| UC-01 | Search Catalog | Member searches by keyword → results shown with availability → can borrow or reserve |
| UC-05 | Renew Loan | Member selects active loan → system checks renewal limit (max 2) and no active holds → 21 days added |
| UC-08 | Register Member | Librarian enters member details → system creates account → welcome email sent |
| UC-09 | Generate Reports | Admin selects report type and date range → system generates → export as CSV or PDF |
| UC-10 | Authenticate | User enters credentials → session created → locked after 5 failed attempts |
| UC-11 | Send Notification | System triggers event → formats message → Email Service sends via SMTP → retries up to 3 times on failure |

---

## 5. Sequence Diagrams — Borrow Book

### 5.1 High-Level (Stakeholders)

![Sequence Diagram — High-Level](images/sequence_borrow_highlevel.png)

Shows the borrow flow at a simple level: Librarian submits request → System validates member and book → Loan confirmed → Email sent. Includes one failure path for when validation fails.

### 5.2 Detailed (Developers)

![Sequence Diagram — Detailed](images/sequence_borrow_detailed.png)

Shows the same flow with internal detail: alt blocks for session, eligibility, and availability checks; database writes inside a transaction; and the confirmation email queued asynchronously to a Notification Worker.

---

## 6. Activity Diagram — Borrow Book Workflow

![Activity Diagram — Borrow Book Swimlane](images/activity_borrow_swimlane.png)

Shows the borrow workflow split across four lanes: Member, Librarian, Backend API, and Database. Three decision points are visible — member standing, book availability, and existing reservations — each with a clear failure exit so no loan is created in an invalid state.

---

## 7. Class Diagram

![Class Diagram](images/class_diagram.png)

### 7.1 Overview

The diagram shows 11 classes with two inheritance hierarchies, one composition, one aggregation, and four associations.

### 7.2 Inheritance

| Hierarchy | Superclass | Subclasses |
|---|---|---|
| Users | `User` (abstract) — login, logout, updateProfile | `Member`, `Librarian`, `Admin` |
| Items | `LibraryItem` (abstract) — getDetails, getAvailableCopies | `Book`, `Journal` |

### 7.3 Composition & Aggregation

| Relationship | Type | Multiplicity | Reason |
|---|---|---|---|
| `Catalog` → `LibraryItem` | **Composition** | 1 to 0..* | Items cannot exist without the catalog |
| `LibraryItem` → `Copy` | **Aggregation** | 1 to 1..* | Copies are tracked independently (can be lost/damaged) |

### 7.4 Associations

| Association | Multiplicity | Notes |
|---|---|---|
| Member — Loan | 1 to 0..* | A member can have multiple active loans |
| Loan — Copy | many to 1 | Each loan ties to one physical copy |
| Member — Reservation | 1 to 0..* | A member can hold multiple reservations |
| Loan — Fine | 0..1 to 0..1 | A loan may produce at most one fine |

---

## 8. State Diagram — Loan Lifecycle

![Loan State Diagram](images/state_loan.png)

### 8.1 Overview

Tracks a `Loan` object from the moment a borrow is requested until it is fully closed. The Loan is the central entity — it is created in UC-02, modified in UC-03 and UC-05, and drives fine calculation in UC-06.

### 8.2 State Descriptions

| State | Meaning |
|---|---|
| **Requested** | Borrow initiated; system is validating member and book. No loan record yet. |
| **Active** | Validation passed. Loan exists; book is BORROWED; due date set (21 days). |
| **Renewed** | Renewal granted (count < 2, no active hold). Due date extended 21 days, then returns to Active. |
| **Overdue** | Due date passed. Fine calculated ($0.25/day). Member cannot borrow until returned. |
| **Returned** | Book scanned back in. Return date recorded. Fine (if any) remains unpaid. |
| **Closed** | Loan resolved — returned with no fine, or fine paid. Book marked AVAILABLE. |
| **Rejected** | Validation failed. No loan record created. |

### 8.3 State-Stimulus Table

| Current State | Event | Guard | Next State | Action |
|---|---|---|---|---|
| *(initial)* | Borrow requested | — | Requested | Begin validation |
| Requested | Validation passes | Member eligible, copy available | Active | Create loan; mark book BORROWED; send email |
| Requested | Validation fails | Ineligible or unavailable | Rejected | Show reason; no loan created |
| Active | Renewal requested | Count < 2, no active hold | Renewed | Extend due date; increment count |
| Active | Renewal requested | Count ≥ 2 or hold exists | Active | Show "Cannot renew" |
| Renewed | Recorded | — | Active | Update due date |
| Active | Due date passes | Not returned | Overdue | Calculate fine; send notice |
| Active | Book returned | On or before due date | Returned | Record return; book AVAILABLE; no fine |
| Overdue | Book returned | — | Returned | Record return; book AVAILABLE; fine UNPAID |
| Returned | Fine paid or no fine | — | Closed | Archive loan; restore borrowing rights |

---

## 9. Data Flow Diagrams

### 9.1 Level 0 — Context DFD

![DFD Level 0](images/dfd_l0.png)

Treats the entire system as one process. Shows all external entities and what data flows in and out:

| Entity | Sends to System | Receives from System |
|---|---|---|
| Member | Search queries, borrow/return/reserve/renew/payment | Results, confirmations, receipts |
| Librarian | Scan events, catalog updates | Checkout confirmations, status updates |
| Admin | User commands, policy changes, report requests | Reports |
| Email Service | — | Notification emails |
| Payment Gateway | Authorization responses | Payment requests |

### 9.2 Level 1 — Decomposed DFD

![DFD Level 1](images/dfd_l1.png)

Breaks the system into 5 processes and 6 data stores:

| Process | Role | Data Stores |
|---|---|---|
| 1.0 Process Loan | Handles borrow, return, renew | D1 Members, D2 Copies, D3 Loans |
| 2.0 Manage Catalog | Adds/edits book records | D2 Copies, D4 Items |
| 3.0 Handle Reservations | Manages the hold queue | D1 Members, D2 Copies, D5 Reservations |
| 4.0 Process Fines | Calculates and records fines | D1 Members, D6 Fines |
| 5.0 Send Notifications | Sends all system emails | D1 Members |

| Store | Contents |
|---|---|
| D1 Members | Accounts, borrowing limits, fine balances |
| D2 Copies | Physical copies, condition, shelf location |
| D3 Loans | Active and historical loan records |
| D4 Items | Catalog records (title, ISBN, author) |
| D5 Reservations | Hold queue with position and expiry |
| D6 Fines | Fine records with amount and payment status |

---

*End of Report — Group 10*
