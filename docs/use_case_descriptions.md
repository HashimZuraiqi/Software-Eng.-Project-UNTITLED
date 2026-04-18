# Use Case Descriptions — Library Management System

This doc explains how the main features of the Library Management System work. For each feature, you'll see who's involved, what has to happen first, the normal steps, what else might happen, and what the result is.

---

## UC-02: Borrow Book

| Field | Content |
|-------|---------|
| **Use Case ID** | UC-02 |
| **Use Case Name** | Borrow Book |
| **Primary Actor(s)** | Member, Librarian |
| **Secondary Actor(s)** | Email Service, System |
| **Before you start** | • Member must be logged in<br>• Member has a good account (no bans or too many overdue books)<br>• Member hasn't borrowed the max number of books<br>• The book is actually available<br>• Nobody else has reserved this book |
| **Main Flow** | 1. Librarian scans the member's card or types in their ID<br>2. System looks up the member and checks if they're OK to borrow<br>3. Librarian scans the book or types in the ISBN<br>4. System finds the book and checks if it's available<br>5. System counts how many books the member already has<br>6. System creates a record for this loan (due in 21 days)<br>7. System marks the book as BORROWED<br>8. System makes a confirmation email with the due date<br>9. Email gets sent to the member<br>10. Librarian hands the book to the member<br>11. System shows a success message |
| **Other things that might happen** | **2a. Member's account is blocked:**<br>&nbsp;&nbsp;&nbsp;• System stops the borrow and says why. Member needs to talk to the staff<br><br>**4a. Book isn't there:**<br>&nbsp;&nbsp;&nbsp;• System tells the librarian the book is checked out<br>&nbsp;&nbsp;&nbsp;• System offers to put a hold on it (go to UC-04: Reserve Book)<br>&nbsp;&nbsp;&nbsp;• Librarian can suggest other copies or similar books<br><br>**5a. Member has too many books out:**<br>&nbsp;&nbsp;&nbsp;• System shows how many they have and the limit<br>&nbsp;&nbsp;&nbsp;• Librarian tells them to return books or renew ones they have<br>&nbsp;&nbsp;&nbsp;• Nothing happens<br><br>**8a. Email is down:**<br>&nbsp;&nbsp;&nbsp;• System still does the borrow anyway<br>&nbsp;&nbsp;&nbsp;• System tries to send the email again later (up to 3 times)<br>&nbsp;&nbsp;&nbsp;• Librarian prints a receipt for the member |
| **What happens after** | • Loan is saved in the system<br>• Book is marked as BORROWED<br>• Member's book count goes up<br>• Confirmation email sent (or will be sent)<br>• Everything is logged |
| **If something breaks** | • **Database problem:** System says "Can't finish this. Try again or call support."<br>• **Can't read the barcode:** Librarian types in the ISBN instead<br>• **Card not found:** Librarian checks the ID number or the member needs to sign up (UC-08) |

---

## UC-03: Return Book

