# Library Management System

## 1. Group Info

- **Group Number:** 10
- **Case Study:** Library Management System
- **Course:** Software Engineering 13477
- **Instructor:** Dr. Samer Elkababji

### Members

| Name | Student ID |
|------|------------|
| Mohammad Abu Taha | 20230279 |
| Hashim Zuraiqi | 20230166 |
| Faris Asaad | 20230015 |
| Hytham Fares | 20230156 |

---

## 2. Overview

### System Purpose

The Library Management System is a database-driven system that automates core library operations including cataloging, borrowing, returning, reserving, renewing, and managing memberships. It serves three primary actors — Members, Librarians, and Admins — and integrates with an Email Service, a Payment Gateway, and an RFID/Barcode Subsystem so that notifications, fine processing, and item scanning fit into the normal workflow rather than being treated as special cases.

### Tools Used

- **Visual Studio Code** — primary editor
- **PlantUML** (jebbs extension) — source for UML and C4 diagrams
- **Draw.io** — source for Data Flow Diagrams (DFD)
- **Pandoc** — Markdown to PDF conversion
- **Git / GitHub** — version control and team collaboration

---

## 3. Diagrams

### Part I & II — Architecture and Behavior (v1.0.0)

| Diagram | Source File | Description |
|---|---|---|
| C4 Level 1 — Context | `uml/c4_l1_context.puml` | System boundary, primary actors, and external systems |
| C4 Level 2 — Container | `uml/c4_l2_container.puml` | Internal containers: web apps, Backend API, Database, Notification Worker |
| Use Case Diagram | `uml/use_case.puml` | Eleven main features with `<<include>>` and `<<extend>>` relationships |
| Sequence — Borrow (High-Level) | `uml/sequence_borrow_highlevel.puml` | Stakeholder view of the borrow flow |
| Sequence — Borrow (Detailed) | `uml/sequence_borrow_detailed.puml` | Developer view with components, transactions, and async notification |
| Activity — Borrow (Swimlane) | `uml/activity_borrow_swimlane.puml` | Workflow across Member, Librarian, Backend API, and Database lanes |

### Part III — Structure (v2.0.0)

| Diagram | Source File | Description |
|---|---|---|
| Class Diagram | `uml/class_diagram.puml` | 11 classes with inheritance, composition, aggregation, and associations |

### Part IV — Behavior (v2.0.0)

| Diagram | Source File | Description |
|---|---|---|
| State Diagram — Loan Lifecycle | `uml/state_loan.puml` | Loan states from Requested through Closed, with state-stimulus table |
| DFD Level 0 | `uml/dfd_l0.drawio` | Context DFD: system as single process with all external entities |
| DFD Level 1 | `uml/dfd_l1.drawio` | Decomposed into 5 sub-processes and 6 data stores |

---

## 4. Repository Structure

```
Software-Eng.-Project-UNTITLED/
├── README.md                          # Title page (this file)
├── docs/
│   ├── report.md                      # Consolidated Software Engineering report
│   ├── se_report_group_10.pdf         # Final PDF submission
│   ├── explanations/                  # Reference drafts kept for traceability
│   │   ├── system_description.md
│   │   ├── sequence_explanation.md
│   │   └── use_case_descriptions.md
│   └── images/                        # PNG exports of UML diagrams (embedded in report.md)
└── uml/                               # Diagram source files (.puml and .drawio)
```

---

## 5. Contributions

| Member | Role | v1.0.0 Work | v2.0.0 Work |
|---|---|---|---|
| Hashim Zuraiqi | Integration Lead (A) | System Description, C4 Level 1 & Level 2, repository setup | Report compilation, README update, PDF generation, consistency pass |
| Mohammad Abu Taha | Behavior (B) | Activity Diagram with swimlanes | DFD Level 0 and Level 1 |
| Hytham Fares | Structure (C) | Use Case Diagram and Use Case Descriptions | Class Diagram |
| Faris Asaad | Behavior (D) | Sequence Diagrams (high-level and detailed) | State Diagram and state-stimulus table |
