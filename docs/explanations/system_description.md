# Library Management System System Description

## What the system does

The Library Management System supports the everyday work of a small to medium library by combining member-facing self-service features with staff tools for circulation and catalog administration. Members use the system to search for books, place holds, borrow and return items, renew active loans, and pay overdue fines. Librarians use it to manage catalog records, check items in and out, update item status, and resolve circulation issues. Admin users handle account management, policy configuration, and reporting tasks that keep the library operating consistently.

The system is centered on a single source of truth for library data. That includes bibliographic records, copies or physical items, member accounts, loan history, reservation queues, and fine balances. Operational workflows are expected to be straightforward and auditable. For example, a borrow transaction should verify the member account, confirm that the requested item is available, create the loan record, update the item status, and trigger a notification so the member receives a confirmation.

External integrations are part of the normal workflow rather than special cases. The email service is used for reminders, confirmations, and due-date notices. The payment gateway is used when a member pays a fine. The RFID or barcode subsystem is used by staff when physical items are scanned during checkout, return, or inventory tasks. An ISBN lookup service is optional but useful when new titles are added, because it reduces manual catalog entry and improves metadata quality.

## Architectural choices shown in the container view

The container view separates the user interface from the business logic and data storage. The Member Web App and Staff Web App are both React applications, but they serve different audiences and different interaction patterns. Members need a simple, public-facing experience optimized for search and self-service. Staff need denser screens for circulation, catalog editing, and administrative work. Splitting these applications avoids mixing unrelated screens and makes the permission model easier to control.

The Backend API is the core coordination layer. It owns authentication, authorization, validation, and the business rules that decide whether a loan can be created or a renewal can be granted. Putting this logic behind a single API keeps both web apps thin and reduces duplication. It also creates a clear place for shared rules such as loan limits, reservation priority, and overdue fine calculation.

The Database is modeled as its own container because the library needs durable transactional storage for core records. Loans, reservations, and fines should be updated consistently, so a relational database is a good fit. PostgreSQL provides strong constraints and transactions, which matter when multiple staff members or members are acting on the same item at the same time.

The Notification Worker is separated from the API so background reminders do not block user requests. Overdue notices, due-date reminders, and confirmation emails are scheduled or deferred work. Keeping them in a worker lets the API respond quickly to checkout and renewal requests while the worker handles retries and time-based jobs independently. This also makes the system easier to scale later if notification volume grows.

The external services remain outside the system boundary because they are owned and operated by third parties or hardware. The payment gateway is a remote dependency and should be isolated behind a clear integration point. The email service is similarly external, and the RFID or barcode subsystem is represented as a boundary interaction because it depends on local hardware or device drivers. In the container diagram, these integrations are shown as edge services so the architecture clearly distinguishes what the library controls from what it consumes.

Overall, the design aims to keep the first release simple without collapsing everything into one application. The user interfaces are separated by audience, the API centralizes business logic, the database preserves consistency, and the worker handles asynchronous work. That gives the project a structure that is easy to explain in v1.0.0 while still leaving room for later expansion if the team decides to add more services or more advanced automation.