| Field | Content |
|-------|---------|
| **Use Case ID** | UC-03 |
| **Use Case Name** | Return Book |
| **Primary Actor(s)** | Member, Librarian |
| **Secondary Actor(s)** | Email Service, System |
| **Before you start** | • Member must be logged in<br>• The member is actually the one who borrowed this book<br>• Librarian is ready to take the book back |
| **Main Flow** | 1. Librarian scans the member's card or ID<br>2. System finds all the books the member has checked out<br>3. Librarian scans the book or types the ISBN<br>4. System finds the matching loan record<br>5. System records the return date and time<br>6. System checks if it's late. If yes, calculates a fine<br>7. System marks the loan as RETURNED<br>8. System marks the book as AVAILABLE again<br>9. Librarian looks at the book for damage and notes it<br>10. System sends a return confirmation email<br>11. If there was a fine, the member can pay now (UC-06: Pay Fine)<br>12. Librarian puts the book back or sends it for processing |
| **Other things that might happen** | **4a. Can't find the loan:**<br>&nbsp;&nbsp;&nbsp;• System says "This member didn't borrow this book"<br>&nbsp;&nbsp;&nbsp;• Librarian double-checks the member ID and ISBN<br>&nbsp;&nbsp;&nbsp;• If still not found, librarian talks to the manager<br><br>**6a. Book is late:**<br>&nbsp;&nbsp;&nbsp;• System figures out the fine (like $0.25/day, max $5)<br>&nbsp;&nbsp;&nbsp;• Shows the fine amount to both the librarian and member<br>&nbsp;&nbsp;&nbsp;• Pay Fine would happen next (UC-06)<br>&nbsp;&nbsp;&nbsp;• Member can pay now or deal with it later<br><br>**9a. Book is damaged:**<br>&nbsp;&nbsp;&nbsp;• Librarian marks it as DAMAGED in the system<br>&nbsp;&nbsp;&nbsp;• System might charge the member for repairs or replacement<br>&nbsp;&nbsp;&nbsp;• Book comes off the shelf and gets fixed<br>&nbsp;&nbsp;&nbsp;• Member gets notified about the charge |
| **What happens after** | • Loan is marked RETURNED with the date and time<br>• Book is marked AVAILABLE<br>• Member's book count goes down<br>• If there was a fine, it's saved in the system<br>• Return confirmation email is sent<br>• Damage notes are saved<br>• Everything is logged |
| **If something breaks** | • **Time zone issues:** System uses the server time. If there's a problem, the admin fixes it<br>• **Can't scan a damaged book:** Librarian uses the ISBN instead<br>• **Member has unpaid fines:** System shows the fine amount. Member pays it (UC-06) or librarian can manually approve it (needs admin sign-off) |

---

## UC-04: Reserve Book

| Field | Content |
|-------|---------|
| **Use Case ID** | UC-04 |
| **Use Case Name** | Reserve Book |
| **Primary Actor(s)** | Member |
| **Secondary Actor(s)** | Librarian, Email Service, System |
| **Before you start** | • Member must be logged in<br>• Member is in good standing (not banned)<br>• The book exists in our system (at least one copy)<br>• Member hasn't already reserved this book |
| **Main Flow** | 1. Member searches for a book by title, author, or ISBN (UC-01: Search Catalog)<br>2. Member clicks on the book they want and clicks "Reserve"<br>3. System shows a summary (title, format, estimated wait time)<br>4. Member confirms the reservation<br>5. System saves the reservation<br>6. System puts the member in the queue (first come, first served)<br>7. System sends a confirmation email with the reservation ID and wait time<br>8. System tells all the librarians a book was reserved<br>9. Member sees "Reservation successful. We'll let you know when it's ready." |
| **Other things that might happen** | **3a. No copies at all:**<br>&nbsp;&nbsp;&nbsp;• System says "No copies in our system"<br>&nbsp;&nbsp;&nbsp;• System suggests similar books or other books by the same author<br>&nbsp;&nbsp;&nbsp;• Member can suggest we buy it; librarian checks it later<br><br>**5a. Member already reserved this book:**<br>&nbsp;&nbsp;&nbsp;• System says "You already have a hold on this (Position #3). We'll notify you."<br>&nbsp;&nbsp;&nbsp;• Nothing new is created<br><br>**6a. Book is actually available right now:**<br>&nbsp;&nbsp;&nbsp;• System could let you borrow it immediately (optional)<br>&nbsp;&nbsp;&nbsp;• Or system sends "Your book is ready!" |
| **What happens after** | • Reservation is saved<br>• Member's spot in the queue is set<br>• Confirmation email is sent<br>• Librarians are notified<br>• Estimated wait time is calculated<br>• Everything is logged |
| **If something breaks** | • **Email is down:** System will try to send the email later<br>• **Book gets borrowed at the same time:** System still reserves it; waits time updates<br>• **Member doesn't pick it up for 30+ days:** System cancels the hold and notifies the member |

---

## UC-06: Pay Fine

