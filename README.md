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

## 2. Overview

### System Purpose

The Library Management System is a database-driven system that automates core library operations including cataloging, borrowing, returning, reserving, renewing, and managing memberships. It serves three primary actors - Members, Librarians, and Admins - and integrates with an Email Service, a Payment Gateway, and an RFID/Barcode Subsystem so that notifications, fine processing, and item scanning fit into the normal workflow rather than being treated as special cases.

### Tools Used

- **Visual Studio Code** - primary editor
- **PlantUML** (jebbs extension) - source for UML and C4 diagrams
- **Pandoc** - Markdown to PDF conversion (for v2.0.0 final report)
- **Git / GitHub** - version control and team collaboration

## 3. Diagrams

| Diagram | Source File | Description |
|---|---|---|
| C4 Level 1 - Context | `uml/c4_l1_context.puml` | System boundary, primary actors, and external systems |
| C4 Level 2 - Container | `uml/c4_l2_container.puml` | Internal containers: web apps, Backend API, Database, Notification Worker |
| Use Case Diagram | `uml/use_case.puml` | Eleven main features with `<<include>>` and `<<extend>>` relationships |
| Sequence - Borrow (High-Level) | `uml/sequence_borrow_highlevel.puml` | Stakeholder view of the borrow flow |
| Sequence - Borrow (Detailed) | `uml/sequence_borrow_detailed.puml` | Developer view with components, transactions, and async notification |
| Activity - Borrow (Swimlane) | `uml/activity_borrow_swimlane.puml` | Workflow across Member, Librarian, Backend API, and Database lanes |

## 4. Repository Structure

```
Software-Eng.-Project-UNTITLED/
├── README.md                     # Title page (this file)
├── docs/
│   ├── report.md                 # Consolidated Software Engineering report
│   ├── explanations/             # Reference drafts kept for traceability
│   │   ├── system_description.md
│   │   ├── sequence_explanation.md
│   │   └── use_case_descriptions.md
│   └── images/                   # PNG exports of UML diagrams (embedded in report.md)
└── uml/                          # PlantUML source files (.puml)
```

## 5. Contributions

| Member | Role | Commits |
|---|---|---|
| Hashim Zuraiqi | System Description, C4 Level 1 and Level 2 diagrams, repository setup | 3 |
| Mohammad Abu Taha | Activity Diagram with swimlanes, repo refactoring| 8 |
| Faris Asaad | Sequence Diagrams (high-level and detailed) | 2 |
| Hytham Fares | Use Case Diagram and Use Case Descriptions | 3 |


