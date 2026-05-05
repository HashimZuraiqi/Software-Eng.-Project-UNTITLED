| Current State | Event | Guard | Action | Next State |
| --- | --- | --- | --- | --- |
| — | memberRequestsLoan | — | createLoanRecord | Requested |
| Requested | librarianApprovesLoan | copyAvailable | recordIssueDate | Active |
| Requested | librarianRejectsLoan | copyUnavailable | notifyMember | Rejected |
| Active | memberRenewsLoan | renewalCount < 2 | incrementRenewalCount; extendDueDate | Renewed |
| Renewed | renewalConfirmed | — | — | Active |
| Active | dueDatePassed | bookNotReturned | calculateFine | Overdue |
| Renewed | dueDatePassed | bookNotReturned | calculateFine | Overdue |
| Active | memberReturnsBook | — | recordReturnDate | Returned |
| Overdue | memberReturnsBook | — | recordReturnDate; issueFineNotice | Returned |
| Returned | fineSettledOrNone | — | archiveLoan | Closed |
| Rejected | — | — | archiveLoan | Closed |