| Field | Content |
|-------|---------|
| **Use Case ID** | UC-06 |
| **Use Case Name** | Pay Fine |
| **Primary Actor(s)** | Member |
| **Secondary Actor(s)** | Librarian, Payment Gateway, Email Service, System |
| **Before you start** | • Member must be logged in<br>• There's a fine that hasn't been paid<br>• Member wants to pay it (or has to)<br>• Payment system is online |
| **Main Flow** | 1. System shows all unpaid fines with details (why: overdue, damage, etc.)<br>2. Member picks which fine(s) to pay and confirms the amount<br>3. System shows a payment form (credit card, debit, etc.)<br>4. Member enters their payment info<br>5. System sends it to the Payment Gateway<br>6. Payment Gateway processes it and sends back success or fail<br>7. If success: system saves the transaction ID<br>8. System marks the fine as PAID<br>9. System sends a receipt email<br>10. System logs everything<br>11. Member sees "Payment successful. Your fine is cleared." |
| **Other things that might happen** | **6a. Payment gets rejected:**<br>&nbsp;&nbsp;&nbsp;• System says "Payment declined. Try again or ask your bank."<br>&nbsp;&nbsp;&nbsp;• System suggests a different card or payment method<br>&nbsp;&nbsp;&nbsp;• Member can try again<br>&nbsp;&nbsp;&nbsp;• Fine stays unpaid until payment works<br><br>**6b. Payment takes too long:**<br>&nbsp;&nbsp;&nbsp;• System says "Taking longer than expected. Try again later."<br>&nbsp;&nbsp;&nbsp;• System checks with the Payment Gateway later<br>&nbsp;&nbsp;&nbsp;• Member should check email for receipt or call support<br><br>**3a. No fines owed:**<br>&nbsp;&nbsp;&nbsp;• System says "You don't have any fines."<br>&nbsp;&nbsp;&nbsp;• Done |
| **What happens after** | • Fine is marked PAID with date and transaction ID<br>• Member's fine balance is cleared<br>• Receipt email is sent<br>• Everything is logged for records<br>• If the member was banned for unpaid fines, they can borrow again |
| **If something breaks** | • **Payment system is down:** System saves it for later, says "Service is down. Try again soon."<br>• **System error when updating fine:** System cancels the payment and credits the member's card<br>• **Card expired:** Payment Gateway says no. Member needs to update their card<br>• **Suspicious activity:** System asks them to log in again |

---

## UC-07: Manage Book Records

| Field | Content |
|-------|---------|
| **Use Case ID** | UC-07 |
| **Use Case Name** | Manage Book Records |
| **Primary Actor(s)** | Librarian, Admin |
| **Secondary Actor(s)** | System |
| **Before you start** | • User must be logged in (UC-08: Authenticate)<br>• User is a Librarian or Admin<br>• Book exists in the system (or you're adding a new one) |
| **Main Flow** | 1. Librarian goes to the Catalog Management section<br>2. Librarian searches for the book by ISBN, title, or author<br>3. System shows matching books<br>4. Librarian picks one to edit<br>5. System shows the book details (title, author, ISBN, location, subjects, copies, status)<br>6. Librarian updates stuff (add a copy, change the condition, add tags, etc.)<br>7. System checks the info is correct (ISBN format, required fields)<br>8. Librarian confirms the changes<br>9. System saves it<br>10. System records when it was changed and who changed it<br>11. System shows "Book updated successfully."<br>12. Librarian can print a label or search again |
| **Other things that might happen** | **2a. Book not found:**<br>&nbsp;&nbsp;&nbsp;• Librarian clicks "Add New Book"<br>&nbsp;&nbsp;&nbsp;• System shows a new book form<br>&nbsp;&nbsp;&nbsp;• Librarian types the ISBN and clicks "Lookup" (optional: looks it up online)<br>&nbsp;&nbsp;&nbsp;• System fills in title, author, and other info automatically<br>&nbsp;&nbsp;&nbsp;• Librarian adds the location, how many copies, and tags<br>&nbsp;&nbsp;&nbsp;• System creates the book record and gives it an ID<br><br>**6a. Multiple copies of the same book:**<br>&nbsp;&nbsp;&nbsp;• System shows all copies with their ID and status (AVAILABLE, BORROWED, DAMAGED, LOST)<br>&nbsp;&nbsp;&nbsp;• Librarian can change individual copy status or add/remove them<br><br>**7a. Something's wrong with what they typed:**<br>&nbsp;&nbsp;&nbsp;• System highlights the bad field and says what's wrong<br>&nbsp;&nbsp;&nbsp;• Librarian fixes it and tries again |
| **What happens after** | • Book record is updated<br>• Change date and who did it is recorded<br>• If it's a new book: it gets a unique ID<br>• Change is logged<br>• If new copy: barcode and label are made, ready to print |
| **If something breaks** | • **Two librarians edit at the same time:** System tells the second one "Someone else just changed this. Refresh and try again."<br>• **Can't look up ISBN online:** Librarian types it in manually, system keeps going<br>• **Can't save to database:** System shows an error and tries to undo. Librarian is told to try again or call IT |

---

## Shorter Descriptions for Remaining Use Cases

### UC-01: Search Catalog
**Who:** Member, Librarian | **Requirements:** Database needs to work | **What happens:** Member types in what they're looking for (keyword, title, author, ISBN) → System searches and filters by if it's available or not → Shows the results with title, author, ISBN, how many copies, and if it's available → Member can narrow down the search or sort by how new it is | **After:** Results show up; member can borrow (UC-02), reserve (UC-04), or search again | **Problems:** Nothing found → suggest similar titles or check spelling

### UC-05: Renew Loan
**Who:** Member, Librarian | **Requirements:** Member has a loan; nobody else reserved it; can renew up to 2 times per loan | **What happens:** Member looks at their active loans → picks a book → system checks if they can renew it → system gives them 21 more days → system sends a confirmation email | **After:** Loan gets a new due date; member gets notified | **Problems:** Someone else reserved it → can't renew. Member can return it or pay fines instead

### UC-08: Register Member
**Who:** Librarian, Admin | **Requirements:** New member shows ID; Librarian is logged in | **What happens:** Librarian types in the member's name, phone, address, email → system checks it's all good → system makes a member account with a unique ID → system sets default borrowing limits and permissions → system sends a welcome email with login info | **After:** Member account is created and logged | **Problems:** Email already used → system warns; no duplicates allowed

### UC-09: Generate Reports
**Who:** Admin, Librarian | **Requirements:** User is Admin or Librarian and logged in | **What happens:** Admin goes to Reports → picks what kind (circulation, fines, member activity, inventory) → system gets the data for the dates/info they want → system makes and shows the report (as a table or chart) → admin can save as CSV or PDF | **After:** Report shows up (or gets saved) | **Problems:** Too much data could take forever → system offers to email it later

### UC-10: Authenticate
**Who:** Everyone (Member, Librarian, Admin) | **Requirements:** You have an account; system is up | **What happens:** User types their username/email and password → system checks if it's right → system makes a session that lasts 24-48 hours → system logs when they logged in → user goes to their dashboard | **After:** You're logged in and can do your stuff | **Problems:** Wrong password → "Username or password incorrect" (keeps it generic for security). After 5 wrong tries, account gets locked

### UC-11: Send Notification
**Who:** System, Email Service | **Requirements:** Something triggers a notification (like a loan confirmation, reminder, or reservation ready) | **What happens:** System figures out what happened and makes a message → gets the member's email → formats the message with details (book title, due date, fine amount, etc.) → Email Service gets it → Email sends it via SMTP → Email tells the system if it worked | **After:** Email is sent (or saved for later) | **Problems:** Email service down → system tries to send it again up to 3 times over 24 hours. Or system tries SMS if that's set up


---

## How to Use This Document

1. **For team presentations:** Each table shows what the feature does, who's involved, and what can go wrong.  
2. **For developers:** The "Before you start" and "What happens after" sections tell you the entry and exit requirements. "Other things that might happen" is how to handle edge cases.  
3. **For QA/testing:** "What happens" and "Other things that might happen" are your test scenarios.  
4. **For stakeholders:** The short descriptions give a quick overview; the full tables have all the details.

---

## Notes on Relationships

- **Always happens (<<include>>):** Stuff like "Authenticate" always happens before anyone borrows or returns a book. The system should never let you skip it.
- **Sometimes happens (<<extend>>):** "Pay Fine" might happen after returning a book—but only if the book is late. "Send Notification" happens after borrowing or reserving—but if the email system is down, the borrow or reserve still works anyway.

---

**Last updated:** 2026-04-18  
**Who wrote it:** Member C (Use Case Lead)  
**Status:** Ready to show the team and start building
